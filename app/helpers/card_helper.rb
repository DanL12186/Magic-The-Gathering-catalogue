module CardHelper
  
  def card_and_edition(name, edition)
    if ["Beta", "Unlimited", "Revised", "Alpha"].include?(edition)
      return "#{edition} #{name}"
    else
      "#{name} (#{edition})"
    end
  end

  def is_basic_land?(card)
    card.card_type == "Land" && !card.subtypes.include?("Nonbasic Land")
  end

  def mana_color(color)
    (color.between?("0", "9") || color == "X") ? "Colorless" : color
  end

end