import { Controller } from "@hotwired/stimulus"

// Single Responsibility Principle: This controller handles inline form submissions
export default class extends Controller {
  static targets = ["form"]
  static values = {
    successEvent: String
  }

  async submit(event) {
    event.preventDefault()
    
    try {
      const formData = new FormData(this.formTarget)
      const response = await fetch(this.formTarget.action, {
        method: 'POST',
        body: formData,
        headers: {
          'Accept': 'application/json'
        }
      })
      
      if (!response.ok) throw new Error('Network response was not ok')
      
      const data = await response.json()
      
      // Dispatch custom event with the created record
      const event = new CustomEvent(this.successEventValue, {
        detail: { record: data },
        bubbles: true
      })
      this.element.dispatchEvent(event)
      
      // Close the modal
      this.element.closest('[data-controller="modal"]').remove()
    } catch (error) {
      console.error('Error:', error)
    }
  }
} 