class LaunchReviewCycle
  Result = Struct.new(:review_cycle, :success?, keyword_init: true)

  def initialize(review_cycle:, launch:, performed_by: nil)
    @review_cycle = review_cycle
    @launch = launch
    @performed_by = performed_by
  end

  def call
    review_cycle.status = launch ? "active" : "draft"

    return Result.new(review_cycle:, success?: false) unless review_cycle.valid?

    ActiveRecord::Base.transaction do
      review_cycle.save!
      build_review_requests if launch
    end

    enqueue_review_request_delivery! if launch

    Result.new(review_cycle:, success?: true)
  rescue ActiveRecord::RecordInvalid
    Result.new(review_cycle:, success?: false)
  end

  private

  attr_reader :review_cycle, :launch

  def enqueue_review_request_delivery!
    review_cycle.review_requests.find_each do |review_request|
      SendReviewRequestJob.perform_later(review_request.id)
    end
  end

  def build_review_requests
    create_review_request!(
      reviewee: review_cycle.reviewee,
      reviewer: review_cycle.reviewee,
      reviewer_role: "reviewee",
      recipient_email: review_cycle.reviewee.email
    )

    review_cycle.peer_reviewers.each do |peer_reviewer|
      create_review_request!(
        reviewee: review_cycle.reviewee,
        reviewer: peer_reviewer,
        reviewer_role: "peer",
        recipient_email: peer_reviewer.email
      )
    end

    create_review_request!(
      reviewee: review_cycle.reviewee,
      reviewer: review_cycle.manager,
      reviewer_role: "manager",
      recipient_email: review_cycle.manager.email
    )
  end

  def create_review_request!(reviewee:, reviewer:, reviewer_role:, recipient_email:)
    review_request = review_cycle.review_requests.create!(
      reviewee:,
      reviewer:,
      reviewer_role:,
      recipient_email:,
      status: "pending",
      delivery_status: "queued"
    )

    review_request.review_request_audits.create!(
      action: "created",
      performed_by:
    )
  end

  attr_reader :performed_by
end
