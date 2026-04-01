require "test_helper"

class QuestionnaireTemplateTest < ActiveSupport::TestCase
  test "returns at most five rendered question templates in order" do
    template = questionnaire_templates(:self_review)

    assert_equal 5, template.rendered_question_templates.count
    assert_equal [
      "Functional and Technical Knowledge",
      "Values Alignment",
      "Collaboration and Teamwork",
      "Adaptability and Continuous Learning",
      "Time Management and Reliability"
    ], template.rendered_question_templates.map(&:title)
  end

  test "requires a supported audience type" do
    template = QuestionnaireTemplate.new(name: "Invalid", audience_type: "custom")

    assert_not template.valid?
    assert_includes template.errors[:audience_type], "is not included in the list"
  end
end
