require "test_helper"

class SendReviewAssignmentMagicLinkTest < ActiveSupport::TestCase
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

  test "issues a fresh magic link and sends the email to the reviewer" do
    result = SendReviewAssignmentMagicLink.call(review_assignment: @assignment)

    assert_predicate result, :success?
    assert_predicate result.magic_link, :persisted?
    assert_equal @peer.email, result.magic_link.recipient_identifier
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal @peer.email, ActionMailer::Base.deliveries.last.to.first
    assert_includes ActionMailer::Base.deliveries.last.body.encoded, "/review_access/"
  end
end
