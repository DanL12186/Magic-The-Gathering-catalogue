require 'open-uri'

module CardPriceScraper

  def self.get_card_prices(name, set)
    prices = []

    mtg_price, tcg_price = self.get_mtgoldfish_and_tcg_prices(name, set)
    ck_price = self.get_card_kingdom_price(name, set)

    [ mtg_price, ck_price, tcg_price ]
  end

  #URL generators, used both by the view and this scraper
  def self.mtgoldfish_url(card_name, card_set)
    set  = process_mtgfish_edition(card_set) + handle_foil(card_set)
    name = I18n.transliterate(card_name)
               .sub(/\([^\)]+\)$/) { | match | '-' + match }
               .delete(",.:;\"'/()!")
               .gsub(/\s+/, '+')
               .sub('+-','-')
    "https://www.mtggoldfish.com/price/#{set}/#{name}#paper"
  end

  def self.get_mtgoldfish_and_tcg_prices(card_name, card_set)
    url   = mtgoldfish_url(card_name, card_set)
    page  = scrape_page_if_exists(url)
    
    #get TCG player price from the same page, until (if) SSL issue can be resolved
    mtg_price = page.css('.price-box-price').children.last.try(:text) if page
    tcg_price = page.css('.btn-shop').text.gsub(/\n+/,' ').match(/Market Price\W+[^\s]+/).to_s.match(/\d.*/)&.to_s if page
    
    [ mtg_price, tcg_price ].map { | price | (price || 'N/A').delete(',') }
  end

  #card kingdom
  def self.card_kingdom_url(card_name, card_set)
    set  = process_card_kingdom_edition(card_set)
    name = I18n.transliterate(card_name.downcase).delete(",.:;'\"()/!").gsub(/ +/,'-') + handle_foil(card_set, 'ck')

    "https://www.cardkingdom.com/mtg/#{set}/#{name}"
  end

  def self.get_card_kingdom_price(card_name, card_set)
    url   = card_kingdom_url(card_name, card_set)
    page  = scrape_page_if_exists(url)
    price = page.css('span.stylePrice').first.text.delete('$').strip if page
    
    price || 'N/A'
  end

  #tcg player; still needed for URL generation in view
  def self.tcg_player_url(card_name, card_set)
    set  = process_tcg_player_edition(card_set)
    name = I18n.transliterate(card_name.downcase).delete(",.:;\"'/").gsub(/ +/, '-')

    "https://shop.tcgplayer.com/magic/#{set}/#{name}"
  end

  class << self
    private

      #scraping support methods
      def scrape_page_if_exists(url)
        Thread.new do
          begin
            Nokogiri::HTML(URI.open(url))
          rescue OpenURI::HTTPError => error
            raise error unless error.message.match?("Not Found")
          end
        end.value
      end

      def handle_foil(edition, site = 'mtg') #should pass card reference and use .has_foil_version
        if site == 'mtg'
          edition.match?(/Vault|Box Topper|Commander's Arsenal|Expeditions|Invocations|Inventions|Mythic Edition/) ? ':Foil' : ''
        elsif site == 'ck'
          edition == "Commander's Arsenal" ? '-foil' : ''
        end
      end

      #mtg goldfish
      def process_mtgfish_edition(edition)
        mtg_exceptions = { 'Alpha' => 'Limited Edition Alpha', 'Beta' => 'Limited Edition Beta', 'Revised' => 'Revised Edition', 
                           'Unlimited' => 'Unlimited Edition', 'Magic 2014' => 'Magic 2014 Core Set', 'Magic 2015' => 'Magic 2015 Core Set', 
                           'Commander 2013' => 'Commander 2013 Edition', 'Modern Masters 2017' => 'Modern Masters 2017 Edition', 
                           'Sixth Edition' => 'Classic Sixth Edition'
                         }

        set = mtg_exceptions[edition] || edition

        set.sub('Time Spiral ', '').sub('Mythic Edition', 'Masterpieces').gsub(' ', '+').delete("':")
      end

      def process_tcg_player_edition(edition)
        tcg_exceptions = { 
          'Sixth Edition' => 'classic-sixth-edition', 'Seventh Edition' => '7th-edition', 'Eighth Edition' => '8th-edition', 'Ninth Edition' => '9th-edition',
          'Tenth Edition' => '10th-edition', 'Time Spiral Timeshifted' => 'timeshifted', 'Amonkhet Invocations' => 'masterpiece-series-amonkhet-invocations', 'Ultimate Box Topper' => 'ultimate-masters-box-toppers'
        }
        set = tcg_exceptions[edition] || edition.gsub(' ', '-').downcase.delete(':')
        edition.match(/Magic 201[0-5]/) ? "#{set}-m#{set.match(/\d{2}$/)}" : edition.match?(/Alpha|Beta|Unl|^Rev/) ? "#{set}-edition" : set
      end

      #card kingdom
      def process_card_kingdom_edition(edition)
        ck_exceptions = { 
          'Fourth Edition' => '4th-edition', 'Fifth Edition' => '5th-edition', 'Sixth Edition' => '6th-edition', 'Seventh Edition' => '7th-edition',
          'Eighth Edition' => '8th-edition', 'Ninth Edition' => '9th-edition', 'Tenth Edition' => '10th-edition', 'Revised' => '3rd-edition', 
          'Ravnica: City of Guilds' => 'ravnica', 'Time Spiral Timeshifted' => 'timeshifted', 'Portal Second Age' => 'portal-ii', 'Portal Three Kingdoms' => 'portal-3k',
          'Ravnica Allegiance Mythic Edition' => 'masterpiece-series-mythic-edition'
        }
        set = ck_exceptions[edition] || edition.gsub(' ', '-').downcase.delete("':")
        set = set.match(/magic-201[0-5]/) ? "#{set.match(/\d+/)}-core-set" : set
      end

    end

end