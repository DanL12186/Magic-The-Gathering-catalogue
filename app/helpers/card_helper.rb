require 'open-uri'

module CardHelper
  include Pagy::Frontend
  include CardSets
  
  def card_and_edition(name, edition)
    edition.match?(/Alpha|Beta|Unlimited|Revised/) ? "#{edition} #{name}" : "#{name} (#{edition})"
  end

  def edition_image_filename(rarity = 'Common', edition)
    file = rarity.match?(/Common|Special/) ? "editions/#{edition.downcase}" : "editions/#{edition.downcase} #{rarity.downcase}"
    file.delete(':')
  end

  def edition_not_present?(edition_codes)
    set_codes = AllEditionsStandardCodes.invert
    edition_codes.none? { | code | set_codes[code] }
  end

  def mana_color(color)
    color.match?(/\d+|X/) ? 'Colorless' : color
  end

  def display_price(price)
    return 'Fetching...' if price.nil?
    return 'N/A' if price == 'N/A'

    insert_commas_in_price(price)
  end

  def insert_commas_in_price(price)
    "$#{number_with_delimiter(price)}"
  end

  def display_other_editions(card)
    set_codes = AllEditionsStandardCodes.invert
    card.other_editions.map do | set_code | 
      edition_name = set_codes[set_code]
      link_to image_tag(edition_image_filename(edition_name), class: 'other-edition'), card_path(edition_name, @card.name) if edition_name
    end.join.html_safe
  end

  def rotation_angle(year, layout)
    return '180deg' if layout == 'flip'
    year.to_i < 2017 ? '90deg' : '-90deg'
  end

  def needs_updating?(last_updated, price)
    older_than_24_hours?(last_updated) || price.empty?
  end

  def older_than_24_hours?(last_updated)
    (Time.now - last_updated) > 24.hours
  end

  def lazy_load?(idx, threshold = 1)
    idx > threshold
  end
  
  def hashify_search_results(results_arr)
    results_arr.map! { | result_arr | { edition: result_arr[0], name: result_arr[1], img_url: result_arr[2] } }
  end

  def gatherer_link(multiverse_id)
    "http://gatherer.wizards.com/Pages/Card/Details.aspx?printed=true&multiverseid=#{multiverse_id}"
  end

  def ebay_search_link(card_name, card_set)
    set, name = [card_set, card_name].map { | str | str.downcase.gsub(' ', '+') }
    
    "https://www.ebay.com/sch/i.html?&_nkw=#{set}+#{name}"
  end

end