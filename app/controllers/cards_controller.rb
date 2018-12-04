class CardsController < ApplicationController
  include Cards
  include CardPriceUpdate
  include CardHelper

  def show
    @card = Card.find(params[:id])
    name = @card.name
    set = @card.edition
    if price_empty_or_older_than_24_hours(@card.updated_at, @card.price)
      @card.update(price: [ get_mtgoldfish_price(name, set), get_card_kingdom_price(name, set),  get_tcg_player_price(name, set)])
      @card.update(updated_at: Time.now) if older_than_24_hours(@card.updated_at)
    end
  end

  def filter
    @cards = Card.all.select { | card | card.attributes.values.any? { | value | value.to_s.delete('.') == params[:filter] } }.sort_by(&:name)
  end

  def index
    @matches, @partial_matches = Card.search(params[:search])
  end

end
