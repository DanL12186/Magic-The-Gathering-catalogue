class DecksController < ApplicationController

  def show
    @deck = Deck.find(params[:id])
    @deck_cards = @deck.cards.shuffle
  end

  def index
    @decks = Deck.all
  end

end