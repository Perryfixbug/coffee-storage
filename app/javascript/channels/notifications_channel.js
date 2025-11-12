import consumer from "channels/consumer"

const NotificationsChannel = consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("Connected to NotificationsChannel")
  },

  disconnected() {
    console.log("Disconnected from NotificationsChannel")
  },

  received(data) {
    const event = new CustomEvent("notification:received", { detail: data })
    window.dispatchEvent(event)
  }
})

export default NotificationsChannel
