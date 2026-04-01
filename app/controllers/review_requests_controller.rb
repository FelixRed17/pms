class ReviewRequestsController < ApplicationController
  def reissue
    review_request = ReviewRequest.find(params[:id])
    result = ReissueReviewRequestLink.new(
      review_request:,
      performed_by: current_user,
      reason: params.dig(:review_request, :reason)
    ).call

    if result.success?
      redirect_to dashboard_cycles_path, notice: "Review link reissued for #{review_request.recipient_email}."
      return
    end

    redirect_to dashboard_cycles_path, alert: "Unable to reissue this review link."
  end
end
