class User < ApplicationRecord
  has_secure_password

  has_many :user_cards
  has_many :cards, through: :user_cards

  has_many :decks, dependent: :destroy

  has_many :collections

  validates :password, presence: true, length: { minimum: 8 }
  validates :name, :email, presence: true, uniqueness: { case_sensitive: false }
end
