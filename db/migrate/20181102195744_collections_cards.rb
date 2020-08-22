class CollectionsCards < ActiveRecord::Migration[5.2]
  def change
    create_table :collections_cards do |t|
      t.integer :card_id
      t.integer :collection_id
      
      t.integer :copies, default: 1
    end
  end
end
