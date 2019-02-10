# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_10_130352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_logs", force: :cascade do |t|
    t.string "activitable_type"
    t.bigint "activitable_id"
    t.string "event_type"
    t.text "event_log"
    t.string "event_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activitable_type", "activitable_id"], name: "index_activity_logs_on_activitable_type_and_activitable_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
  end

  create_table "flats", force: :cascade do |t|
    t.string "addressid"
    t.string "number"
    t.float "area"
    t.string "area_unit", default: "m2"
    t.string "floor_number"
    t.integer "room_count"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "PLN", null: false
    t.string "status"
    t.string "concept_url"
    t.bigint "building_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_flats_on_building_id"
  end

end
