require "faker"

# ---- USERS ----
# puts "👤 Tạo users..."
# users = Array.new(100) do |i|
#   User.create!(
#     fullname: "example-#{i+1}",
#     email: "user#{i + 1}@example.com",
#     password: "123456",
#     password_confirmation: "123456",
#     phone: Faker::PhoneNumber.cell_phone,
#     address: Faker::Address.full_address,
#     role: %w[admin staff manager].sample,
#     birth_date: Faker::Date.birthday(min_age: 20, max_age: 50)
#   )
# end

# # ---- AGENCIES ----
# puts "🏢 Tạo agencies..."
# agencies = Array.new(200) do
#   Agency.create!(
#     name: Faker::Company.name,
#     location: Faker::Address.city,
#     phone: Faker::PhoneNumber.phone_number,
#     email: Faker::Internet.email
#   )
# end

# # ---- PRODUCTS ----
# puts "📦 Tạo products..."
# products = Array.new(500) do
#   Product.create!(
#     name: Faker::Commerce.product_name,
#     unit: %w[cái thùng hộp kg lít].sample,
#     price_per_unit: Faker::Commerce.price(range: 10.0..100.0),
#     quantity: rand(100..1000),
#     detail: Faker::Lorem.sentence(word_count: 6),
#     product_code: Faker::Alphanumeric.alphanumeric(number: 6).upcase
#   )
# end

# ---- ORDERS ----
def create_orders(type, count, users, agencies, products)
  puts "🧾 Tạo #{count} #{type}..."
  orders_data = []
  ordered_products_data = []

  count.times do
    user = users.sample
    agency = agencies.sample
    orders_data << {
      type: type,
      user_id: user.id,
      agency_id: agency.id,
      created_at: Faker::Time.backward(days: 180),
      updated_at: Time.now
    }
  end

  Order.insert_all!(orders_data)

  # Lấy lại danh sách id mới tạo
  new_orders = Order.where(type: type).order(created_at: :desc).limit(count)

  new_orders.each do |order|
    rand(1..5).times do
      product = products.sample
      quantity = rand(1..10)
      ordered_products_data << {
        order_id: order.id,
        product_id: product.id,
        quantity: quantity,
        price_per_unit: product.price_per_unit,
        created_at: Time.now,
        updated_at: Time.now
      }
    end
  end

  OrderedProduct.insert_all!(ordered_products_data)
end

ActiveRecord::Base.transaction do
  create_orders("ImportOrder", 10_000, User.all.to_a, Agency.all.to_a, Product.all.to_a)
  create_orders("ExportOrder", 10_000, User.all.to_a, Agency.all.to_a, Product.all.to_a)
end

puts "✅ Seed xong rồi!"
