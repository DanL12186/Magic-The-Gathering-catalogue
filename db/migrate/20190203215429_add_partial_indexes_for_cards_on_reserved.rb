class AddPartialIndexesForCardsOnReserved < ActiveRecord::Migration[5.2]
  def change
    add_index :cards, :reserved, where: "(reserved = true)"
  end
end