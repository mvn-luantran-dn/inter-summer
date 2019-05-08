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

ActiveRecord::Schema.define(version: 2019_05_08_081250) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.string "file"
    t.string "name"
    t.integer "module_id"
    t.string "module_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["module_id"], name: "index_assets_on_module_id"
    t.index ["module_type"], name: "index_assets_on_module_type"
  end

  create_table "auction_details", force: :cascade do |t|
    t.bigint "auction_id"
    t.bigint "user_id"
    t.integer "price_bid"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_id"], name: "index_auction_details_on_auction_id"
    t.index ["user_id"], name: "index_auction_details_on_user_id"
  end

  create_table "auctions", force: :cascade do |t|
    t.bigint "timer_id"
    t.string "status"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["timer_id"], name: "index_auctions_on_timer_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
  end

  create_table "ckeditor_assets", id: :serial, force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "product_id"
    t.integer "amount"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_items_on_order_id"
    t.index ["product_id"], name: "index_items_on_product_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "content"
    t.bigint "user_id"
    t.integer "status"
    t.integer "timer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.string "address"
    t.string "phone"
    t.string "name"
    t.integer "total_price"
    t.datetime "deleted_at"
    t.string "status", default: "waitting", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_id", null: false
    t.string "city"
    t.index ["payment_id"], name: "index_orders_on_payment_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transport_fee"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "category_id"
    t.string "name"
    t.text "detail"
    t.integer "price"
    t.integer "quantity"
    t.integer "price_at"
    t.string "status"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.string "size"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "discount"
    t.string "description"
    t.text "detail"
    t.bigint "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["user_id"], name: "index_promotions_on_user_id"
  end

  create_table "promotions_categories", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "promotion_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discount", null: false
    t.index ["category_id"], name: "index_promotions_categories_on_category_id"
    t.index ["promotion_id"], name: "index_promotions_categories_on_promotion_id"
  end

  create_table "timers", force: :cascade do |t|
    t.bigint "product_id"
    t.time "start_at"
    t.time "end_at"
    t.time "period"
    t.integer "bid_step"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_running", default: true
    t.index ["product_id"], name: "index_timers_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.string "role"
    t.string "provider"
    t.string "uid"
    t.string "activation_digest"
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "deleted_at"
    t.string "address"
    t.string "phone"
    t.integer "gender", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status"
    t.boolean "root", default: false
    t.datetime "deactivated_at"
    t.date "birth_day"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "auction_details", "auctions"
  add_foreign_key "auction_details", "users"
  add_foreign_key "auctions", "timers"
  add_foreign_key "items", "orders"
  add_foreign_key "items", "products"
  add_foreign_key "notifications", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "promotions", "users"
  add_foreign_key "promotions_categories", "categories"
  add_foreign_key "promotions_categories", "promotions"
  add_foreign_key "timers", "products"
end
