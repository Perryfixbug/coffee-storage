class CreateOrderedProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :ordered_products do |t|
      t.float :quantity
      t.float :price_per_unit
      t.references :product, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
