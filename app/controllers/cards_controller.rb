class CardsController < ApplicationController
  include Cards
  include ApplicationHelper

  def show
    @card = Card.find(params[:id])
    if price_empty_or_older_than_24_hours(@card.updated_at, @card.price)
      @card.update(price: [ get_mtgoldfish_price(@card.name, @card.edition), get_card_kingdom_price(@card.name, @card.edition) ])
    end
  end

  def filter
    @cards = Card.all.select { | card | card.attributes.values.any? { | value | value == params[:filter] } }.sort_by(&:name)
  end

  def index
    @cards = Card.search(params[:search])
  end

end
