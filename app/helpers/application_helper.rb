include Cards

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

  def truncate_at_three_words(card_name)
    words = card_name.split(/-| /)[0..2]
    len = words.join(' ').length
    card_name[0..len].strip
  end

end