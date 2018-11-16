class AddPriceColumnToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :price, :string, array: true, default: []
  end
end
