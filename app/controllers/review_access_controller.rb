class ReviewAccessController < ApplicationController
  rate_limit to: 20, within: 1.minute,
    only: :show,
    name: "review_access_show",
    by: :review_access_show_rate_key,
    with: :handle_rate_limited_review_access

  rate_limit to: 10, within: 1.minute,
    only: [:submit, :consume],
    name: "review_access_consume",
    by: :review_access_consume_rate_key,
    with: :handle_rate_limited_review_access

  INVALID_LINK_MESSAGE = "This link is invalid or expired.".freeze
  SESSION_EXPIRED_MESSAGE = "Session expired.".freeze

  before_action :load_magic_link_from_token, only: :show
  before_action :load_magic_link_from_session, only: [:submit, :consume]
  before_action :load_review_request, only: [:show, :submit]

  def show
    @magic_link.mark_accessed!
    persist_magic_link_session!(@magic_link)
    @review_submission = @review_request.build_submission_with_answers
  end

  def submit
    @review_submission = @review_request.build_submission
    @review_submission.assign_attributes(review_submission_params)

    if @review_submission.valid? && @magic_link.consume!
      ActiveRecord::Base.transaction do
        @review_submission.save!
        @review_submission.mark_submitted!
        @review_request.mark_completed!
      end

      reset_magic_link_session!
      redirect_to confirmation_review_access_path, notice: "Review submitted."
      return
    end

    render :show, status: :unprocessable_entity
  end

  def consume
    unless @magic_link.consume!
      reset_magic_link_session!
      redirect_to invalid_review_access_path, alert: INVALID_LINK_MESSAGE
      return
    end

    reset_magic_link_session!
    redirect_to confirmation_review_access_path, notice: "Magic link accepted."
  end

  def invalid
    render status: :gone
  end

  def confirmation
  end

  private

  def load_magic_link_from_token
    @magic_link = MagicLink.find_active_by_token(
      params[:token],
      purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION
    )

    return if @magic_link

    reset_magic_link_session!
    redirect_to invalid_review_access_path, alert: INVALID_LINK_MESSAGE
  end

  def load_magic_link_from_session
    @magic_link = MagicLink.find_by(id: session[:magic_link_id])

    valid_scope = @magic_link &&
      @magic_link.purpose == session[:magic_link_purpose] &&
      @magic_link.resource_type == session[:magic_link_resource_type] &&
      @magic_link.resource_id == session[:magic_link_resource_id]

    return if valid_scope

    reset_magic_link_session!
    redirect_to invalid_review_access_path, alert: SESSION_EXPIRED_MESSAGE
  end

  def persist_magic_link_session!(magic_link)
    session[:magic_link_id] = magic_link.id
    session[:magic_link_purpose] = magic_link.purpose
    session[:magic_link_resource_type] = magic_link.resource_type
    session[:magic_link_resource_id] = magic_link.resource_id
  end

  def reset_magic_link_session!
    session.delete(:magic_link_id)
    session.delete(:magic_link_purpose)
    session.delete(:magic_link_resource_type)
    session.delete(:magic_link_resource_id)
  end

  private

  def review_access_show_rate_key
    [
      request.remote_ip,
      MagicLink.digest(params[:token].to_s)
    ].join(":")
  end

  def review_access_consume_rate_key
    [
      request.remote_ip,
      session[:magic_link_id] || "no-link"
    ].join(":")
  end

  def handle_rate_limited_review_access
    redirect_to invalid_review_access_path, alert: INVALID_LINK_MESSAGE
  end

  def load_review_request
    @review_request = @magic_link.resource

    return if @review_request.is_a?(ReviewRequest)

    reset_magic_link_session!
    redirect_to invalid_review_access_path, alert: INVALID_LINK_MESSAGE
  end

  def review_submission_params
    params.require(:review_submission).permit(
      review_answers_attributes: [:question_template_id, :score, :comment]
    )
  end
end
