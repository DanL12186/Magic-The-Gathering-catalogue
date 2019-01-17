class DecksCards < ActiveRecord::Migration[5.2]
  def change
    create_table :decks_cards do |t|
      t.integer :card_id
      t.integer :deck_id
      t.integer :copies, default: 1
    end
  end
end
