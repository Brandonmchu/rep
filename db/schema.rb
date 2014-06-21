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

ActiveRecord::Schema.define(version: 20140621161403) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "houses", force: true do |t|
    t.string   "address"
    t.string   "unit_type"
    t.string   "fronting"
    t.integer  "rooms"
    t.integer  "plus_rooms"
    t.string   "stories"
    t.string   "acreage"
    t.integer  "bedrooms"
    t.integer  "dens"
    t.integer  "washrooms"
    t.integer  "lot_first_dimension"
    t.integer  "lot_second_dimension"
    t.string   "lot_dimension_units"
    t.integer  "lot_square_footage"
    t.string   "mls"
    t.string   "kitchens"
    t.string   "fam_rm"
    t.string   "basement"
    t.string   "fireplace"
    t.string   "sq_foot"
    t.string   "park_method"
    t.string   "garage_type"
    t.integer  "garages"
    t.integer  "parking_spaces"
    t.string   "pool"
    t.text     "description"
    t.string   "image_urls",           default: [], array: true
    t.string   "image_descriptions",   default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "non_houses", force: true do |t|
    t.string   "unit_type"
    t.integer  "rooms"
    t.integer  "plus_rooms"
    t.integer  "bedrooms"
    t.integer  "dens"
    t.integer  "washrooms"
    t.string   "corp"
    t.string   "address"
    t.string   "prop_mgmt"
    t.integer  "kitchens"
    t.string   "fam_rm"
    t.integer  "apx_age"
    t.integer  "sqft_range_first"
    t.integer  "sqft_range_second"
    t.string   "exposure"
    t.string   "pets"
    t.string   "locker"
    t.integer  "level"
    t.integer  "unit_number"
    t.integer  "maintenance"
    t.string   "air_con"
    t.string   "incl_heat"
    t.string   "incl_cable"
    t.string   "incl_insurance"
    t.string   "incl_comm_elem"
    t.string   "incl_water"
    t.string   "incl_hydro"
    t.string   "incl_cac"
    t.string   "incl_parking"
    t.string   "balcony"
    t.string   "ensuite_laundry"
    t.string   "laundry_level"
    t.string   "exterior"
    t.string   "park_method"
    t.string   "park_type"
    t.integer  "park_spaces"
    t.integer  "park_cost"
    t.string   "amenities"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales", force: true do |t|
    t.string   "address"
    t.integer  "list_price"
    t.integer  "sold_price"
    t.integer  "original_price"
    t.string   "taxes"
    t.integer  "days_on_market"
    t.string   "spis"
    t.date     "list_date"
    t.date     "sold_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
