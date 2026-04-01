class ReviewRequest < ApplicationRecord
  REVIEWER_ROLES = {
    reviewee: "reviewee",
    peer: "peer",
    manager: "manager"
  }.freeze
  STATUSES = {
    pending: "pending",
    completed: "completed"
  }.freeze
  DELIVERY_STATUSES = {
    pending: "pending",
    queued: "queued",
    sent: "sent",
    failed: "failed"
  }.freeze

  belongs_to :review_cycle, inverse_of: :review_requests
  belongs_to :reviewee, class_name: "Person", inverse_of: :review_requests_as_reviewee
  belongs_to :reviewer, class_name: "Person", inverse_of: :review_requests_as_reviewer, optional: true

  has_many :magic_links, as: :resource, dependent: :destroy
  has_many :review_submissions, dependent: :destroy, inverse_of: :review_request
  has_many :review_request_audits, dependent: :destroy, inverse_of: :review_request

  enum :reviewer_role, REVIEWER_ROLES, prefix: true, validate: true
  enum :status, STATUSES, validate: true
  enum :delivery_status, DELIVERY_STATUSES, prefix: :delivery, validate: true

  validates :recipient_email, presence: true

  def build_submission
    review_submissions.build(
      review_cycle:,
      reviewee:,
      reviewer:,
      reviewer_role:,
      status: "draft"
    )
  end

  def questionnaire_template
    @questionnaire_template ||= QuestionnaireTemplate.find_by!(audience_type: questionnaire_audience_type)
  end

  def build_submission_with_answers
    build_submission.tap do |submission|
      submission.review_answers = questionnaire_template.rendered_question_templates.map do |question_template|
        ReviewAnswer.new(question_template:)
      end
    end
  end

  def questionnaire_heading
    return "Key Behaviours - #{reviewee.full_name}" if reviewer_role_peer?

    questionnaire_template.name
  end

  def mark_completed!
    update!(status: "completed")
  end

  def queue_delivery!
    update!(
      delivery_status: "queued",
      last_delivery_error: nil
    )
  end

  def mark_delivery_sent!
    update!(
      delivery_status: "sent",
      last_sent_at: Time.current,
      delivery_attempts_count: delivery_attempts_count + 1,
      last_delivery_error: nil
    )
  end

  def mark_delivery_failed!(error)
    update!(
      delivery_status: "failed",
      delivery_attempts_count: delivery_attempts_count + 1,
      last_delivery_error: error.message
    )
  end

  def reissueable?
    !completed?
  end

  private

  def questionnaire_audience_type
    {
      "reviewee" => "self_review",
      "peer" => "peer_review",
      "manager" => "manager_review"
    }.fetch(reviewer_role)
  end
end
