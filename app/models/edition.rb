class Edition < ApplicationRecord
  validates :name, uniqueness: true
  validates :set_code, uniqueness: true
end
