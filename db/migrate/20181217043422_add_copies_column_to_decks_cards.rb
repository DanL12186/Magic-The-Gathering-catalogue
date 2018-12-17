class AddCopiesColumnToDecksCards < ActiveRecord::Migration[5.2]
  def change
    add_column :decks_cards, :copies, :integer, default: 1
  end
end
