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

ActiveRecord::Schema.define(version: 20160827033709) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "approveds", force: :cascade do |t|
    t.string   "uid"
    t.string   "upc"
    t.string   "product_name"
    t.string   "brand"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "avoids", force: :cascade do |t|
    t.string   "uid"
    t.string   "upc"
    t.string   "product_name"
    t.string   "brand"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "contacteds", force: :cascade do |t|
    t.string   "upc"
    t.string   "uid"
    t.boolean  "contacted"
    t.string   "brand"
    t.string   "product"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "eid"
    t.string   "name",       null: false
    t.string   "function"
    t.string   "warnings"
    t.string   "status"
    t.string   "foods"
    t.string   "details"
    t.string   "source"
    t.string   "other"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "concerns"
    t.string   "uid"
    t.string   "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
