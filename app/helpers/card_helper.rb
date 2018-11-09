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
end