class MagicLink < ApplicationRecord
  PURPOSE_REVIEW_SUBMISSION = "review_submission".freeze

  belongs_to :resource, polymorphic: true

  validates :token_digest, presence: true, uniqueness: true
  validates :purpose, presence: true
  validates :resource_type, presence: true
  validates :resource_id, presence: true
  validates :expires_at, presence: true

  scope :active, lambda {
    where(used_at: nil, revoked_at: nil)
      .where("expires_at > ?", Time.current)
  }

  attr_reader :raw_token

  def self.issue!(purpose:, resource:, recipient_identifier: nil, expires_at: 3.days.from_now)
    revoke_active_for!(purpose:, resource:)

    raw_token = SecureRandom.urlsafe_base64(32)
    record = create!(
      purpose:,
      resource:,
      recipient_identifier:,
      token_digest: digest(raw_token),
      expires_at:
    )

    record.instance_variable_set(:@raw_token, raw_token)
    record
  end

  def self.find_active_by_token(raw_token, purpose:)
    return nil if raw_token.blank?

    active.find_by(token_digest: digest(raw_token), purpose:)
  end

  def self.digest(raw_token)
    Digest::SHA256.hexdigest(raw_token)
  end

  def self.revoke_active_for!(purpose:, resource:)
    where(
      purpose:,
      resource:,
      used_at: nil,
      revoked_at: nil
    ).where("expires_at > ?", Time.current)
      .update_all(revoked_at: Time.current, updated_at: Time.current)
  end

  def consume!
    now = Time.current

    self.class
      .where(id:, used_at: nil, revoked_at: nil)
      .where("expires_at > ?", now)
      .update_all(used_at: now, updated_at: now) == 1
  end

  def expired?
    expires_at <= Time.current
  end

  def used?
    used_at.present?
  end

  def revoked?
    revoked_at.present?
  end

  def active?
    !expired? && !used? && !revoked?
  end

  def mark_accessed!
    update!(accessed_at: Time.current)
  end

  def mark_used!
    update!(used_at: Time.current)
  end

  def revoke!
    update!(revoked_at: Time.current)
  end
end
