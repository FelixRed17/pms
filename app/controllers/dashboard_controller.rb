class DashboardController < ApplicationController
  before_action :prepare_dashboard_shell

  def home
    @active_dashboard_section = "launch"
  end

  def cycles
    @active_dashboard_section = "cycles"
  end

  def employees
    @active_dashboard_section = "employees"
  end

  def reports
    @active_dashboard_section = "reports"
  end

  private

  def prepare_dashboard_shell
    @render_dashboard_shell = true
    @people = Person.order(:first_name, :last_name)
    @review_cycle = ReviewCycle.new(status: "draft")
    @questionnaire_templates = QuestionnaireTemplate.includes(:question_templates).order(:audience_type)
    @review_cycles = ReviewCycle
      .includes(:reviewee, :manager, :peer_reviewers, review_requests: [:reviewer, :review_request_audits])
      .order(created_at: :desc)
  end
end
