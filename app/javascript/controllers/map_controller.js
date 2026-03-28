import { Controller } from "@hotwired/stimulus"

const CATEGORY_COLORS = {
  restaurant: "#f97316",
  museum: "#3b82f6",
  park: "#22c55e",
  landmark: "#a855f7",
  shopping: "#ec4899",
  entertainment: "#ef4444",
  other: "#6b7280"
}

export default class extends Controller {
  static values = {
    places: { type: Array, default: [] },
    interactive: { type: Boolean, default: false },
    reverseUrl: { type: String, default: "/geocoding/reverse" },
    reverseLoading: { type: String, default: "…" },
    reverseNotFound: { type: String, default: "" },
    namePlaceholder: { type: String, default: "" }
  }

  static targets = [
    "container",
    "clickForm", "clickName", "clickAddress", "clickLatitude", "clickLongitude",
    "clickCategory", "clickSubmitForm"
  ]

  connect() {
    this.markers = {}
    this.initMap()

    this.observer = new MutationObserver(() => this.syncMarkersFromDom())
    const placeList = document.getElementById("places_list")
    if (placeList) {
      this.observer.observe(placeList, { childList: true })
    }

    this.handleTabShown = (event) => {
      if (!this.map) return
      const panel = event.target
      if (!panel.contains(this.element)) return

      setTimeout(() => this.refreshMapSize(), 50)
    }
    document.addEventListener("tab:shown", this.handleTabShown)
  }

  disconnect() {
    if (this.resizeObserver) this.resizeObserver.disconnect()
    if (this.observer) this.observer.disconnect()
    if (this.map) this.map.remove()
    document.removeEventListener("tab:shown", this.handleTabShown)
  }

  refreshMapSize() {
    if (!this.map) return
    this.map.invalidateSize()
    requestAnimationFrame(() => this.map.invalidateSize())
  }

  async initMap() {
    try {
      const L = await import("leaflet")
      this.L = L

      this.map = L.map(this.containerTarget, {
        zoomControl: true,
        scrollWheelZoom: true
      }).setView([48.8566, 2.3522], 4)

      L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        maxZoom: 19
      }).addTo(this.map)

      if (this.interactiveValue) {
        this.map.on("click", (e) => this.handleMapClick(e))
      }

      this.map.whenReady(() => {
        this.refreshMapSize()
        ;[100, 300, 600].forEach(ms => setTimeout(() => this.refreshMapSize(), ms))
        this.emitMapCenter()
      })

      this.map.on("moveend", () => this.emitMapCenter())

      this.resizeObserver = new ResizeObserver(() => {
        const dialog = document.getElementById("turbo-confirm-dialog")
        if (dialog && !dialog.classList.contains("hidden")) return
        this.refreshMapSize()
      })
      this.resizeObserver.observe(this.containerTarget)

      this.hasDoneInitialBoundsFit = false
      this.renderMarkers({ fitBounds: true })
    } catch (error) {
      console.error("Failed to initialize Leaflet map:", error)
    }
  }

  placesValueChanged() {
    if (this.map && this.L) {
      this.renderMarkers({ fitBounds: !this.hasDoneInitialBoundsFit })
    }
  }

  emitMapCenter() {
    if (!this.map) return
    const c = this.map.getCenter()
    document.dispatchEvent(new CustomEvent("places-map:center", {
      bubbles: true,
      detail: { lat: c.lat, lng: c.lng }
    }))
  }

  afterPlaceSubmit() {
    this.cancelPin()
  }

  renderMarkers(options = {}) {
    const fitBounds = options.fitBounds === true

    if (!this.map || !this.L) return

    Object.values(this.markers).forEach(m => m.remove())
    this.markers = {}

    const bounds = []

    this.placesValue.forEach((place, index) => {
      if (!place.latitude || !place.longitude) return

      const color = CATEGORY_COLORS[place.category] || CATEGORY_COLORS.other
      const marker = this.createMarker(place, index + 1, color)
      marker.addTo(this.map)
      this.markers[place.id] = marker
      bounds.push([place.latitude, place.longitude])
    })

    if (fitBounds && bounds.length > 0) {
      this.map.fitBounds(bounds, { padding: [40, 40], maxZoom: 14 })
      this.hasDoneInitialBoundsFit = true
    }
  }

  createMarker(place, number, color) {
    const icon = this.L.divIcon({
      className: "custom-map-pin",
      html: `<div style="background:${color};color:white;width:28px;height:28px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;border:2px solid white;box-shadow:0 2px 6px rgba(0,0,0,0.3);">${number}</div>`,
      iconSize: [28, 28],
      iconAnchor: [14, 14]
    })

    const marker = this.L.marker([place.latitude, place.longitude], { icon })

    marker.bindPopup(`
      <div style="font-size:13px;">
        <strong>${this.escapeHtml(place.name)}</strong>
        ${place.address ? `<br><span style="color:#6b7280;">${this.escapeHtml(place.address)}</span>` : ''}
      </div>
    `)

    marker.on("click", () => {
      const card = document.getElementById(`place_${place.id}`)
      if (card) {
        card.scrollIntoView({ behavior: "smooth", block: "center" })
        card.classList.add("ring-2", "ring-indigo-400")
        setTimeout(() => card.classList.remove("ring-2", "ring-indigo-400"), 2000)
      }
    })

    return marker
  }

  async handleMapClick(e) {
    if (!this.hasClickFormTarget) return

    if (this.tempMarker) this.tempMarker.remove()

    this.tempMarker = this.L.marker(e.latlng, {
      icon: this.L.divIcon({
        className: "custom-map-pin",
        html: '<div style="background:#6366f1;color:white;width:28px;height:28px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:14px;font-weight:700;border:2px solid white;box-shadow:0 2px 6px rgba(0,0,0,0.3);">+</div>',
        iconSize: [28, 28],
        iconAnchor: [14, 14]
      })
    }).addTo(this.map)

    this.clickLatitudeTarget.value = e.latlng.lat.toFixed(7)
    this.clickLongitudeTarget.value = e.latlng.lng.toFixed(7)
    if (this.hasClickAddressTarget) this.clickAddressTarget.value = ""
    this.clickNameTarget.value = ""
    this.clickNameTarget.placeholder = this.reverseLoadingValue
    this.clickFormTarget.classList.remove("hidden")

    try {
      const params = new URLSearchParams({
        lat: String(e.latlng.lat),
        lon: String(e.latlng.lng)
      })
      const response = await fetch(`${this.reverseUrlValue}?${params}`)
      if (response.ok) {
        const data = await response.json()
        if (data.latitude != null && data.longitude != null) {
          this.clickLatitudeTarget.value = Number(data.latitude).toFixed(7)
          this.clickLongitudeTarget.value = Number(data.longitude).toFixed(7)
        }
        if (data.name) {
          this.clickNameTarget.value = data.name
        }
        if (this.hasClickAddressTarget && data.address) {
          this.clickAddressTarget.value = data.address
        }
        if (!data.name) {
          this.clickNameTarget.placeholder = this.reverseNotFoundValue || this.namePlaceholderValue
        } else if (this.namePlaceholderValue) {
          this.clickNameTarget.placeholder = this.namePlaceholderValue
        }
      } else {
        this.clickNameTarget.placeholder = this.reverseNotFoundValue || this.namePlaceholderValue
      }
    } catch {
      this.clickNameTarget.placeholder = this.reverseNotFoundValue || this.namePlaceholderValue
    }

    this.clickNameTarget.focus()
  }

  cancelPin() {
    if (this.tempMarker) {
      this.tempMarker.remove()
      this.tempMarker = null
    }
    if (this.hasClickFormTarget) {
      this.clickFormTarget.classList.add("hidden")
    }
    if (this.hasClickNameTarget && this.namePlaceholderValue) {
      this.clickNameTarget.placeholder = this.namePlaceholderValue
    }
    if (this.hasClickAddressTarget) this.clickAddressTarget.value = ""
  }

  highlightPlace(event) {
    const placeId = event.params.id
    const marker = this.markers[placeId]
    if (marker) {
      this.map.setView(marker.getLatLng(), 15, { animate: true })
      marker.openPopup()
    }
  }

  syncMarkersFromDom() {
    const placeList = document.getElementById("places_list")
    if (!this.map || !this.L || !placeList) return

    const cards = placeList.querySelectorAll("[data-place-json]")
    const places = Array.from(cards).map(card => {
      try { return JSON.parse(card.dataset.placeJson) } catch { return null }
    }).filter(Boolean)

    const nextIds = new Set(places.map(p => p.id))
    Object.keys(this.markers).forEach((id) => {
      const numId = Number(id)
      if (!nextIds.has(numId)) {
        this.markers[id].remove()
        delete this.markers[id]
      }
    })

    places.forEach((place, index) => {
      if (!place.latitude || !place.longitude) return
      if (this.markers[place.id]) return

      const color = CATEGORY_COLORS[place.category] || CATEGORY_COLORS.other
      const marker = this.createMarker(place, index + 1, color)
      marker.addTo(this.map)
      this.markers[place.id] = marker
    })

    this.renumberMarkerLabels(places)

    if (this.tempMarker) {
      this.tempMarker.remove()
      this.tempMarker = null
    }
    if (this.hasClickFormTarget) {
      this.clickFormTarget.classList.add("hidden")
    }
  }

  renumberMarkerLabels(places) {
    places.forEach((place, index) => {
      const marker = this.markers[place.id]
      if (!marker) return
      const color = CATEGORY_COLORS[place.category] || CATEGORY_COLORS.other
      const icon = this.L.divIcon({
        className: "custom-map-pin",
        html: `<div style="background:${color};color:white;width:28px;height:28px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;border:2px solid white;box-shadow:0 2px 6px rgba(0,0,0,0.3);">${index + 1}</div>`,
        iconSize: [28, 28],
        iconAnchor: [14, 14]
      })
      marker.setIcon(icon)
    })
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}
