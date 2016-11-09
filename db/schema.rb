# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161109132158) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "user_info_id"
    t.string   "name"
    t.string   "address_detail"
    t.string   "phone"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["user_info_id"], name: "index_addresses_on_user_info_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "authentication_token",   limit: 30
    t.index ["authentication_token"], name: "index_admins_on_authentication_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "appointment_item_groups", force: :cascade do |t|
    t.integer  "count"
    t.integer  "appointment_id"
    t.integer  "store_month"
    t.float    "price"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "type_name"
    t.index ["appointment_id"], name: "index_appointment_item_groups_on_appointment_id"
  end

  create_table "appointment_items", force: :cascade do |t|
    t.integer  "garment_id"
    t.integer  "appointment_id"
    t.integer  "store_month"
    t.float    "price"
    t.integer  "status"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "appointment_item_group_id"
    t.string   "aasm_state"
    t.index ["appointment_id"], name: "index_appointment_items_on_appointment_id"
    t.index ["appointment_item_group_id"], name: "index_appointment_items_on_appointment_item_group_id"
    t.index ["garment_id"], name: "index_appointment_items_on_garment_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.string   "address"
    t.string   "name"
    t.string   "phone"
    t.integer  "number"
    t.date     "date"
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "seq"
    t.string   "aasm_state"
    t.float    "price",      default: 0.0
    t.string   "detail"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "bills", force: :cascade do |t|
    t.decimal  "amount"
    t.integer  "bill_type",  default: 0
    t.string   "seq"
    t.string   "sign"
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["user_id"], name: "index_bills_on_user_id"
  end

  create_table "distribution_items", force: :cascade do |t|
    t.integer  "distribution_id"
    t.integer  "garment_id"
    t.float    "price"
    t.integer  "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["distribution_id"], name: "index_distribution_items_on_distribution_id"
    t.index ["garment_id"], name: "index_distribution_items_on_garment_id"
  end

  create_table "distributions", force: :cascade do |t|
    t.string   "address"
    t.string   "name"
    t.string   "phone"
    t.date     "date"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_distributions_on_user_id"
  end

  create_table "garment_logs", force: :cascade do |t|
    t.integer  "garment_id"
    t.string   "title"
    t.string   "comment"
    t.string   "old_status"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["garment_id"], name: "index_garment_logs_on_garment_id"
  end

  create_table "garments", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "put_in_time"
    t.datetime "expire_time"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "seq"
    t.integer  "row"
    t.integer  "carbit"
    t.integer  "place"
    t.string   "aasm_state"
    t.index ["seq"], name: "index_garments_on_seq"
    t.index ["user_id"], name: "index_garments_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.string   "title"
    t.string   "photo_type"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "imageable_type"
    t.integer  "imageable_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id"
  end

  create_table "ping_requests", force: :cascade do |t|
    t.string   "object_type"
    t.string   "ping_id"
    t.boolean  "complete"
    t.integer  "amount"
    t.string   "subject"
    t.string   "body"
    t.string   "client_ip"
    t.string   "extra"
    t.string   "order_no"
    t.string   "channel"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "openid"
    t.string   "metadata"
  end

  create_table "price_systems", force: :cascade do |t|
    t.string   "name"
    t.string   "season"
    t.integer  "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchase_logs", force: :cascade do |t|
    t.string   "operation_type"
    t.string   "operation"
    t.float    "change"
    t.string   "payment_method"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_info_id"
    t.string   "detail"
    t.float    "balance"
    t.index ["user_info_id"], name: "index_purchase_logs_on_user_info_id"
  end

  create_table "sms_tokens", force: :cascade do |t|
    t.string   "phone"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone"], name: "index_sms_tokens_on_phone"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_infos", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "nickname"
    t.string   "mail"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "default_address_id"
    t.float    "balance",            default: 0.0
    t.index ["user_id"], name: "index_user_infos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "", null: false
    t.string   "phone",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "authentication_token",   limit: 30
    t.string   "openid"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["openid"], name: "index_users_on_openid"
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wechat_sessions", force: :cascade do |t|
    t.string   "openid",     null: false
    t.string   "hash_store"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["openid"], name: "index_wechat_sessions_on_openid", unique: true
  end

end
