import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="recinto-modal"
export default class extends Controller {
  connect() {
  }

  initialize() { 
    this.element.setAttribute("data-action", "click->recinto-modal#showModal")
  }

  showModal(event) {
    event.preventDefault()
    this.url = this.element.getAttribute("href")
    fetch(this.url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html",
      }
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
  }
}
