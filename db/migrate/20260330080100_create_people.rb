class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people do |t|
      t.references :user, null: true, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :job_title

      t.timestamps
    end

    add_index :people, "lower(email)", unique: true, name: "index_people_on_lower_email"
  end
end
