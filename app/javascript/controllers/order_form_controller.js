import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "agencyInput", "agencyResults", "agencyHidden", "selectedAgency",
    "productInput", "productResults", "selectedProducts", "orderTotal"
  ]

  connect() {
    this.productIndex = 0 // để sinh key cho ordered_products_attributes
    this.timer = null
  }

  // 🔍 Tìm đại lý
  searchAgency() {
    clearTimeout(this.timer)
    this.timer = setTimeout( async ()=>{
      const query = this.agencyInputTarget.value.trim()
      if (query === "") return

      const response = await fetch(`/search/agencies?q=${encodeURIComponent(query)}`)
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
    }, 500)
  }

  selectAgency(e) {
    const { id, name } = e.target.dataset
    this.agencyHiddenTarget.value = id
    this.selectedAgencyTarget.textContent = `Đã chọn: ${name} (Mã: ${id})`
    this.agencyResultsTarget.classList.add("hidden")
  }

  // 🔍 Tìm sản phẩm
  searchProduct() {
    clearTimeout(this.timer)
    this.timer = setTimeout( async ()=>{
      const query = this.productInputTarget.value.trim()
      if (query === "") return

      const response = await fetch(`/search/products?q=${encodeURIComponent(query)}`)
      const products = await response.json()

      if (products.length === 0) {
        this.productResultsTarget.innerHTML = "<li class='p-2 text-gray-500'>Không tìm thấy</li>"
        this.productResultsTarget.classList.remove("hidden")
        return
      }

      this.productResultsTarget.innerHTML = products.map(p => `
        <li class="p-2 flex justify-between items-center">
          <span>${p.name} (Mã: ${p.id})</span>
          <span class="text-gray-500">
            Tồn kho: ${p.quantity} ${p.unit || ''} | Giá: ${p.price_per_unit.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' })}
          </span>
          <button type="button"
                  class="bg-blue-500 text-white px-3 py-1 rounded-md text-sm"
                  data-id="${p.id}" data-name="${p.name}" data-quantity="${p.quantity}" data-price="${p.price_per_unit}"
                  data-action="click->order-form#addProduct">Chọn</button>
        </li>
      `).join("")
      this.productResultsTarget.classList.remove("hidden")
    }, 500)
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
    this.updateOrderTotal()
  }

  // ❌ Xóa sản phẩm
  removeProduct(e) {
    e.target.closest("li").remove()
    this.updateOrderTotal()
  }

  updateOrderTotal() {
    let total = 0
    this.selectedProductsTarget.querySelectorAll("li").forEach(item => {
      const totalSpan = item.querySelector(".product-total")
      const value = totalSpan.textContent.replace(/[^0-9.-]+/g,"") // bỏ ký tự VND
      total += parseFloat(value) || 0
    })
    this.orderTotalTarget.textContent = "Tổng: " + total.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' })
  }
}
