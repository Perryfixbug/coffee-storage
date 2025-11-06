import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileName"]

  fileSelected(event) {
    const file = event.target.files[0]
    if (file) {
      this.fileNameTarget.textContent = `Đã chọn: ${file.name}`
    } else {
      this.fileNameTarget.textContent = ""
    }
  }
}
