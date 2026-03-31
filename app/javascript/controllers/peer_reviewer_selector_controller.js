import { Controller } from "@hotwired/stimulus"

const MAX_PEER_REVIEWERS = 3

export default class extends Controller {
  static targets = [
    "emptyState",
    "helper",
    "hiddenInputs",
    "input",
    "selectedList",
    "suggestions"
  ]
  static values = {
    managerInputId: String,
    revieweeInputId: String
  }

  connect() {
    this.employees = JSON.parse(this.element.dataset.employees || "[]")
    this.selectedReviewerIds = []
    this.syncRelatedSelections = this.syncRelatedSelections.bind(this)
    this.revieweeInput?.addEventListener("change", this.syncRelatedSelections)
    this.managerInput?.addEventListener("change", this.syncRelatedSelections)
    this.render()
  }

  disconnect() {
    this.revieweeInput?.removeEventListener("change", this.syncRelatedSelections)
    this.managerInput?.removeEventListener("change", this.syncRelatedSelections)
  }

  search() {
    this.renderSuggestions()
  }

  open() {
    if (this.limitReached) return

    this.renderSuggestions()
  }

  closeLater() {
    window.setTimeout(() => {
      this.suggestionsTarget.classList.add("hidden")
    }, 120)
  }

  addReviewer(event) {
    const employeeId = Number(event.currentTarget.dataset.employeeId)
    const validationMessage = this.validationMessageFor(employeeId)

    if (validationMessage) {
      this.setHelperMessage(validationMessage, true)
      return
    }

    this.selectedReviewerIds = [...this.selectedReviewerIds, employeeId]
    this.inputTarget.value = ""
    this.render()
    this.setHelperMessage("You can add up to 3 peer reviewers", false)
  }

  removeReviewer(event) {
    const employeeId = Number(event.currentTarget.dataset.employeeId)

    this.selectedReviewerIds = this.selectedReviewerIds.filter((id) => id !== employeeId)
    this.render()
    this.setHelperMessage("You can add up to 3 peer reviewers", false)
  }

  syncRelatedSelections() {
    const invalidSelections = this.selectedReviewerIds.filter((employeeId) => {
      return this.validationMessageFor(employeeId, { checkExistingSelection: false }) !== null
    })

    if (invalidSelections.length > 0) {
      this.selectedReviewerIds = this.selectedReviewerIds.filter((employeeId) => !invalidSelections.includes(employeeId))

      const lastInvalidId = invalidSelections[invalidSelections.length - 1]
      const message = this.validationMessageFor(lastInvalidId, { checkExistingSelection: false }).message

      this.render()
      this.setHelperMessage(message, true)
      return
    }

    this.render()
  }

  render() {
    this.renderSelectedReviewers()
    this.renderHiddenInputs()
    this.renderSuggestions()
  }

  renderSelectedReviewers() {
    const selectedEmployees = this.selectedEmployees

    if (selectedEmployees.length === 0) {
      this.selectedListTarget.innerHTML = `
        <div class="rounded-2xl border border-dashed border-slate-200 bg-slate-50 px-4 py-5 text-sm text-slate-500">
          No peer reviewers added yet.
        </div>
      `
      return
    }

    this.selectedListTarget.innerHTML = selectedEmployees.map((employee) => `
      <div class="flex items-center justify-between gap-4 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-4">
        <div class="min-w-0">
          <p class="truncate text-sm font-semibold text-slate-900">${employee.name}</p>
          <p class="mt-1 truncate text-sm text-slate-500">${employee.email}${employee.jobTitle ? ` • ${employee.jobTitle}` : ""}</p>
        </div>
        <button
          type="button"
          class="shrink-0 rounded-full px-3 py-1.5 text-xs font-semibold uppercase tracking-[0.18em] text-slate-500 transition hover:bg-slate-200 hover:text-slate-800"
          data-action="peer-reviewer-selector#removeReviewer"
          data-employee-id="${employee.id}"
        >
          Remove
        </button>
      </div>
    `).join("")
  }

  renderHiddenInputs() {
    this.hiddenInputsTarget.innerHTML = this.selectedReviewerIds.map((employeeId) => `
      <input type="hidden" name="review_cycle[peer_reviewer_ids][]" value="${employeeId}">
    `).join("")
  }

  renderSuggestions() {
    const query = this.inputTarget.value.trim().toLowerCase()
    const suggestions = this.availableEmployees.filter((employee) => {
      if (query.length === 0) return true

      return [employee.name, employee.email, employee.jobTitle]
        .filter(Boolean)
        .join(" ")
        .toLowerCase()
        .includes(query)
    })

    if (this.limitReached) {
      this.inputTarget.disabled = true
      this.inputTarget.placeholder = "Peer reviewer limit reached"
      this.suggestionsTarget.classList.add("hidden")
      this.setHelperMessage("You have reached the maximum of 3 peer reviewers", true)
      return
    }

    this.inputTarget.disabled = false
    this.inputTarget.placeholder = "Search employees to add as peer reviewers"

    if (suggestions.length === 0) {
      this.suggestionsTarget.innerHTML = `
        <div class="px-4 py-4 text-sm text-slate-500">No matching employees found.</div>
      `
      this.suggestionsTarget.classList.remove("hidden")
      return
    }

    this.suggestionsTarget.innerHTML = `
      <ul class="max-h-72 overflow-y-auto py-2">
        ${suggestions.map((employee) => `
          <li>
            <button
              type="button"
              class="flex w-full items-center justify-between gap-4 px-4 py-3 text-left transition hover:bg-slate-50"
              data-action="peer-reviewer-selector#addReviewer"
              data-employee-id="${employee.id}"
            >
              <div class="min-w-0">
                <p class="truncate text-sm font-medium text-slate-900">${employee.name}</p>
                <p class="mt-1 truncate text-xs text-slate-500">${employee.email}${employee.jobTitle ? ` • ${employee.jobTitle}` : ""}</p>
              </div>
              <span class="rounded-full bg-slate-100 px-2.5 py-1 text-xs font-medium text-slate-500">Add</span>
            </button>
          </li>
        `).join("")}
      </ul>
    `

    this.suggestionsTarget.classList.remove("hidden")
  }

  setHelperMessage(message, isAlert) {
    this.helperTarget.textContent = message
    this.helperTarget.classList.toggle("text-slate-400", !isAlert)
    this.helperTarget.classList.toggle("text-orange-600", isAlert)
  }

  validationMessageFor(employeeId, options = {}) {
    const checkExistingSelection = options.checkExistingSelection !== false

    if (checkExistingSelection && this.selectedReviewerIds.includes(employeeId)) {
      return "This employee has already been added"
    }

    if (this.revieweeId && employeeId === this.revieweeId) {
      return "The reviewee cannot be a peer reviewer"
    }

    if (this.managerId && employeeId === this.managerId) {
      return "The manager cannot be a peer reviewer"
    }

    if (this.selectedReviewerIds.length >= MAX_PEER_REVIEWERS) {
      return "You have reached the maximum of 3 peer reviewers"
    }

    return null
  }

  get limitReached() {
    return this.selectedReviewerIds.length >= MAX_PEER_REVIEWERS
  }

  get selectedEmployees() {
    return this.selectedReviewerIds
      .map((employeeId) => this.employees.find((employee) => employee.id === employeeId))
      .filter(Boolean)
  }

  get availableEmployees() {
    return this.employees.filter((employee) => {
      return !this.selectedReviewerIds.includes(employee.id) &&
        employee.id !== this.revieweeId &&
        employee.id !== this.managerId
    })
  }

  get revieweeId() {
    return Number(this.revieweeInput?.value) || null
  }

  get managerId() {
    return Number(this.managerInput?.value) || null
  }

  get revieweeInput() {
    return document.getElementById(this.revieweeInputIdValue)
  }

  get managerInput() {
    return document.getElementById(this.managerInputIdValue)
  }
}
