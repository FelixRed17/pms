class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions, if_not_exists: true do |t|
      t.boolean :active
      t.integer :position
      t.text :question_text
      t.string :question_type
      t.timestamps
    end

    add_index :questions, [ :active, :position ], if_not_exists: true
    add_index :questions, :active, if_not_exists: true
    add_index :questions, :position, if_not_exists: true
  end
end
