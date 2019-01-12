# require 'open-uri'
# require 'nokogiri'
# require 'mtg-sdk'
# require 'json'

# rare cards from homelands expansion
# set = 'hml'
# cards = MTG::Card.where(set: set).where(rarity: "Rare").all
# cards.each { | card | card.representable_attrs = nil; card.rulings = nil }
# cards.map! { | card | JSON.parse(card.serialize) } #easier view... 

# cards.select { | card | card.rarity == "Rare" }.each do | card | 
#   Card.new(name: card.name, rarity: card.rarity, subtypes: card.subtypes || [], card_type: card.types, power: card.power.try(:to_i), artist: card.artist, edition: "Homelands", toughness: card.toughness.try(:to_i), flavor_text: card.flavor, mana: card.mana_cost.gsub(/\W/,'').split('').map { | x | @mana_abbrev[x] || x }, multiverse_id: card.multiverse_id, reserved: card.reserved) if card.name.match?("Sengir")
# end

# or if a ruby obj

# Card.new(name: card['name'], rarity: card['rarity'], subtypes: card['subtypes'], card_type: card['types'][0], power: card['power'] ? card['power'][0].to_i : nil, artist: card['artist'], edition: card['setName'], toughness: card['toughness'] ? card['toughness'][0].to_i : nil, flavor_text: card['flavor'])

# get other edition printings from MTG SDK after loading card set
# def get_editions(cards)
#   cards.each do | card_hash |
#     card = Card.find_by_name(card_hash["name"])
#     next unless card
#     other_editions = card_hash["printings"].reject { | ed | ed == card_hash['set'] }
#     card.update(other_editions:  other_editions)
#   end
# end

# #scryfall updating: 
# @url = "https://api.scryfall.com/cards/search?q=set:leg"#+named=mox-diamond"
# @set = JSON.parse(Nokogiri::HTML(open(@url).read))

# #each page is 175 cards; loop cards/175 times

# def update_set(set)
#   ((set['total_cards']/175) + 1).times do
#     card_set = set['data']

#     card_set.each do | obj | 
#       legalities = obj['legalities'].transform_values { | value | value == 'legal' }
#       legendary = obj['type_line'].include?("Legendary")
#       types = obj['type_line'].sub('Legendary ','').split
#       types.delete('—')
#       type = types.shift
#       subtypes = types.size > 0 ? types : []
#       subtypes << 'Nonbasic Land' if type == 'Land' && !['Plains', 'Island', 'Swamp', 'Mountain', 'Forest'].include?(obj['name'])
#       card = Card.find { | card | I18n.transliterate(card.name) == I18n.transliterate(obj['name']) && obj['set_name'].match?(/#{card.edition}/i) }
#       card.update(:hi_res_img => obj['image_uris']['large'].sub(/\?\d+/,''), :cropped_img => obj['image_uris']['art_crop'], :reserved => obj['reserved'], :year => obj['released_at'][0..3], :multiverse_id => obj['multiverse_ids'][0], :rarity => obj['rarity'].capitalize, legendary: legendary, subtypes: subtypes, legalities: legalities, card_type: type, layout: obj['layout']) if card
#     end

#     if set['next_page'].nil?
#       puts "Finished." 
#       break
#     end

#     @url = set['next_page']

#     puts ''
#     puts "Loading next page..."
#     puts ''

#     set = JSON.parse(Nokogiri::HTML(open(@url).read))
#   end
# end

# # scryfall creating:
# @mana_abbrev = {
#   "R" => "Red",
#   "G" => "Green",
#   "U" => "Blue", 
#   "B" => "Black",
#   "W" => "White"
# }

# @url = "https://api.scryfall.com/cards/search?q=set:atq"
# @set = JSON.parse(Nokogiri::HTML(open(@url).read))

# # each page is 175 cards; loop cards/175 times
# def create_set(set)
#   ((set['total_cards']/175).ceil + 1).times do
#     card_set = set['data']
    
#     card_set.each do | obj |
#       create_card(obj['multiverse_ids'][0])
#     end

#     if set['next_page'].nil?
#       puts "Finished." 
#       break
#     end

#     @url = set['next_page']

#     puts ''
#     puts "Loading next page..."
#     puts ''
    
#     set = JSON.parse(Nokogiri::HTML(open(@url).read))
#   end
# end

# def get_mana_cost(str)
#   str.delete('{}').chars.map { | char | @mana_abbrev[char] || char }
# end

# def legendary?(str)
#   str.include?("Legendary")
# end

# def get_legalities(legality_hash)
#   legality_hash.transform_values { | value | value == 'legal' }
# end

# def format_edition(edition)
#   return edition.split.first if edition.match?(/Revised|Unlimited/)
#   return edition.split.last if edition.match?(/Beta|Alpha/)
#   edition
# end

# def get_card_types(str)
#   types = str.sub('Legendary ', '').split
#   types.delete('—')
#   types
# end

# def get_flavor_text(str)
#   return str.gsub("â", "—") if str
#   nil
# end

# # # #single card
# def create_card(id)
#   @url = "https://api.scryfall.com/cards/multiverse/#{id}"
#   obj = JSON.parse(Nokogiri::HTML(open(@url).read))

#   if obj['layout'] == 'transform'
#     create_transform_cards(obj)
#     return
#   end

#   legendary = legendary?(obj['type_line'])
#   subtypes = get_card_types(obj['type_line'])
#   type = subtypes.shift
#   edition = format_edition(obj['set_name'])
#   #for planeswalkers
#   loyalty = obj['loyalty']&.to_i
# #  changing json format from { 'vintage' => 'legal' } to { 'vintage' => true }
#   legalities = get_legalities(obj['legalities'])

#   mana = get_mana_cost(obj['mana_cost'])

#   subtypes << 'Nonbasic Land' if type == 'Land' && !['Plains', 'Island', 'Swamp', 'Mountain', 'Forest'].include?(obj['name'])

#   Card.create(name: obj['name'], legendary: legendary, legalities: legalities, edition: edition, hi_res_img: obj['image_uris']['large'].sub(/\?\d+/,''), :cropped_img => obj['image_uris']['art_crop'].sub(/\?\d+/,''), :reserved => obj['reserved'], :year => obj['released_at'][0..3], :multiverse_id => obj['multiverse_ids'][0], :rarity => obj['rarity'].capitalize, power: obj['power'].try(:to_i), artist: obj['artist'], toughness: obj['toughness'].try(:to_i), mana: mana, card_type: type, subtypes: subtypes, flavor_text: get_flavor_text(obj['flavor_text']), layout: obj['layout'], frame: obj['frame'].to_i, loyalty: loyalty )
# end

# def create_transform_cards(card_hash)
#   card_face_specific_data, card_back_specific_data = card_hash['card_faces']
#   face_id, back_id = card_hash['multiverse_ids']
#   legalities = get_legalities(card_hash['legalities'])
#   reserved = card_hash['reserved']
#   edition = format_edition(card_hash['set_name'])
#   rarity = card_hash['rarity'].capitalize
#   layout = 'transform'
#   frame = card_hash['frame'].to_i
#   year = card_hash['released_at'][0..3]

#   #card_face attributes
#   face_name = card_face_specific_data['name']
#   face_legendary = legendary?(card_face_specific_data['type_line'])
#   face_hi_res = card_face_specific_data['image_uris']['large'].sub(/\?\d+/,'')
#   face_crop = card_face_specific_data['image_uris']['art_crop'].sub(/\?\d+/,'')
#   face_power = card_face_specific_data['power']&.to_i
#   face_toughness = card_face_specific_data['toughness']&.to_i
#   face_artist = card_face_specific_data['artist']
#   face_mana = get_mana_cost(card_face_specific_data['mana_cost'])
#   face_subtypes = get_card_types(card_face_specific_data['type_line'])
#   face_type = face_subtypes.shift
#   face_flavor = get_flavor_text(card_face_specific_data['flavor_text'])
#   face_twin = back_id
#   face_loyalty = card_face_specific_data['loyalty']&.to_i
  
#   face = Card.new(name: face_name, edition: edition, legendary: face_legendary, multiverse_id: face_id, hi_res_img: face_hi_res, cropped_img: face_crop, power: face_power, toughness: face_toughness, artist: face_artist, mana: face_mana, card_type: face_type, subtypes: face_subtypes, flavor_text: face_flavor, flip_card_multiverse_id: face_twin, loyalty: face_loyalty)

#   #card_back attributes
#   back_name = card_back_specific_data['name']
#   back_legendary = legendary?(card_back_specific_data['type_line'])
#   back_hi_res = card_back_specific_data['image_uris']['large'].sub(/\?\d+/,'')
#   back_crop = card_back_specific_data['image_uris']['art_crop'].sub(/\?\d+/,'')
#   back_power = card_back_specific_data['power']&.to_i
#   back_toughness = card_back_specific_data['toughness']&.to_i
#   back_artist = card_back_specific_data['artist']
#   back_subtypes = get_card_types(card_back_specific_data['type_line'])
#   back_type = back_subtypes.shift
#   back_flavor = get_flavor_text(card_back_specific_data['flavor_text'])
#   back_twin = face_id
#   back_loyalty = card_back_specific_data['loyalty']&.to_i

#   back = Card.new(name: back_name, edition: edition, legendary: back_legendary, multiverse_id: back_id, hi_res_img: back_hi_res, cropped_img: back_crop, power: back_power, toughness: back_toughness, artist: back_artist, mana: nil, card_type: back_type, subtypes: back_subtypes, flavor_text: back_flavor, flip_card_multiverse_id: back_twin, loyalty: back_loyalty)

#   [face, back].each do | card | 
#     card.legalities = legalities 
#     card.layout = layout
#     card.year = year
#     card.reserved = reserved
#     card.rarity = rarity
#     card.frame = frame
    
#     card.save
#   end  
# end

# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# # Examples:

# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)

# Card.create(name: "Mountain", artist: "John Avon", card_type: "Land", edition: "Mirage")
# Card.create(name: "Plains", artist: "Tom Wänerstrand", card_type: "Land", edition: "Mirage")
# Card.create(name: "Swamp", artist: "Bob Eggleton", card_type: "Land", edition: "Mirage")
# Card.create(name: "Forest", artist: "Tony Roberts", card_type: "Land", edition: "Mirage")
# Card.create(name: "Island", artist: "Douglas Shuler", card_type: "Land", edition: "Mirage")