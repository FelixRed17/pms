class ReviewAssignment < ApplicationRecord
  has_many :magic_links, as: :resource, dependent: :destroy

  validates :name, presence: true

  def issue_magic_link!(purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION, recipient_identifier: nil, expires_at: 3.days.from_now)
    MagicLink.issue!(
      purpose:,
      resource: self,
      recipient_identifier:,
      expires_at:
    )
  end
end
