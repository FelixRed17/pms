class AddDeliveryFieldsToReviewRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :review_requests, :delivery_status, :string, null: false, default: "pending" unless column_exists?(:review_requests, :delivery_status)
    add_column :review_requests, :last_sent_at, :datetime unless column_exists?(:review_requests, :last_sent_at)
    add_column :review_requests, :delivery_attempts_count, :integer, null: false, default: 0 unless column_exists?(:review_requests, :delivery_attempts_count)
    add_column :review_requests, :last_delivery_error, :text unless column_exists?(:review_requests, :last_delivery_error)
  end
end
