class AddColorColumnToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :color, :string
  end
end
