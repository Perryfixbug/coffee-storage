require 'faker'

puts "Seeding 20 realistic products..."

20.times do |i|
  Product.create!(
    name: Faker::Commerce.product_name,
    unit: [ "kg", "box", "piece", "pack", "bottle" ].sample,
    price_per_unit: Faker::Commerce.price(range: 10.0..500.0),
    quantity: rand(1.0..100.0).round(1),
    detail: Faker::Lorem.sentence(word_count: 8),
    product_code: "P#{format('%04d', i + 1)}"
  )
end

puts "Seeded 20 products!"
