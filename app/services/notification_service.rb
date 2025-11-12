class NotificationService
  def self.notify(user, noti_type:, content:)
    notification = Notification.create!(
      user: user,
      noti_type: noti_type,
      content: content,
      read: false
    )

    # Gửi realtime qua ActionCable
    NotificationsChannel.broadcast_to(user, {
      id: notification.id,
      noti_type: notification.noti_type,
      content: notification.content
    })

    notification
  end
end
