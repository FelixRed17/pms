class QuestionnaireTemplate < ApplicationRecord
  AUDIENCE_TYPES = {
    self_review: "self_review",
    peer_review: "peer_review",
    manager_review: "manager_review"
  }.freeze

  has_many :question_templates, -> { order(:position, :id) }, dependent: :destroy, inverse_of: :questionnaire_template

  enum :audience_type, AUDIENCE_TYPES, validate: true

  validates :name, presence: true
  validates :audience_type, presence: true, uniqueness: true

  def rendered_question_templates
    rendered_titles = QuestionnaireCatalog.rendered_titles_for(audience_type)

    question_templates.select { |question_template| rendered_titles.include?(question_template.title) }
      .sort_by { |question_template| rendered_titles.index(question_template.title) || question_template.position }
      .first(QuestionnaireCatalog::MAX_RENDERED_SECTIONS)
  end

  def self.seed_system_templates!
    QuestionnaireCatalog::DEFINITIONS.each do |template_definition|
      template = find_or_initialize_by(audience_type: template_definition[:audience_type])
      template.update!(name: template_definition[:name])

      template_definition[:questions].each do |question_definition|
        question_template = template.question_templates.find_or_initialize_by(title: question_definition[:title])
        question_template.update!(question_definition)
      end
    end
  end
end
