require "test_helper"

class ReviewRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear
    clear_enqueued_jobs
  end

  test "hr can reissue a link, revoke the previous one, and record an audit" do
    review_request = review_requests(:linus_peer_review_request)
    previous_link = MagicLink.issue!(
      purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION,
      resource: review_request,
      recipient_identifier: review_request.recipient_email
    )

    assert_difference -> { ReviewRequestAudit.count }, 1 do
      assert_enqueued_jobs 1, only: SendReviewRequestJob do
        post reissue_review_request_path(review_request), params: {
          review_request: {
            reason: "Reviewer could not find the first email"
          }
        }
      end
    end

    assert_redirected_to dashboard_cycles_path
    assert_predicate previous_link.reload, :revoked?

    review_request.reload
    assert_equal "queued", review_request.delivery_status
    assert_equal "reissued", review_request.review_request_audits.order(:id).last.action
    assert_equal "Reviewer could not find the first email", review_request.review_request_audits.order(:id).last.reason
    assert_equal users(:hr_user), review_request.review_request_audits.order(:id).last.performed_by
  end
end
