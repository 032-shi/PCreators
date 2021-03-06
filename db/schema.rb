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

ActiveRecord::Schema.define(version: 2021_07_05_023246) do

  create_table "draft_configurations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "part_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "part_configurations", force: :cascade do |t|
    t.integer "pc_configuration_id"
    t.integer "part_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "part_tag_maps", force: :cascade do |t|
    t.integer "part_id"
    t.integer "part_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id"], name: "index_part_tag_maps_on_part_id"
    t.index ["part_tag_id"], name: "index_part_tag_maps_on_part_tag_id"
  end

  create_table "part_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parts", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pc_configurations", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.string "image_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "score", precision: 5, scale: 3
  end

  create_table "post_favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_tag_maps", force: :cascade do |t|
    t.integer "post_id"
    t.integer "post_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_tag_maps_on_post_id"
    t.index ["post_tag_id"], name: "index_post_tag_maps_on_post_tag_id"
  end

  create_table "post_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.string "image_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "profile_image_id"
    t.string "introduction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
