# require 'open-uri'
# require 'nokogiri'
# require 'mtg_sdk'

# #get other edition printings from MTG SDK after loading card set
# #set code, e.g. 'mir', 'hml', 'all', 'lea'
def get_editions(set_code)
  cards = MTG::Card.where(set: set_code).all;
  cards.each { | card | card.representable_attrs = nil; card.legalities = nil; card.foreign_names = nil; card.rulings = nil }; nil
  cards.map! { | card | JSON.parse(card.serialize) } #easier view... 
  cards.each do | card_hash |
    card = Card.find_by(multiverse_id: card_hash["multiverseid"])
    next unless card && !card_hash['supertypes'].include?('Basic')
    other_editions = card_hash["printings"].reject { | ed | ed == card_hash['set'] }
    card.update(other_editions:  other_editions)
  end
end

EARLY_CORE_SETS = { 
  'Fourth Edition' => '4th-edition', 
  'Fifth Edition' => '5th-edition',
  'Sixth Edition' => '6th-edition', 
  'Seventh Edition' => '7th-edition' 
}

# # CardKingdom Set Scraping
def get_set_prices(set_code)
  @set_name = Editions.invert[set_code.upcase]

  @threads = []
  @cards = {}

  card_set_names = Card.where(edition: @set_name).map(&:name)
  card_set_names.each { | name |  @cards[I18n.transliterate(name)] = ['N/A', 'N/A', 'N/A'] }
  
  #won't get all prices unless all cards have been added; uses local card count for page #'s 
  def get_mtgoldfish_set_prices(set_code)
    set = set_code.upcase

    url = "https://www.mtggoldfish.com/index/#{set}#paper"

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
        next
      end
      @cards[name][0] = price if @cards[name]&.first == 'N/A'
    end
  end

  def get_card_kingdom_set_prices(set_code)
    set = @set_name.gsub(' ', '-').downcase
    set = EARLY_CORE_SETS[set.titleize] || set
    total_pages = @cards.size.fdiv(60).ceil

    (1..total_pages).each do | idx |
      @threads << Thread.new do 
        url = "https://www.cardkingdom.com/mtg/#{set}?filter%5Bipp%5D=60&page=#{idx}"
        card_divs = Nokogiri::HTML(open(url)).css('div.productItemWrapper.productCardWrapper')

        card_divs.each do | card_div | 
          name = card_div.css('span a').text
          price = card_div.css('.itemAddToCart.NM').text.match(/\d+\.\d+/)[0]

          if !@cards[name]
            puts [name, price, 'cardkingdom'].to_s if !@cards[name]
            next
          end
          
          @cards[name][1] = price
        end
      end
    end
  end

  #tcg player does 7th edition, 8th edition etc but fourth fifth sixth edition
  def get_tcg_player_set_prices(set_code)
    set = @set_name.gsub(' ', '-').downcase
    set = "classic-sixth-edition" if set == "sixth-edition"

    url = "https://shop.tcgplayer.com/price-guide/magic/#{set}"

    card_rows = Nokogiri::HTML(open(url)).css('tbody tr')

    card_rows.each do | card_row | 
      name = I18n.transliterate(card_row.css('div.productDetail a').text)
      price = card_row.css('td.marketPrice').text.match(/\d+\,*\d*\.\d+/)[0].delete(',')
      
      if !@cards[name]
        puts [name, price, 'tcgplayer'].to_s if !@cards[name]
        next
      end
      @cards[name][2] = price
    end
  end

  def save_prices(set_code)
    @cards.each do | name, prices |
      edition = @set_name
      #could probably save a lot of querying just by saving all the cards as objects to the @cards hash, updating and saving from there.
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
# # Scryfall updating: 
# # each page is 175 cards; loop cards/175 times
def update_set(set_code)
  url = "https://api.scryfall.com/cards/search?q=set:#{set_code}"
  set = JSON.parse(open(url).read)
  ((set['total_cards']/175) + 1).times do
    card_set = set['data']

    card_set.each do | obj | 
      legendary = legendary?(obj['type_line'])
      legalities = obj['legalities']
      legendary = obj['type_line'].include?("Legendary")
      loyalty = obj['loyalty']&.to_i
      subtypes = get_card_types(obj['type_line'])
      type = subtypes.shift
      edition = format_edition(obj['set_name'])
      subtypes << 'Nonbasic Land' if type == 'Land' && !['Plains', 'Island', 'Swamp', 'Mountain', 'Forest'].include?(obj['name'])

      card = Card.find_by(multiverse_id: obj['multiverse_ids'][0])
      card.update(:hi_res_img => obj['image_uris']['large'].sub(/\?\d+/,''), :cropped_img => obj['image_uris']['art_crop'], :reserved => obj['reserved'], :year => obj['released_at'][0..3], :multiverse_id => obj['multiverse_ids'][0], :rarity => obj['rarity'].capitalize, legendary: legendary, subtypes: subtypes, legalities: legalities, frame: obj['frame'].to_i, loyalty: loyalty, card_type: type, layout: obj['layout'], reprint: obj['reprint'], scryfall_uri: obj['scryfall_uri'], border_color: obj['border_color'], oracle_text: obj['oracle_text']) if card
    end

    if set['next_page'].nil?
      puts "Finished." 
      break
    end

    url = set['next_page']

    puts ''
    puts "Loading next page..."
    puts ''

    set = JSON.parse(open(url).read)
  end
end

# scryfall creating:
# each page is 175 cards; loop cards/175 times
def create_set(set_code)
  url = "https://api.scryfall.com/cards/search?q=set:#{set_code}"
  set = JSON.parse(open(url).read)
  ((set['total_cards']/175).ceil + 1).times do
    card_set = set['data']
    
    card_set.each do | obj |
      create_card(obj)
    end

    if set['next_page'].nil?
      puts "Finished." 
      break
    end

    url = set['next_page']

    puts ''
    puts "Loading next page..."
    puts ''
    
    set = JSON.parse(open(url).read)
  end
end

def get_mana_cost(str)
  str.delete('{}').chars.map { | char | @mana_abbrev[char] || char }
end

@mana_abbrev = {
  "R" => "Red",
  "G" => "Green",
  "U" => "Blue", 
  "B" => "Black",
  "W" => "White"
}

def legendary?(str)
  str.include?("Legendary")
end

def format_edition(edition)
  return edition.split.first if edition.match?(/Revised|Unlimited/)
  return edition.split.last if edition.match?(/Beta|Alpha/)
  edition
end

def get_card_types(str)
  types = str.sub('Legendary ', '').split
  types.delete('—')
  types
end

def get_flavor_text(str)
  return str.gsub("â", "—") if str
  nil
end

def get_colors(mana)
  mana.uniq.reject { | str | str.to_i > 0 || str == 'X' || str == '0' }
end

# # #single card
def create_card(id_or_obj)
  if id_or_obj.class == Integer
    @url = "https://api.scryfall.com/cards/multiverse/#{id_or_obj}"
    obj = JSON.parse(Nokogiri::HTML(open(@url).read))
  else
    obj = id_or_obj
  end
  if obj['layout'] == 'transform'
    create_transform_cards(obj)
    return
  end

  legendary = legendary?(obj['type_line'])
  subtypes = get_card_types(obj['type_line'])
  type = subtypes.shift
  edition = format_edition(obj['set_name'])
  #for planeswalkers
  loyalty = obj['loyalty']&.to_i
#  changing json format from { 'vintage' => 'legal' } to { 'vintage' => true }
  legalities = obj['legalities']

  mana = get_mana_cost(obj['mana_cost'])
  colors = get_colors(mana)
  subtypes << 'Nonbasic Land' if type == 'Land' && !['Plains', 'Island', 'Swamp', 'Mountain', 'Forest'].include?(obj['name'])

  Card.create(name: obj['name'], legendary: legendary, legalities: legalities, edition: edition, colors: colors, hi_res_img: obj['image_uris']['large'].sub(/\?\d+/,''), :cropped_img => obj['image_uris']['art_crop'].sub(/\?\d+/,''), :reserved => obj['reserved'], :year => obj['released_at'][0..3], :multiverse_id => obj['multiverse_ids'][0], :rarity => obj['rarity'].capitalize, power: obj['power'].try(:to_i), artist: obj['artist'], toughness: obj['toughness'].try(:to_i), mana: mana, converted_mana_cost: obj['cmc'].to_i, card_type: type, subtypes: subtypes, flavor_text: get_flavor_text(obj['flavor_text']), layout: obj['layout'], frame: obj['frame'].to_i, loyalty: loyalty, reprint: obj['reprint'], scryfall_uri: obj['scryfall_uri'].sub!(/\?utm_source\=.+/,''), border_color: obj['border_color'], oracle_text: obj['oracle_text'] )
end

def create_transform_cards(card_hash)
  card_face_specific_data, card_back_specific_data = card_hash['card_faces']
  face_id, back_id = card_hash['multiverse_ids']
  scryfall_uri = card_hash['scryfall_uri']
  border_color = card_hash['border_color']
  legalities = card_hash['legalities']
  reserved = card_hash['reserved']
  reprint = card_hash['reprint']
  edition = format_edition(card_hash['set_name'])
  rarity = card_hash['rarity'].capitalize
  layout = 'transform'
  frame = card_hash['frame'].to_i
  year = card_hash['released_at'][0..3]

  #card_face attributes
  face_name = card_face_specific_data['name']
  face_legendary = legendary?(card_face_specific_data['type_line'])
  face_hi_res = card_face_specific_data['image_uris']['large'].sub(/\?\d+/,'')
  face_crop = card_face_specific_data['image_uris']['art_crop'].sub(/\?\d+/,'')
  face_power = card_face_specific_data['power']&.to_i
  face_toughness = card_face_specific_data['toughness']&.to_i
  face_artist = card_face_specific_data['artist']
  face_mana = get_mana_cost(card_face_specific_data['mana_cost'])
  face_colors = get_colors(face_mana)
  face_subtypes = get_card_types(card_face_specific_data['type_line'])
  face_type = face_subtypes.shift
  face_flavor = get_flavor_text(card_face_specific_data['flavor_text'])
  face_twin = back_id
  face_loyalty = card_face_specific_data['loyalty']&.to_i
  face_oracle_text = card_face_spcific_data['oracle_text']
  
  face = Card.new(name: face_name, edition: edition, legendary: face_legendary, multiverse_id: face_id, colors: face_colors, hi_res_img: face_hi_res, cropped_img: face_crop, power: face_power, toughness: face_toughness, artist: face_artist, mana: face_mana, card_type: face_type, subtypes: face_subtypes, flavor_text: face_flavor, flip_card_multiverse_id: face_twin, loyalty: face_loyalty, oracle_text: face_oracle_text)

  #card_back attributes
  back_name = card_back_specific_data['name']
  back_legendary = legendary?(card_back_specific_data['type_line'])
  back_hi_res = card_back_specific_data['image_uris']['large'].sub(/\?\d+/,'')
  back_crop = card_back_specific_data['image_uris']['art_crop'].sub(/\?\d+/,'')
  back_power = card_back_specific_data['power']&.to_i
  back_toughness = card_back_specific_data['toughness']&.to_i
  back_artist = card_back_specific_data['artist']
  back_subtypes = get_card_types(card_back_specific_data['type_line'])
  back_type = back_subtypes.shift
  back_colors = []
  back_flavor = get_flavor_text(card_back_specific_data['flavor_text'])
  back_twin = face_id
  back_loyalty = card_back_specific_data['loyalty']&.to_i
  back_oracle_text = card_back_spcific_data['oracle_text']

  back = Card.new(name: back_name, edition: edition, legendary: back_legendary, multiverse_id: back_id, colors: back_colors, hi_res_img: back_hi_res, cropped_img: back_crop, power: back_power, toughness: back_toughness, artist: back_artist, mana: nil, card_type: back_type, subtypes: back_subtypes, flavor_text: back_flavor, flip_card_multiverse_id: back_twin, loyalty: back_loyalty, oracle_text: back_oracle_text)

  [face, back].each do | card | 
    card.scryfall_uri = scryfall_uri
    card.border_color = border_color
    card.legalities = legalities
    card.reserved = reserved
    card.reprint = reprint
    card.rarity = rarity
    card.layout = layout
    card.frame = frame
    card.year = year

    card.save
  end  
end

# # Examples:

# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)