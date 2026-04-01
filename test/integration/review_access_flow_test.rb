require "test_helper"

class ReviewAccessFlowTest < ActionDispatch::IntegrationTest
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
      name: "Peer review",
      review_cycle: @cycle,
      reviewer: @peer,
      reviewee: @reviewee,
      assignment_type: "peer",
      status: "pending"
    )

    @shared_question = Question.create!(
      question_text: "What are %{subject_possessive} strongest contributions?",
      question_type: "text",
      position: 1,
      active: true,
      audience: "all"
    )
    @peer_question = Question.create!(
      question_text: "How effectively does %{subject_name} collaborate with the team?",
      question_type: "rating",
      position: 2,
      active: true,
      audience: "peer"
    )
  end

  test "valid magic link shows the access page and records access time" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)

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
      resource: @assignment,
      expires_at: 1.minute.ago
    )

    get review_access_token_path(token: magic_link.raw_token)

    assert_redirected_to invalid_review_access_path
  end

  test "consume submits answers, marks the assignment submitted, and redirects to confirmation" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)

    get review_access_token_path(token: magic_link.raw_token)
    post consume_review_access_path, params: {
      responses: {
        @shared_question.id.to_s => { text_value: "Ada is dependable." },
        @peer_question.id.to_s => { rating_value: "4" }
      }
    }

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
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)

    get review_access_token_path(token: magic_link.raw_token)
    post consume_review_access_path, params: {
      responses: {
        @shared_question.id.to_s => { text_value: "Ada is dependable." },
        @peer_question.id.to_s => { rating_value: "4" }
      }
    }
    get review_access_token_path(token: magic_link.raw_token)

    assert_redirected_to invalid_review_access_path
  end

  test "tampered session scope is rejected during consume" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)
    another_assignment = ReviewAssignment.create!(
      name: "Peer review 2",
      review_cycle: @cycle,
      reviewer: people(:katherine),
      reviewee: @reviewee,
      assignment_type: "peer",
      status: "pending"
    )

    get review_access_token_path(token: magic_link.raw_token)
    magic_link.update_columns(resource_id: another_assignment.id, updated_at: Time.current)

    post consume_review_access_path, params: {
      responses: {
        @shared_question.id.to_s => { text_value: "Ada is dependable." },
        @peer_question.id.to_s => { rating_value: "4" }
      }
    }

    assert_redirected_to invalid_review_access_path
    assert_not_predicate magic_link.reload, :used?
  end

  test "exchange removes the raw token from the browser url" do
    magic_link = MagicLink.issue!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, resource: @assignment)

    get review_access_token_path(token: magic_link.raw_token)

    assert_redirected_to review_access_path
    assert_equal "http://www.example.com/review_access", response.location
  end
end
