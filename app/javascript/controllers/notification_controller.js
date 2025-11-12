import { Controller } from "@hotwired/stimulus"
import NotificationsChannel from "channels/notifications_channel"

export default class extends Controller {
  static targets = ["list", "count"]

  connect() {
    this.open = false
    this.count = 0

    // Lắng nghe sự kiện từ Action Cable
    document.addEventListener("notification:received", event => {
      this.addNotification(event.detail)
      console.log(event);
    })
  }

  addNotification(data) {
    const div = document.createElement("div")
    div.className = "px-3 py-2 text-sm hover:bg-gray-100 border-b border-gray-100 cursor-pointer"
    div.innerText = data.content
    this.listTarget.prepend(div)

    // Hiển thị badge
    this.count += 1
    this.countTarget.innerText = this.count
    this.countTarget.classList.remove("hidden")
  }

  markAllRead() {
    this.count = 0
    if( this.countTarget ) this.countTarget.classList.add("hidden")
    NotificationsChannel.perform("mark_all_read")
  }

  clearAll(){
    this.count = 0
    if( this.countTarget ) this.countTarget.classList.add("hidden")
    this.listTarget.innerText = ""
    NotificationsChannel.perform("clear_all")
  }
}
