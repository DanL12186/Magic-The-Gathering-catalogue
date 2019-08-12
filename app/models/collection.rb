class Collection < ApplicationRecord
  has_many :collections_cards, dependent: :destroy
  has_many :cards, through: :collections_cards

  validates :name, presence: true, uniqueness: { scope: :user_id }

  belongs_to :user
end