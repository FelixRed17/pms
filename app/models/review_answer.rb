class ReviewAnswer < ApplicationRecord
    belongs_to :review_assignment
    belongs_to :question

    validates :question_id, uniqueness: {
      scope: :review_assignment_id,
      message: "already has an answer for this assignment"
    }

    validate :value_matches_question_type

    private

    def value_matches_question_type
      return unless question

      case question.question_type
      when "text"
        errors.add(:base, "must match the question type") unless text_value.present? &&
  rating_value.blank? && boolean_value.nil?
      when "rating"
        valid = rating_value.present? && text_value.blank? && boolean_value.nil?
        errors.add(:base, "must match the question type") unless valid
      when "boolean"
        valid = !boolean_value.nil? && text_value.blank? && rating_value.blank?
        errors.add(:base, "must match the question type") unless valid
      end
    end
  end