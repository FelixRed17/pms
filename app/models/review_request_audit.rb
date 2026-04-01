class ReviewRequestAudit < ApplicationRecord
  ACTIONS = {
    created: "created",
    reissued: "reissued"
  }.freeze

  belongs_to :review_request, inverse_of: :review_request_audits
  belongs_to :performed_by, class_name: "User", optional: true

  enum :action, ACTIONS, validate: true

  validates :action, presence: true
  validate :reason_required_for_reissue

  private

  def reason_required_for_reissue
    return unless action == "reissued" && reason.blank?

    errors.add(:reason, "can't be blank")
  end
end
