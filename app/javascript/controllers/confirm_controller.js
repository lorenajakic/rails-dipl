import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "message", "confirmBtn"]

  connect() {
    this.resolver = null
  }

  show(message) {
    return new Promise((resolve) => {
      this.resolver = resolve
      this.messageTarget.textContent = message
      this.lockScroll()
      this.dialogTarget.classList.remove("hidden")
      this.confirmBtnTarget.focus()
    })
  }

  accept() {
    this.dialogTarget.classList.add("hidden")
    this.unlockScroll()
    if (this.resolver) this.resolver(true)
    this.resolver = null
  }

  cancel() {
    this.dialogTarget.classList.add("hidden")
    this.unlockScroll()
    if (this.resolver) this.resolver(false)
    this.resolver = null
  }

  lockScroll() {
    this.previousOverflow = document.body.style.overflow
    this.previousPaddingRight = document.body.style.paddingRight
    const w = window.innerWidth - document.documentElement.clientWidth
    document.body.style.overflow = "hidden"
    if (w > 0) document.body.style.paddingRight = `${w}px`
  }

  unlockScroll() {
    document.body.style.overflow = this.previousOverflow || ""
    document.body.style.paddingRight = this.previousPaddingRight || ""
  }

  backdropClick(event) {
    if (event.target === this.dialogTarget) {
      this.cancel()
    }
  }

  keydown(event) {
    if (event.key === "Escape") this.cancel()
  }
}
