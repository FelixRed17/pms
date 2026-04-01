require "test_helper"

class SendReviewRequestJobTest < ActiveJob::TestCase
  test "delivers a magic link email and marks the request sent" do
    review_request = review_requests(:katherine_peer_review_request)

    assert_difference -> { ActionMailer::Base.deliveries.count }, 1 do
      perform_enqueued_jobs do
        SendReviewRequestJob.perform_later(review_request.id)
      end
    end

    review_request.reload

    assert_equal "sent", review_request.delivery_status
    assert_predicate review_request.last_sent_at, :present?
    assert_equal 1, review_request.delivery_attempts_count
    assert_match %r{/review_access/[\w-]+}, ActionMailer::Base.deliveries.last.body.to_s
  end
end
