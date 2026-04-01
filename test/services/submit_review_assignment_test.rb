require "test_helper"

class SubmitReviewAssignmentTest < ActiveSupport::TestCase
  setup do
    @reviewee = people(:ada)
    @manager = people(:grace)

    @cycle = ReviewCycle.create!(
      reviewee: @reviewee,
      manager: @manager,
      name: "2026 Mid-Year Review",
      status: "active",
      start_on: Date.new(2026, 6, 1),
      end_on: Date.new(2026, 6, 30)
    )

    @assignment = ReviewAssignment.create!(
      name: "Self review",
      review_cycle: @cycle,
      reviewer: @reviewee,
      reviewee: @reviewee,
      assignment_type: "self",
      status: "pending"
    )

    @shared_question = Question.create!(
      question_text: "What are %{subject_possessive} strongest contributions?",
      question_type: "text",
      position: 1,
      active: true,
      audience: "all"
    )
    @self_question = Question.create!(
      question_text: "What are your growth goals?",
      question_type: "text",
      position: 2,
      active: true,
      audience: "self"
    )
  end

  test "persists answers, marks the assignment submitted, and consumes the magic link" do
    magic_link = @assignment.issue_magic_link!

    result = SubmitReviewAssignment.call(
      magic_link: magic_link,
      responses_params: {
        @shared_question.id.to_s => { text_value: "Reliable delivery" },
        @self_question.id.to_s => { text_value: "Improve delegation" }
      }
    )

    assert_predicate result, :success?
    assert_equal 2, @assignment.review_answers.reload.count
    assert_equal "submitted", @assignment.reload.status
    assert_predicate @assignment, :submitted?
    assert_predicate magic_link.reload, :used?
  end

  test "rejects submissions that include questions outside the assignment audience" do
    peer_question = Question.create!(
      question_text: "How well does the employee collaborate with peers?",
      question_type: "text",
      position: 3,
      active: true,
      audience: "peer"
    )
    magic_link = @assignment.issue_magic_link!

    result = SubmitReviewAssignment.call(
      magic_link: magic_link,
      responses_params: {
        @shared_question.id.to_s => { text_value: "Reliable delivery" },
        peer_question.id.to_s => { text_value: "Should not be allowed" }
      }
    )

    assert_not_predicate result, :success?
    assert_includes result.errors, "All review questions must be answered."
    assert_includes result.errors, "The submission contains invalid questions."
    assert_equal 0, @assignment.review_answers.reload.count
    assert_equal "pending", @assignment.reload.status
    assert_not_predicate magic_link.reload, :used?
  end
end
