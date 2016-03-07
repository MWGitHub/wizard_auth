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

ActiveRecord::Schema.define(version: 20160306233951) do

  create_table "courses", force: :cascade do |t|
    t.string   "title",         null: false
    t.string   "description",   null: false
    t.integer  "instructor_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["instructor_id"], name: "index_courses_on_instructor_id"

  create_table "enrollments", force: :cascade do |t|
    t.integer  "student_id", null: false
    t.integer  "course_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "enrollments", ["course_id"], name: "index_enrollments_on_course_id"
  add_index "enrollments", ["student_id", "course_id"], name: "index_enrollments_on_student_id_and_course_id", unique: true
  add_index "enrollments", ["student_id"], name: "index_enrollments_on_student_id"

  create_table "wizards", force: :cascade do |t|
    t.string   "username",                        null: false
    t.string   "password_digest",                 null: false
    t.string   "session_token",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "instructor",      default: false, null: false
  end

  add_index "wizards", ["username"], name: "index_wizards_on_username", unique: true

end
