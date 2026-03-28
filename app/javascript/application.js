import "@hotwired/turbo-rails"
import "controllers"

Turbo.setConfirmMethod((message, _element) => {
  const dialog = document.getElementById("turbo-confirm-dialog")
  if (!dialog) return Promise.resolve(confirm(message))

  const controller = dialog
    .closest("[data-controller='confirm']")
  if (!controller) return Promise.resolve(confirm(message))

  const app = window.Stimulus
  const ctrl = app.getControllerForElementAndIdentifier(controller, "confirm")
  if (!ctrl) return Promise.resolve(confirm(message))

  return ctrl.show(message)
})
