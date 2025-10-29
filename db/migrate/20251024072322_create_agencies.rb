class CreateAgencies < ActiveRecord::Migration[8.0]
  def change
    create_table :agencies do |t|
      t.string :name
      t.string :location
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
