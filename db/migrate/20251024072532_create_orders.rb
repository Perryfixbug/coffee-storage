class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :type
      t.references :user, null: false, foreign_key: true
      t.references :agency, null: false, foreign_key: true

      t.timestamps
    end
  end
end
