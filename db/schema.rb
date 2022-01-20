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

ActiveRecord::Schema.define(version: 2022_01_19_112758) do

  create_table "data_ratings", charset: "latin1", force: :cascade do |t|
    t.bigint "part_id"
    t.json "data"
    t.json "currency"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["part_id"], name: "index_data_ratings_on_part_id"
  end

  create_table "parts", charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.string "brand"
    t.text "describe", size: :medium
    t.string "detail_num"
    t.string "o_e"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "data_ratings", "parts"
end
