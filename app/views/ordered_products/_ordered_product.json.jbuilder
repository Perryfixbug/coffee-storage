json.extract! ordered_product, :id, :quantity, :price_per_unit, :product_id, :order_id, :created_at, :updated_at
json.url ordered_product_url(ordered_product, format: :json)
