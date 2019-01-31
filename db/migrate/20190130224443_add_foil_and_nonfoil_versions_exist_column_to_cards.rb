class AddFoilAndNonfoilVersionsExistColumnToCards < ActiveRecord::Migration[5.2]
  def change
    #foil versions exist for most any card printed after Urza's Legacy
    add_column :cards, :foil_version_exists, :boolean, default: false
    add_column :cards, :nonfoil_version_exists, :boolean, default: true
  end
end
