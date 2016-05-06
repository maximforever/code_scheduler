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

ActiveRecord::Schema.define(version: 20160506114507) do

  create_table "advisors", force: :cascade do |t|
    t.string   "name"
    t.integer  "max_hours"
    t.integer  "html",         default: 0
    t.integer  "js",           default: 0
    t.integer  "jquery",       default: 0
    t.integer  "angular",      default: 0
    t.integer  "ruby",         default: 0
    t.integer  "rails",        default: 0
    t.integer  "php",          default: 0
    t.integer  "python",       default: 0
    t.integer  "java",         default: 0
    t.integer  "sql",          default: 0
    t.integer  "git",          default: 0
    t.integer  "cmd",          default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "availability"
  end

  create_table "shift_assignments", force: :cascade do |t|
    t.integer  "shift_id"
    t.integer  "advisor_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "shift_assignments", ["advisor_id"], name: "index_shift_assignments_on_advisor_id"
  add_index "shift_assignments", ["shift_id"], name: "index_shift_assignments_on_shift_id"

  create_table "shifts", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.integer  "html",           default: 0
    t.integer  "js",             default: 0
    t.integer  "jquery",         default: 0
    t.integer  "angular",        default: 0
    t.integer  "ruby",           default: 0
    t.integer  "rails",          default: 0
    t.integer  "php",            default: 0
    t.integer  "python",         default: 0
    t.integer  "java",           default: 0
    t.integer  "sql",            default: 0
    t.integer  "git",            default: 0
    t.integer  "cmd",            default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "advisor_number", default: 0
  end

  create_table "vacations", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.integer  "advisor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

end
