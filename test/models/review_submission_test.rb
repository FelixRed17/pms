require "test_helper"

class ReviewSubmissionTest < ActiveSupport::TestCase
  test "requires answers for each rendered question template" do
    review_request = review_requests(:ada_self_review_request)
    submission = review_request.build_submission_with_answers
    submission.review_answers = submission.review_answers.first(4)

    assert_not submission.valid?
    assert_includes submission.errors[:review_answers], "must answer every rendered question"
  end

  test "marks a submission as submitted" do
    submission = review_submissions(:peer_submission)

    submission.mark_submitted!

    assert_equal "submitted", submission.status
    assert_predicate submission.submitted_at, :present?
  end

  test "allows exactly one submitted submission per review request" do
    review_request = review_requests(:linus_peer_review_request)
    duplicate = review_request.build_submission
    duplicate.assign_attributes(
      review_cycle: review_request.review_cycle,
      reviewee: review_request.reviewee,
      reviewer: review_request.reviewer,
      reviewer_role: review_request.reviewer_role,
      status: "submitted",
      submitted_at: Time.current,
      review_answers: review_request.questionnaire_template.rendered_question_templates.map do |question_template|
        ReviewAnswer.new(question_template:, score: 4, comment: "Duplicate answer")
      end
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:review_request_id], "already has a submitted response"
  end
end
