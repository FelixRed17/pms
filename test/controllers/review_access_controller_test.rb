require "test_helper"

class ReviewAccessControllerTest < ActionDispatch::IntegrationTest
  test "show renders the correct questionnaire title, score legend, and role-specific fields" do
    review_request = review_requests(:linus_peer_review_request)
    magic_link = MagicLink.issue!(
      resource: review_request,
      purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION,
      recipient_identifier: review_request.recipient_email
    )

    get review_access_url(token: magic_link.raw_token)

    assert_response :success
    assert_select "h1", text: /Key Behaviours - Ada Lovelace/
    assert_select "legend", text: "Scoring scale"
    assert_select "input[type='radio'][name='review_submission[review_answers_attributes][0][score]'][value='5']"
    assert_select "textarea[name='review_submission[review_answers_attributes][0][comment]']"
  end

  test "submission creates review answers and consumes the magic link" do
    review_request = review_requests(:katherine_peer_review_request)
    magic_link = MagicLink.issue!(
      resource: review_request,
      purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION,
      recipient_identifier: review_request.recipient_email
    )

    get review_access_url(token: magic_link.raw_token)

    post submit_review_access_url(token: magic_link.raw_token), params: {
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
                comment: "Thoughtful answer #{index + 1}"
              }
            ]
          end
      }
    }

    assert_redirected_to confirmation_review_access_path
    assert_equal 1, review_request.review_submissions.submitted.count
    assert_predicate magic_link.reload, :used?
  end
end
