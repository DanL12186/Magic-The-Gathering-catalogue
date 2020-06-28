class DecksController < ApplicationController
  include DeckHandStats
  
  before_action :set_deck, only: [:show, :sample_hand]
  before_action :set_shuffled_deck, only: [:show, :sample_hand]
  before_action :redirect_unless_logged_in, only: [:new, :show, :index]
  before_action :deny_unauthorized_deck_access, only: [:show, :sample_hand, :edit, :update, :destroy]
  before_action :build_deck, only: [:create]

  def new
    @deck = Deck.new
  end

  def create
    @deck.valid? ? (redirect_to decks_path) : (render :new)
  end

  def calculate_custom_hand_odds
    render json: calculate_odds
  end

  def sample_hand
    @sample_hand = draw_hand(@shuffled_deck_cards)
    @card_types = card_classifications(@sample_hand)
    @hand_frequencies = card_frequencies(@sample_hand)
    @deck_frequencies = card_frequencies(@shuffled_deck_cards)

    @multivar_args = multivar_geo_freq_args(@hand_frequencies, @deck_frequencies).values
  end

  def show
    @deck_frequencies = card_frequencies(@shuffled_deck_cards)
    @card_types = card_classifications(@shuffled_deck_cards).to_json
  end

  def index
    @decks = current_user.decks
  end

  private

    def set_deck
      @deck = Deck.find(params[:id])
    end

    def set_shuffled_deck
      @shuffled_deck_cards = shuffled_deck(@deck)
    end

    def deny_unauthorized_deck_access
      redirect_to root_path unless logged_in? && @deck.user_id == current_user.id
    end

    def calculate_odds
      deck_size = params[:deck_size].to_i
      cards_drawn = params[:cards_drawn].to_i
      multivar_args = hand_and_deck_card_counts(params).values
      
      Probability.multivariate_hypergeometric_distribution(deck_size, cards_drawn, *multivar_args)
    end
    
    #create the deck and then its decks_cards
    def build_deck
      cards_with_quantities = params[:decks_cards][:list].split(/ \r\n/)
      
      deck_name = deck_params[:name]

      @deck = Deck.create({ name: deck_name, user_id: current_user.id })

      return nil unless @deck.id

      #this will later be used to let the user know if any of the cards they entered were invalid and didn't work
      unfound_cards = []

      decks_cards = cards_with_quantities.map do | card_string |
        edition_match = card_string.match(/[a-z]+(?=\])/i)
        edition = edition_match[0] if edition_match
        
        #remove set name in brackets if it exists, then split on 'x ' coming after digits
        copies, name = card_string.sub(/ \[[a-z]+\]/i, '').split(/(?<=\d)x /)
        
        #find cheapest card variant if no edition/set is specified
        card_id = find_specific_or_cheapest_card_variant_id(name, edition)

        if card_id.nil?
          unfound_cards << name
          puts "thank u,"; next
        end
      
        { copies: copies.to_i, deck_id: @deck.id, card_id: card_id }
      end.compact

      DecksCard.transaction do
        @deck.decks_cards.build(decks_cards)
        @deck.save
      end
    end

    def deck_params
      params.require(:deck).permit(:name, :user_id, :colors, :card_types, decks_cards_attributes: [:card_id, :copies])
    end

end