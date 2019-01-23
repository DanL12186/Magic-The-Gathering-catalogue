class AddCardAndArtworkRatingsToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :rating, :float, default: 0
    add_column :cards, :total_ratings, :integer, default: 0

    add_column :cards, :art_rating, :float, default: 0
    add_column :cards, :total_art_ratings, :integer, default: 0
  end
end
