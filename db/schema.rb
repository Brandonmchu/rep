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

ActiveRecord::Schema.define(version: 20140617034042) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sales", force: true do |t|
    t.string   "address"
    t.string   "listprice"
    t.string   "soldprice"
    t.string   "original_price"
    t.string   "taxes"
    t.string   "days_market"
    t.string   "date_list"
    t.string   "date_sold"
    t.string   "unit_type"
    t.string   "fronting"
    t.string   "rooms"
    t.string   "stories"
    t.string   "acreage"
    t.string   "bedrooms"
    t.string   "lot"
    t.string   "mls"
    t.string   "kitchens"
    t.string   "fam_rm"
    t.string   "basement"
    t.string   "fireplace"
    t.string   "sq_foot"
    t.string   "mutual"
    t.string   "garage_type"
    t.string   "parking_spaces"
    t.string   "pool"
    t.string   "image_urls",         default: [], array: true
    t.string   "image_descriptions", default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
