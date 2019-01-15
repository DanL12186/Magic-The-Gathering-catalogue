class CardsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update_prices]

  include Cards
  include CardHelper

  def show
    @card = find_by_name_or_id(params[:id])
    if @card.layout == 'transform'
      @flip = Card.find_by(multiverse_id: @card.flip_card_multiverse_id)
    end
  end

  def card_names
    names = Card.where(reprint: false).pluck(:name)
    render json: names
  end

  def update_prices
    card = Card.find(params[:id])
    name = card.name
    set = card.edition
    
    #prevents a back-click from triggering another update after a necessary update was performed
    if needs_updating?(card.updated_at, card.price)
      card.update(price: [ get_mtgoldfish_price(name, set), get_card_kingdom_price(name, set),  get_tcg_player_price(name, set)], updated_at: Time.now)
    end

    render json: card
  end

  def search_results
    search_result = Card.search(params[:search])
    if search_result.is_a?(String)
      redirect_to card_path(search_result)
    else
      @matches, @partial_matches = search_result
    end
  end

  def color
    @cards = Card.where(color: params[:color], reprint: false).sort_by(&:name)
  end

  def filter_search
    filters = params.select { | key, value | ['rarity', 'reserved', 'reprint', 'legendary', 'card_type', 'color', 'edition', 'converted_mana_cost', 'name'].include?(key) && !value.empty? }.permit!
    results = filters.keys.size < 2 ? nil : Card.where(filters).limit(1200)
    
    render json: CardSerializer.new(results).serializable_hash[:data]
  end

  private

  def find_by_name_or_id(identifier)
    identifier.match?(/\d/) ? Card.find(identifier) : Card.find_by(name: identifier)
  end

end