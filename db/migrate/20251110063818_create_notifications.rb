class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :type
      t.text :content

      t.timestamps
    end
  end
end
