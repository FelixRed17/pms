class PeerReviewAssignment < ApplicationRecord
  belongs_to :review_cycle, inverse_of: :peer_review_assignments
  belongs_to :peer_reviewer, class_name: "Person", inverse_of: :peer_review_assignments

  validates :peer_reviewer_id, uniqueness: { scope: :review_cycle_id }
end
