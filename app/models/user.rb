class User < ApplicationRecord
  has_secure_password

  has_many :users_cards
  has_many :cards, through: :users_cards
  has_many :decks
  has_many :collections

  validates :name, :password, :email, presence: true
end
