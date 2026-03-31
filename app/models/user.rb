class User < ApplicationRecord
  ROLES = %w[employee hr].freeze

  has_one :person, dependent: :nullify

  before_validation :normalize_email

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :role, presence: true, inclusion: { in: ROLES }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase.presence
  end
end
