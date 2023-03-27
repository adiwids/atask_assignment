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

ActiveRecord::Schema[7.0].define(version: 2023_03_27_040023) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "memberships", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "member_id"
    t.integer "status", limit: 2, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "member_id"], name: "memberships_idx"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.bigint "owner_id"
    t.integer "members_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name"
    t.index ["owner_id"], name: "index_teams_on_owner_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "transaction_type", null: false
    t.datetime "date_time", default: "2023-03-27 05:35:27"
    t.bigint "owner_id"
    t.string "owner_type", null: false
    t.string "owner_name"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "IDR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date_time"], name: "index_transactions_on_date_time"
    t.index ["owner_id", "owner_type"], name: "transactions_owner_idx"
    t.index ["owner_name"], name: "index_transactions_on_owner_name"
    t.index ["owner_type"], name: "index_transactions_on_owner_type"
    t.index ["transaction_type"], name: "index_transactions_on_transaction_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "owner_type"
    t.integer "balance_cents", default: 0, null: false
    t.string "balance_currency", default: "IDR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "wallets_owner_idx"
  end

  add_foreign_key "memberships", "teams"
  add_foreign_key "memberships", "users", column: "member_id"
end
