class Collection < ApplicationRecord
  belongs_to :user
  
  has_many :cards, through: :collections_cards
end
