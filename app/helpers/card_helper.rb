module CardHelper
  def card_and_edition(name, edition)
    if ["Beta", "Unlimited", "Revised", "Alpha"].include?(edition)
      return "#{edition} #{name}"
    else
      "#{name} (#{edition})"
    end
  end
end