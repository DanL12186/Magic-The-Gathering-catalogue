require 'open-uri'
require 'nokogiri'
require 'mtg_sdk'

module ApplicationHelper

  def color_to_mana(color)
    mana_types = {
      "Red" => "mountain",
      "Green" => "forest",
      "Black" => "swamp",
      "Blue"  => "island",
      "White" => "plains",
      "Colorless" => "colorless",
      "Gold" => "gold"
    }

    mana_types[color] || color
  end

  def card_class(card)
    card.edition == 'Alpha' ? 'card_img alpha' : 'card_img'
  end

  ##################################### Links and Scraping #####################################


  ##############################################################################

end