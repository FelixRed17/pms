class ReviewAccessController < ApplicationController
  rate_limit to: 20, within: 1.minute,
    only: :exchange,
    name: "review_access_exchange",
    by: :review_access_exchange_rate_key,
    with: :handle_rate_limited_review_access

  rate_limit to: 10, within: 1.minute,
    only: :consume,
    name: "review_access_consume",
    by: :review_access_consume_rate_key,
    with: :handle_rate_limited_review_access

  INVALID_LINK_MESSAGE = "This link is invalid or expired.".freeze
  SESSION_EXPIRED_MESSAGE = "Session expired.".freeze

  before_action :load_magic_link_from_token, only: :exchange
  before_action :load_magic_link_from_session, only: [ :show, :consume ]

  def exchange
    @magic_link.mark_accessed!
    reset_session
    persist_magic_link_session!(@magic_link)
    redirect_to review_access_path
  end

  def show
    load_review_assignment_context
  end

  def consume
    load_review_assignment_context

    result = SubmitReviewAssignment.call(
      magic_link: @magic_link,
      responses_params: review_submission_params
    )

    unless result.success?
      @submission_errors = result.errors
      flash.now[:alert] = @submission_errors.to_sentence
      render :show, status: :unprocessable_entity
      return
    end

    reset_magic_link_session!
    redirect_to confirmation_review_access_path, notice: "Review submitted."
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

  def review_access_exchange_rate_key
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

  def load_review_assignment_context
    @assignment = @magic_link.resource
    @resource = @assignment
    @questions = Question.for_assignment_type(@assignment.assignment_type)
    @submission_errors ||= []
  end

  def review_submission_params
    params.fetch(:responses, {}).permit!.to_h
  end
end
