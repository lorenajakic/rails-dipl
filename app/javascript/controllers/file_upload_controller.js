import { Controller } from "@hotwired/stimulus"

const ALLOWED_TYPES = [
  "application/pdf",
  "image/jpeg",
  "image/png",
  "image/webp"
]

export default class extends Controller {
  static targets = ["input", "filename", "error"]
  static values = { maxBytes: Number }

  pick() {
    this.clearError()
    const file = this.inputTarget.files[0]
    if (!file) {
      this.filenameTarget.textContent = this.inputTarget.dataset.defaultLabel || ""
      return
    }
    this.filenameTarget.textContent = file.name
  }

  validateSubmit(event) {
    this.clearError()
    const file = this.inputTarget.files[0]
    if (!file) return

    if (!ALLOWED_TYPES.includes(file.type)) {
      event.preventDefault()
      this.showError(this.inputTarget.dataset.invalidTypeMessage)
      return
    }

    if (file.size > this.maxBytesValue) {
      event.preventDefault()
      this.showError(this.inputTarget.dataset.tooLargeMessage)
    }
  }

  showError(message) {
    if (this.hasErrorTarget) {
      this.errorTarget.textContent = message
      this.errorTarget.classList.remove("hidden")
    }
  }

  clearError() {
    if (this.hasErrorTarget) {
      this.errorTarget.textContent = ""
      this.errorTarget.classList.add("hidden")
    }
  }
}
