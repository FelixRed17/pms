import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["navItem", "overlay", "panel", "sidebar"]
  static values = { active: String }

  connect() {
    this.activeValue = this.activeValue || "launch"
    this.sidebarOpen = false
    this.render()
  }

  switchSection(event) {
    this.activeValue = event.currentTarget.dataset.section
    this.closeSidebar()
  }

  toggleSidebar() {
    this.sidebarOpen = !this.sidebarOpen
    this.renderSidebar()
  }

  closeSidebar() {
    this.sidebarOpen = false
    this.renderSidebar()
  }

  activeValueChanged() {
    this.render()
  }

  render() {
    this.renderPanels()
    this.renderNav()
    this.renderSidebar()
  }

  renderPanels() {
    this.panelTargets.forEach((panel) => {
      const isActive = panel.dataset.section === this.activeValue

      panel.classList.toggle("hidden", !isActive)
    })
  }

  renderNav() {
    this.navItemTargets.forEach((item) => {
      const isActive = item.dataset.section === this.activeValue

      item.setAttribute("aria-current", isActive ? "page" : "false")

      item.classList.toggle("bg-orange-600", isActive)
      item.classList.toggle("text-white", isActive)
      item.classList.toggle("shadow-lg", isActive)
      item.classList.toggle("shadow-orange-950/20", isActive)
      item.classList.toggle("hover:bg-slate-900", !isActive)
      item.classList.toggle("text-slate-300", !isActive)
      item.classList.toggle("hover:text-white", !isActive)
    })
  }

  renderSidebar() {
    if (!this.hasSidebarTarget || !this.hasOverlayTarget) return

    this.sidebarTarget.classList.toggle("-translate-x-full", !this.sidebarOpen)
    this.overlayTarget.classList.toggle("hidden", !this.sidebarOpen)
  }
}
