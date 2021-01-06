class CollectionsController < ApplicationController
  before_action :build_collection, only: [:create]
  before_action :redirect_unless_logged_in, only: [:new]

  def new
    @collection = Collection.new
  end

  def create
    @collection.valid? ? (redirect_to collections_path) : (render :new)
  end

  def index
    @collections = current_user.collections
  end

  def show
    @collection = Collection.includes(:cards).find(params[:id])
  end

  private

    def build_collection
      card_list = params[:collections_cards][:list].split(/ \r\n/)
  
      @collection = Collection.new(name: collection_params[:name], user_id: current_user.id)
  
      return nil unless @collection.save
  
      @collections_cards = card_list.map do | card_string | 
        #split on 'x ' coming after digit(s), and ' - ', e.g.: '1x Dack Fayden - Conspiracy' -> ['1', 'Dack Fayden', 'Conspiracy']
        copies, name, edition = card_string.split(/(?<=\d)x | - /)
        
        card_id = Card.select(:id).find_by(name: name, edition: edition).id
        
        next if card_id.nil?
      
        { copies: copies.to_i, collection_id: @collection.id, card_id: card_id }
      end.compact
  
      CollectionsCard.transaction do
        CollectionsCard.create(@collections_cards)
      end
    end

    def collection_params
      params.require(:collection).permit(:name, :user_id)
    end
end
