class CreateEditions < ActiveRecord::Migration[5.2]
  def change
    create_table :editions do |t|
      t.string :name
      t.string :set_code
      t.string :release_date

      t.string :set_type #e.g. explansion, core set
      t.string :category #e.g., vintage, modern, standard
      t.string :block, default: nil #e.g. Ice Age Block, 
      t.integer :card_count #total cards in the set

      t.integer :cards_per_pack #cards per booster pack
      t.integer :commons_per_pack
      t.integer :uncommons_per_pack

      t.boolean :mythics?

      t.timestamps
    end
  end
end
