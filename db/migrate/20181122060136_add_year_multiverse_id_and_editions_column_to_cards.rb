class AddYearMultiverseIdAndEditionsColumnToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :year, :string
    add_column :cards, :other_editions, :string, array: true, default: []
    add_column :cards, :multiverse_id, :integer
  end
end
