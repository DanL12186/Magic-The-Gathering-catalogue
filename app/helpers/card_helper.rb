module CardHelper
  include Cards
  require 'open-uri'
  
  def card_and_edition(name, edition)
    edition.match?(/Alpha|Beta|Unlimited|Revised/) ? "#{edition} #{name}" : "#{name} (#{edition})"
  end

  def edition_filename(rarity, edition)
    file = rarity == "Common" ? "editions/#{edition.downcase}" : "editions/#{edition.downcase} #{rarity.downcase}"
    file.delete(':')
  end

  def is_modern_or_basic_land?(card)
    !Editions[card.edition] && !card.edition.match?(/Urza's|Mercadian/) || card.card_type == "Basic" && !card.subtypes.include?("Nonbasic Land")
  end

  def mana_color(color)
    (color.between?('0', '9') || color == 'X') ? 'Colorless' : color
  end

  def sort_by_number_and_name_desc(cards, deck_frequencies)
    cards.uniq { | card | card.name }.sort_by { | card | [ -@deck_frequencies[card.name], card.name ] }
  end

  def insert_commas_in_price(price)
    return 'Fetching...' if price.nil?
    return 'N/A' if price == 'N/A'

    "$#{number_with_delimiter(price)}"
  end

  def needs_updating?(last_updated, price)
    older_than_24_hours?(last_updated) || price.empty?
  end

  def older_than_24_hours?(last_updated)
    (Time.now - last_updated) > 24.hours
  end

  def add_prices_to_all
    cards = Card.where(price: [])
    cards.each do | card | 
      args = [card.name, card.edition]
      prices = [get_mtgoldfish_price(*args), get_card_kingdom_price(*args), get_tcg_player_price(*args) ]
      card.update(price: prices)
    end
  end

  ##################################### Links and Scraping #####################################

  def scrape_page_if_exists(url)
    Thread.new do 
      begin
        Nokogiri::HTML(open(url))
      rescue OpenURI::HTTPError => error
        raise error unless error.message.match?("Not Found")
      end
    end
  end


  def mtgoldfish_url(card_name, card_set)
    set = (card_set.match?(/Alpha|Beta/) ? ("Limited Edition #{card_set}") : card_set.match?(/Rev|Unl/) ? ("#{card_set} Edition") : (card_set))
          .gsub(' ', '+').delete("':")
    name = I18n.transliterate(card_name).gsub(' ', '+').delete(",.:;'")

    "https://www.mtggoldfish.com/price/#{set}/#{name}#paper"
  end

  def get_mtgoldfish_price(card_name, card_set)
    url = mtgoldfish_url(card_name, card_set)
    page = scrape_page_if_exists(url)
    price = page.value ? page.value.css('.price-box-price').children.last.try(:text) : nil
    puts price
    price ? price.delete(',') : 'N/A'
  end


  def card_kingdom_url(card_name, card_set)
    puts card_set
    set = (card_set == 'Revised') ? ('3rd-edition') : (card_set == 'Fourth Edition') ? '4th-edition' : card_set.gsub(' ', '-').downcase.delete("':")
    set = set.match(/201[0-5]/) ? "#{set.match(/\d+/)[0]}-core-set" : set
    set = "Ravnica" if card_set.match?("Ravnica: City of Guilds")
    puts set
    name = I18n.transliterate(card_name.downcase).gsub(' ','-').delete(",.:;'")

    "https://www.cardkingdom.com/mtg/#{set}/#{name}"
  end

  def get_card_kingdom_price(card_name, card_set)
    url = card_kingdom_url(card_name, card_set)
    page = scrape_page_if_exists(url)
    price = page.value.css('span.stylePrice').first.text.strip if page.value
    
    price ? price.delete('$') : 'N/A'
  end


  def tcg_player_url(card_name, card_set)
    set = card_set.gsub(' ', '-').downcase.delete(':')
    set += '-edition' if card_set.match?(/Alpha|Beta|Unl|Rev/)
    name = I18n.transliterate(card_name.downcase).gsub(' ', '-').delete(",.:;'")

    "https://shop.tcgplayer.com/magic/#{set}/#{name}"
  end

  def get_tcg_player_price(card_name, card_set)
    url = tcg_player_url(card_name, card_set)
    page = scrape_page_if_exists(url)
    price = page.value ? page.value.css('div.price-point.price-point--market td').first.text : nil

    price ? price.delete('$,') : 'N/A'
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