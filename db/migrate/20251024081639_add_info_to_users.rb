class AddInfoToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :phone, :string
    add_column :users, :address, :string
    add_column :users, :role, :string
    add_column :users, :birth_date, :date
  end
end
