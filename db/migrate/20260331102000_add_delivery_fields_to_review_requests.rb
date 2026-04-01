class AddDeliveryFieldsToReviewRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :review_requests, :delivery_status, :string, null: false, default: "pending"
    add_column :review_requests, :last_sent_at, :datetime
    add_column :review_requests, :delivery_attempts_count, :integer, null: false, default: 0
    add_column :review_requests, :last_delivery_error, :text
  end
end
