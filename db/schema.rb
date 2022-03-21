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

ActiveRecord::Schema.define(version: 2022_03_20_093259) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "food_id", null: false
    t.string "body", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["food_id"], name: "index_comments_on_food_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "food_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["food_id"], name: "index_favorites_on_food_id"
    t.index ["user_id", "food_id"], name: "index_favorites_on_user_id_and_food_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "food_tags", force: :cascade do |t|
    t.bigint "food_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["food_id", "tag_id"], name: "index_food_tags_on_food_id_and_tag_id", unique: true
    t.index ["food_id"], name: "index_food_tags_on_food_id"
    t.index ["tag_id"], name: "index_food_tags_on_tag_id"
  end

  create_table "foods", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "image"
    t.text "recipe", null: false
    t.text "cooking_comment"
    t.integer "cooking_time", null: false
    t.integer "cooking_time_unit", null: false
    t.integer "serving", null: false
    t.string "uuid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_foods_on_user_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.bigint "food_id", null: false
    t.string "ingredient_name", null: false
    t.string "quantity"
    t.boolean "proper_quantity", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["food_id"], name: "index_ingredients_on_food_id"
  end

  create_table "nutritions", force: :cascade do |t|
    t.bigint "food_id", null: false
    t.float "calories", null: false
    t.float "carbo", null: false
    t.float "fiber", null: false
    t.float "protein", null: false
    t.float "fat", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["food_id"], name: "index_nutritions_on_food_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "uuid", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.string "twitter_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "comments", "foods"
  add_foreign_key "comments", "users"
  add_foreign_key "favorites", "foods"
  add_foreign_key "favorites", "users"
  add_foreign_key "food_tags", "foods"
  add_foreign_key "food_tags", "tags"
  add_foreign_key "foods", "users"
  add_foreign_key "ingredients", "foods"
  add_foreign_key "nutritions", "foods"
end
