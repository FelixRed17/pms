class ReviewAnswer < ApplicationRecord
  belongs_to :review_submission, inverse_of: :review_answers
  belongs_to :question_template, inverse_of: :review_answers

  validates :question_template_id, uniqueness: { scope: :review_submission_id }
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, allow_nil: true
  validate :score_requirements
  validate :comment_requirements

  delegate :required?, :requires_comment?, :requires_score?, to: :question_template

  private

  def score_requirements
    return unless question_template
    return unless requires_score? && score.blank?

    errors.add(:score, "can't be blank")
  end

  def comment_requirements
    return unless question_template
    return unless required? && requires_comment? && comment.blank?

    errors.add(:comment, "can't be blank")
  end
end
