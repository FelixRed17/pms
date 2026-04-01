class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.references :review_cycle, null: false, foreign_key: true
      t.text :content, null: false
      t.string :question_type, null: false
      t.integer :position, null: false

      t.timestamps
    end

    add_index :questions, [:review_cycle_id, :position], unique: true
  end
end
