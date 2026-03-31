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
    @review_cycles = ReviewCycle
      .includes(:reviewee, :manager, :peer_reviewers)
      .order(created_at: :desc)
  end
end
