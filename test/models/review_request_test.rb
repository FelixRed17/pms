require "test_helper"

class ReviewRequestTest < ActiveSupport::TestCase
  test "resolves the questionnaire template for the reviewer role" do
    review_request = review_requests(:ada_self_review_request)

    assert_equal questionnaire_templates(:self_review), review_request.questionnaire_template
  end

  test "builds a draft submission with rendered question templates" do
    review_request = review_requests(:linus_peer_review_request)

    submission = review_request.build_submission_with_answers

    assert_equal "draft", submission.status
    assert_equal 5, submission.review_answers.size
    assert_equal questionnaire_templates(:peer_review).rendered_question_templates.map(&:id), submission.review_answers.map(&:question_template_id)
  end
end
