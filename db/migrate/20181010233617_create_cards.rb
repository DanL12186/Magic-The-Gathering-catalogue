class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|

      t.string :name, null: false
      t.string :edition, null: false
      t.string :artist
      t.string :card_type

      t.string :subtypes, array: true, default: []
      t.string :colors, array: true, default: []
      t.string :mana, array: true, default: []

      t.integer :converted_mana_cost

      t.integer :power, default: nil
      t.integer :toughness, default: nil

      t.boolean :restricted, default: false
      t.boolean :reserved, default: false
      t.string :rarity

      t.string :abilities, array: true, default: [] #e.g. flying, trample
      t.string :effects #e.g. all creatures destroyed when entering game
      t.string :activated_abilities, array: true, default: [] #e.g. tap to add x to mana pool
      
      t.string :img_url
      t.text :flavor_text

      t.timestamps
    end
    add_index :cards, :subtypes, using: 'gin'
    add_index :cards, :colors, using: 'gin'
    add_index :cards, :abilities, using: 'gin'
    add_index :cards, :mana, using: 'gin'
    add_index :cards, :activated_abilities, using: 'gin'
  end
end