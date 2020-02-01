module Probability

  def self.factorial(n)
    return 1 if n < 2

    (2..n).reduce(:*)
  end

  #      x!
  # ------------
  # (y! * (x-y)!)
  def self.binomial_coefficient(x, y)
    return 1 if x == y
    factorial(x).fdiv(factorial(y) * factorial(x-y))
  end

  #odds as a percent of getting EXACTLY target_num cards.
  def self.hypergeometric_distribution(copies, deck_size, target_num, cards_drawn)
    return 0 if target_num > copies
    
    top = binomial_coefficient(copies, target_num) * binomial_coefficient(deck_size - copies, cards_drawn - target_num)
    bottom = binomial_coefficient(deck_size, cards_drawn)

    (top.fdiv(bottom) * 100).round(4)
  end

#   def chance_of_drawing_at_least_x_cards(copies, deck_size, target_num, cards_drawn) #alternative to above
#     (target_num..copies).map { | target | hypergeometric_distribution(copies, deck_size, target, cards_drawn) }.sum.round(4)
#   end

  def self.chance_of_drawing_at_least_x_cards(copies, deck_size, target_num, cards_drawn)
    sum = 0

    (target_num..copies).each do | target |
      sum += hypergeometric_distribution(copies, deck_size, target, cards_drawn)
    end
    sum.round(4)
  end

  #odds of getting a specific hand as a percent.

  #Ex: 
  #You want 5 mana from a 71-card deck with 21 mana, plus 1 shivan dragon out of four in the deck: 
  ### multivariate_hypergeometric_distribution(71, 8, [21,5], [4,1], [46, 2])..
  #where [21, 5] is 5 needed lands out of 21 total, [4,1] is 1 needed shivan of 4 total, and [46, 2] is 2 "other" cards of 46 remaining cards in the deck.
  #if cards already total to 7 (or 8, if that's your hand size), a final entry in the form [x_remaining_cards, 0] is unnecessary.
  def self.multivariate_hypergeometric_distribution(deck_size, cards_drawn, *total_and_target_arrays)
    return 0 if total_and_target_arrays.map(&:last).sum > cards_drawn
    
    numerator = 1

    total_and_target_arrays.each do | arr |
      target_copies, target_num = arr

      numerator *= binomial_coefficient(target_copies, target_num)
    end

    denominator = binomial_coefficient(deck_size, cards_drawn)
    (100 * numerator.fdiv(denominator)).round(4)
  end
  
end