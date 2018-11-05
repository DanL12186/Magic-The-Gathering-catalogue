class Deck < ApplicationRecord
  has_many :cards, through: :decks_cards
  has_many :card_types, through: :cards
  has_many :colors, through: :cards

  belongs_to :user
end
