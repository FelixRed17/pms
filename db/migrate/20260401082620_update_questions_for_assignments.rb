class UpdateQuestionsForAssignments < ActiveRecord::Migration[8.1]
  def change
    rename_column :questions, :content, :question_text if column_exists?(:questions, :content) && !column_exists?(:questions, :question_text)

    add_column :questions, :active, :boolean, null: false, default: true unless column_exists?(:questions, :active)

    if index_exists?(:questions, [ :review_cycle_id, :position ], name: "index_questions_on_review_cycle_id_and_position")
      remove_index :questions, name: "index_questions_on_review_cycle_id_and_position"
    end

    remove_reference :questions, :review_cycle, foreign_key: true if column_exists?(:questions, :review_cycle_id)

    add_index :questions, [ :active, :position ], if_not_exists: true
    add_index :questions, :active, if_not_exists: true
  end
end
