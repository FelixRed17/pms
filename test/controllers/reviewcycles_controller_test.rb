require "test_helper"

class ReviewcyclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear
    clear_enqueued_jobs
  end

  test "should get new" do
    get reviewcycles_new_url
    assert_response :success
    assert_select "div.review-cycle-form"
    assert_select "button", text: "Save & Launch"
    assert_select "button", text: "Add question", count: 0
  end

  test "save and launch creates a cycle, review requests, and mock emails" do
    assert_difference -> { ReviewCycle.count }, 1 do
      assert_difference -> { ReviewRequest.count }, 4 do
        assert_enqueued_jobs 4, only: SendReviewRequestJob do
          post reviewcycles_path, params: {
            review_cycle: {
              name: "Q3 Launch",
              start_on: Date.new(2026, 7, 1),
              end_on: Date.new(2026, 7, 31),
              reviewee_id: people(:ada).id,
              manager_id: people(:grace).id,
              peer_reviewer_ids: [people(:linus).id, people(:katherine).id]
            },
            commit_action: "launch"
          }
        end
      end
    end

    review_cycle = ReviewCycle.order(:created_at).last

    assert_redirected_to root_path
    assert_equal "active", review_cycle.status
    assert_equal 4, review_cycle.review_requests.count
    assert_equal %w[queued queued queued queued], review_cycle.review_requests.order(:id).pluck(:delivery_status)
  end

  test "save draft stores the cycle without creating requests or emails" do
    assert_difference -> { ReviewCycle.count }, 1 do
      assert_no_difference -> { ReviewRequest.count } do
        assert_no_enqueued_jobs only: SendReviewRequestJob do
          post reviewcycles_path, params: {
            review_cycle: {
              name: "Q3 Draft",
              start_on: Date.new(2026, 7, 1),
              end_on: Date.new(2026, 7, 31),
              reviewee_id: people(:ada).id,
              manager_id: people(:grace).id,
              peer_reviewer_ids: [people(:linus).id]
            },
            commit_action: "draft"
          }
        end
      end
    end

    assert_equal "draft", ReviewCycle.order(:created_at).last.status
  end
end
