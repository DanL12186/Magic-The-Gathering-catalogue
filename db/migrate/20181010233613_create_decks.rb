class CreateDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :decks do |t|
      t.string :name, null: false
      t.integer :user_id
      t.string :colors, array: true
      t.string :card_types, array: true

      t.timestamps
    end
  end
end
