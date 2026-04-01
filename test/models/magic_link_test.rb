require "test_helper"

class MagicLinkTest < ActiveSupport::TestCase
  setup do
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
      name: "Quarterly Review",
      review_cycle: @cycle,
      reviewer: @peer,
      reviewee: @reviewee,
      assignment_type: "peer",
      status: "pending"
    )
  end

  test "issue stores a digest and exposes the raw token on the returned record only" do
    magic_link = MagicLink.issue!(
      purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION,
      resource: @assignment,
      recipient_identifier: "reviewer@example.com"
    )

    assert_predicate magic_link.raw_token, :present?
    assert_equal MagicLink.digest(magic_link.raw_token), magic_link.token_digest
    assert_equal "reviewer@example.com", magic_link.recipient_identifier
  end

  test "issuing a new link revokes the previous active link for the same purpose and resource" do
    first_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)
    second_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)

    assert_predicate first_link.reload, :revoked?
    assert_predicate second_link.reload, :active?
  end

  test "find_active_by_token returns the active link for a valid token and purpose" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)

    assert_equal magic_link, MagicLink.find_active_by_token(magic_link.raw_token, purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION)
  end

  test "find_active_by_token rejects expired links" do
    magic_link = MagicLink.issue!(
      purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION,
      resource: @assignment,
      expires_at: 1.minute.ago
    )

    assert_nil MagicLink.find_active_by_token(magic_link.raw_token, purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION)
  end

  test "find_active_by_token rejects used links" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)
    magic_link.mark_used!

    assert_nil MagicLink.find_active_by_token(magic_link.raw_token, purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION)
  end

  test "find_active_by_token rejects revoked links" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)
    magic_link.revoke!

    assert_nil MagicLink.find_active_by_token(magic_link.raw_token, purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION)
  end

  test "consume! marks the link used once and rejects replay" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)

    assert magic_link.consume!
    assert_not magic_link.consume!
    assert_predicate magic_link.reload, :used?
  end
end
