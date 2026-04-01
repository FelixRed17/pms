class Person < ApplicationRecord
  belongs_to :user, optional: true
  has_many :review_cycles_as_reviewee,
    class_name: "ReviewCycle",
    foreign_key: :reviewee_id,
    inverse_of: :reviewee,
    dependent: :destroy
  has_many :managed_review_cycles,
    class_name: "ReviewCycle",
    foreign_key: :manager_id,
    inverse_of: :manager
  has_many :review_assignments_as_reviewer,
    class_name: "ReviewAssignment",
    foreign_key: :reviewer_id,
    inverse_of: :reviewer,
    dependent: :destroy
  has_many :review_assignments_as_reviewee,
    class_name: "ReviewAssignment",
    foreign_key: :reviewee_id,
    inverse_of: :reviewee,
    dependent: :destroy
  has_many :peer_review_assignments,
    class_name: "PeerReviewAssignment",
    foreign_key: :peer_reviewer_id,
    inverse_of: :peer_reviewer,
    dependent: :destroy
  has_many :peer_review_cycles, through: :peer_review_assignments, source: :review_cycle
  has_many :review_requests_as_reviewee,
    class_name: "ReviewRequest",
    foreign_key: :reviewee_id,
    inverse_of: :reviewee,
    dependent: :destroy
  has_many :review_requests_as_reviewer,
    class_name: "ReviewRequest",
    foreign_key: :reviewer_id,
    inverse_of: :reviewer
  has_many :review_submissions_as_reviewee,
    class_name: "ReviewSubmission",
    foreign_key: :reviewee_id,
    inverse_of: :reviewee,
    dependent: :destroy
  has_many :review_submissions_as_reviewer,
    class_name: "ReviewSubmission",
    foreign_key: :reviewer_id,
    inverse_of: :reviewer

  before_validation :normalize_email

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase.presence
  end
end
