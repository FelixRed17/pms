class CreatePeerReviewAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :peer_review_assignments do |t|
      t.references :review_cycle, null: false, foreign_key: true
      t.references :peer_reviewer, null: false, foreign_key: { to_table: :people }

      t.timestamps
    end

    add_index :peer_review_assignments,
      [:review_cycle_id, :peer_reviewer_id],
      unique: true
  end
end
