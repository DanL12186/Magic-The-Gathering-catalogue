class CollectionsController < ApplicationController
  before_action :build_collection, only: [:create]

  def new
    @collection = Collection.new
  end

  def create
    @collection.valid? ? (redirect_to collections_path) : (render :new)
  end

  def index
    @collections = Collection.where(user_id: current_user.id)
  end

  private

    def build_collection
      card_list = params[:collections_cards][:list].split(/ \r\n/)
  
      @collection = Collection.create(name: collection_params[:name], user_id: current_user.id)
  
      return nil unless @collection.id
  
      collections_cards = card_list.map do | card_string | 
        #split on 'x ' coming after digit(s), and ' - ', e.g.: '1x Dack Fayden - Conspiracy' -> ['1', 'Dack Fayden', 'Conspiracy']
        copies, name, edition = card_string.split(/(?<=\d)x | - /)
        
        card_id = Card.find_by(name: name, edition: edition)&.id
  
        next if card_id.nil?
      
        { copies: copies.to_i, collection_id: @collection.id, card_id: card_id }
      end.compact
  
      CollectionsCard.create(collections_cards)
    end

    def collection_params
      params.require(:collection).permit(:name, :user_id, collections_cards_attributes: [:card_id])
    end
end
