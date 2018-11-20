class DecksController < ApplicationController
  include DeckHandStats

  def calculate_custom_hand_odds
    @deck_size = params[:deck_size].to_i
    @cards_drawn = params[:cards_drawn].to_i
    @multivar_args = get_param_stats(params).values
    @answer = multivariate_hypergeometric_distribution(@deck_size, @cards_drawn, *@multivar_args)

    render json: @answer, status: 201
  end

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