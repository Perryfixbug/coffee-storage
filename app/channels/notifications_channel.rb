class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "[Cable] Subscribing NotificationsChannel for user #{current_user.id}"
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def mark_all_read
    current_user.notifications.unread.update_all(read: true)

    # Broadcast để client cập nhật realtime
    NotificationsChannel.broadcast_to(current_user, { action: "mark_all_read" })
  end

  def clear_all
    current_user.notifications.delete_all

    # Broadcast để client cập nhật realtime
    NotificationsChannel.broadcast_to(current_user, { action: "clear_all" })
  end
end
