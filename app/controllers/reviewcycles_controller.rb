class ReviewcyclesController < ApplicationController
  before_action :prepare_dashboard_shell

  def new
    @active_dashboard_section = "launch"
    @review_cycle = ReviewCycle.new(status: "draft")
  end

  def create
    @active_dashboard_section = "launch"
    @review_cycle = ReviewCycle.new(review_cycle_params)
    result = LaunchReviewCycle.new(
      review_cycle: @review_cycle,
      launch: params[:commit_action] == "launch",
      performed_by: current_user
    ).call

    if result.success?
      redirect_to root_path, notice: success_message_for(result.review_cycle)
      return
    end

    render :new, status: :unprocessable_entity
  end

  private

  def prepare_dashboard_shell
    @render_dashboard_shell = true
    @people = Person.order(:first_name, :last_name)
    @questionnaire_templates = QuestionnaireTemplate.includes(:question_templates).order(:audience_type)
    @review_cycles = ReviewCycle
      .includes(:reviewee, :manager, :peer_reviewers)
      .order(created_at: :desc)
  end

  def review_cycle_params
    params.require(:review_cycle).permit(
      :name,
      :start_on,
      :end_on,
      :reviewee_id,
      :manager_id,
      peer_reviewer_ids: []
    )
  end

  def success_message_for(review_cycle)
    return "#{review_cycle.name} saved as draft." if review_cycle.status == "draft"

    "#{review_cycle.name} launched. Mock questionnaire links were sent to the terminal mailer output."
  end
end
