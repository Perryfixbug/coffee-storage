import { Controller } from '@hotwired/stimulus'

export default class extends Controller{
  static targets = ["input", "result"]

  connect(){
    this.timer = null
    console.log("Connect search successfully!");
  }

  universalSearch() {
    clearTimeout(this.timer)
    this.timer = setTimeout(async ()=>{
      const query = this.inputTarget.value.trim()

      // Ẩn nếu không có query
      if (query === "") {
        this.resultTarget.classList.add("hidden")
        this.resultTarget.innerHTML = ""
        return
      }

      try {
        const response = await fetch(`/search/universalSearch?q=${encodeURIComponent(query)}`)
        if (!response.ok) throw new Error("Network error")

        const results = await response.json()

        // Nếu không có kết quả
        if (results.length === 0) {
          this.resultTarget.innerHTML = `<div class="p-2 text-gray-500 text-sm">Không có kết quả</div>`
          this.resultTarget.classList.remove("hidden")
          return
        }

        // Tạo HTML danh sách kết quả
        const resultHtml = results.map(r => `
          <a href="/${r.type}s/${r.id}"
            class="block px-3 py-2 hover:bg-gray-300 cursor-pointer text-sm">
            <strong>${r.name}</strong>
            <span class="text-gray-400">#${r.id}</span>
            ${r.type ? `<span class="ml-2 text-xs text-blue-500">(${r.type})</span>` : ""}
          </a>
        `).join("")

        this.resultTarget.innerHTML = resultHtml
        this.resultTarget.classList.remove("hidden")
      } catch (error) {
        console.error("Search failed:", error)
      }
    }, 500)
  }
}
