// app/javascript/controllers/order_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "agencyInput", "agencyResults", "agencyHidden", "selectedAgency",
    "productInput", "productResults", "selectedProducts", "hiddenFields"
  ]

  connect() {
    this.agencyTimer = null
    this.productTimer = null
  }

  // 🕵️‍♂️ Tìm đại lý (auto-search)
  searchAgency() {
    clearTimeout(this.agencyTimer)
    const query = this.agencyInputTarget.value.trim()
    if (query.length < 2) {
      this.agencyResultsTarget.classList.add("hidden")
      return
    }

    this.agencyTimer = setTimeout(() => {
      fetch(`/agencies/search?q=${encodeURIComponent(query)}`)
        .then(r => r.text())
        .then(html => {
          this.agencyResultsTarget.innerHTML = html
          this.agencyResultsTarget.classList.remove("hidden")
        })
    }, 300)
  }

  selectAgency(event) {
    const id = event.target.dataset.id
    const name = event.target.dataset.name

    this.agencyHiddenTarget.value = id
    this.selectedAgencyTarget.textContent = `Đã chọn: ${name}`
    this.agencyResultsTarget.classList.add("hidden")
    this.agencyInputTarget.value = name
  }

  // 📦 Tìm sản phẩm (auto-search)
  searchProduct() {
    clearTimeout(this.productTimer)
    const query = this.productInputTarget.value.trim()
    if (query.length < 2) {
      this.productResultsTarget.classList.add("hidden")
      return
    }

    this.productTimer = setTimeout(() => {
      fetch(`/products/search?q=${encodeURIComponent(query)}`)
        .then(r => r.text())
        .then(html => {
          this.productResultsTarget.innerHTML = html
          this.productResultsTarget.classList.remove("hidden")
        })
    }, 300)
  }

  selectProduct(event) {
    const id = event.target.dataset.id
    const name = event.target.dataset.name
    const price = event.target.dataset.price

    // ✅ Thêm sản phẩm đã chọn vào danh sách
    const li = document.createElement("li")
    li.classList.add("p-2", "flex", "justify-between", "items-center")
    li.innerHTML = `
      <span>${name} - ${price}₫</span>
      <input type="number" value="1" min="1" class="border p-1 w-16 text-center" data-product-id="${id}">
    `
    this.selectedProductsTarget.appendChild(li)

    // 🔒 Ẩn kết quả
    this.productResultsTarget.classList.add("hidden")
    this.productInputTarget.value = ""
  }
}
