FactoryBot.define do
  factory :ordered_product do
    quantity { 1.5 }
    price_per_unit { 1.5 }
    product { nil }
    order { nil }
  end
end
