class Question < ApplicationRecord
  enum :question_type, {
    text: "text",
    rating: "rating",
    boolean: "boolean"
  }, prefix: true

  enum :audience, {
    all: "all",
    self: "self",
    peer: "peer",
    manager: "manager"
  }, prefix: true

  has_many :review_answers, dependent: :restrict_with_exception

  validates :question_text, presence: true
  validates :position, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :question_type, presence: true
  validates :audience, presence: true
  validates :active, inclusion: { in: [ true, false ] }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position) }
  scope :active_ordered, -> { active.ordered }
  scope :for_assignment_type, ->(assignment_type) { where(audience: [ "all", assignment_type ]).order(:position) }

  def dynamic_text(reviewer:, reviewee:)
    format(question_text, dynamic_text_placeholders(reviewer:, reviewee:))
  rescue KeyError
    question_text
  end

  private

  def dynamic_text_placeholders(reviewer:, reviewee:)
    reviewee_name = [ reviewee.first_name, reviewee.last_name ].compact_blank.join(" ").presence || reviewee.email
    self_review = reviewer == reviewee

    {
      subject_name: self_review ? "you" : reviewee_name,
      subject_object: self_review ? "you" : reviewee_name,
      subject_possessive: self_review ? "your" : "#{reviewee_name}'s",
      subject_reflexive: self_review ? "yourself" : reviewee_name,
      subject_is: self_review ? "are" : "is",
      subject_has: self_review ? "have" : "has"
    }
  end
end
