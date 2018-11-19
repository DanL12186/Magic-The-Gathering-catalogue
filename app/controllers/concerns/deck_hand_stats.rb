module DeckHandStats
 
  def shuffled_deck(cards)
    cards.shuffle
  end

  def sample_hand(deck, n=7)
    deck.first(n)
  end

  def next_eight_cards(deck)
    deck[7..-1].first(8)
  end

  def hand_stats(hand)
    
    classifications = { 
      'lands' => 0,
      'nonbasic_lands' => 0,
      'creatures' => 0, 
      'spells' => 0,
      'artifacts' => 0, 
      'small_creatures' => 0,
      'medium_creatures' => 0,
      'large_creatures' => 0
    }
    
    hand.each do | card | 
      classifications['spells'] += 1 if card.card_type.match?(/sorcery|instant/i)
      classifications['artifacts'] += 1 if card.card_type == 'Artifact'

      if card.card_type == 'Land'
        classifications['lands'] += 1
        classifications['nonbasic_lands'] += 1 if card.subtypes.include?('Nonbasic Land')
      end

      if card.card_type.match?('Creature')
        classifications['creatures'] += 1 
        if card.power.between?(0,2)
          classifications['small_creatures'] += 1 
        elsif card.power.between?(3,4)
          classifications['medium_creatures'] += 1
        else
          classifications['large_creatures'] += 1 if card.power >= 5
        end
      end
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
   
    #parens around key, value are necessary with index on a hash
    hand_freqs.each.with_index(1) do | (card, hand_count), idx | 
      total_and_target_arrays[idx] = [ deck_freqs[card], hand_count ]
    end
    total_and_target_arrays
  end

  #Later make a function that counts the number of copies of each card in your hand, and the num copies in....
  #your deck (this should be predetermined in a hash). Return a hash with keys (names of cards) pointing to ...
  #an array with [copies_in_deck, copies_in_hand], and finally one last key which is just [deck_size - 7, 0] to...
  #represent the remaining cards in the deck.
end