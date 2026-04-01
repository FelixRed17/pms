require "test_helper"

class ReviewAccessFlowTest < ActionDispatch::IntegrationTest
  setup do
    @review_request = review_requests(:katherine_peer_review_request)
  end

  test "valid magic link shows the access page and records access time" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @review_request)

    get review_access_token_path(token: magic_link.raw_token)

    assert_redirected_to review_access_path

    follow_redirect!

    assert_response :success
    assert_includes response.body, "Your secure review link is active."
    assert_includes response.body, "What are Ada Lovelace&#39;s strongest contributions?"
    assert_includes response.body, "How effectively does Ada Lovelace collaborate with the team?"
    assert_predicate magic_link.reload.accessed_at, :present?
  end

  test "invalid token redirects to the invalid page" do
    get review_access_token_path(token: "invalid-token")

    assert_redirected_to invalid_review_access_path

    follow_redirect!

    assert_response :gone
    assert_includes response.body, "invalid, expired, or has already been used"
  end

  test "expired token redirects to the invalid page" do
    magic_link = MagicLink.issue!(
      purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION,
      resource: @review_request,
      expires_at: 1.minute.ago
    )

    get review_access_token_path(token: magic_link.raw_token)

    assert_redirected_to invalid_review_access_path
  end

  test "consume marks the link used and redirects to confirmation" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @review_request)

    get review_access_path(token: magic_link.raw_token)
    post submit_review_access_path(token: magic_link.raw_token), params: valid_submission_params(@review_request)

    assert_redirected_to confirmation_review_access_path
    assert_equal "submitted", @assignment.reload.status
    assert_equal 2, @assignment.review_answers.count
    assert_predicate magic_link.reload, :used?
  end

  test "invalid submission rerenders the form and keeps the link active" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)

    get review_access_token_path(token: magic_link.raw_token)
    post consume_review_access_path, params: {
      responses: {
        @shared_question.id.to_s => { text_value: "Ada is dependable." }
      }
    }

    assert_response :unprocessable_entity
    assert_includes response.body, "All review questions must be answered."
    assert_not_predicate magic_link.reload, :used?
    assert_equal "pending", @assignment.reload.status
  end

  test "used links cannot be replayed" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @review_request)

    get review_access_path(token: magic_link.raw_token)
    post submit_review_access_path(token: magic_link.raw_token), params: valid_submission_params(@review_request)
    get review_access_path(token: magic_link.raw_token)

    assert_redirected_to invalid_review_access_path
  end

  test "tampered session scope is rejected during consume" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @review_request)
    another_request = review_requests(:grace_manager_review_request)

    get review_access_path(token: magic_link.raw_token)
    magic_link.update_columns(resource_id: another_request.id, updated_at: Time.current)

    post submit_review_access_path(token: magic_link.raw_token), params: valid_submission_params(@review_request)

    assert_redirected_to invalid_review_access_path
    assert_not_predicate magic_link.reload, :used?
  end

  private

  def valid_submission_params(review_request)
    {
      review_submission: {
        review_answers_attributes: review_request
          .questionnaire_template
          .rendered_question_templates
          .each_with_index
          .to_h do |question_template, index|
            [
              index.to_s,
              {
                question_template_id: question_template.id,
                score: 4,
                comment: "Response #{index + 1}"
              }
            ]
          end
      }
    }
  end
end
