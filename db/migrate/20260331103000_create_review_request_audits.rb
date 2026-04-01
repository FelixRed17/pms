class CreateReviewRequestAudits < ActiveRecord::Migration[8.1]
  def change
    create_table :review_request_audits do |t|
      t.references :review_request, null: false, foreign_key: true
      t.references :performed_by, foreign_key: { to_table: :users }
      t.string :action, null: false
      t.text :reason

      t.timestamps
    end
  end
end
