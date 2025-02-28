import { Controller } from "@hotwired/stimulus"

// Single Responsibility Principle: This controller handles only address search functionality
export default class extends Controller {
  static targets = ["input", "results", "selectedId"]
  static values = {
    url: String,
    minLength: { type: Number, default: 2 }
  }

  connect() {
    this.resultsTarget.hidden = true
    this.boundClickOutside = this.clickOutside.bind(this)
    document.addEventListener("click", this.boundClickOutside)
    
    // Listen for address creation events
    this.handleAddressCreated = this.handleAddressCreated.bind(this)
    document.addEventListener("address:created", this.handleAddressCreated)
  }

  disconnect() {
    document.removeEventListener("click", this.boundClickOutside)
    document.removeEventListener("address:created", this.handleAddressCreated)
  }

  async search() {
    const query = this.inputTarget.value

    if (query.length < this.minLengthValue) {
      this.resultsTarget.hidden = true
      return
    }

    try {
      const response = await fetch(`${this.urlValue}?query=${encodeURIComponent(query)}`)
      const addresses = await response.json()
      
      this.resultsTarget.innerHTML = this.buildResultsHtml(addresses)
      this.resultsTarget.hidden = false
    } catch (error) {
      console.error("Error fetching addresses:", error)
    }
  }

  select(event) {
    const selectedId = event.currentTarget.dataset.id
    const selectedText = event.currentTarget.textContent
    
    this.inputTarget.value = selectedText
    this.selectedIdTarget.value = selectedId
    this.resultsTarget.hidden = true
  }

  clickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.resultsTarget.hidden = true
    }
  }

  handleAddressCreated(event) {
    const address = event.detail.record
    this.inputTarget.value = `${address.street}, ${address.city} ${address.postal_code}`
    this.selectedIdTarget.value = address.id
  }

  buildResultsHtml(addresses) {
    if (addresses.length === 0) {
      return '<div class="p-2 text-gray-500">No addresses found</div>'
    }

    return addresses.map(address => `
      <div
        class="p-2 hover:bg-gray-100 cursor-pointer"
        data-action="click->address-search#select"
        data-id="${address.id}">
        ${address.street}, ${address.city} ${address.postal_code}
      </div>
    `).join('')
  }
} 