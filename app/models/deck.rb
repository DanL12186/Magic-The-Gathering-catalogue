class Deck < ApplicationRecord
  has_many :decks_cards, dependent: :destroy
  has_many :cards, through: :decks_cards
  has_many :card_types, through: :cards
  has_many :colors, through: :cards

  validates :name, uniqueness: { scope: :user_id }

  belongs_to :user
end