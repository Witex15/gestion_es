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

ActiveRecord::Schema[8.0].define(version: 2025_02_28_080519) do
  create_table "addresses", force: :cascade do |t|
    t.integer "zip"
    t.string "town"
    t.string "street"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.time "start_at"
    t.time "end_at"
    t.boolean "archived"
    t.integer "subject_id", null: false
    t.integer "school_class_id", null: false
    t.integer "moment_id", null: false
    t.integer "teacher_id", null: false
    t.integer "week_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["moment_id"], name: "index_courses_on_moment_id"
    t.index ["school_class_id"], name: "index_courses_on_school_class_id"
    t.index ["subject_id"], name: "index_courses_on_subject_id"
    t.index ["teacher_id"], name: "index_courses_on_teacher_id"
  end

  create_table "examinations", force: :cascade do |t|
    t.string "title"
    t.date "effective_date"
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_examinations_on_course_id"
  end

  create_table "grades", force: :cascade do |t|
    t.integer "value"
    t.date "execute_on"
    t.integer "examination_id", null: false
    t.integer "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["examination_id"], name: "index_grades_on_examination_id"
    t.index ["student_id"], name: "index_grades_on_student_id"
  end

  create_table "moments", force: :cascade do |t|
    t.string "uid"
    t.date "start_on"
    t.date "end_on"
    t.integer "moment_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "username"
    t.string "lastname"
    t.string "firstname"
    t.string "email"
    t.string "phone_number"
    t.string "iban"
    t.integer "role"
    t.integer "status_id", null: false
    t.integer "address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["address_id"], name: "index_people_on_address_id"
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true
    t.index ["status_id"], name: "index_people_on_status_id"
  end

  create_table "promotion_asserts", force: :cascade do |t|
    t.string "description"
    t.string "function"
    t.integer "moment_id", null: false
    t.integer "sector_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["moment_id"], name: "index_promotion_asserts_on_moment_id"
    t.index ["sector_id"], name: "index_promotion_asserts_on_sector_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "school_classes", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.integer "moment_id", null: false
    t.integer "room_id", null: false
    t.integer "master_id", null: false
    t.integer "sector_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["master_id"], name: "index_school_classes_on_master_id"
    t.index ["moment_id"], name: "index_school_classes_on_moment_id"
    t.index ["room_id"], name: "index_school_classes_on_room_id"
    t.index ["sector_id"], name: "index_school_classes_on_sector_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "students_classes", force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "school_class_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_class_id"], name: "index_students_classes_on_school_class_id"
    t.index ["student_id"], name: "index_students_classes_on_student_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.integer "teacher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_subjects_on_teacher_id"
  end

  add_foreign_key "courses", "moments"
  add_foreign_key "courses", "school_classes"
  add_foreign_key "courses", "subjects"
  add_foreign_key "courses", "teachers"
  add_foreign_key "examinations", "courses"
  add_foreign_key "grades", "examinations"
  add_foreign_key "grades", "students"
  add_foreign_key "people", "addresses"
  add_foreign_key "people", "statuses"
  add_foreign_key "promotion_asserts", "moments"
  add_foreign_key "promotion_asserts", "sectors"
  add_foreign_key "school_classes", "masters"
  add_foreign_key "school_classes", "moments"
  add_foreign_key "school_classes", "rooms"
  add_foreign_key "school_classes", "sectors"
  add_foreign_key "students_classes", "school_classes"
  add_foreign_key "students_classes", "students"
  add_foreign_key "subjects", "teachers"
end
