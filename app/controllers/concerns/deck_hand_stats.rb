#These methods are here because they're needed by both the controller and the view

module DeckHandStats
  include DeckHelper

  def card_classifications(hand)
    
    classifications = { 
      'lands' => 0,
      'nonbasic lands' => 0,
      'creatures' => 0, 
      'spells' => 0,
      'artifacts' => 0, 
    }
    
    hand.each do | card | 
      classifications['spells'] += 1 if card.card_type.match?(/sorcery|instant/i)
      classifications['artifacts'] += 1 if card.card_type == 'Artifact'

      if card.card_type.match?(/Land|Basic/)
        classifications['lands'] += 1
        classifications['nonbasic lands'] += 1 if card.subtypes.include?('Nonbasic Land')
      end

      classifications['creatures'] += 1 if card.card_type.match?('Creature')
    end
    classifications
  end

  def card_frequencies(deck_or_hand)
    card_counts = {}
    cards = deck_or_hand.map(&:name)
    cards.uniq.each { | card | card_counts[card] = cards.count(card) }
    card_counts
  end
  
  def multivar_geo_freq_args(hand_freqs, deck_freqs)
    total_and_target_arrays = {}
   
    #parens around (key, value) are necessary with index on a hash
    hand_freqs.each.with_index(1) do | (card, hand_count), idx | 
      total_and_target_arrays[idx] = [ deck_freqs[card], hand_count ]
    end
    total_and_target_arrays
  end

  #Responsible for grabbing the user's input from the hand odds calculator form, for  multivariate_hypergeometric_distribution calculation.
  #Returns an array of arrays in the format [ [desired_cards_in_hand1, total_desired_cards_in_deck1] ..]
  def hand_and_deck_card_counts(params)
    total_vs_desired_card_counts = {}
    pertinent_keys = params.select { | param | param.match?("in_") }.keys
    len = pertinent_keys.size/2

    (0...len).each do | idx | 
      total_vs_desired_card_counts[idx] = [ params["in_deck_#{idx}"].to_i, params["in_hand_#{idx}"].to_i ]
    end

    deck_total = total_vs_desired_card_counts.map { | _, value | value.first }.sum
    hand_total = total_vs_desired_card_counts.map { | _, value | value.last }.sum
    #ensures there are fewer total target cards than drawn cards
    if hand_total < params[:cards_drawn].to_i
      total_vs_desired_card_counts[len] = [ params[:deck_size].to_i - deck_total, params[:cards_drawn].to_i - hand_total ]
    end
    
    total_vs_desired_card_counts
  end

end