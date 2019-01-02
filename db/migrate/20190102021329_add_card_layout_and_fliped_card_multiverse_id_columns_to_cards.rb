class AddCardLayoutAndFlipedCardMultiverseIdColumnsToCards < ActiveRecord::Migration[5.2]
  def change
    #layout of card, e.g. split (i.e. Cut // Ribbons), transform (i.e. Ludevic's Test Subject), or normal
    add_column :cards, :layout, :string, default: 'normal'
    add_column :cards, :flip_card_multiverse_id, :integer, default: nil
  end
end
