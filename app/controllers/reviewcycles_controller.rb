class ReviewcyclesController < ApplicationController
  before_action :prepare_dashboard_shell

  def new
    @active_dashboard_section = "launch"
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
