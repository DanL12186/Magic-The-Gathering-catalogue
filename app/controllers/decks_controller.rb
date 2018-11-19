class DecksController < ApplicationController
  include DeckHandStats

  def show
    @deck = Deck.find(params[:id])
    @shuffled_deck_cards = shuffled_deck(@deck.cards)
    @sample_hand = sample_hand(@shuffled_deck_cards)
    @next_eight_cards = next_eight_cards(@shuffled_deck_cards)
    @stats_hash = hand_stats(@sample_hand)

    @hand_frequencies = card_frequencies(@sample_hand)
    @deck_frequencies = card_frequencies(@shuffled_deck_cards)

    @multivar_args = multivar_geo_freq_args(@hand_frequencies, @deck_frequencies).values
  end

  def index
    @decks = Deck.all
  end

end