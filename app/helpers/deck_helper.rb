module DeckHelper
  def factorial(n)
    return n if n < 2

    (2..n).reduce(:*)
  end

  #      x!
  # ------------
  # (y! * (x-y)!)
  def binomial_coefficient(x, y)
    return 1 if x == y #seems to do the trick
    factorial(x).fdiv(factorial(y) * factorial(x-y))
  end

  #odds as a percent of getting EXACTLY target_num cards.
  def hypergeometric_distribution(copies, deck_size, target_num, cards_drawn)
    return 0 if target_num > copies
    
    top = binomial_coefficient(copies, target_num) * binomial_coefficient(deck_size - copies, cards_drawn - target_num)
    bottom = binomial_coefficient(deck_size, cards_drawn)

    (top.fdiv(bottom) * 100).round(4)
  end

  def chance_of_drawing_at_least_x_cards(copies, deck_size, target_num, cards_drawn)
    sum = 0

    (target_num..copies).each do | target |
      sum += hypergeometric_distribution(copies, deck_size, target, cards_drawn)
    end
    sum.round(4)
  end

#   def chance_of_drawing_at_least_x_cards(copies, deck_size, target_num, cards_drawn) #alternative to above
#     (target_num..copies).map { | target | hypergeometric_distribution(copies, deck_size, target, cards_drawn) }.sum.round(4)
#   end

  #odds of getting a specific hand as a percent.
  #doesn't work. might be wrong formula
  def multivariate_hypergeometric_distribution(deck_size, cards_drawn, *total_and_target_arrays)
    numerator = 1

    total_and_target_arrays.each do | arr |
      target_copies, target_num = arr

      numerator *= binomial_coefficient(target_copies, target_num)
    end

    denominator = binomial_coefficient(deck_size, cards_drawn)

    (100 * numerator.fdiv(denominator)).round(4)
  end

  def sample_hand(n = 7, deck)
    deck.shuffle.first(n)
  end

  def shuffle_deck(deck)
    deck.shuffle!
  end
end