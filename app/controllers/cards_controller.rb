class CardsController < ApplicationController
  include Cards
  include CardPriceUpdate
  include CardHelper

  def show
    @card = params[:id].match?(/\d/) ? Card.find(params[:id]) : Card.find_by_name(params[:id])
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

  def card_names
    names = Card.pluck(:name)
    render json: names
  end

  def index
    search_result = Card.search(params[:search])
    if search_result.class == String
      redirect_to card_path(search_result)
    else
      @matches, @partial_matches = search_result
    end
  end

  def filter_search
    filters = params.select { | key, value | ["rarity", "reserved", "card_type", "color", "edition", "converted_mana_cost", "name"].include?(key) && !value.empty? }.permit!

    @results = filters.empty? ? nil : Card.where(filters)

    render json: @results
  end

end