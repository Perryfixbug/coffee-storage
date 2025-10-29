class Order < ApplicationRecord
  belongs_to :user
  belongs_to :agency, optional: true
  has_many :ordered_products, dependent: :destroy
  accepts_nested_attributes_for :ordered_products, allow_destroy: true

  def total_price
    ordered_products.to_a.sum { |op| op.quantity.to_f * op.price_per_unit.to_f }
  end
end
