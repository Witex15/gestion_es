import { Controller } from "@hotwired/stimulus"

// Single Responsibility Principle: This controller handles only modal functionality
export default class extends Controller {
  connect() {
    // Prevent body scrolling when modal is open
    document.body.style.overflow = 'hidden'
  }

  disconnect() {
    // Restore body scrolling when modal is closed
    document.body.style.overflow = ''
  }

  close(event) {
    event.preventDefault()
    this.element.remove()
  }
} 