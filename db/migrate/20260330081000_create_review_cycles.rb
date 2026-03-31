class CreateReviewCycles < ActiveRecord::Migration[8.1]
  def change
    create_table :review_cycles do |t|
      t.references :person, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.string :review_type, null: false
      t.string :status, null: false, default: "draft"
      t.date :start_on, null: false
      t.date :end_on, null: false

      t.timestamps
    end
  end
end
