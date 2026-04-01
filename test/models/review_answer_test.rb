require "test_helper"

class ReviewAnswerTest < ActiveSupport::TestCase
  setup do
    @reviewee = people(:ada)
    @manager = people(:grace)

    @cycle = ReviewCycle.create!(
      reviewee: @reviewee,
      manager: @manager,
      name: "2026 Mid-Year Review",
      status: "draft",
      start_on: Date.new(2026, 6, 1),
      end_on: Date.new(2026, 6, 30)
    )

    @assignment = ReviewAssignment.create!(
      name: "Self review",
      review_cycle: @cycle,
      reviewer: @reviewee,
      reviewee: @reviewee,
      assignment_type: "self",
      status: "pending"
    )
  end

  test "is valid with text value for text question" do
    question = Question.create!(
      question_text: "Describe a strength",
      question_type: "text",
      position: 1,
      active: true,
      audience: "all"
    )

    answer = ReviewAnswer.new(
      review_assignment: @assignment,
      question: question,
      text_value: "Very reliable"
    )

    assert answer.valid?
  end

  test "is valid with rating value for rating question" do
    question = Question.create!(
      question_text: "Rate communication",
      question_type: "rating",
      position: 2,
      active: true,
      audience: "all"
    )

    answer = ReviewAnswer.new(
      review_assignment: @assignment,
      question: question,
      rating_value: 4
    )

    assert answer.valid?
  end

  test "is valid with boolean value for boolean question" do
    question = Question.create!(
      question_text: "Would you work with them again?",
      question_type: "boolean",
      position: 3,
      active: true,
      audience: "all"
    )

    answer = ReviewAnswer.new(
      review_assignment: @assignment,
      question: question,
      boolean_value: true
    )

    assert answer.valid?
  end

  test "rejects mismatched value type" do
    question = Question.create!(
      question_text: "Describe a strength",
      question_type: "text",
      position: 1,
      active: true,
      audience: "all"
    )

    answer = ReviewAnswer.new(
      review_assignment: @assignment,
      question: question,
      rating_value: 5
    )

    assert_not answer.valid?
    assert_includes answer.errors[:base], "must match the question type"
  end

  test "does not allow duplicate question answers for the same assignment" do
    question = Question.create!(
      question_text: "Describe a strength",
      question_type: "text",
      position: 1,
      active: true,
      audience: "all"
    )

    ReviewAnswer.create!(
      review_assignment: @assignment,
      question: question,
      text_value: "Strong collaborator"
    )

    duplicate = ReviewAnswer.new(
      review_assignment: @assignment,
      question: question,
      text_value: "Clear communicator"
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:question_id], "already has an answer for this assignment"
  end
end
