class ReviewAssignment < ApplicationRecord
  TYPES = %w[self peer manager].freeze
  STATUSES = %w[pending submitted expired].freeze

  belongs_to :review_cycle
  belongs_to :reviewer, class_name: "Person"
  belongs_to :reviewee, class_name: "Person"

  has_many :review_answers, dependent: :destroy
  has_many :magic_links, as: :resource, dependent: :destroy

  validates :assignment_type, presence: true, inclusion: { in: TYPES }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :reviewer_id, uniqueness: {
    scope: [ :review_cycle_id, :assignment_type ],
    message: "already has this assignment type for the cycle"
  }

  validate :reviewee_matches_cycle
  validate :assignment_type_rules

  def issue_magic_link!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, recipient_identifier: nil, expires_at: 3.days.from_now)
    MagicLink.issue!(
      purpose: purpose,
      resource: self,
      recipient_identifier: recipient_identifier,
      expires_at: expires_at
    )
  end

  def mark_submitted!
    update!(status: "submitted", submitted_at: Time.current)
  end

  def submitted?
    status == "submitted"
  end

  private

  def reviewee_matches_cycle
    return unless review_cycle && reviewee
    return if review_cycle.reviewee_id == reviewee_id

    errors.add(:reviewee, "must match the review cycle reviewee")
  end

  def assignment_type_rules
    return unless review_cycle && reviewer && reviewee

    case assignment_type
    when "self"
      errors.add(:reviewer, "must be the reviewee for self assignments") unless reviewer_id == reviewee_id
    when "manager"
      errors.add(:reviewer, "must be the cycle manager for manager assignments") unless reviewer_id == review_cycle.manager_id
    when "peer"
      errors.add(:reviewer, "cannot be the reviewee for peer assignments") if reviewer_id == reviewee_id
      errors.add(:reviewer, "cannot be the cycle manager for peer assignments") if reviewer_id == review_cycle.manager_id
    end
  end
end
