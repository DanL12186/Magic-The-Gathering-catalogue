class Deck < ApplicationRecord
  has_many :deck_cards, dependent: :destroy
  has_many :cards, through: :deck_cards
  
  has_many :card_types, through: :cards
  has_many :colors, through: :cards

  belongs_to :user
end