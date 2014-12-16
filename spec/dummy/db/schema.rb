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

ActiveRecord::Schema.define(version: 20141215211104) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "job_runs", force: true do |t|
    t.string   "worker_class"
    t.string   "arguments",       array: true
    t.boolean  "successful"
    t.datetime "completed_at"
    t.text     "log"
    t.text     "error_class"
    t.text     "error_message"
    t.text     "error_backtrace", array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
