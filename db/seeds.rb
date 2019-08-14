###Card-building Tools###

require 'open-uri'
require 'mtg_sdk'
include CardSets

SET_CODES_IN_CHRONOLOGICAL_ORDER = AllEditionsStandardCodes.invert.map.with_index { | (set_code, _), idx | [set_code, idx] }.to_h

# #get other edition printings from MTG SDK after loading card set
# #set code, e.g. 'mir', 'hml', 'all', 'lea'
def get_editions(set_code)
  set_code.upcase!
  
  set_name = AllEditionsStandardCodes.invert[set_code]
  
  sdk_cards = MTG::Card.where(set: set_code).all
  sdk_cards.map! { | card | JSON.parse(card.serialize) }
  
  #find in batches of 100 and only commit once per batch
  Card.where(edition: set_name).find_in_batches(batch_size: 200) do | db_cards | 
    Card.transaction do
      db_cards.each do | db_card |
        sdk_card = sdk_cards.find { | card | card['name'] == db_card.name }
        next unless sdk_card && !sdk_card['supertypes'].include?('Basic')
      
        other_editions = sdk_card["printings"].reject  { |  ed  | !SET_CODES_IN_CHRONOLOGICAL_ORDER[ed] || ed == set_code }
                                              .sort_by { | code | SET_CODES_IN_CHRONOLOGICAL_ORDER[code] }
        
        db_card.update(other_editions: other_editions) unless other_editions.empty?
      end
    end
  end
end

# # Scryfall updating: each page is 175 cards;
def update_set(set_code)
  url = "https://api.scryfall.com/cards/search?q=set:#{set_code}"
  set = JSON.parse(open(url).read)
  page_count = set['total_cards'].fdiv(175).ceil

  page_count.times do
    card_set = set['data']

    Card.transaction do
      card_set.each do | obj | 
        next if obj['layout'] == 'split'

        card = Card.find_by(multiverse_id: obj['multiverse_ids'][0])
        
        next unless card
        
        #allow transform card method to take over for flip cards
        if card.layout == 'transform'
          back = Card.find_by(multiverse_id: card.flip_card_multiverse_id)
          create_or_update_transform_card(obj, card, back)
          next
        end

        legendary = legendary?(obj['type_line'])
        legalities = obj['legalities']
        loyalty = obj['loyalty']&.to_i
        subtypes = get_card_types(obj['type_line'])
        type = subtypes.shift
        edition = format_edition(obj['set_name'])
        subtypes << 'Nonbasic Land' if type == 'Land' && !['Plains', 'Island', 'Swamp', 'Mountain', 'Forest'].include?(obj['name'])
        has_foil_version = obj['foil']
        has_nonfoil_version = obj['nonfoil']
        card_number = obj['collector_number']

        card.update(hi_res_img: obj['image_uris']['large'].sub(/\?\d+/,''), cropped_img: obj['image_uris']['art_crop'].sub(/\?\d+$/,''), reserved: obj['reserved'], 
        year: obj['released_at'][0..3], :multiverse_id => obj['multiverse_ids'][0], :rarity => obj['rarity'].capitalize, legendary: legendary, 
        subtypes: subtypes, legalities: legalities, frame: obj['frame'].to_i, loyalty: loyalty, card_type: type, layout: obj['layout'], 
        reprint: obj['reprint'], scryfall_uri: obj['scryfall_uri'], border_color: obj['border_color'], flavor_text: get_flavor_text(obj['flavor_text']), 
        oracle_text: obj['oracle_text'], foil_version_exists: has_foil_version, nonfoil_version_exists: has_nonfoil_version, card_number: card_number)
      end
    end

    if set['next_page'].nil?
      puts "Finished." 
      break
    end

    url = set['next_page']

    puts
    puts "Loading next page..."
    puts

    set = JSON.parse(open(url).read)
  end
end

# scryfall creating:
# each page is 175 cards; loop cards/175 times
def create_set(set_code)
  url = "https://api.scryfall.com/cards/search?q=set:#{set_code}"
  set = JSON.parse(open(url).read)
  page_count = set['total_cards'].fdiv(175).ceil
  
  page_count.times do
    card_set = set['data']
    
    Card.transaction do
      card_set.each do | obj |
        create_card(obj)
      end
    end

    if set['next_page'].nil?
      puts "Finished." 
      break
    end

    url = set['next_page']

    puts
    puts "Loading next page..."
    puts
    
    set = JSON.parse(open(url).read)
  end
  
  #expire card name caches after adding a new set so searches will display new cards
  #will only work if integrated into the app directly, and not run through Rails console
  Rails.cache.delete("all_unique_card_names#{Time.now.day}")
  Rails.cache.delete("all_card_names_with_editions#{Time.now.day}")
end

#/P accounts for cards with Phyrexian casting costs (e.g. {G/P} means 'either one green mana or 2 life')
def get_mana_cost(str)
  mana_abbrev = {
    "R" => "Red",
    "G" => "Green",
    "U" => "Blue", 
    "B" => "Black",
    "W" => "White"
  }

  str.delete('{}/P').chars.map { | char | mana_abbrev[char] || char }
end

def legendary?(str)
  str.include?("Legendary")
end

def format_edition(edition)
  return edition.split.first if edition.match?(/Revised|Unlimited/)
  return edition.split.last if edition.match?(/Beta|Alpha/)
  edition
end

def get_card_types(typeline)
  types = typeline.sub('Legendary ', '').split
  types.delete('—')
  types
end

def get_flavor_text(flavor)
  flavor.gsub("â", "—") if flavor
end

#remove non-colors from mana cost (e.g. 3, X colorless)
def get_colors(mana)
  mana.uniq.reject { | str | str.match?(/\d|X/) }
end

#creates a single card, either via the command-line where user specifies a multiverse ID, or when called by create_set, passed a hash.
def create_card(id_or_hash)
  if id_or_hash.is_a?(Integer)
    @url = "https://api.scryfall.com/cards/multiverse/#{id_or_hash}"
    card_hash = JSON.parse(Nokogiri::HTML(open(@url).read))
  else
    card_hash = id_or_hash
  end

  if card_hash['layout'] == 'transform'
    create_or_update_transform_card(card_hash)
    return
  end

  legendary = legendary?(card_hash['type_line'])
  subtypes = get_card_types(card_hash['type_line'])
  type = subtypes.shift
  edition = format_edition(card_hash['set_name'])
  loyalty = card_hash['loyalty']&.to_i
  legalities = card_hash['legalities']

  mana = get_mana_cost(card_hash['mana_cost'])
  colors = get_colors(mana)
  subtypes << 'Nonbasic Land' if type == 'Land' && !['Plains', 'Island', 'Swamp', 'Mountain', 'Forest'].include?(card_hash['name'])
  has_foil_version = card_hash['foil']
  has_nonfoil_version = card_hash['nonfoil']
  card_number = card_hash['collector_number']

  Card.create(name: card_hash['name'], legendary: legendary, legalities: legalities, edition: edition, colors: colors, hi_res_img: card_hash['image_uris']['large'].sub(/\?\d+/,''), :cropped_img => card_hash['image_uris']['art_crop'].sub(/\?\d+/,''), :reserved => card_hash['reserved'], :year => card_hash['released_at'][0..3], :multiverse_id => card_hash['multiverse_ids'][0], :rarity => card_hash['rarity'].capitalize, power: card_hash['power'].try(:to_i), artist: card_hash['artist'], toughness: card_hash['toughness'].try(:to_i), mana: mana, converted_mana_cost: card_hash['cmc'].to_i, card_type: type, subtypes: subtypes, flavor_text: get_flavor_text(card_hash['flavor_text']), layout: card_hash['layout'], frame: card_hash['frame'].to_i, loyalty: loyalty, reprint: card_hash['reprint'], scryfall_uri: card_hash['scryfall_uri'].sub!(/\?utm_source\=.+/,''), border_color: card_hash['border_color'], oracle_text: card_hash['oracle_text'], foil_version_exists: has_foil_version, nonfoil_version_exists: has_nonfoil_version, card_number: card_number )
end

#Either updates an existing transform card from existing data (accepts Ruby object), or creates one when called by create_set and passed a hash
def create_or_update_transform_card(card_hash, card_face_object = nil, card_back_object = nil)
  card_face_specific_data, card_back_specific_data = card_hash['card_faces']
  face_id, back_id = card_hash['multiverse_ids']
  has_nonfoil_version = card_hash['nonfoil']
  has_foil_version = card_hash['foil']
  scryfall_uri = card_hash['scryfall_uri']
  border_color = card_hash['border_color']
  card_number = card_hash['collector_number']
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
  face_oracle_text = card_face_specific_data['oracle_text']
  
  card_face_attributes = { name: face_name, edition: edition, legendary: face_legendary, multiverse_id: face_id, colors: face_colors, hi_res_img: face_hi_res, cropped_img: face_crop, power: face_power, toughness: face_toughness, artist: face_artist, mana: face_mana, card_type: face_type, subtypes: face_subtypes, flavor_text: face_flavor, flip_card_multiverse_id: face_twin, loyalty: face_loyalty, oracle_text: face_oracle_text, card_number: "#{card_number}a" }
  
  #if updating, assign attributes to passed-in Ruby object; otherwise create one via hash.
  if !!card_face_object 
    face = card_face_object
    face.assign_attributes(card_face_attributes)
  else
    face = Card.new(card_face_attributes)
  end

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
  back_oracle_text = card_back_specific_data['oracle_text']

  card_back_attributes = { name: back_name, edition: edition, legendary: back_legendary, multiverse_id: back_id, colors: back_colors, hi_res_img: back_hi_res, cropped_img: back_crop, power: back_power, toughness: back_toughness, artist: back_artist, mana: nil, card_type: back_type, subtypes: back_subtypes, flavor_text: back_flavor, flip_card_multiverse_id: back_twin, loyalty: back_loyalty, oracle_text: back_oracle_text, card_number: "#{card_number}b" }

  if !!card_back_object
    back = card_back_object
    back.assign_attributes(card_back_attributes)
  else
    back = Card.new(card_back_attributes)
  end

  [face, back].each do | card | 
    card.nonfoil_version_exists = has_nonfoil_version
    card.foil_version_exists = has_foil_version
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
