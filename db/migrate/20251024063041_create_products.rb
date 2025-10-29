class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :unit
      t.float :price_per_unit
      t.float :quantity
      t.string :detail
      t.string :product_code

      t.timestamps
    end
  end
end
