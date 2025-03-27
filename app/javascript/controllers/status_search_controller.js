import { Controller } from "@hotwired/stimulus"

// Single Responsibility Principle: This controller handles only status search functionality
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
    
    // Listen for status creation events
    this.handleStatusCreated = this.handleStatusCreated.bind(this)
    document.addEventListener("status:created", this.handleStatusCreated)
  }

  disconnect() {
    document.removeEventListener("click", this.boundClickOutside)
    document.removeEventListener("status:created", this.handleStatusCreated)
  }

  async search() {
    const query = this.inputTarget.value

    if (query.length < this.minLengthValue) {
      this.resultsTarget.hidden = true
      return
    }

    try {
      const response = await fetch(`${this.urlValue}?query=${encodeURIComponent(query)}`)
      const statuses = await response.json()
      
      this.resultsTarget.innerHTML = this.buildResultsHtml(statuses)
      this.resultsTarget.hidden = false
    } catch (error) {
      console.error("Error fetching statuses:", error)
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

  handleStatusCreated(event) {
    const status = event.detail.record
    this.inputTarget.value = status.name
    this.selectedIdTarget.value = status.id
  }

  buildResultsHtml(statuses) {
    if (statuses.length === 0) {
      return '<div class="p-2 text-gray-500">No statuses found</div>'
    }

    return statuses.map(status => `
      <div
        class="p-2 hover:bg-gray-100 cursor-pointer"
        data-action="click->status-search#select"
        data-id="${status.id}">
        ${status.name}
      </div>
    `).join('')
  }
} 