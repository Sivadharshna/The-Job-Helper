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

ActiveRecord::Schema.define(version: 2023_04_11_120725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accepted_offers", force: :cascade do |t|
    t.datetime "schedule"
    t.string "approval_type"
    t.bigint "approval_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["approval_type", "approval_id"], name: "index_accepted_offers_on_approval"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "college_applications", force: :cascade do |t|
    t.bigint "college_id", null: false
    t.bigint "company_id", null: false
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["college_id"], name: "index_college_applications_on_college_id"
    t.index ["company_id"], name: "index_college_applications_on_company_id"
  end

  create_table "colleges", force: :cascade do |t|
    t.string "name"
    t.string "email_id"
    t.string "contact_no"
    t.string "address"
    t.string "website_link"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_colleges_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "contact_no"
    t.string "address"
    t.string "website_link"
    t.string "email_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "companies_students", id: false, force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "student_id", null: false
    t.index ["company_id", "student_id"], name: "index_companies_students_on_company_id_and_student_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.bigint "college_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["college_id"], name: "index_courses_on_college_id"
  end

  create_table "individual_applications", force: :cascade do |t|
    t.bigint "individual_id", null: false
    t.bigint "job_id", null: false
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["individual_id"], name: "index_individual_applications_on_individual_id"
    t.index ["job_id"], name: "index_individual_applications_on_job_id"
  end

  create_table "individuals", force: :cascade do |t|
    t.string "name"
    t.string "email_id"
    t.string "address"
    t.integer "age"
    t.string "contact_no"
    t.integer "experience"
    t.float "sslc_percentage"
    t.string "hsc_diplomo"
    t.float "hsc_diplomo_percentage"
    t.string "bachelors_degree"
    t.string "masters_degree"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_individuals_on_user_id"
  end

  create_table "job_details", force: :cascade do |t|
    t.bigint "accepted_offer_id", null: false
    t.string "result"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["accepted_offer_id"], name: "index_job_details_on_accepted_offer_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.float "salary"
    t.integer "minimum_experience"
    t.string "mode"
    t.string "minimum_educational_qualification"
    t.float "expected_sslc_percentage"
    t.float "expected_hsc_percentage"
    t.float "expected_cgpa"
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_jobs_on_company_id"
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.string "scopes"
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "permissions", force: :cascade do |t|
    t.string "status"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_permissions_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.float "sslc_percentage"
    t.string "hsc_diplomo"
    t.float "hsc_diplomo_percentage"
    t.float "cgpa"
    t.integer "graduation_year"
    t.string "placement_status", default: "Yet to be placed"
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_students_on_course_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "role", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "college_applications", "colleges"
  add_foreign_key "college_applications", "companies"
  add_foreign_key "colleges", "users"
  add_foreign_key "companies", "users"
  add_foreign_key "courses", "colleges"
  add_foreign_key "individual_applications", "individuals"
  add_foreign_key "individual_applications", "jobs"
  add_foreign_key "individuals", "users"
  add_foreign_key "job_details", "accepted_offers"
  add_foreign_key "jobs", "companies"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "permissions", "users"
  add_foreign_key "students", "courses"
end
