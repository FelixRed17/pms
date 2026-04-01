class QuestionTemplate < ApplicationRecord
  QUESTION_TYPES = {
    score_with_comment: "score_with_comment",
    score_only: "score_only",
    comment_only: "comment_only"
  }.freeze

  belongs_to :questionnaire_template, inverse_of: :question_templates
  has_many :review_answers, dependent: :restrict_with_exception, inverse_of: :question_template

  enum :question_type, QUESTION_TYPES, validate: true

  validates :title, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :position, uniqueness: { scope: :questionnaire_template_id }
  validates :required, inclusion: { in: [true, false] }

  def guidance_points
    description.to_s.lines.map(&:strip).filter_map do |line|
      cleaned = line.delete_prefix("-").strip
      cleaned if cleaned.present?
    end
  end

  def requires_score?
    score_only? || score_with_comment?
  end

  def requires_comment?
    comment_only? || score_with_comment?
  end
end
