import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['hello']

  connect() {
    this.helloTarget.innerHTML = "Hello world!"
  }
}
