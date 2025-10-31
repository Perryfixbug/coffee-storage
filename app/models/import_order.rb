class ImportOrder < Order
  after_commit :update_quantity, on: :create 

  def update_quantity
    ordered_products.each do |od|
      p = Product.find(od.product.id)
      p.update!(quantity: p.quantity + od.quantity)
    end
  end
end
