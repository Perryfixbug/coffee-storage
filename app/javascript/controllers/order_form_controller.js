import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "agencyInput", "agencyResults", "agencyHidden", "selectedAgency",
    "productInput", "productResults", "selectedProducts"
  ]

  connect() {
    this.productIndex = 0 // để sinh key cho ordered_products_attributes
  }

  // 🔍 Tìm đại lý
  async searchAgency() {
    const query = this.agencyInputTarget.value.trim()
    if (query === "") return

    const response = await fetch(`/agencies/search?q=${encodeURIComponent(query)}`)
    const agencies = await response.json()

    if (agencies.length === 0) {
      this.agencyResultsTarget.innerHTML = "<div class='p-2 text-gray-500'>Không tìm thấy</div>"
      this.agencyResultsTarget.classList.remove("hidden")
      return
    }

    this.agencyResultsTarget.innerHTML = agencies.map(a => `
      <div class="p-2 hover:bg-blue-50 cursor-pointer"
           data-action="click->order-form#selectAgency"
           data-id="${a.id}" data-name="${a.name}">
        ${a.name} (Mã: ${a.id})
      </div>
    `).join("")
    this.agencyResultsTarget.classList.remove("hidden")
  }

  selectAgency(e) {
    const { id, name } = e.target.dataset
    this.agencyHiddenTarget.value = id
    this.selectedAgencyTarget.textContent = `Đã chọn: ${name} (Mã: ${id})`
    this.agencyResultsTarget.classList.add("hidden")
  }

  // 🔍 Tìm sản phẩm
  async searchProduct() {
    const query = this.productInputTarget.value.trim()
    if (query === "") return

    const response = await fetch(`/products/search?q=${encodeURIComponent(query)}`)
    const products = await response.json()

    if (products.length === 0) {
      this.productResultsTarget.innerHTML = "<li class='p-2 text-gray-500'>Không tìm thấy</li>"
      this.productResultsTarget.classList.remove("hidden")
      return
    }

    this.productResultsTarget.innerHTML = products.map(p => `
      <li class="p-2 flex justify-between items-center">
        <span>${p.name} (Mã: ${p.id})</span>
        <button type="button"
                class="bg-blue-500 text-white px-3 py-1 rounded-md text-sm"
                data-id="${p.id}" data-name="${p.name}"
                data-action="click->order-form#addProduct">Chọn</button>
      </li>
    `).join("")
    this.productResultsTarget.classList.remove("hidden")
  }

  // ➕ Thêm sản phẩm
  addProduct(e) {
    const { id, name } = e.target.dataset
    const index = this.productIndex++ // tạo key duy nhất cho mỗi sản phẩm

    const item = document.createElement("li")
    item.classList.add("p-2", "flex", "justify-between", "items-center", "gap-2")

    item.innerHTML = `
      <span>${name} (Mã: ${id})</span>
      <div class="flex items-center gap-2">
        <input type="hidden" name="order[ordered_products_attributes][${index}][product_id]" value="${id}">
        <input type="number" 
               name="order[ordered_products_attributes][${index}][quantity]" 
               placeholder="SL" 
               class="border p-1 w-16 text-center rounded" 
               value="1" min="1">
        <button type="button" class="text-red-600 text-sm" data-action="click->order-form#removeProduct">Xóa</button>
      </div>
    `
    this.selectedProductsTarget.appendChild(item)
    this.productResultsTarget.classList.add("hidden")
  }

  // ❌ Xóa sản phẩm
  removeProduct(e) {
    e.target.closest("li").remove()
  }
}
