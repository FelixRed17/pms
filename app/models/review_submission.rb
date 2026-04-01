class ReviewSubmission < ApplicationRecord
  STATUSES = {
    draft: "draft",
    submitted: "submitted"
  }.freeze

  belongs_to :review_request, inverse_of: :review_submissions
  belongs_to :review_cycle, inverse_of: :review_submissions
  belongs_to :reviewee, class_name: "Person", inverse_of: :review_submissions_as_reviewee
  belongs_to :reviewer, class_name: "Person", inverse_of: :review_submissions_as_reviewer, optional: true

  has_many :review_answers, dependent: :destroy, inverse_of: :review_submission

  accepts_nested_attributes_for :review_answers

  enum :status, STATUSES, validate: true
  enum :reviewer_role, ReviewRequest::REVIEWER_ROLES, prefix: true, validate: true

  scope :submitted, -> { where(status: "submitted") }

  validate :must_answer_all_rendered_questions
  validate :only_one_submitted_submission_per_request

  def mark_submitted!
    update!(status: "submitted", submitted_at: Time.current)
  end

  private

  def must_answer_all_rendered_questions
    expected = review_request.questionnaire_template.rendered_question_templates.map(&:id).sort
    actual = review_answers.reject(&:marked_for_destruction?).map(&:question_template_id).compact.sort

    return if expected == actual

    errors.add(:review_answers, "must answer every rendered question")
  end

  def only_one_submitted_submission_per_request
    return unless status == "submitted"
    return unless review_request

    existing_submission = review_request.review_submissions.submitted.where.not(id: id).exists?
    return unless existing_submission

    errors.add(:review_request_id, "already has a submitted response")
  end
end
