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

ActiveRecord::Schema[8.1].define(version: 2026_04_11_040605) do
  create_table "feed_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "entry_id"
    t.integer "feed_source_id", null: false
    t.datetime "published_at"
    t.text "summary"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["feed_source_id", "entry_id"], name: "index_feed_entries_on_feed_source_id_and_entry_id", unique: true
    t.index ["feed_source_id"], name: "index_feed_entries_on_feed_source_id"
  end

  create_table "feed_sources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "fetched_at"
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["url"], name: "index_feed_sources_on_url", unique: true
  end

  add_foreign_key "feed_entries", "feed_sources"
end
