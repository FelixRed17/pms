class SendReviewAssignmentMagicLink
  Result = Struct.new(:success?, :magic_link, :errors, keyword_init: true)

  def self.call(review_assignment:, expires_at: 3.days.from_now)
    new(review_assignment:, expires_at:).call
  end

  def initialize(review_assignment:, expires_at:)
    @review_assignment = review_assignment
    @expires_at = expires_at
  end

  def call
    return failure("A reviewer email address is required.") if review_assignment.reviewer.email.blank?

    magic_link = review_assignment.issue_magic_link!(
      recipient_identifier: review_assignment.reviewer.email,
      expires_at: expires_at
    )

    ReviewAssignmentMailer.magic_link(review_assignment:, magic_link:).deliver_now

    Result.new(success?: true, magic_link:, errors: [])
  rescue ActiveRecord::RecordInvalid => error
    failure(*error.record.errors.full_messages)
  end

  private

  attr_reader :expires_at, :review_assignment

  def failure(*errors)
    Result.new(success?: false, magic_link: nil, errors: errors.flatten.compact.uniq)
  end
end
