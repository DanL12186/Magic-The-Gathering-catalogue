class User < ApplicationRecord
  has_secure_password

  has_many :users_cards
  has_many :cards, through: :users_cards
  has_many :decks, dependent: :destroy
  has_many :collections

  validates :password, presence: true, length: { minimum: 8 }
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, uniqueness: true
end
