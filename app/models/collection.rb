class Collection < ApplicationRecord
  belongs_to :user
  
  has_many :collection_cards
  has_many :cards, through: :collection_cards
end
