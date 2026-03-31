require "test_helper"

class ReviewAccessFlowTest < ActionDispatch::IntegrationTest
  setup do
    @assignment = ReviewAssignment.create!(name: "Leadership Review")
  end

  test "valid magic link shows the access page and records access time" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)

    get review_access_path(token: magic_link.raw_token)

    assert_response :success
    assert_includes response.body, "Your secure review link is active."
    assert_predicate magic_link.reload.accessed_at, :present?
  end

  test "invalid token redirects to the invalid page" do
    get review_access_path(token: "invalid-token")

    assert_redirected_to invalid_review_access_path

    follow_redirect!

    assert_response :gone
    assert_includes response.body, "invalid, expired, or has already been used"
  end

  test "expired token redirects to the invalid page" do
    magic_link = MagicLink.issue!(
      purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION,
      resource: @assignment,
      expires_at: 1.minute.ago
    )

    get review_access_path(token: magic_link.raw_token)

    assert_redirected_to invalid_review_access_path
  end

  test "consume marks the link used and redirects to confirmation" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)

    get review_access_path(token: magic_link.raw_token)
    post consume_review_access_path

    assert_redirected_to confirmation_review_access_path
    assert_predicate magic_link.reload, :used?
  end

  test "used links cannot be replayed" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)

    get review_access_path(token: magic_link.raw_token)
    post consume_review_access_path
    get review_access_path(token: magic_link.raw_token)

    assert_redirected_to invalid_review_access_path
  end

  test "tampered session scope is rejected during consume" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)
    another_assignment = ReviewAssignment.create!(name: "Peer Review")

    get review_access_path(token: magic_link.raw_token)
    magic_link.update_columns(resource_id: another_assignment.id, updated_at: Time.current)

    post consume_review_access_path

    assert_redirected_to invalid_review_access_path
    assert_not_predicate magic_link.reload, :used?
  end
end
