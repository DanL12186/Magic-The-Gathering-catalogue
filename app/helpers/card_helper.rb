module CardHelper
  require 'open-uri'
  include Pagy::Frontend
  include Cards
  
  def card_and_edition(name, edition)
    edition.match?(/Alpha|Beta|Unlimited|Revised/) ? "#{edition} #{name}" : "#{name} (#{edition})"
  end

  def edition_image_filename(rarity = 'Common', edition)
    file = rarity.match?(/Common|Special/) ? "editions/#{edition.downcase}" : "editions/#{edition.downcase} #{rarity.downcase}"
    file.delete(':')
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
    inverted_editions = AllEditionsStandardCodes.invert
    card.other_editions.map do | set_code | 
      edition_name = inverted_editions[set_code]
      link_to image_tag(edition_image_filename(edition_name), width: '32px', style: 'margin-right: 2px;'), "/cards/#{edition_name}/#{@card.name}" if edition_name
    end.join.html_safe
  end

  def rotation_type(year) 
    year.to_i < 2017 ? 'cw' : 'ccw'
  end

  def needs_updating?(last_updated, price)
    older_than_24_hours?(last_updated) || price.empty?
  end

  def older_than_24_hours?(last_updated)
    (Time.now - last_updated) > 24.hours
  end

  def lazy_load?(idx)
    idx > 1
  end

  def wizards_reserved_list
    "https://magic.wizards.com/en/articles/archive/official-reprint-policy-2010-03-10"
  end
  
  def hashify_search_results(results_arr)
    results_arr.map! { | result_arr | { edition: result_arr[0], name: result_arr[1], img_url: result_arr[2] } }
  end

  def add_prices_to_all
    cards = Card.where(prices: [])
    cards.each do | card | 
      args = [card.name, card.edition]
      prices = [get_mtgoldfish_price(*args), get_card_kingdom_price(*args), get_tcg_player_price(*args) ]
      card.update(prices: prices)
    end
  end

  def handle_foil(edition) #should just use a bool later as a card attr
    edition.match?(/From the Vault|Commander's Arsenal|Expeditions|Invokations|Inventions/) ? ':Foil' : ''
  end

  ##################################### Links and Scraping #####################################

  def scrape_page_if_exists(url)
    Thread.new do 
      begin
        Nokogiri::HTML(open(url))
      rescue OpenURI::HTTPError => error
        raise error unless error.message.match?("Not Found")
      end
    end.value
  end


  def process_mtgfish_edition(edition)
    set = edition.match?(/Alpha|Beta/) ? ("Limited Edition #{edition}") : edition.match?(/^Rev|Unl/) ? ("#{edition} Edition") : (edition)
    set += ' Core Set' if set.match?(/Magic 201[4-5]/)
    set.sub('Time Spiral ', '').gsub(' ', '+').delete("':")
  end

  def mtgoldfish_url(card_name, card_set)
    set = process_mtgfish_edition(card_set) + handle_foil(card_set)
    name = I18n.transliterate(card_name)
               .sub(/\([^\)]+\)$/) { | match | '-' + match }
               .delete(",.:;\"'/()!")
               .gsub(/\s+/, '+')
               .sub('+-','-')
    "https://www.mtggoldfish.com/price/#{set}/#{name}#paper"
  end

  def get_mtgoldfish_price(card_name, card_set)
    url = mtgoldfish_url(card_name, card_set)
    page = scrape_page_if_exists(url)
    price = page ? page.css('.price-box-price').children.last.try(:text) : nil
    price ? price.delete(',') : 'N/A'
  end


  def process_card_kingdom_edition(edition)
    ck_exceptions = { 
      'Fourth Edition' => '4th-edition', 'Fifth Edition' => '5th-edition', 'Sixth Edition' => '6th-edition', 'Seventh Edition' => '7th-edition',
      'Eighth Edition' => '8th-edition', 'Ninth-edition' => '9th-edition', 'Tenth-edition' => '10th-edition', 'Revised' => '3rd-edition', 
      'Ravnica: City of Guilds' => 'Ravnica', 'Time Spiral Timeshifted' => 'Timeshifted'
    }
    set = ck_exceptions[edition] || edition.gsub(' ', '-').downcase.delete("':")
    set = set.match(/magic-201[0-5]/) ? "#{set.match(/\d+/)}-core-set" : set
  end

  def card_kingdom_url(card_name, card_set)
    set = process_card_kingdom_edition(card_set)
    name = I18n.transliterate(card_name.downcase).delete(",.:;'\"()/!").gsub(/ +/,'-')

    "https://www.cardkingdom.com/mtg/#{set}/#{name}"
  end

  def get_card_kingdom_price(card_name, card_set)
    url = card_kingdom_url(card_name, card_set)
    page = scrape_page_if_exists(url)
    price = page.css('span.stylePrice').first.text.delete('$').strip if page
    
    price || 'N/A'
  end


  def process_tcg_player_edition(edition)
    tcg_exceptions = { 
      'Sixth Edition' => 'classic-sixth-edition', 'Seventh Edition' => '7th-edition', 'Eighth Edition' => '8th-edition', 'Ninth Edition' => '9th-edition',
      'Tenth Edition' => '10th-edition', 'Ravnica: City of Guilds' => 'Ravnica', 'Time Spiral Timeshifted' => 'Timeshifted'
    }
    set = tcg_exceptions[edition] || edition.gsub(' ', '-').downcase.delete(':')
    set += edition.match(/Magic 201[0-5]/) ? "-m#{set.match(/\d{2}$/)}" : edition.match?(/Alpha|Beta|Unl|^Rev/) ? '-edition' : ''
  end

  def tcg_player_url(card_name, card_set)
    set = process_tcg_player_edition(card_set)
    name = I18n.transliterate(card_name.downcase).delete(",.:;\"'/").gsub(/ +/, '-')

    "https://shop.tcgplayer.com/magic/#{set}/#{name}"
  end

  def get_tcg_player_price(card_name, card_set)
    url = tcg_player_url(card_name, card_set)
    page = scrape_page_if_exists(url)
    price = page ? page.css('div.price-point.price-point--market td').first.text.delete('$,') : nil

    price || 'N/A'
  end


  def gatherer_link(multiverse_id)
    "http://gatherer.wizards.com/Pages/Card/Details.aspx?printed=true&multiverseid=#{multiverse_id}"
  end

  def ebay_search_link(card_name, card_set)
    set = card_set.downcase.gsub(' ', '+')
    name = card_name.downcase.gsub(' ', '+')
    "https://www.ebay.com/sch/i.html?&_nkw=#{set}+#{name}"
  end
  #######################################################################################################
end