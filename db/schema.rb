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

ActiveRecord::Schema.define(version: 2022_01_10_110833) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "name", null: false
    t.string "quantity"
    t.boolean "proper_quantity", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["food_id"], name: "index_ingredients_on_food_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "food_tags", "foods"
  add_foreign_key "food_tags", "tags"
  add_foreign_key "foods", "users"
  add_foreign_key "ingredients", "foods"
end
