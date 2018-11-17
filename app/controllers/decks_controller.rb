class DecksController < ApplicationController
  include DeckHandStats

  def show
    @deck = Deck.find(params[:id])
    @shuffled_deck_cards = shuffled_deck(@deck)
    @sample_hand = sample_hand(@shuffled_deck_cards)
    @next_eight_cards = next_eight_cards(@shuffled_deck_cards)
    @stats_hash ||= hand_stats(@sample_hand)
  end

  def index
    @decks = Deck.all
  end

end