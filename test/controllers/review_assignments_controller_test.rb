require "test_helper"

class ReviewAssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear

    @reviewee = people(:ada)
    @manager = people(:grace)
    @peer = people(:linus)

    @cycle = ReviewCycle.create!(
      reviewee: @reviewee,
      manager: @manager,
      name: "2026 Mid-Year Review",
      status: "active",
      start_on: Date.new(2026, 6, 1),
      end_on: Date.new(2026, 6, 30)
    )

    @assignment = ReviewAssignment.create!(
      name: "Peer review",
      review_cycle: @cycle,
      reviewer: @peer,
      reviewee: @reviewee,
      assignment_type: "peer",
      status: "pending"
    )
  end

  test "index shows the cycle assignments" do
    get review_cycle_review_assignments_path(@cycle)

    assert_response :success
    assert_includes response.body, @cycle.name
    assert_includes response.body, "Send magic link"
    assert_includes response.body, @peer.email
  end

  test "create issues a magic link and sends the reviewer email" do
    assert_emails 1 do
      post send_magic_link_review_cycle_review_assignment_path(@cycle, @assignment)
    end

    assert_redirected_to review_cycle_review_assignments_path(@cycle)
    assert_equal @peer.email, ActionMailer::Base.deliveries.last.to.first
    assert_equal 1, @assignment.magic_links.active.count
    assert_equal @peer.email, @assignment.magic_links.last.recipient_identifier
  end
end
