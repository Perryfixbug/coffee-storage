import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    // Tự động ẩn sau 3 giây
    setTimeout(() => this.close(), 3000)
  }

  close() {
    this.element.classList.add("opacity-0")
    setTimeout(() => this.element.remove(), 300)
  }
}
