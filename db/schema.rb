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

ActiveRecord::Schema.define(version: 2019_01_15_212329) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string "name", null: false
    t.string "edition", null: false
    t.string "artist"
    t.string "card_type"
    t.string "subtypes", default: [], array: true
    t.string "colors", default: [], array: true
    t.string "mana", default: [], array: true
    t.integer "converted_mana_cost"
    t.integer "power"
    t.integer "toughness"
    t.boolean "restricted", default: false
    t.boolean "reserved", default: false
    t.string "rarity"
    t.string "abilities", default: [], array: true
    t.string "effects"
    t.string "activated_abilities", default: [], array: true
    t.string "img_url"
    t.text "flavor_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "site_note"
    t.string "color"
    t.string "price", default: [], array: true
    t.string "hi_res_img"
    t.string "cropped_img"
    t.string "year"
    t.string "other_editions", default: [], array: true
    t.integer "multiverse_id"
    t.json "legalities", default: {}
    t.boolean "iconic", default: false
    t.boolean "legendary", default: false
    t.string "layout", default: "normal"
    t.integer "flip_card_multiverse_id"
    t.integer "loyalty"
    t.integer "frame"
    t.text "oracle_text", default: ""
    t.string "border_color", default: "black"
    t.string "scryfall_uri"
    t.boolean "reprint", default: false
    t.index ["abilities"], name: "index_cards_on_abilities", using: :gin
    t.index ["activated_abilities"], name: "index_cards_on_activated_abilities", using: :gin
    t.index ["colors"], name: "index_cards_on_colors", using: :gin
    t.index ["iconic"], name: "index_cards_on_iconic", where: "(iconic = true)"
    t.index ["mana"], name: "index_cards_on_mana", using: :gin
    t.index ["multiverse_id"], name: "index_cards_on_multiverse_id"
    t.index ["reprint"], name: "index_cards_on_reprint", where: "(reprint = false)"
    t.index ["subtypes"], name: "index_cards_on_subtypes", using: :gin
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collections_cards", force: :cascade do |t|
    t.integer "card_id"
    t.integer "collection_id"
  end

  create_table "decks", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id"
    t.string "colors", array: true
    t.string "card_types", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_types"], name: "index_decks_on_card_types", using: :gin
    t.index ["colors"], name: "index_decks_on_colors", using: :gin
  end

  create_table "decks_cards", force: :cascade do |t|
    t.integer "card_id"
    t.integer "deck_id"
    t.integer "copies", default: 1
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_cards", force: :cascade do |t|
    t.integer "user_id"
    t.integer "card_id"
  end

end
