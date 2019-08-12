class AddCopiesToCollectionsCards < ActiveRecord::Migration[5.2]
  def change
    add_column :collections_cards, :copies, :integer, default: 1
  end
end
