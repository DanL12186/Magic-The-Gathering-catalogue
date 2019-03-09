#################################################################################################################
#Threaded scraper which gets all prices for all cards in a set off of MTGfish, CardKingdom, and TCGPlayer. 

#A fraction of a percent of cards don't work on one site or another due to differences in how that site
#lists it... cards with multiple artwork versions are most primarily affected.

#This won't get all prices unless all cards of the given set have been added; uses local card count for page #'s
#################################################################################################################
require 'open-uri'

EARLY_CORE_SETS = { 
  'Fourth Edition' => '4th-edition', 
  'Fifth Edition' => '5th-edition',
  'Sixth Edition' => '6th-edition', 
  'Seventh Edition' => '7th-edition',
  'Eighth Edition' => '8th-edition',
  'Ninth Edition' => '9th-edition',
  'Tenth Edition' => '10th-edition'
}

def get_set_prices(set_code)
  @set_name = AllEditionsStandardCodes.invert[set_code.upcase]

  @threads = []
  @cards = {}

  card_set_names = Card.where(edition: @set_name).map(&:name)
  card_set_names.each { | name | @cards[I18n.transliterate(name)] = ['N/A', 'N/A', 'N/A'] }
  
  #set for mtgoldfish is actually the set code for full sets
  def get_mtgoldfish_set_prices(set_code)
    set_code.upcase!
    #filter all alt set codes that are two letters in mtgoldfish instead of 3
    set_code = Cards::Editions[@set_name] if Cards::Editions[@set_name]
    set_code += '_F' if set_code.match?(/MS2|MS3|EXP/)

    url = "https://www.mtggoldfish.com/index/#{set_code}#paper"

    #MTGoldFish loads its online prices before refreshing with its paper prices..
    #so it's necessary to wait on the thread so the page can provide the correct data
    card_rows = Thread.new do 
      page = Thread.new { open(url) }.value
      Nokogiri::HTML(page)
    end.value.css('tbody tr')
 
    card_rows.each do | card_row |
      name = card_row.css('td a').text
      price = card_row.css('td.text-right').text.match(/\d+\,*\d*\.\d+/)[0].delete(',')
      if !@cards[name]
        if name.match?("(A)")
          fixed_name = name.sub(' (A)', '')
          @cards[fixed_name][0] = price if @cards[fixed_name] && @cards[fixed_name][0] == 'N/A'
        end
        puts "Failed to get price for #{name} on cardkingdom" unless @cards[fixed_name]
        next
      end
      @cards[name][0] = price if @cards[name]&.first == 'N/A'
    end
  end

  def get_card_kingdom_set_prices(set_code)
    set = @set_name.match(/Magic 201[0-5]/) ? "#{@set_name.match(/\d+/)}-core-set" : @set_name.delete("':")
    set = set.gsub(' ', '-').downcase
    set = 'ravnica' if set_code.match?(/rav/i)
    set = "masterpiece-series-#{set.split('-')[-1]}" if set.match?(/expeditions|inventions|invocations/)
    set = EARLY_CORE_SETS[set.titleize] || set
    
    total_pages = @cards.size.fdiv(60).ceil

    (1..total_pages).each do | idx |
      @threads << Thread.new do 
        url = "https://www.cardkingdom.com/mtg/#{set}?filter%5Bipp%5D=60&page=#{idx}"
        card_divs = Nokogiri::HTML(open(url)).css('div.productItemWrapper.productCardWrapper')

        card_divs.each do | card_div | 
          name = card_div.css('span a').text.sub("(Oversized Foil)",'').sub(/\((Foil|HOU|AKH|KLD|AER|OGW.+|BFZ.+)\)/,'').strip
          price = card_div.css('.itemAddToCart.NM').text.match(/\d+\.\d+/)[0]

          if !@cards[name]
            puts "Failed to get price for #{name} on cardkingdom"
            next
          end
          
          @cards[name][1] = price
        end
      end
    end
  end

  #tcg player does 7th edition, 8th edition etc but fourth fifth sixth edition
  def get_tcg_player_set_prices(set_code)
    tcg_exceptions = { 
      'Sixth Edition' => 'classic-sixth-edition', 'Seventh Edition' => '7th-edition', 'Eighth Edition' => '8th-edition', 'Ninth Edition' => '9th-edition',
      'Tenth Edition' => '10th-edition', 'Time Spiral Timeshifted' => 'timeshifted', 'Amonkhet Invocations' => 'masterpiece-series-amonkhet-invocations',
      'Kaladesh Inventions' => 'masterpiece-series-kaladesh-inventions', 'Ultimate Box Topper' => 'ultimate-masters-box-toppers'
    }
    
    set = tcg_exceptions[@set_name] || @set_name.gsub(' ', '-').downcase.delete(':')
    set += @set_name.match(/magic 201[0-5]/) ? "-m#{set.match(/\d{2}$/)}" : @set_name.match?(/Alpha|Beta|Unl|^Rev/) ? '-edition' : ''
    
    url = "https://shop.tcgplayer.com/price-guide/magic/#{set}"

    card_rows = Nokogiri::HTML(open(url)).css('tbody tr')

    card_rows.each do | card_row | 
      name = I18n.transliterate(card_row.css('div.productDetail a').text)
      price = card_row.css('td.marketPrice').text.match(/\d+\,*\d*\.\d+/)[0].delete(',')
      
      if !@cards[name]
        puts "Failed to get price for #{name} on tcgplayer"
        next
      end
      @cards[name][2] = price
    end
  end

  def save_prices(set_code)
    @cards.each do | name, prices |
      edition = @set_name
      #could probably save a lot of querying by saving all the cards as objects to the @cards hash, updating and saving from there.
      card = Card.find_by(name: name, edition: edition)

      #Sites strip I18n from card names :(
      if !card
        matched_editions = Card.where(edition: edition)
        card = matched_editions.find { | card | I18n.transliterate(card.name) == name }
        next unless card
      end
      card.prices = prices
      card.save unless card.prices.all? { | price | price == 'N/A' }
    end
  end

  get_mtgoldfish_set_prices(set_code)
  get_card_kingdom_set_prices(set_code)
  get_tcg_player_set_prices(set_code)

  @threads.each(&:join)

  save_prices(set_code)
end