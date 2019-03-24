class AddCardNumberColumnToCardTable < ActiveRecord::Migration[5.2]
  def change
    #number of a card in its respective set, e.g. '64' (e.g., 64/236)
    #flip cards will be a/b (e.g. '64a'/'64b'). Needed because some 
    #newer sets inexplicably order cards by card # rather than Multiverse ID
    add_column :cards, :card_number, :string
  end
end
