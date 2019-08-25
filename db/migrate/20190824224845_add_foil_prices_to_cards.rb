class AddFoilPricesToCards < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :foil_prices, :string, array: true, default: []
  end
end
