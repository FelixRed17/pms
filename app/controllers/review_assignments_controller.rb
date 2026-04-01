class ReviewAssignmentsController < ApplicationController
  before_action :load_review_cycle
  before_action :load_review_assignment, only: :send_magic_link

  def index
    @review_assignments = @review_cycle.review_assignments.includes(:reviewer, :reviewee).order(:assignment_type, :created_at)
  end

  def send_magic_link
    result = SendReviewAssignmentMagicLink.call(review_assignment: @review_assignment)

    if result.success?
      redirect_to review_cycle_review_assignments_path(@review_cycle), notice: "Magic link sent to #{@review_assignment.reviewer.email}."
    else
      redirect_to review_cycle_review_assignments_path(@review_cycle), alert: result.errors.to_sentence
    end
  end

  private

  def load_review_cycle
    @review_cycle = ReviewCycle.find(params[:review_cycle_id])
  end

  def load_review_assignment
    @review_assignment = @review_cycle.review_assignments.find(params[:id])
  end
end
