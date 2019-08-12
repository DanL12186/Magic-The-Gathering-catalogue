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

ActiveRecord::Schema.define(version: 2019_08_12_151021) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string "name", null: false
    t.string "edition", null: false
    t.string "artist"
    t.string "card_type"
    t.integer "multiverse_id", null: false
    t.string "mana", default: [], array: true
    t.string "subtypes", default: [], array: true
    t.string "color"
    t.string "colors", default: [], array: true
    t.integer "year"
    t.boolean "reprint", default: false
    t.string "border_color", default: "black"
    t.json "legalities", default: {}
    t.boolean "iconic", default: false
    t.boolean "legendary", default: false
    t.string "other_editions", default: [], array: true
    t.integer "converted_mana_cost"
    t.integer "power"
    t.integer "toughness"
    t.boolean "restricted", default: false
    t.boolean "reserved", default: false
    t.string "rarity"
    t.integer "loyalty"
    t.integer "frame"
    t.string "layout", default: "normal"
    t.integer "flip_card_multiverse_id"
    t.text "original_text", default: ""
    t.text "oracle_text", default: ""
    t.string "abilities", default: [], array: true
    t.string "effects"
    t.string "activated_abilities", default: [], array: true
    t.string "prices", default: [], array: true
    t.string "img_url"
    t.string "hi_res_img"
    t.string "cropped_img"
    t.text "flavor_text"
    t.text "site_note"
    t.string "scryfall_uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hand_picked", default: false
    t.float "rating", default: 0.0
    t.integer "total_ratings", default: 0
    t.float "art_rating", default: 0.0
    t.integer "total_art_ratings", default: 0
    t.boolean "foil_version_exists", default: false
    t.boolean "nonfoil_version_exists", default: true
    t.string "card_number"
    t.index ["edition"], name: "index_cards_on_edition"
    t.index ["hand_picked"], name: "index_cards_on_hand_picked", where: "(hand_picked = true)"
    t.index ["iconic"], name: "index_cards_on_iconic", where: "(iconic = true)"
    t.index ["multiverse_id"], name: "index_cards_on_multiverse_id"
    t.index ["name"], name: "index_cards_on_name"
    t.index ["reserved"], name: "index_cards_on_reserved", where: "(reserved = true)"
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
    t.integer "copies", default: 1
  end

  create_table "decks", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id"
    t.string "colors", array: true
    t.string "card_types", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
