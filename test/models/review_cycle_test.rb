require "test_helper"

class ReviewCycleTest < ActiveSupport::TestCase
  test "is valid with required attributes" do
    review_cycle = ReviewCycle.new(
      reviewee: people(:ada),
      manager: people(:grace),
      peer_reviewers: [people(:linus), people(:katherine)],
      name: "2026 Mid-Year Review",
      status: "draft",
      start_on: Date.new(2026, 6, 1),
      end_on: Date.new(2026, 6, 30)
    )

    assert review_cycle.valid?
  end

  test "requires a reviewee" do
    review_cycle = ReviewCycle.new(
      manager: people(:grace),
      name: "2026 Mid-Year Review",
      status: "draft",
      start_on: Date.new(2026, 6, 1),
      end_on: Date.new(2026, 6, 30)
    )

    assert_not review_cycle.valid?
    assert_includes review_cycle.errors[:reviewee], "must exist"
  end

  test "requires a manager" do
    review_cycle = ReviewCycle.new(
      reviewee: people(:ada),
      name: "2026 Mid-Year Review",
      status: "draft",
      start_on: Date.new(2026, 6, 1),
      end_on: Date.new(2026, 6, 30)
    )

    assert_not review_cycle.valid?
    assert_includes review_cycle.errors[:manager], "must exist"
  end

  test "requires a name" do
    review_cycle = ReviewCycle.new(
      reviewee: people(:ada),
      manager: people(:grace),
      status: "draft",
      start_on: Date.new(2026, 6, 1),
      end_on: Date.new(2026, 6, 30)
    )

    assert_not review_cycle.valid?
    assert_includes review_cycle.errors[:name], "can't be blank"
  end

  test "allows up to three peer reviewers" do
    review_cycle = ReviewCycle.new(
      reviewee: people(:ada),
      manager: people(:grace),
      peer_reviewers: [people(:linus), people(:katherine), people(:margaret), people(:donald)],
      name: "2026 Mid-Year Review",
      status: "draft",
      start_on: Date.new(2026, 6, 1),
      end_on: Date.new(2026, 6, 30)
    )

    assert_not review_cycle.valid?
    assert_includes review_cycle.errors[:peer_reviewers], "can have at most 3 reviewers"
  end

  test "requires a supported status" do
    review_cycle = ReviewCycle.new(
      reviewee: people(:ada),
      manager: people(:grace),
      name: "2026 Mid-Year Review",
      status: "archived",
      start_on: Date.new(2026, 6, 1),
      end_on: Date.new(2026, 6, 30)
    )

    assert_not review_cycle.valid?
    assert_includes review_cycle.errors[:status], "is not included in the list"
  end

  test "does not allow the reviewee to review their own cycle" do
    review_cycle = ReviewCycle.new(
      reviewee: people(:ada),
      manager: people(:grace),
      peer_reviewers: [people(:ada)],
      name: "2026 Mid-Year Review",
      status: "draft",
      start_on: Date.new(2026, 6, 1),
      end_on: Date.new(2026, 6, 30)
    )

    assert_not review_cycle.valid?
    assert_includes review_cycle.errors[:peer_reviewers], "cannot include the reviewee"
  end

  test "does not allow the manager to also be a peer reviewer" do
    review_cycle = ReviewCycle.new(
      reviewee: people(:ada),
      manager: people(:grace),
      peer_reviewers: [people(:grace)],
      name: "2026 Mid-Year Review",
      status: "draft",
      start_on: Date.new(2026, 6, 1),
      end_on: Date.new(2026, 6, 30)
    )

    assert_not review_cycle.valid?
    assert_includes review_cycle.errors[:peer_reviewers], "cannot include the manager"
  end

  test "requires an end date on or after the start date" do
    review_cycle = ReviewCycle.new(
      reviewee: people(:ada),
      manager: people(:grace),
      name: "2026 Mid-Year Review",
      status: "draft",
      start_on: Date.new(2026, 6, 30),
      end_on: Date.new(2026, 6, 1)
    )

    assert_not review_cycle.valid?
    assert_includes review_cycle.errors[:end_on], "must be on or after the start date"
  end

  test "supports review requests and submissions" do
    review_cycle = review_cycles(:engineering_q2)

    assert_equal 4, review_cycle.review_requests.count
    assert_includes review_cycle.review_submissions, review_submissions(:self_submission)
  end
end
