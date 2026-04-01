class SendReviewRequestJob < ApplicationJob
  queue_as :default

  def perform(review_request_id)
    review_request = ReviewRequest.find(review_request_id)

    magic_link = MagicLink.issue!(
      purpose: MagicLink::PURPOSE_REVIEW_SUBMISSION,
      resource: review_request,
      recipient_identifier: review_request.recipient_email
    )

    mail = ReviewRequestMailer.questionnaire_link(review_request, magic_link.raw_token)

    if Rails.env.development?
      Rails.logger.info("\n--- MOCK REVIEW REQUEST EMAIL ---\n#{mail.body.encoded}\n--- END MOCK REVIEW REQUEST EMAIL ---\n")
    else
      mail.deliver_now
    end

    review_request.mark_delivery_sent!
  rescue StandardError => error
    review_request&.mark_delivery_failed!(error)
    raise
  end
end
