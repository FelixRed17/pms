class CreateReviewRequestsAndSubmissions < ActiveRecord::Migration[8.1]
  def change
    unless table_exists?(:review_requests)
      create_table :review_requests do |t|
        t.references :review_cycle, null: false, foreign_key: true
        t.references :reviewee, null: false, foreign_key: { to_table: :people }
        t.references :reviewer, foreign_key: { to_table: :people }
        t.string :reviewer_role, null: false
        t.string :recipient_email, null: false
        t.string :status, null: false, default: "pending"

        t.timestamps
      end
    end

    add_index :review_requests, [:review_cycle_id, :reviewer_role, :reviewer_id], unique: true, name: "idx_review_requests_on_cycle_role_reviewer", if_not_exists: true

    unless table_exists?(:review_submissions)
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
    end

    ensure_review_answers_table!

    add_index :review_answers, [:review_submission_id, :question_template_id], unique: true, name: "idx_review_answers_on_submission_question", if_not_exists: true
  end

  private

  def ensure_review_answers_table!
    unless table_exists?(:review_answers)
      create_review_answers_table!
      return
    end

    return if legacy_review_answers_schema?

    if review_answers_empty?
      drop_table :review_answers
      create_review_answers_table!
      return
    end

    raise StandardError, "review_answers exists with an incompatible schema and contains data. Manual repair is required before continuing."
  end

  def create_review_answers_table!
    create_table :review_answers do |t|
      t.references :review_submission, null: false, foreign_key: true
      t.references :question_template, null: false, foreign_key: true
      t.integer :score
      t.text :comment

      t.timestamps
    end
  end

  def legacy_review_answers_schema?
    column_exists?(:review_answers, :review_submission_id) &&
      column_exists?(:review_answers, :question_template_id)
  end

  def review_answers_empty?
    select_value("SELECT COUNT(*) FROM #{quote_table_name(:review_answers)}").to_i.zero?
  end
end
