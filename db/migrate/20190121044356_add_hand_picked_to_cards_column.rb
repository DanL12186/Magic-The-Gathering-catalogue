class AddHandPickedToCardsColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :hand_picked, :boolean, default: false
    add_index :cards, :hand_picked, where: "(hand_picked = true)"
  end
end
