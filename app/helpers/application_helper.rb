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

  def get_mtgoldfish_price(card_name, card_set)
    name = card_name.gsub(' ', '+').delete(",.:;'")
    set = (card_set.match?(/Alpha|Beta/) ? ("Limited Edition #{card_set}") : card_set.match?(/Rev|Unl/) ? ("#{card_set} Edition") : (card_set))
          .gsub(' ', '+')

    page = Thread.new { Nokogiri::HTML(open("https://www.mtggoldfish.com/price/#{set}/#{name}#paper")) }
    price = page.value.css('.price-box-price').children.last.try(:text)
    price ? "$#{price}" : "N/A"
  end

  def get_card_kingdom_price(card_name, card_set)
    set = card_set.gsub(' ', '-').downcase
    set = "3rd-edition" if set == "revised"
    name = card_name.gsub(' ', '-').delete(",.:;'").downcase

    page = Thread.new { Nokogiri::HTML(open("https://www.cardkingdom.com/mtg/#{set}/#{name}")) }
    page.value.css('span.stylePrice').first.text.strip.gsub('\n','')
  end

  def ebay_search_link(card_name, card_set)
    "https://www.ebay.com/sch/i.html?&_nkw=#{card_set.downcase.gsub(' ','+')}+#{card_name.downcase.gsub(' ', '+')}"
  end
end