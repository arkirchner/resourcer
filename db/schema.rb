# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_16_044819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # These are custom enum types that must be created before they can be used in the schema definition
  create_enum "history_events", ["create", "destroy", "update"]
  create_enum "member_providers", ["github", "google"]

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "histories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "issue_id"
    t.bigint "member_id"
    t.datetime "changed_at", null: false
    t.enum "event", null: false, as: "history_events"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["issue_id"], name: "index_histories_on_issue_id"
    t.index ["member_id"], name: "index_histories_on_member_id"
  end

  create_table "history_issues", force: :cascade do |t|
    t.bigint "item_id"
    t.uuid "history_id", null: false
    t.string "from_subject", default: "", null: false
    t.string "to_subject", default: "", null: false
    t.date "from_due_at"
    t.date "to_due_at"
    t.bigint "from_parent_id"
    t.bigint "to_parent_id"
    t.text "from_description", default: "", null: false
    t.text "to_description", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id", "history_id"], name: "index_history_issues_on_id_and_history_id", unique: true
    t.index ["item_id"], name: "index_history_issues_on_item_id"
  end

  create_table "history_project_member_issue_assignments", force: :cascade do |t|
    t.bigint "item_id"
    t.uuid "history_id", null: false
    t.bigint "from_project_member_id"
    t.bigint "to_project_member_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id", "history_id"], name: "index_history_issue_assignments_on_id_and_history_id", unique: true
    t.index ["item_id"], name: "index_history_project_member_issue_assignments_on_item_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "note", default: "", null: false
    t.string "token", default: "", null: false
    t.bigint "project_member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_member_id"], name: "index_invitations_on_project_member_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "subject", null: false
    t.date "due_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "project_id", null: false
    t.bigint "parent_id"
    t.text "description", default: "", null: false
    t.index ["project_id"], name: "index_issues_on_project_id"
  end

  create_table "members", force: :cascade do |t|
    t.enum "provider", null: false, as: "member_providers"
    t.string "provider_id", null: false
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image_url", default: "", null: false
    t.index ["provider_id", "provider"], name: "index_members_on_provider_id_and_provider", unique: true
  end

  create_table "project_member_invitations", force: :cascade do |t|
    t.bigint "project_member_id", null: false
    t.bigint "invitation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["invitation_id"], name: "index_project_member_invitations_on_invitation_id", unique: true
    t.index ["project_member_id"], name: "index_project_member_invitations_on_project_member_id"
  end

  create_table "project_member_issue_assignments", force: :cascade do |t|
    t.bigint "project_member_id", null: false
    t.bigint "issue_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["issue_id"], name: "index_project_member_issue_assignments_on_issue_id", unique: true
    t.index ["project_member_id"], name: "index_project_member_issue_assignments_on_project_member_id"
  end

  create_table "project_members", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "project_id", null: false
    t.boolean "owner", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id", "project_id"], name: "index_project_members_on_member_id_and_project_id", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.string "key", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_projects_on_key", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.bigint "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.uuid "request_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["request_id"], name: "index_versions_on_request_id"
  end

  add_foreign_key "histories", "issues"
  add_foreign_key "histories", "members"
  add_foreign_key "history_issues", "histories"
  add_foreign_key "history_issues", "issues", column: "from_parent_id"
  add_foreign_key "history_issues", "issues", column: "item_id", on_delete: :nullify
  add_foreign_key "history_issues", "issues", column: "to_parent_id"
  add_foreign_key "history_project_member_issue_assignments", "histories"
  add_foreign_key "history_project_member_issue_assignments", "project_member_issue_assignments", column: "item_id", on_delete: :nullify
  add_foreign_key "history_project_member_issue_assignments", "project_members", column: "from_project_member_id"
  add_foreign_key "history_project_member_issue_assignments", "project_members", column: "to_project_member_id"
  add_foreign_key "invitations", "project_members"
  add_foreign_key "issues", "issues", column: "parent_id"
  add_foreign_key "issues", "projects"
  add_foreign_key "project_member_invitations", "invitations"
  add_foreign_key "project_member_invitations", "project_members"
  add_foreign_key "project_member_issue_assignments", "issues"
  add_foreign_key "project_member_issue_assignments", "project_members"
  add_foreign_key "project_members", "members"
  add_foreign_key "project_members", "projects"
  add_foreign_key "versions", "members", column: "whodunnit", on_delete: :nullify
end
