class CreateReviewAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :review_assignments do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
