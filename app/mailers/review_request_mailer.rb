class ReviewRequestMailer < ApplicationMailer
  def questionnaire_link(review_request, raw_token)
    @review_request = review_request
    @reviewee = review_request.reviewee
    @questionnaire_title = review_request.questionnaire_heading
    @magic_link_url = review_access_url(token: raw_token)

    mail(
      to: review_request.recipient_email,
      subject: "Performance review questionnaire for #{@reviewee.full_name}"
    )
  end
end
