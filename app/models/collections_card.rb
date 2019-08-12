class CollectionsCard < ApplicationRecord
  belongs_to :collection
  belongs_to :card
end