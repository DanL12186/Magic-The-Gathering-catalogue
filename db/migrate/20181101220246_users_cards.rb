class UserCards < ActiveRecord::Migration[5.2]
  def change
    create_table :user_cards do |t|
      t.integer :user_id
      t.integer :card_id
    end
  end
end
