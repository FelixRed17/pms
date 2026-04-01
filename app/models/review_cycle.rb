class ReviewCycle < ApplicationRecord
  STATUSES = %w[draft active closed].freeze
  MAX_PEER_REVIEWERS = 3

  belongs_to :reviewee, class_name: "Person", inverse_of: :review_cycles_as_reviewee
  belongs_to :manager, class_name: "Person", inverse_of: :managed_review_cycles

  has_many :review_assignments, dependent: :destroy, inverse_of: :review_cycle
  has_many :peer_review_assignments, dependent: :destroy, inverse_of: :review_cycle
  has_many :peer_reviewers, through: :peer_review_assignments, source: :peer_reviewer

  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :start_on, presence: true
  validates :end_on, presence: true
  validate :end_on_cannot_be_before_start_on
  validate :peer_reviewer_rules

  private

  def end_on_cannot_be_before_start_on
    return if start_on.blank? || end_on.blank?
    return if end_on >= start_on

    errors.add(:end_on, "must be on or after the start date")
  end

  def peer_reviewer_rules
    reviewers = peer_reviewers.to_a
    reviewer_ids = reviewers.filter_map(&:id)

    if reviewers.size > MAX_PEER_REVIEWERS
      errors.add(:peer_reviewers, "can have at most #{MAX_PEER_REVIEWERS} reviewers")
    end

    if reviewer_ids.uniq.size != reviewer_ids.size
      errors.add(:peer_reviewers, "must be unique")
    end

    if reviewee_id.present? && reviewer_ids.include?(reviewee_id)
      errors.add(:peer_reviewers, "cannot include the reviewee")
    end

    if manager_id.present? && reviewer_ids.include?(manager_id)
      errors.add(:peer_reviewers, "cannot include the manager")
    end
  end
end
