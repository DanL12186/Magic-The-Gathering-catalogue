class AddOracleTextBorderColorScryfallUriAndReprint < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :oracle_text, :text, default: ""
    add_column :cards, :border_color, :string, default: "black"
    add_column :cards, :scryfall_uri, :string
    add_column :cards, :reprint, :boolean, default: false
  end
end
