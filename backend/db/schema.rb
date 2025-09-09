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

ActiveRecord::Schema[8.0].define(version: 2025_09_09_103604) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "genre_summaries", force: :cascade do |t|
    t.bigint "genre_id", null: false
    t.integer "year"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id", "year"], name: "index_genre_summaries_on_genre_id_and_year"
    t.index ["genre_id"], name: "index_genre_summaries_on_genre_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "master_releases", force: :cascade do |t|
    t.integer "discogs_id"
    t.string "masters"
    t.string "master"
    t.string "main_release"
    t.string "artists"
    t.string "artist"
    t.string "name"
    t.string "join"
    t.string "genres"
    t.string "genre"
    t.string "styles"
    t.string "style"
    t.integer "year"
    t.string "title"
    t.string "data_quality"
    t.string "videos"
    t.string "video"
    t.string "description"
    t.string "anv"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "master_releases_genres", force: :cascade do |t|
    t.bigint "master_release_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_master_releases_genres_on_genre_id"
    t.index ["master_release_id"], name: "index_master_releases_genres_on_master_release_id"
  end

  create_table "master_releases_styles", force: :cascade do |t|
    t.bigint "master_release_id", null: false
    t.bigint "style_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["master_release_id"], name: "index_master_releases_styles_on_master_release_id"
    t.index ["style_id"], name: "index_master_releases_styles_on_style_id"
  end

  create_table "style_summaries", force: :cascade do |t|
    t.bigint "style_id", null: false
    t.integer "year"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["style_id", "year"], name: "index_style_summaries_on_style_id_and_year"
    t.index ["style_id"], name: "index_style_summaries_on_style_id"
  end

  create_table "styles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_styles_on_name", unique: true
  end

  add_foreign_key "genre_summaries", "genres"
  add_foreign_key "master_releases_genres", "genres"
  add_foreign_key "master_releases_genres", "master_releases"
  add_foreign_key "master_releases_styles", "master_releases"
  add_foreign_key "master_releases_styles", "styles"
  add_foreign_key "style_summaries", "styles"
end
