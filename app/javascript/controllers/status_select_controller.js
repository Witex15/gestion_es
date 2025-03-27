import { Controller } from "@hotwired/stimulus"

// Single Responsibility Principle: This controller handles status selection and creation
export default class extends Controller {
  toggleNewStatus(event) {
    const newStatusField = this.element.querySelector('input[name*="new_status_name"]')
    if (event.target.value) {
      newStatusField.value = ''
      newStatusField.disabled = true
    } else {
      newStatusField.disabled = false
    }
  }
} 