import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 4000 } }

  connect() {
    requestAnimationFrame(() => {
      this.element.classList.remove("translate-y-4", "opacity-0")
      this.element.classList.add("translate-y-0", "opacity-100")
    })

    this._timeout = setTimeout(() => this.dismiss(), this.delayValue)
  }

  disconnect() {
    if (this._timeout) clearTimeout(this._timeout)
  }

  dismiss() {
    this.element.classList.remove("translate-y-0", "opacity-100")
    this.element.classList.add("translate-y-4", "opacity-0")

    this.element.addEventListener("transitionend", () => {
      this.element.remove()
    }, { once: true })
  }
}
