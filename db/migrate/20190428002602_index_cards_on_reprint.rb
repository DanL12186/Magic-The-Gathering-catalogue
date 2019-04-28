class IndexCardsOnReprint < ActiveRecord::Migration[5.2]
  def change
    remove_index "cards", name: "index_cards_on_reprint", where: "(reprint = false)"
  end
end
