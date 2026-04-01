class EnforceOneSubmittedSubmissionPerRequest < ActiveRecord::Migration[8.1]
  def change
    add_index :review_submissions,
      :review_request_id,
      unique: true,
      where: "status = 'submitted'",
      name: "idx_one_submitted_review_submission_per_request"
  end
end
