module DeckHandStats
 
  def shuffled_deck(deck)
    @deck.cards.shuffle
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

end