require 'set_price_scraper.rb'

class CardsController < ApplicationController
  include CardSets
  include CardHelper
  include Pagy::Backend

  def show
    @card = Card.find_by(edition: params[:edition], name: params[:name])

    if @card.nil?
      render_404
    elsif @card.layout == 'transform'
      @flip = Card.find_by(multiverse_id: @card.flip_card_multiverse_id)
      redirect_if_not_face_card
    end
  end

  #all unique names as JSON
  def card_names
    render json: Card.all_card_names_json
  end

  def card_names_with_editions
    render json: Card.all_card_and_edition_names_json
  end

  #only called if card hasn't been updated in > 24h
  def update_prices
    card = Card.find(params[:id])
    flip = Card.find_by(multiverse_id: card.flip_card_multiverse_id) if card.flip_card_multiverse_id
    
    #updated_at prevents repeated views from triggering updates after a necessary update was performed but no prices changed
    #check needs_updating? again so backclicks don't cause a retrigger
    if needs_updating?(card.updated_at, card.prices)
      prices = CardPriceScraper.get_card_prices(card.name, card.edition)

      card.update(prices: prices, updated_at: Time.now)
      flip.update(prices: prices, updated_at: Time.now) if flip
    end

    render json: card.prices
  end

  def search_results
    search_result = Card.search(params[:search])
    if search_result.is_a?(Hash)
      redirect_to card_path(search_result[:edition], search_result[:name])
    else
      @matches, @partial_matches = search_result
    end
  end

  def color
    @pagy, @cards = pagy(Card.where(color: params[:color], reprint: false).order(:name), items: 100)
  end

  def edition
    if AllEditionsStandardCodes[params[:edition]]
      @pagy, @cards = pagy(Card.where(edition: params[:edition]).order(:multiverse_id), items: 100)
    else
      render_404
    end
  end

  #only display original prints, ignoring reprints of that artist's work
  def artist
    @cards = Card.where(artist: params[:artist]).order(:multiverse_id, :color).uniq(&:name)
  end

  def reserved_list
    @pagy, @cards = pagy(Card.where(reserved: true, reprint: false).order(:multiverse_id), items: 50)
  end

  def filter_search
    results = CardSerializer.new(get_filter_search_results).serializable_hash
    
    render json: JSON.generate(results[:data])
  end

  private

    #Returns search results for Find Cards By Properties page.
    #required_attributes are required for the page to display and for sort buttons to work; filters are the user's selection of options.
    def get_filter_search_results
      required_attributes = [:rarity, :edition, :converted_mana_cost, :prices, :card_type, :color, :name, :hi_res_img, :multiverse_id]
      filter_options = Card.attribute_names
      
      filters = params.select { | key, value | filter_options.include?(key) && value.presence }.permit!
      
      #do not exclude reprints if a particular edition/set is selected
      filters.delete(:reprint) if filters[:edition]

      min_filters = filters[:edition] ? 1 : 2

      Card.select(filters.keys + required_attributes).where(filters).limit(1200) unless filters.keys.size < min_filters
    end

    def redirect_if_not_face_card
      redirect_to card_path(@flip.edition, @flip.name) if @card.card_number&.end_with?('b')
    end

end