module CardHelper
  include Pagy::Frontend
  include CardSets
  
  def card_and_edition(name, edition)
    edition.match?(/Alpha|Beta|Unlimited|Revised/) ? "#{edition} #{name}" : "#{name} (#{edition})"
  end

  def edition_image_filename(rarity = 'Common', edition)
    filename = rarity.match?(/Common|Special/) ? "editions/#{edition.downcase}" : "editions/#{edition.downcase} #{rarity.downcase}"
    filename.delete(':')
  end

  #checks whether no .other_editions set codes on a card exist in this app
  def edition_not_present?(edition_codes)
    set_codes = AllEditionsStandardCodes.invert
    edition_codes.none?(&set_codes)
  end

  def mana_color(color)
    color.match?(/\d+|X/) ? 'Colorless' : color
  end

  def display_price(price)
    return 'Fetching...' if price.nil?
    return 'N/A' if price == 'N/A'

    number_to_currency(price)
  end

  def display_other_editions(card)
    set_codes = AllEditionsStandardCodes.invert
    card.other_editions.map do | set_code | 
      edition_name = set_codes[set_code]
      link_to image_tag(edition_image_filename(edition_name), class: 'other-edition'), card_path(edition_name, card.name) if edition_name
    end.join.html_safe
  end

  def rotation_angle(year, layout)
    return '180deg' if layout == 'flip'
    year.to_i < 2017 ? '90deg' : '-90deg'
  end

  def needs_updating?(last_updated, price)
    last_updated.before?(1.day.ago) || price.empty?
  end

  def lazy_load?(idx, threshold = 1)
    idx > threshold
  end

  def generate_foil_show_class(card)
    "#{"hidden" if card.nonfoil_version_exists?} foil-overlay show-pg-foil #{'flip-foil' if card.card_number.match?(/(a|b)/)} foil-overlay-js #{'post-2015-foil' if card.frame == 2015}".strip
  end

  def gatherer_link(multiverse_id)
    "https://gatherer.wizards.com/Pages/Card/Details.aspx?printed=true&multiverseid=#{multiverse_id}"
  end

  def ebay_search_link(card_name, card_set)
    set, name = [card_set, card_name].map { | str | str.downcase.gsub(' ', '+') }
    
    "https://www.ebay.com/sch/i.html?&_nkw=#{set}+#{name}"
  end

end