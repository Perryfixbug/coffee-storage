import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "hidden"]
  static values = { url: String }

  connect() {
    this.timer = null
  }

  inputTargetConnected() {
    this.inputTarget.addEventListener("input", this.search.bind(this))
  }

  search(event) {
    clearTimeout(this.timer)
    const query = this.inputTarget.value.trim()
    if (query.length < 2) {
      this.resultsTarget.classList.add("hidden")
      return
    }

    this.timer = setTimeout(() => {
      fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`, {
        headers: { Accept: "text/vnd.turbo-stream.html" }
      })
        .then(r => r.text())
        .then(html => {
          this.resultsTarget.innerHTML = html
          this.resultsTarget.classList.remove("hidden")
        })
    }, 200)
  }

  select(event) {
    const id = event.target.dataset.id
    const name = event.target.dataset.name

    this.hiddenTarget.value = id
    this.inputTarget.value = name
    this.resultsTarget.classList.add("hidden")
  }
}
