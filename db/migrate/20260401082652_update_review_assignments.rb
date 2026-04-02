class UpdateReviewAssignments < ActiveRecord::Migration[8.1]
  def change
    add_reference :review_assignments, :review_cycle, null: false, foreign_key: true unless column_exists?(:review_assignments, :review_cycle_id)
    add_reference :review_assignments, :reviewer, null: false, foreign_key: { to_table: :people } unless column_exists?(:review_assignments, :reviewer_id)
    add_reference :review_assignments, :reviewee, null: false, foreign_key: { to_table: :people } unless column_exists?(:review_assignments, :reviewee_id)
    add_column :review_assignments, :assignment_type, :string, null: false unless column_exists?(:review_assignments, :assignment_type)
    add_column :review_assignments, :status, :string, null: false, default: "pending" unless column_exists?(:review_assignments, :status)
    add_column :review_assignments, :submitted_at, :datetime unless column_exists?(:review_assignments, :submitted_at)

    add_index :review_assignments,
      [:review_cycle_id, :reviewer_id, :assignment_type],
      unique: true,
      name: "index_review_assignments_uniqueness",
      if_not_exists: true
  end
end
