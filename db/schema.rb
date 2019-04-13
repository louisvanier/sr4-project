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

ActiveRecord::Schema.define(version: 2019_04_13_190758) do

  create_table "templates_matrix_programs", force: :cascade do |t|
    t.string "name"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "has_programs_id"
    t.integer "has_programs_type"
    t.index ["has_programs_id", "has_programs_type"], name: "index_templates_matrix_programs_on_has_programs"
  end

  create_table "templates_matrix_users", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.integer "reaction"
    t.integer "intuition"
    t.integer "logic"
    t.integer "willpower"
    t.integer "computer"
    t.integer "cybercombat"
    t.integer "data_search"
    t.integer "electronic_warfare"
    t.integer "hacking"
    t.string "access_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_templates_matrix_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "password"
    t.string "image_url"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
