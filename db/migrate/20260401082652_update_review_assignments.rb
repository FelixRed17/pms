class UpdateReviewAssignments < ActiveRecord::Migration[8.1]
    def change
      change_table :review_assignments, bulk: true do |t|
        t.references :review_cycle, null: false, foreign_key: true
        t.references :reviewer, null: false, foreign_key: { to_table: :people }
        t.references :reviewee, null: false, foreign_key: { to_table: :people }
        t.string :assignment_type, null: false
        t.string :status, null: false, default: "pending"
        t.datetime :submitted_at
      end

      add_index :review_assignments,
        [:review_cycle_id, :reviewer_id, :assignment_type],
        unique: true,
        name: "index_review_assignments_uniqueness"
    end
  end
