class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price_per_unit, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
