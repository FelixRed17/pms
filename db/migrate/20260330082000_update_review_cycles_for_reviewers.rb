class UpdateReviewCyclesForReviewers < ActiveRecord::Migration[8.1]
  def change
    rename_column :review_cycles, :person_id, :reviewee_id
    remove_column :review_cycles, :review_type, :string

    rename_index :review_cycles, "index_review_cycles_on_person_id", "index_review_cycles_on_reviewee_id"

    add_reference :review_cycles, :manager, null: false, foreign_key: { to_table: :people }
  end
end
