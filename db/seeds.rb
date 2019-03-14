# require 'open-uri'
# require 'mtg_sdk'

# #get other edition printings from MTG SDK after loading card set
# #set code, e.g. 'mir', 'hml', 'all', 'lea'

def get_editions(set_code)
  set_codes_in_chronological_order = AllEditionsStandardCodes.invert.map.with_index { | (set_code, set_name), idx | [set_code, idx] }.to_h
  cards = MTG::Card.where(set: set_code).all
  
  cards.map! { | card | JSON.parse(card.serialize) }

  cards.each do | card_hash |
    card = Card.find_by(multiverse_id: card_hash["multiverseid"])
    next unless card && !card_hash['supertypes'].include?('Basic')
    other_editions = card_hash["printings"].reject { | ed | !set_codes_in_chronological_order[ed] || ed == set_code.upcase }.sort_by { | set_code | set_codes_in_chronological_order[set_code] }
    
    card.update(other_editions:  other_editions)
  end
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
      has_foil_version = obj['foil']
      has_nonfoil_version = obj['nonfoil']

      card = Card.find_by(multiverse_id: obj['multiverse_ids'][0])

      card.update(hi_res_img: obj['image_uris']['large'].sub(/\?\d+/,''), cropped_img: obj['image_uris']['art_crop'].sub(/\?\d+$/,''), reserved: obj['reserved'], 
      year: obj['released_at'][0..3], :multiverse_id => obj['multiverse_ids'][0], :rarity => obj['rarity'].capitalize, legendary: legendary, 
      subtypes: subtypes, legalities: legalities, frame: obj['frame'].to_i, loyalty: loyalty, card_type: type, layout: obj['layout'], 
      reprint: obj['reprint'], scryfall_uri: obj['scryfall_uri'], border_color: obj['border_color'], flavor_text: get_flavor_text(obj['flavor_text']), 
      oracle_text: obj['oracle_text'], foil_version_exists: has_foil_version, nonfoil_version_exists: has_nonfoil_version) if card
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

#/P accounts for cards with Phyrexian casting costs (e.g. {G/P} means 'either one green mana or 2 life')
def get_mana_cost(str)
  str.delete('{}/P').chars.map { | char | @mana_abbrev[char] || char }
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
  if id_or_obj.is_a?(Integer)
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
  loyalty = obj['loyalty']&.to_i
  legalities = obj['legalities']

  mana = get_mana_cost(obj['mana_cost'])
  colors = get_colors(mana)
  subtypes << 'Nonbasic Land' if type == 'Land' && !['Plains', 'Island', 'Swamp', 'Mountain', 'Forest'].include?(obj['name'])
  has_foil_version = obj['foil']
  has_nonfoil_version = obj['nonfoil']

  Card.create(name: obj['name'], legendary: legendary, legalities: legalities, edition: edition, colors: colors, hi_res_img: obj['image_uris']['large'].sub(/\?\d+/,''), :cropped_img => obj['image_uris']['art_crop'].sub(/\?\d+/,''), :reserved => obj['reserved'], :year => obj['released_at'][0..3], :multiverse_id => obj['multiverse_ids'][0], :rarity => obj['rarity'].capitalize, power: obj['power'].try(:to_i), artist: obj['artist'], toughness: obj['toughness'].try(:to_i), mana: mana, converted_mana_cost: obj['cmc'].to_i, card_type: type, subtypes: subtypes, flavor_text: get_flavor_text(obj['flavor_text']), layout: obj['layout'], frame: obj['frame'].to_i, loyalty: loyalty, reprint: obj['reprint'], scryfall_uri: obj['scryfall_uri'].sub!(/\?utm_source\=.+/,''), border_color: obj['border_color'], oracle_text: obj['oracle_text'], foil_version_exists: has_foil_version, nonfoil_version_exists: has_nonfoil_version )
end

def create_transform_cards(card_hash)
  card_face_specific_data, card_back_specific_data = card_hash['card_faces']
  face_id, back_id = card_hash['multiverse_ids']
  has_nonfoil_version = obj['nonfoil']
  has_foil_version = obj['foil']
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
  face_oracle_text = card_face_specific_data['oracle_text']
  
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
  back_oracle_text = card_back_specific_data['oracle_text']

  back = Card.new(name: back_name, edition: edition, legendary: back_legendary, multiverse_id: back_id, colors: back_colors, hi_res_img: back_hi_res, cropped_img: back_crop, power: back_power, toughness: back_toughness, artist: back_artist, mana: nil, card_type: back_type, subtypes: back_subtypes, flavor_text: back_flavor, flip_card_multiverse_id: back_twin, loyalty: back_loyalty, oracle_text: back_oracle_text)

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