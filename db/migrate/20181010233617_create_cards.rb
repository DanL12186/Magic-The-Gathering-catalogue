class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|

      t.string :name, null: false
      t.string :edition, null: false
      t.string :artist
      t.string :card_type

      t.integer :multiverse_id, null: false

      t.string :mana, array: true, default: []

      t.string :subtypes, array: true, default: []
      t.string :color
      t.string :colors, array: true, default: []
      
      t.integer :year
      t.boolean :reprint, default: false

      #card # in its respective set, e.g. '64' (e.g., 64/236); flip cards will be a/b (e.g. '64a'/'64b'). 
      #Needed because some newer sets inexplicably order cards by card # rather than Multiverse ID
      t.string :card_number

      t.string :border_color, default: 'black'
      t.json :legalities, default: {}

      t.boolean :iconic, default: false
      t.boolean :legendary, default: false

      t.string :other_editions, array: true, default: []

      t.integer :converted_mana_cost

      t.integer :power, default: nil
      t.integer :toughness, default: nil

      t.boolean :restricted, default: false
      t.boolean :reserved, default: false
      t.string :rarity

      t.integer :loyalty, default: nil
      t.integer :frame

      #layout of card, e.g. 'split' (i.e. Cut // Ribbons), 'transform' (i.e. Ludevic's Test Subject)
      t.string :layout, default: 'normal'

      t.integer :flip_card_multiverse_id, default: nil

      t.text :original_text, default: ''
      t.text :oracle_text, default: ''
      
      t.string :prices, array: true, default: []

      t.string :img_url

      t.string :hi_res_img
      t.string :cropped_img

      t.text :flavor_text

      t.text :site_note
      
      t.string :scryfall_uri

      t.timestamps

      t.index ["iconic"], name: "index_cards_on_iconic", where: "(iconic = true)"
      t.index ["multiverse_id"], name: "index_cards_on_multiverse_id"
    end
  end
end