require "test_helper"

load Rails.root.join("db/migrate/20260331090000_create_questions.rb")
load Rails.root.join("db/migrate/20260331100000_create_questionnaire_templates.rb")
load Rails.root.join("db/migrate/20260331101000_create_review_requests_and_submissions.rb")
load Rails.root.join("db/migrate/20260331102000_add_delivery_fields_to_review_requests.rb")
load Rails.root.join("db/migrate/20260331104000_enforce_one_submitted_submission_per_request.rb")
load Rails.root.join("db/migrate/20260401082621_update_question_with_audience.rb")
load Rails.root.join("db/migrate/20260401082652_update_review_assignments.rb")
load Rails.root.join("db/migrate/20260401082715_create_review_answers.rb")

class IdempotentMigrationsTest < ActiveSupport::TestCase
  MIGRATIONS = [
    CreateQuestions,
    CreateQuestionnaireTemplates,
    CreateReviewRequestsAndSubmissions,
    AddDeliveryFieldsToReviewRequests,
    EnforceOneSubmittedSubmissionPerRequest,
    UpdateQuestionWithAudience,
    UpdateReviewAssignments,
    CreateReviewAnswers
  ].freeze

  test "guarded migrations can run against the current schema" do
    MIGRATIONS.each do |migration|
      error = nil

      ActiveRecord::Migration.suppress_messages do
        migration.new.migrate(:up)
      rescue StandardError => exception
        error = exception
      end

      assert_nil error, error_message_for(migration, error)
    end
  end

  private

  def error_message_for(migration, error)
    return "#{migration.name} should be idempotent" if error.nil?

    "#{migration.name} should be idempotent, but raised #{error.class}: #{error.message}"
  end
end
