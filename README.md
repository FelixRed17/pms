# Performance Review System

## Appetite

We are investing a fixed 6-week cycle to build a lightweight, scalable performance review system that removes administrative overhead for HR while increasing trust in the feedback process.

---

## Problem

HR teams spend significant time coordinating performance reviews:

- Manually sending reminders and collecting feedback
- Managing reviewer lists and follow-ups
- Ensuring anonymity in peer reviews
- Compiling feedback into reports

This leads to:

- High administrative overhead
- Delayed review cycles
- Reduced trust in anonymity
- Poor scalability as the company grows

---

## Solution

Build a system where HR can launch a review cycle and automate the entire review process:

- HR creates a review cycle
- HR assigns:
  - A **reviewee** (person being reviewed)
  - Up to **3 peer reviewers**
  - A **manager reviewer**
- Each participant receives a **secure magic link via email**
- Reviewees, peers, and managers submit feedback anonymously (except self-review)
- The system aggregates responses
- A **branded PDF report** is automatically generated and delivered to the employee

---

## Core User

**Primary user: HR**

HR owns the entire workflow:

- Creates and launches review cycles
- Selects participants
- Triggers feedback collection
- Oversees completion

---

## Key Flow

### 1. Create Review Cycle

HR fills out a review cycle form:

- Select reviewee (person being reviewed)
- Add up to 3 peer reviewers
- Add a manager reviewer

### 2. Send Invitations

System sends emails with secure magic links to:

- Reviewee (self-review)
- Peer reviewers
- Manager reviewer

### 3. Submit Feedback

- Each participant completes their review via their unique link
- No login required
- Peer and manager reviews are anonymous
- Self-review is not anonymous

### 4. Generate Report

- System aggregates all feedback
- Generates a branded PDF report

### 5. Deliver Report

- Final report is sent to the reviewee
- HR can optionally monitor completion status

---

## Constraints

- Reviews must remain anonymous (except self-review)
- Magic links must be secure, unique, and non-guessable
- No login friction for reviewers
- Minimal manual intervention from HR

---

## Success Metrics

- Reduce HR administrative time by **60–80%**
- Increase completion rate of reviews
- Improve trust in anonymity of peer feedback
- Enable scaling of review cycles without additional HR effort

---

## Out of Scope (For Now)

- Complex performance analytics dashboards
- Continuous feedback systems
- Integration with external HR systems

---

## Risks & Open Questions

- How do we guarantee anonymity while preventing abuse?
- What happens if a reviewer does not complete their review?
- Should HR be able to resend or edit reviewer lists mid-cycle?
- How long should magic links remain valid?

---

## Pitch

This system transforms performance reviews from a manual, trust-fragile process into a streamlined, automated workflow.

By removing coordination overhead and guaranteeing anonymity, HR can run review cycles faster, employees can trust the process, and organizations can scale performance management effortlessly.
