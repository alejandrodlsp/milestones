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

ActiveRecord::Schema[8.0].define(version: 2025_04_25_082305) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "milestone_categories", force: :cascade do |t|
    t.bigint "milestone_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_milestone_categories_on_category_id"
    t.index ["milestone_id"], name: "index_milestone_categories_on_milestone_id"
  end

  create_table "milestone_checkpoints", force: :cascade do |t|
    t.bigint "milestone_id", null: false
    t.string "name", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["milestone_id"], name: "index_milestone_checkpoints_on_milestone_id"
  end

  create_table "milestone_comments", force: :cascade do |t|
    t.bigint "milestone_id", null: false
    t.bigint "user_id", null: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["milestone_id"], name: "index_milestone_comments_on_milestone_id"
    t.index ["user_id"], name: "index_milestone_comments_on_user_id"
  end

  create_table "milestone_completions", force: :cascade do |t|
    t.bigint "milestone_id", null: false
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["milestone_id"], name: "index_milestone_completions_on_milestone_id"
  end

  create_table "milestone_lists", force: :cascade do |t|
    t.bigint "milestone_id", null: false
    t.bigint "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_milestone_lists_on_list_id"
    t.index ["milestone_id"], name: "index_milestone_lists_on_milestone_id"
  end

  create_table "milestones", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "user_id"
    t.boolean "private", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "due_date"
    t.bigint "original_milestone_id"
    t.integer "status", default: 0, null: false
    t.index ["original_milestone_id"], name: "index_milestones_on_original_milestone_id"
    t.index ["user_id"], name: "index_milestones_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "last_name", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "last_login"
    t.datetime "last_login_attempt"
    t.integer "loging_attempts", default: 0
    t.string "role", default: "user", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "lists", "users"
  add_foreign_key "milestone_categories", "categories"
  add_foreign_key "milestone_categories", "milestones"
  add_foreign_key "milestone_checkpoints", "milestones"
  add_foreign_key "milestone_comments", "milestones"
  add_foreign_key "milestone_comments", "users"
  add_foreign_key "milestone_completions", "milestones"
  add_foreign_key "milestone_lists", "lists"
  add_foreign_key "milestone_lists", "milestones"
  add_foreign_key "milestones", "milestones", column: "original_milestone_id"
  add_foreign_key "milestones", "users"
end
