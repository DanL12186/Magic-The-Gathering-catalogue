class Card < ApplicationRecord
  include Cards

  has_many :users_cards
  has_many :decks_cards, dependent: :destroy
  has_many :collections_cards

  has_many :users, through: :users_cards
  has_many :decks, through: :cards_decks

  validates :img_url, uniqueness: true
  validates :name, :edition, presence: true

  BASE_URL = "https://cdn1.mtggoldfish.com/images/gf"

  def initialize(**args)
    super(args)

    encoded_card_name = card_name_url_encode(args[:name])
    edition_abbreviation = Editions[args[:edition]]

    if args[:name] && args[:edition]
      self.img_url = "#{BASE_URL}/#{encoded_card_name}#{edition_abbreviation}%255D.jpg"
    end

    unless args[:mana].nil?
      mana = args[:mana].reject { | str | str == '0' }
      
      self.converted_mana_cost = mana.map(&:to_i).sum + mana.reject { | str | str.to_i > 0 }.size
      self.colors = mana.uniq.reject { | str | str.to_i > 0 || str == "X" || str == "0" }
      self.color = self.colors.size == 1 ? self.colors.first : self.colors.size > 1 ? "Gold" : "Colorless"
    end
  end

  def self.search(search)
    matches = []
    partial_matches = []

    Card.all.each do | card | 
      next unless card.name.match?(/#{search}/i)
      
      if card.name.split.any? { | word | word.downcase == search.downcase } 
        matches << card
      else 
        partial_matches << card
      end
    end
    [ matches, partial_matches ]
  end
  
end