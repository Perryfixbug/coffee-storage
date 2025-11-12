class AddRefToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_reference :notifications, :user, null: false, foreign_key: true
    add_column :notifications, :read, :boolean, default: false
  end
end
