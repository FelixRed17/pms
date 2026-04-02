# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_01_082715) do
  create_table "magic_links", force: :cascade do |t|
    t.datetime "accessed_at"
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "purpose", null: false
    t.string "recipient_identifier"
    t.bigint "resource_id", null: false
    t.string "resource_type", null: false
    t.datetime "revoked_at"
    t.string "token_digest", null: false
    t.datetime "updated_at", null: false
    t.datetime "used_at"
    t.index ["purpose", "resource_type", "resource_id"], name: "index_magic_links_on_purpose_and_resource"
    t.index ["purpose"], name: "index_magic_links_on_purpose"
    t.index ["resource_type", "resource_id"], name: "index_magic_links_on_resource_type_and_resource_id"
    t.index ["token_digest"], name: "index_magic_links_on_token_digest", unique: true
  end

  create_table "peer_review_assignments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "peer_reviewer_id", null: false
    t.integer "review_cycle_id", null: false
    t.datetime "updated_at", null: false
    t.index ["peer_reviewer_id"], name: "index_peer_review_assignments_on_peer_reviewer_id"
    t.index ["review_cycle_id", "peer_reviewer_id"], name: "idx_on_review_cycle_id_peer_reviewer_id_c5b9741730", unique: true
    t.index ["review_cycle_id"], name: "index_peer_review_assignments_on_review_cycle_id"
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "job_title"
    t.string "last_name", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index "lower(email)", name: "index_people_on_lower_email", unique: true
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "question_templates", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "position", null: false
    t.string "question_type", null: false
    t.integer "questionnaire_template_id", null: false
    t.boolean "required", default: true, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_template_id", "position"], name: "idx_question_templates_on_template_and_position", unique: true
    t.index ["questionnaire_template_id"], name: "index_question_templates_on_questionnaire_template_id"
  end

  create_table "questionnaire_templates", force: :cascade do |t|
    t.string "audience_type", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["audience_type"], name: "index_questionnaire_templates_on_audience_type", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.boolean "active"
    t.string "audience", default: "all", null: false
    t.datetime "created_at", null: false
    t.integer "position"
    t.text "question_text"
    t.string "question_type"
    t.datetime "updated_at", null: false
    t.index ["active", "position"], name: "index_questions_on_active_and_position"
    t.index ["active"], name: "index_questions_on_active"
    t.index ["audience"], name: "index_questions_on_audience"
    t.index ["position"], name: "index_questions_on_position"
  end

  create_table "review_answers", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.integer "question_template_id", null: false
    t.integer "review_submission_id", null: false
    t.integer "score"
    t.datetime "updated_at", null: false
    t.index ["question_template_id"], name: "index_review_answers_on_question_template_id"
    t.index ["review_submission_id", "question_template_id"], name: "idx_review_answers_on_submission_question", unique: true
    t.index ["review_submission_id"], name: "index_review_answers_on_review_submission_id"
  end

  create_table "review_assignments", force: :cascade do |t|
    t.string "assignment_type", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "review_cycle_id", null: false
    t.integer "reviewee_id", null: false
    t.integer "reviewer_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "submitted_at"
    t.datetime "updated_at", null: false
    t.index ["review_cycle_id", "reviewer_id", "assignment_type"], name: "index_review_assignments_uniqueness", unique: true
    t.index ["review_cycle_id"], name: "index_review_assignments_on_review_cycle_id"
    t.index ["reviewee_id"], name: "index_review_assignments_on_reviewee_id"
    t.index ["reviewer_id"], name: "index_review_assignments_on_reviewer_id"
  end

  create_table "review_cycles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.date "end_on", null: false
    t.integer "manager_id", null: false
    t.string "name", null: false
    t.integer "reviewee_id", null: false
    t.date "start_on", null: false
    t.string "status", default: "draft", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_review_cycles_on_manager_id"
    t.index ["reviewee_id"], name: "index_review_cycles_on_reviewee_id"
  end

  create_table "review_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "delivery_attempts_count", default: 0, null: false
    t.string "delivery_status", default: "pending", null: false
    t.text "last_delivery_error"
    t.datetime "last_sent_at"
    t.string "recipient_email", null: false
    t.integer "review_cycle_id", null: false
    t.integer "reviewee_id", null: false
    t.integer "reviewer_id"
    t.string "reviewer_role", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["review_cycle_id", "reviewer_role", "reviewer_id"], name: "idx_review_requests_on_cycle_role_reviewer", unique: true
    t.index ["review_cycle_id"], name: "index_review_requests_on_review_cycle_id"
    t.index ["reviewee_id"], name: "index_review_requests_on_reviewee_id"
    t.index ["reviewer_id"], name: "index_review_requests_on_reviewer_id"
  end

  create_table "review_submissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "review_cycle_id", null: false
    t.integer "review_request_id", null: false
    t.integer "reviewee_id", null: false
    t.integer "reviewer_id"
    t.string "reviewer_role", null: false
    t.string "status", default: "draft", null: false
    t.datetime "submitted_at"
    t.datetime "updated_at", null: false
    t.index ["review_cycle_id"], name: "index_review_submissions_on_review_cycle_id"
    t.index ["review_request_id"], name: "idx_one_submitted_review_submission_per_request", unique: true, where: "status = 'submitted'"
    t.index ["review_request_id"], name: "index_review_submissions_on_review_request_id"
    t.index ["reviewee_id"], name: "index_review_submissions_on_reviewee_id"
    t.index ["reviewer_id"], name: "index_review_submissions_on_reviewer_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.index "lower(email)", name: "index_users_on_lower_email", unique: true
  end

  add_foreign_key "peer_review_assignments", "people", column: "peer_reviewer_id"
  add_foreign_key "peer_review_assignments", "review_cycles"
  add_foreign_key "people", "users"
  add_foreign_key "question_templates", "questionnaire_templates"
  add_foreign_key "review_answers", "question_templates"
  add_foreign_key "review_answers", "review_submissions"
  add_foreign_key "review_assignments", "people", column: "reviewee_id"
  add_foreign_key "review_assignments", "people", column: "reviewer_id"
  add_foreign_key "review_assignments", "review_cycles"
  add_foreign_key "review_cycles", "people", column: "manager_id"
  add_foreign_key "review_cycles", "people", column: "reviewee_id"
  add_foreign_key "review_requests", "people", column: "reviewee_id"
  add_foreign_key "review_requests", "people", column: "reviewer_id"
  add_foreign_key "review_requests", "review_cycles"
  add_foreign_key "review_submissions", "people", column: "reviewee_id"
  add_foreign_key "review_submissions", "people", column: "reviewer_id"
  add_foreign_key "review_submissions", "review_cycles"
  add_foreign_key "review_submissions", "review_requests"
end
