class CardsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:update_prices]

  include Cards
  include CardHelper

  def show
    @card = params[:id].match?(/\d/) ? Card.find(params[:id]) : Card.find_by_name(params[:id])
  end

  def filter
    @cards = Card.all.select { | card | card.attributes.values.any? { | value | value.to_s.delete('.') == params[:filter] } }.sort_by(&:name)
  end

  def card_names
    names = Card.pluck(:name)
    render json: names
  end

  def update_prices
    card = Card.find(params[:id])
    name = card.name
    set = card.edition
    
    #prevents a pack-back from triggering another update after a necessary update was performed
    if needs_updating?(card.updated_at, card.price)
      card.update(price: [ get_mtgoldfish_price(name, set), get_card_kingdom_price(name, set),  get_tcg_player_price(name, set)], updated_at: Time.now)
    end

    render json: card
  end

  def index
    search_result = Card.search(params[:search])
    if search_result.is_a?(String)
      redirect_to card_path(search_result)
    else
      @matches, @partial_matches = search_result
    end
  end

  def filter_search
    filters = params.select { | key, value | ['rarity', 'reserved', 'card_type', 'color', 'edition', 'converted_mana_cost', 'name'].include?(key) && !value.empty? }.permit!

    results = filters.empty? ? nil : Card.where(filters)

    render json: results
  end

end