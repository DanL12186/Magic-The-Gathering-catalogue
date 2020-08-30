module DeckHelper
  
  def generate_mana_curve_data(deck)
    frequencies = {}

    mana_costs = deck.map(&:converted_mana_cost).compact

    (0..mana_costs.max).each { | cost | frequencies[cost] = mana_costs.count(cost) }

    #map mana cost frequencies into an { x-axis : X, y-axis : Y } format
    graph_data = frequencies.map { | key, value | { 'x' => key, 'y' => value } }

    graph_data.to_json
  end

  def shuffled_deck(deck)
    cards = []

    deck.decks_cards.includes(:card).each do | deck_card | 
      card = deck_card.card
      deck_card.copies.times { cards << card } 
    end
    cards.shuffle
  end

  def draw_hand(deck, n=7)
    deck.first(n).sort_by(&:card_type)
  end

  #rotates each card by two degrees times its distance from the center (7 cards)
  def set_rotation_angle(idx)
    angle = (2 * idx) - 6
    "transform: rotate(#{angle}deg)"
  end

  def next_eight_cards(deck)
    deck[7..-1].first(8)
  end

  #CardKingdom sells all cards for a minimum of $0.25 which can inflate the reported value
  #return TCG Player price if CK price is $0.25.
  #return MTGFish Price if CK price is N/A
  def determine_appropriate_price(prices)
    return 0 if prices.empty?

    prices.map!(&:to_f)

    mtg_fish, card_kingdom, tcg_player = prices

    return card_kingdom unless card_kingdom <= 0.25
    return tcg_player unless tcg_player.zero?
    mtg_fish
  end

  def calculate_deck_value(cards)
    values = cards.map(&:prices) 

    total_value = values.map { | prices | determine_appropriate_price(prices) }.sum.round(4)
    
    number_to_currency(total_value)
  end

  def sort_by_number_and_name_desc(cards, deck_frequencies)
    cards.uniq(&:name).sort_by { | card | [ -@deck_frequencies[card.name], card.name ] }
  end

  #return the id of the exact match if user specifies edition, otherwise find cheapest version's id
  def find_specific_or_cheapest_card_variant_id(name, edition = nil)
    return Card.find_by(name: name, edition: edition).id unless edition.nil?
    return Card.find_by(name: name).id if ApplicationHelper::LANDS.include?(name)

    Card.select(:id, :prices, :name)
        .where(name: name)
        .reject { | card | card.prices[1] == "N/A" }
        .min_by { | card | card.prices[1].to_i }
        &.id
  end
end