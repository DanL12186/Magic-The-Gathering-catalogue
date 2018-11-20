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
      "White" => "plains"
    }

    mana_types[color] || color
  end


  def mtgoldfish_url(card_name, card_set)
    set = (card_set.match?(/Alpha|Beta/) ? ("Limited Edition #{card_set}") : card_set.match?(/Rev|Unl/) ? ("#{card_set} Edition") : (card_set))
          .gsub(' ', '+')
    name = I18n.transliterate(card_name).gsub(' ', '+').delete(",.:;'")

    "https://www.mtggoldfish.com/price/#{set}/#{name}#paper"
  end

  def get_mtgoldfish_price(card_name, card_set)
    url = mtgoldfish_url(card_name, card_set)

    page = Thread.new do 
      begin
        Nokogiri::HTML(open(url)) 
      rescue OpenURI::HTTPError => error
        raise error unless error.message == '404 Not Found'
      end
    end
    price = page.value ? page.value.css('.price-box-price').children.last.try(:text) : nil
    price ? "$#{price}" : "N/A"
  end


  def card_kingdom_url(card_name, card_set)
    set = card_set.gsub(' ', '-').downcase
    set = "3rd-edition" if set == "revised"
    name = I18n.transliterate(card_name.downcase).gsub(' ', '-').delete(",.:;'")

    "https://www.cardkingdom.com/mtg/#{set}/#{name}"
  end

  def get_card_kingdom_price(card_name, card_set)
    url = card_kingdom_url(card_name, card_set)

    page = Thread.new { Nokogiri::HTML(open(url)) }
    page.value.css('span.stylePrice').first.text.strip
  end


  def tcg_player_url(card_name, card_set)
    set = card_set.gsub(' ', '-').downcase
    set += '-edition' if card_set.match?(/Alpha|Beta|Unl|Rev/)
    name = I18n.transliterate(card_name.downcase).gsub(' ', '-').delete(",.:;'")

    "https://shop.tcgplayer.com/magic/#{set}/#{name}"
  end

  def get_tcg_player_price(card_name, card_set)
    url = tcg_player_url(card_name, card_set)

    page = Thread.new do 
      begin
        Nokogiri::HTML(open(url)) 
      rescue OpenURI::HTTPError => error
        raise error unless error.message == '404 Not Found'
      end
    end
    page.value.css('div.price-point.price-point--market td').text
    price = page.value ? page.value.css('div.price-point.price-point--market td').text : nil
    price ? "#{price}" : "N/A"
  end


  def ebay_search_link(card_name, card_set)
    set = card_set.downcase.gsub(' ', '+')
    name = card_name.downcase.gsub(' ', '+')
    "https://www.ebay.com/sch/i.html?&_nkw=#{set}+#{name}"
  end

end