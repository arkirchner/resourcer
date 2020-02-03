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

ActiveRecord::Schema.define(version: 2020_02_03_064839) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # These are custom enum types that must be created before they can be used in the schema definition
  create_enum "member_providers", ["github", "google"]

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

  add_foreign_key "issues", "issues", column: "parent_id"
  add_foreign_key "issues", "projects"
  add_foreign_key "project_member_issue_assignments", "issues"
  add_foreign_key "project_member_issue_assignments", "project_members"
  add_foreign_key "project_members", "members"
  add_foreign_key "project_members", "projects"
end
