class AddIndexingToCardNameAndEdition < ActiveRecord::Migration[5.2]
  def change
    add_index :cards, :name
    add_index :cards, :edition
  end
end
