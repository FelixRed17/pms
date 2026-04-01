require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  setup do
    @reviewee = Person.create!(
      first_name: "Ada",
      last_name: "Lovelace",
      email: "ada-#{SecureRandom.hex(4)}@example.com"
    )
    @peer_reviewer = Person.create!(
      first_name: "Grace",
      last_name: "Hopper",
      email: "grace-#{SecureRandom.hex(4)}@example.com"
    )
  end

  test "active_ordered returns active questions sorted by position" do
    second_question = Question.create!(
      question_text: "Second question",
      question_type: "text",
      position: 2,
      active: true
    )
    first_question = Question.create!(
      question_text: "First question",
      question_type: "rating",
      position: 1,
      active: true
    )
    Question.create!(
      question_text: "Inactive question",
      question_type: "boolean",
      position: 3,
      active: false
    )

    assert_equal [ first_question, second_question ], Question.active_ordered.to_a
  end

  test "dynamic_text renders self review wording from placeholders" do
    question = Question.create!(
      question_text: "What are %{subject_possessive} strongest contributions?",
      question_type: "text",
      position: 1,
      active: true
    )

    assert_equal "What are your strongest contributions?",
      question.dynamic_text(reviewer: @reviewee, reviewee: @reviewee)
  end

  test "dynamic_text renders non-self review wording from placeholders" do
    question = Question.create!(
      question_text: "What are %{subject_possessive} strongest contributions?",
      question_type: "text",
      position: 1,
      active: true
    )

    assert_equal "What are Ada Lovelace's strongest contributions?",
      question.dynamic_text(reviewer: @peer_reviewer, reviewee: @reviewee)
  end

  test "dynamic_text falls back to the raw question text when no placeholders are used" do
    question = Question.create!(
      question_text: "Describe a key strength.",
      question_type: "text",
      position: 1,
      active: true
    )

    assert_equal "Describe a key strength.",
      question.dynamic_text(reviewer: @peer_reviewer, reviewee: @reviewee)
  end

  test "for_assignment_type returns shared and matching audience questions in order" do
    shared = Question.create!(
      question_text: "Shared",
      question_type: "text",
      position: 1,
      active: true,
      audience: "all"
    )
    self_only = Question.create!(
      question_text: "Self only",
      question_type: "text",
      position: 2,
      active: true,
      audience: "self"
    )
    peer_only = Question.create!(
      question_text: "Peer only",
      question_type: "text",
      position: 3,
      active: true,
      audience: "peer"
    )

    assert_equal [ shared, self_only ], Question.for_assignment_type("self").to_a
  end
end
