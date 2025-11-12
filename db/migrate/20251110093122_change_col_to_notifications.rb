class ChangeColToNotifications < ActiveRecord::Migration[8.0]
  def change
    rename_column :notifications, :type, :noti_type
  end
end
