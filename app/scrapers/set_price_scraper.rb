#################################################################################################################
#Threaded scraper which gets all prices for all cards in a set off of MTGfish, CardKingdom, and TCGPlayer. 

#A fraction of a percent of cards don't work on one site or another due to differences in how that site
#lists it... cards with multiple artwork versions are most primarily affected.

#Accepts an optional second parameter, which if set to 'foil' or 'foils' will update foil_prices instead of prices.
#May later have both happen at once if it seems reasonable

#This won't get all prices unless all cards of the given set have been added; uses local card count for page #'s
#################################################################################################################
require 'open-uri'

module SetPriceScraper
  include CardSets

  def self.get_set_prices(set_code, card_finish = 'regular')
    @set_name = AllEditionsStandardCodes.invert[set_code.upcase]

    display_errors('Invalid Set Code', card_finish) if @set_name.nil?

    return nil if card_finish == 'foil' && (!set_has_foils?(@set_name) || set_code.match?(/EXP|MS2|MS3|Vault/i))

    @threads = []
    @cards = {}

    @card_set_names = Card.where(edition: @set_name).pluck(:name)
    @card_set_names.each { | name | @cards[I18n.transliterate(name)] = ['N/A', 'N/A', 'N/A'] }

    get_mtgoldfish_set_prices(set_code.upcase, card_finish)
    get_card_kingdom_set_prices(card_finish)
    get_tcg_player_set_prices() unless card_finish.match?(/foil/i)

    @threads.each(&:join)

    save_prices(card_finish)
  end

  class << self
    private

      CK_EXCEPTIONS = {
        'Revised' => '3rd-edition',
        'Fourth Edition' => '4th-edition',
        'Fifth Edition' => '5th-edition',
        'Sixth Edition' => '6th-edition',
        'Seventh Edition' => '7th-edition',
        'Eighth Edition' => '8th-edition',
        'Ninth Edition' => '9th-edition',
        'Tenth Edition' => '10th-edition',
        'Ravnica City of Guilds' => 'ravnica',
        'Time Spiral Timeshifted' => 'timeshifted'
      }

      TCG_EXCEPTIONS = { 
        'Sixth Edition' => 'classic-sixth-edition', 'Seventh Edition' => '7th-edition', 'Eighth Edition' => '8th-edition', 'Ninth Edition' => '9th-edition',
        'Tenth Edition' => '10th-edition', 'Time Spiral Timeshifted' => 'timeshifted', 'Amonkhet Invocations' => 'masterpiece-series-amonkhet-invocations',
        'Kaladesh Inventions' => 'masterpiece-series-kaladesh-inventions', 'Ultimate Box Topper' => 'ultimate-masters-box-toppers'
      }

      #returns whether or not a set can have foils.
      #only check vintage cards; Urza's Legacy (2/15/99) and onwards have foils
      def set_has_foils?(set_name)
        return true unless CardSets::VintageEditions.include?(set_name)

        foil_date = Date.parse('1999-02-15')
        set       = Edition.find_by(name: set_name)

        Date.parse(set.release_date) >= foil_date && !set_name.match?(/Sixth|Portal/)
      end

    
      #set for mtgoldfish is actually the set code for full sets
      def get_mtgoldfish_set_prices(set_code, card_finish)
        #filter all alt set codes that are two letters in mtgoldfish instead of 3
        set_code = CardSets::VintageEditions[@set_name] || { "PUMA" => "PRM-UMA" }[set_code] || set_code
          
        set_code += '_F' if card_finish.match?(/foil/i) || set_code.match?(/MS2|MS3|EXP/)

        url = "https://www.mtggoldfish.com/index/#{set_code}#paper"

        #MTGoldFish loads its online prices before refreshing with its paper prices..
        #so it's necessary to wait on the thread so the page can provide the correct data
        card_rows = Thread.new do 
          page = Thread.new { URI.open(url) }.value
          Nokogiri::HTML(page)
        end.value.css('tbody tr')

        card_rows.each do | card_row |
          name  = card_row.css('td a').text
          price = card_row.css('td.text-right').text.match(/\d+\,*\d*\.\d+/)[0].delete(',')

          if @cards[name].nil?
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

      def get_card_kingdom_set_prices(card_finish)        
        set = @set_name.match?(/Magic 201[0-5]/) ? "#{@set_name.match(/\d+/)}-core-set" : @set_name.delete("':")
        set = CK_EXCEPTIONS[set] if CK_EXCEPTIONS.include?(set)
        set = set.gsub(' ', '-').downcase
          
        if set.match?(/expeditions|inventions|invocations/)
          set = "masterpiece-series-#{set.split('-')[-1]}"
        elsif card_finish.match?(/foil/i)
          set += '/foils'
        end
        
        total_pages = @cards.size.fdiv(60).ceil

        (1..total_pages).each do | idx |
          @threads << Thread.new do 
            url = "https://www.cardkingdom.com/mtg/#{set}?filter%5Bipp%5D=60&page=#{idx}"
            card_divs = Nokogiri::HTML(URI.open(url)).css('div.productItemWrapper.productCardWrapper')

            card_divs.each do | card_div | 
              name = card_div.css('span a').text.sub("(Oversized Foil)",'').sub(/\((Foil|HOU|AKH|KLD|AER|OGW.+|BFZ.+)\)/,'').strip
              price = card_div.css('.itemAddToCart.NM').text.match(/\d+\.\d+/)[0]

              unless @cards[name]
                puts "Failed to get price for #{name} on cardkingdom"
                next
              end
              
              @cards[name][1] = price
            end
          end
        end
      end

      #tcg player does 7th edition, 8th edition etc but fourth fifth sixth edition
      def get_tcg_player_set_prices        
        set = TCG_EXCEPTIONS[@set_name] || @set_name.gsub(' ', '-').downcase.delete(':')
        set += @set_name.match(/magic 201[0-5]/) ? "-m#{set.match(/\d{2}$/)}" : @set_name.match?(/Alpha|Beta|Unl|^Rev/) ? '-edition' : ''
        
        url = "https://shop.tcgplayer.com/price-guide/magic/#{set}"

        card_rows = Nokogiri::HTML(URI.open(url)).css('tbody tr')

        card_rows.each do | card_row | 
          name = I18n.transliterate(card_row.css('div.productDetail a').text)
          
          unless @cards[name]
            puts "Failed to get price for #{name} on tcgplayer"
            next
          end

          price = card_row.css('td.marketPrice').text.match(/\d+\,*\d*\.\d+/).to_s.delete(',')
          
          #newly-released sets on TCG will have a lot of missing prices
          if price.empty? 
            price = 'Pricing Not Yet Available'
          end

          @cards[name][2] = price
        end
      end

      def save_prices(card_finish)
        edition = @set_name

        Card.where(edition: edition).find_in_batches(batch_size: 150) do | cards |
          Card.transaction do
            cards.each do | card |
              prices = @cards[card.name] || @cards[I18n.transliterate(card.name)]

              price_column = card_finish.match?(/foil/i) ? :foil_prices : :prices

              card.update(price_column => prices) unless prices.nil? || prices.all?('N/A')
            end
          end
        end
      end

      def display_errors(error, card_finish)
        if error.match?('Not Found')
          puts 'Page was not found; the site may currently be down.'
          return nil
        elsif error == 'Invalid Set Code'
          puts "Whoops! That doesn't seem to be a valid set code" 
          puts "if you know the name of the set you're trying input, type it in and we'll try again!"
          puts "Do you know the name of the set you're trying to scrape? y/n"

          input = gets.strip.downcase

          if input.match?(/^y/i)
            lowercase_set_names = AllEditionsStandardCodes.map { | set_name, set_code | [ set_name.downcase, set_code ] }.to_h

            puts "Enter the set name (case insensitive):"
            
            set_name = gets.strip.downcase
            
            set_code = lowercase_set_names[set_name]

            if set_code
              SetPriceScraper.get_set_prices(set_code, card_finish)
            else
              puts "Sorry, that doesn't appear to be a valid set name!"
              return nil
            end
          else
            puts "Goodbye!"
          end
        end
      end

    end
end