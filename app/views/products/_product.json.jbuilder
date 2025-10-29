json.extract! product, :id, :name, :unit, :price_per_unit, :quantity, :detail, :product_code, :created_at, :updated_at
json.url product_url(product, format: :json)
