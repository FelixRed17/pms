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

ActiveRecord::Schema[8.1].define(version: 2026_03_30_083000) do
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
  add_foreign_key "review_cycles", "people", column: "manager_id"
  add_foreign_key "review_cycles", "people", column: "reviewee_id"
end
