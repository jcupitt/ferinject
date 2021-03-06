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

ActiveRecord::Schema.define(version: 20150521150119) do

  create_table "patients", force: true do |t|
    t.string   "initials"
    t.date     "date_of_birth"
    t.integer  "screening_number",         limit: 255, default: 0
    t.date     "screening_date"
    t.boolean  "meets_inclusion_criteria"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rejection_note"
    t.string   "hospital_identifier"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "institution"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "remember_digest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
