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

ActiveRecord::Schema[8.0].define(version: 2026_03_28_130001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
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

  create_table "place_comments", force: :cascade do |t|
    t.bigint "place_id", null: false
    t.bigint "user_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_place_comments_on_place_id"
    t.index ["user_id"], name: "index_place_comments_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.string "name", null: false
    t.string "address"
    t.decimal "latitude", precision: 10, scale: 7, null: false
    t.decimal "longitude", precision: 10, scale: 7, null: false
    t.integer "category", default: 6, null: false
    t.integer "estimated_duration_minutes"
    t.bigint "added_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["added_by_id"], name: "index_places_on_added_by_id"
    t.index ["trip_id"], name: "index_places_on_trip_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.string "title", null: false
    t.integer "category", null: false
    t.date "date"
    t.text "details"
    t.integer "cost_cents"
    t.string "cost_currency", default: "EUR"
    t.bigint "uploaded_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id", "category"], name: "index_tickets_on_trip_id_and_category"
    t.index ["trip_id"], name: "index_tickets_on_trip_id"
    t.index ["uploaded_by_id"], name: "index_tickets_on_uploaded_by_id"
  end

  create_table "trip_invitations", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.citext "email", null: false
    t.string "token", null: false
    t.datetime "accepted_at"
    t.bigint "invited_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invited_by_id"], name: "index_trip_invitations_on_invited_by_id"
    t.index ["token"], name: "index_trip_invitations_on_token", unique: true
    t.index ["trip_id", "email"], name: "index_trip_invitations_on_trip_id_and_email", unique: true
    t.index ["trip_id"], name: "index_trip_invitations_on_trip_id"
  end

  create_table "trip_participants", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id", "user_id"], name: "index_trip_participants_on_trip_id_and_user_id", unique: true
    t.index ["trip_id"], name: "index_trip_participants_on_trip_id"
    t.index ["user_id"], name: "index_trip_participants_on_user_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "title", null: false
    t.string "destination", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "status", default: 0, null: false
    t.bigint "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_trips_on_creator_id"
    t.index ["start_date"], name: "index_trips_on_start_date"
    t.index ["status"], name: "index_trips_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.citext "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "place_comments", "places", on_delete: :cascade
  add_foreign_key "place_comments", "users", on_delete: :cascade
  add_foreign_key "places", "trips", on_delete: :cascade
  add_foreign_key "places", "users", column: "added_by_id", on_delete: :cascade
  add_foreign_key "tickets", "trips", on_delete: :cascade
  add_foreign_key "tickets", "users", column: "uploaded_by_id", on_delete: :cascade
  add_foreign_key "trip_invitations", "trips", on_delete: :cascade
  add_foreign_key "trip_invitations", "users", column: "invited_by_id", on_delete: :cascade
  add_foreign_key "trip_participants", "trips", on_delete: :cascade
  add_foreign_key "trip_participants", "users", on_delete: :cascade
  add_foreign_key "trips", "users", column: "creator_id", on_delete: :cascade
end
