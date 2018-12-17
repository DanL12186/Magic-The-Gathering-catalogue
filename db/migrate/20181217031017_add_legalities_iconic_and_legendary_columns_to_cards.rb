class AddLegalitiesIconicAndLegendaryColumnsToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :legalities, :json, default: {}
    add_column :cards, :iconic, :boolean, default: false
    add_column :cards, :legendary, :boolean, default: false
  end
end