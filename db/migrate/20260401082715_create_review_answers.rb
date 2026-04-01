class CreateReviewAnswers < ActiveRecord::Migration[8.1]
    def change
      create_table :review_answers do |t|
        t.references :review_assignment, null: false, foreign_key: true
        t.references :question, null: false, foreign_key: true
        t.text :text_value
        t.integer :rating_value
        t.boolean :boolean_value
        t.timestamps
      end

      add_index :review_answers,
        [:review_assignment_id, :question_id],
        unique: true,
        name: "index_review_answers_uniqueness"
    end
  end
