# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150125005950) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "homepage"
  end

  create_table "accounts_users", force: true do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts_users", ["account_id", "user_id"], name: "index_accounts_users_on_account_id_and_user_id", unique: true

  create_table "credit_cards", force: true do |t|
    t.text     "name"
    t.decimal  "credit_limit"
    t.decimal  "interest_rate"
    t.decimal  "balance_transfer_fee"
    t.integer  "no_interest_months"
    t.decimal  "foreign_transaction_fee"
    t.text     "homepage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.text     "title"
    t.text     "detail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "noteable_id"
    t.string   "noteable_type"
  end

  add_index "notes", ["noteable_id", "noteable_type"], name: "index_notes_on_noteable_id_and_noteable_type"

  create_table "payments", force: true do |t|
    t.integer  "account_id"
    t.datetime "payment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount"
    t.text     "reference"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
