class UpdateQuestionWithAudience < ActiveRecord::Migration[8.1]
    def change
      add_column :questions, :audience, :string, null: false, default: "all"
      add_index :questions, :audience
    end
  end
