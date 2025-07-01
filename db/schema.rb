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

ActiveRecord::Schema[8.0].define(version: 2025_09_15_064239) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "log_entries", force: :cascade do |t|
    t.text "table"
    t.text "attr"
    t.bigint "subject_id"
    t.text "subject_name"
    t.text "action"
    t.text "user"
    t.text "old_value"
    t.text "new_value"
    t.bigint "old_value_id"
    t.bigint "new_value_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["new_value_id"], name: "index_log_entries_on_new_value_id"
    t.index ["table", "subject_id"], name: "index_log_entries_on_table_and_subject_id"
    t.index ["user_id"], name: "index_log_entries_on_user_id"
  end

  create_table "master_data", force: :cascade do |t|
    t.string "leading_cooperation_partner_name"
    t.string "leading_cooperation_partner_address"
    t.string "leading_cooperation_partner_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participations", force: :cascade do |t|
    t.string "authority_name"
    t.string "authority_address"
    t.string "authority_email"
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.string "partner_number"
    t.string "name_of_the_signatory"
    t.string "official_email_authority"
    t.integer "role"
    t.date "effectiveness_date"
    t.date "withdrawal_receipt_date"
    t.string "withdrawal_name_of_the_signatory"
    t.date "withdrawal_effectiveness_date"
    t.date "withdrawal_effectiveness_date_corrected"
    t.boolean "active", default: true, null: false
    t.uuid "activity_token"
    t.string "ra_name"
    t.string "ra_email"
    t.string "ra_phone"
    t.text "ra_note"
    t.boolean "ra_active", default: false, null: false
    t.date "ra_activate_date"
    t.boolean "ra_trained", default: false, null: false
    t.date "ra_train_date"
    t.integer "ra_training"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: false, null: false
    t.text "name"
    t.text "login"
    t.text "password_digest"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "log_entries", "users"
end
