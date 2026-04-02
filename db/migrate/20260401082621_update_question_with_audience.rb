class UpdateQuestionWithAudience < ActiveRecord::Migration[8.1]
  def change
    add_column :questions, :audience, :string, null: false, default: "all" unless column_exists?(:questions, :audience)
    add_index :questions, :audience, if_not_exists: true
  end
end
