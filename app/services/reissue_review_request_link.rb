class ReissueReviewRequestLink
  Result = Struct.new(:review_request, :success?, keyword_init: true)

  def initialize(review_request:, performed_by:, reason:)
    @review_request = review_request
    @performed_by = performed_by
    @reason = reason
  end

  def call
    return Result.new(review_request:, success?: false) unless review_request.reissueable?

    ActiveRecord::Base.transaction do
      MagicLink.revoke_active_for!(
        purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION,
        resource: review_request
      )

      review_request.queue_delivery!
      review_request.review_request_audits.create!(
        action: "reissued",
        reason:,
        performed_by:
      )
    end

    SendReviewRequestJob.perform_later(review_request.id)
    Result.new(review_request:, success?: true)
  rescue ActiveRecord::RecordInvalid
    Result.new(review_request:, success?: false)
  end

  private

  attr_reader :review_request, :performed_by, :reason
end
