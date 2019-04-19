include Cards

module ApplicationHelper
  LANDS = Set.new(['Swamp', 'Island', 'Mountain', 'Forest', 'Plains'])

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
    name_len = words.join(' ').length
    truncated_name = card_name[0..name_len].strip
    truncated_name == card_name ? card_name : "#{truncated_name}..."
  end

  def title(page_name)
    content_for(:title) { page_name }
  end

end