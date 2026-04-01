class ReviewAssignmentMailer < ApplicationMailer
  def magic_link(review_assignment:, magic_link:)
    @review_assignment = review_assignment
    @magic_link = magic_link
    @review_cycle = review_assignment.review_cycle
    @reviewee = review_assignment.reviewee
    @reviewer = review_assignment.reviewer
    @review_url = review_access_token_url(token: magic_link.raw_token)

    mail(
      to: @reviewer.email,
      subject: "Review request for #{full_name(@reviewee)}"
    )
  end

  private

  def full_name(person)
    [ person.first_name, person.last_name ].join(" ")
  end
end
