class AddLoyaltyCountersAndFrameColumnsToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :loyalty, :integer, default: nil
    add_column :cards, :frame, :integer
  end
end
