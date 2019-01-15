class AddIndexingToMultiverseAndPartialIndexingToReprintsAndIconic < ActiveRecord::Migration[5.2]
  def change
    add_index :cards, :multiverse_id
    add_index :cards, :reprint, where: "reprint = false"
    add_index :cards, :iconic, where: "iconic = true"
  end
end
