import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if(entry.isIntersecting) {
          const link = this.element.querySelector("#load-more-link");
          if(link) link.click;
        }
      })
    }, { rootMargin: "400px"}) 
  }

  disconnect() {
    this.observer.disconnect()
  }
}