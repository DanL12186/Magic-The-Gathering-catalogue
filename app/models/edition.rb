class Edition < ApplicationRecord
  validates :name, uniqueness: true
end
