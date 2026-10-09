# NFR Requirements — Clarifying Questions

## Context

The walking skeleton focuses on CRUD + localStorage for the TODO app. This questionnaire clarifies specific NFR targets and constraints for the skeleton phase before detailing requirements.

---

## Q1: Performance Target for Skeleton Phase

**Question:** For the walking skeleton (CRUD operations, single-device, localStorage), what performance target is realistic and meets learning objectives?

**Current Requirement:** NFR1 specifies < 2 seconds load time on 4G throttling.

**Options:**

A. Stick with NFR1 target (< 2 seconds) — validates performance baseline for the skeleton
B. Relax to < 3 seconds for skeleton phase — prioritize simplicity; tighten in polish phase
C. Focus on interactive performance first (time-to-interactive) — load time is secondary for local app
D. Other approach

[Answer]: A

---

## Q2: Security Scope for Skeleton

**Question:** Given the skeleton is single-device, single-user, and localStorage-only, what security measures are essential vs. deferred?

**Current Requirement:** NFR2 (Accessibility), NFR4 (Code Quality), NFR5 (Code Style), NFR9 (No Console Errors).

**Options:**

A. Essential for skeleton: code quality + no secrets hardcoded + input validation; defer authentication & complex encryption to Phase 2
B. Essential: just code quality & linting; defer security validation to Phase 2
C. Full security posture now: validation + error handling + audit logging
D. Other approach

[Answer]: A

---

## Q3: Observability in Skeleton

**Question:** Should the skeleton include structured logging and monitoring, or just error handling?

**Specification Context:** NFR10 (State Management) covers state handling but doesn't specify monitoring.

**Options:**

A. Error handling only for skeleton — log errors to console in dev, error boundary in prod
B. Structured logging for key operations (task creation, localStorage sync, filtering)
C. Full observability: logs + metrics + alerts (overkill for local app)
D. Other approach

[Answer]: A

---

## Q4: Scalability Target

**Question:** For a single-device local app, what is the practical scaling target for the skeleton?

**Current Requirement:** NFR3 mentions no multi-device sync, no backend.

**Options:**

A. Single browser session, no concurrency concerns — just ensure state consistency
B. Multiple browser tabs on same device — state must sync across tabs via localStorage events
C. Full scalability engineering (unnecessary for POC)
D. Other approach

[Answer]: A

---

## Q5: Reliability & Data Durability

**Question:** If localStorage fails, what is the acceptable degradation for the skeleton?

**Specification Context:** NFR6 mentions error display if localStorage fails and save is disabled.

**Options:**

A. Graceful degradation: in-memory only, user warned, save disabled, app fully functional
B. Fail fast: disable app if localStorage unavailable
C. Hybrid: try localStorage, fall back to in-memory, no warning
D. Other approach

[Answer]: A

---

## Q6: Code Quality Targets

**Question:** For a spec-review scope with 40% coverage floor, what code quality gates are realistic?

**Options:**

A. Prettier + ESLint (zero-config) + 40% line coverage via Jest/React Testing Library
B. Add SonarQube or code complexity limits — overkill for skeleton
C. Focus on linting only; defer coverage to Phase 2
D. Other approach

[Answer]: A

---

## Q7: Tech Stack Lock-In

**Question:** Should NFR Requirements lock the tech stack decisions for the skeleton, or defer to code generation?

**Specification Context:** Team confirmed React 18 + Vite + localStorage, no external UI frameworks.

**Options:**

A. Lock now in tech-stack-decisions.md: React 18, Vite, Prettier, ESLint, Jest, React Testing Library
B. Keep high-level (React, Vite) and let code generation optimize tooling
C. Lock only React + Vite; let developer choose testing framework
D. Other approach

[Answer]: A

---

## Q8: Browser Compatibility Scope

**Question:** For the skeleton, should we target all modern browsers or narrow the scope?

**Current Requirement:** NFR3 lists Chrome, Firefox, Safari, Edge (latest 2 versions).

**Options:**

A. Full scope (all 4 browsers latest 2 versions) — validates cross-browser baseline
B. Primary browsers (Chrome + Firefox) only — reduce test matrix for skeleton
C. Chrome only for skeleton; expand in Phase 2
D. Other approach

[Answer]: A

---

## Q9: Accessibility Priority

**Question:** For the skeleton, is full WCAG 2.1 AA compliance required, or can some features be deferred?

**Current Requirement:** NFR2 requires keyboard navigation, labels, color contrast, focus indicators.

**Options:**

A. Full WCAG 2.1 AA for skeleton — validates accessibility baseline from day one
B. Core accessibility (keyboard, labels) for skeleton; defer advanced features (screen reader optimization) to Phase 2
C. Defer accessibility to Phase 2 — focus on CRUD functionality first
D. Other approach

[Answer]: A

---

## Q10: Definition of Walking Skeleton Completion

**Question:** What criteria confirm the walking skeleton meets NFR requirements?

**Options:**

A. Verification command (launch app, add/edit/delete task, refresh, verify persistence) + all NFRs green in build-and-test
B. Verification command + no console errors + pass all WCAG AA checks
C. Verification command only — NFRs verified in Phase 2
D. Other approach

[Answer]: A

---

## Consolidated Summary Confirmation

**NFR Requirements Clarification Complete:**

All 10 clarifying questions have been answered, defining the specific NFR scope for the walking skeleton:

1. Performance: < 2 seconds load time (NFR1 baseline)
2. Security: Input validation + no hardcoded secrets (Phase 2 deferral for complex security)
3. Observability: Error handling + console logging (skeleton scope)
4. Scalability: Single session, no concurrency engineering
5. Reliability: Graceful degradation if localStorage fails
6. Code Quality: Prettier + ESLint + 40% coverage
7. Tech Stack: Locked — React 18, Vite, Jest, React Testing Library
8. Browser Compatibility: All 4 modern browsers (latest 2 versions)
9. Accessibility: Full WCAG 2.1 AA compliance
10. Skeleton Completion: Verification command + NFRs green

**Does this summary look correct?**

[Answer]: Looks correct

