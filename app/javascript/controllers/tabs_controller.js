import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static classes = ["activeTab", "inactiveTab"]

  connect() {
    const hash = window.location.hash.replace("#", "")
    const tabNames = ["places", "itinerary", "chat", "tickets"]
    const index = tabNames.indexOf(hash)

    this.showTab(index >= 0 ? index : 0)
  }

  select(event) {
    const index = parseInt(event.params.index, 10)
    this.showTab(index)
  }

  showTab(index) {
    const tabNames = ["places", "itinerary", "chat", "tickets"]

    this.tabTargets.forEach((tab, i) => {
      if (i === index) {
        tab.classList.add(...this.activeTabClasses)
        tab.classList.remove(...this.inactiveTabClasses)
      } else {
        tab.classList.remove(...this.activeTabClasses)
        tab.classList.add(...this.inactiveTabClasses)
      }
    })

    this.panelTargets.forEach((panel, i) => {
      panel.classList.toggle("hidden", i !== index)
    })

    if (tabNames[index]) {
      history.replaceState(null, "", `#${tabNames[index]}`)
    }

    this.panelTargets[index]?.dispatchEvent(
      new CustomEvent("tab:shown", { bubbles: true })
    )
  }
}
