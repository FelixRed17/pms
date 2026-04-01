require "test_helper"

class ReviewAssignmentTest < ActiveSupport::TestCase
  setup do
    @reviewee = people(:ada)
    @manager = people(:grace)
    @peer = people(:linus)

    @cycle = ReviewCycle.create!(
      reviewee: @reviewee,
      manager: @manager,
      name: "2026 Mid-Year Review",
      status: "draft",
      start_on: Date.new(2026, 6, 1),
      end_on: Date.new(2026, 6, 30)
    )
  end

  test "is valid for a self assignment" do
    assignment = ReviewAssignment.new(
      name: "Self review",
      review_cycle: @cycle,
      reviewer: @reviewee,
      reviewee: @reviewee,
      assignment_type: "self",
      status: "pending"
    )

    assert assignment.valid?
  end

  test "is valid for a manager assignment" do
    assignment = ReviewAssignment.new(
      name: "Manager review",
      review_cycle: @cycle,
      reviewer: @manager,
      reviewee: @reviewee,
      assignment_type: "manager",
      status: "pending"
    )

    assert assignment.valid?
  end

  test "is valid for a peer assignment" do
    assignment = ReviewAssignment.new(
      name: "Peer review",
      review_cycle: @cycle,
      reviewer: @peer,
      reviewee: @reviewee,
      assignment_type: "peer",
      status: "pending"
    )

    assert assignment.valid?
  end

  test "requires self assignment reviewer to be the reviewee" do
    assignment = ReviewAssignment.new(
      name: "Invalid self review",
      review_cycle: @cycle,
      reviewer: @peer,
      reviewee: @reviewee,
      assignment_type: "self",
      status: "pending"
    )

    assert_not assignment.valid?
    assert_includes assignment.errors[:reviewer], "must be the reviewee for self assignments"
  end

  test "requires manager assignment reviewer to be the cycle manager" do
    assignment = ReviewAssignment.new(
      name: "Invalid manager review",
      review_cycle: @cycle,
      reviewer: @peer,
      reviewee: @reviewee,
      assignment_type: "manager",
      status: "pending"
    )

    assert_not assignment.valid?
    assert_includes assignment.errors[:reviewer], "must be the cycle manager for manager assignments"
  end

  test "does not allow peer assignment reviewer to be the reviewee" do
    assignment = ReviewAssignment.new(
      name: "Invalid peer review",
      review_cycle: @cycle,
      reviewer: @reviewee,
      reviewee: @reviewee,
      assignment_type: "peer",
      status: "pending"
    )

    assert_not assignment.valid?
    assert_includes assignment.errors[:reviewer], "cannot be the reviewee for peer assignments"
  end

  test "does not allow duplicate assignment type per reviewer in a cycle" do
    ReviewAssignment.create!(
      name: "Existing peer review",
      review_cycle: @cycle,
      reviewer: @peer,
      reviewee: @reviewee,
      assignment_type: "peer",
      status: "pending"
    )

    duplicate = ReviewAssignment.new(
      name: "Duplicate peer review",
      review_cycle: @cycle,
      reviewer: @peer,
      reviewee: @reviewee,
      assignment_type: "peer",
      status: "pending"
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:reviewer_id], "already has this assignment type for the cycle"
  end
end
