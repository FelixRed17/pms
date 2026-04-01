class CreateReviewRequestsAndSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :review_requests do |t|
      t.references :review_cycle, null: false, foreign_key: true
      t.references :reviewee, null: false, foreign_key: { to_table: :people }
      t.references :reviewer, foreign_key: { to_table: :people }
      t.string :reviewer_role, null: false
      t.string :recipient_email, null: false
      t.string :status, null: false, default: "pending"

      t.timestamps
    end

    add_index :review_requests, [:review_cycle_id, :reviewer_role, :reviewer_id], unique: true, name: "idx_review_requests_on_cycle_role_reviewer"

    create_table :review_submissions do |t|
      t.references :review_request, null: false, foreign_key: true
      t.references :review_cycle, null: false, foreign_key: true
      t.references :reviewee, null: false, foreign_key: { to_table: :people }
      t.references :reviewer, foreign_key: { to_table: :people }
      t.string :reviewer_role, null: false
      t.string :status, null: false, default: "draft"
      t.datetime :submitted_at

      t.timestamps
    end

    create_table :review_answers do |t|
      t.references :review_submission, null: false, foreign_key: true
      t.references :question_template, null: false, foreign_key: true
      t.integer :score
      t.text :comment

      t.timestamps
    end

    add_index :review_answers, [:review_submission_id, :question_template_id], unique: true, name: "idx_review_answers_on_submission_question"
  end
end
