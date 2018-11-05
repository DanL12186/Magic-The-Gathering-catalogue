class CollectionsCards < ApplicationRecord
  belongs_to :collection
  belongs_to :card
end