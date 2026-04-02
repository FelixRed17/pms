class CreateQuestionnaireTemplates < ActiveRecord::Migration[8.1]
  def change
    unless table_exists?(:questionnaire_templates)
      create_table :questionnaire_templates do |t|
        t.string :name, null: false
        t.string :audience_type, null: false

        t.timestamps
      end
    end

    add_index :questionnaire_templates, :audience_type, unique: true, if_not_exists: true

    unless table_exists?(:question_templates)
      create_table :question_templates do |t|
        t.references :questionnaire_template, null: false, foreign_key: true
        t.string :title, null: false
        t.text :description
        t.string :question_type, null: false
        t.integer :position, null: false
        t.boolean :required, null: false, default: true
        t.string :category

        t.timestamps
      end
    end

    add_index :question_templates, [:questionnaire_template_id, :position], unique: true, name: "idx_question_templates_on_template_and_position", if_not_exists: true
  end
end
