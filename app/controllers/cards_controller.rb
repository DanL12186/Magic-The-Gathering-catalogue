class CardsController < ApplicationController

  def show
    @card = Card.find(params[:id])
  end

  def filter
    @cards = Card.all.select { | card | card.attributes.values.any? { | value | value == params[:filter] } }.sort_by(&:name)
  end

  def index
    @cards = Card.search(params[:search])
  end

end
