# Discovered Rules — Supporting Evidence and Reasoning

## Overview

This document explains the reasoning behind each affirmed practice and traces them to the specification, team context, and org-level defaults.

---

## Way of Working — Trunk-Based Development

### Context

The project is a learning/POC for a TODO app specification review. The team is small (1–2 developers) and work is expected to be incremental with frequent integration.

### Decision

Affirm **trunk-based development** with squash-merge to `main`.

### Reasoning

1. **Org-Level Default:** `org.md` already specifies trunk-based development, short-lived feature branches, and squash-merge pattern. We are not deviating; we are affirming alignment.
2. **Scope Fit:** POC/learning scope suits short-lived branches. We expect to iterate quickly, and merging frequently keeps the main branch always deployable.
3. **Auditability:** Squash-merge preserves a clean `main` history (1:1 with Bolts) while the event log captures the full commit history. This balances readability with auditability.
4. **No Long-Lived Branches:** We avoid release branches, staging branches, or develop branches. Instead, we use tags and environment configs to gate production deploys.

### Traceability

- Org default: `org.md` § Way of Working (affirmed in framework)
- Scope: `261008-specification-review` (POC scope → short iteration cycles)

---

## Walking Skeleton — Core CRUD + localStorage

### Context

The specification describes a TODO app. The team wants to build iteratively and verify working software early. The skeleton strategy is enabled for this project (`skeleton: on`).

### Decision

Affirm a **walking skeleton** of Add/Edit/Delete/View tasks with localStorage persistence.

### Reasoning

1. **Org-Level Default:** `org.md` § Walking Skeleton requires that when `skeleton: on`, we identify the smallest working integrated slice and verify it before later Units/features.
2. **V1 Scope:** The skeleton covers the absolute minimum for a TODO app: add, view, edit, delete, and persistence. It excludes filtering, search, and styling as secondary features.
3. **Verification:** The skeleton is verified by a recorded, human-authorized Construction Verification Command: "Launch app → add task → refresh → confirm persistence → edit → delete → confirm changes persist."
4. **Checkpoint Approval:** After skeleton is verified, the human approves it at a checkpoint before iterating on secondary features (filtering, dark mode, etc.).
5. **Separation of Concerns:** This skeleton tests the core domain logic (task CRUD) independently of styling and secondary features, reducing integration risk.

### Traceability

- Org default: `org.md` § Walking Skeleton
- Scope: `261008-specification-review` (POC scope → early verification desired)
- Specification: TODO app with add/edit/delete/view

---

## Testing Posture — Test-After with 70% Coverage

### Context

The scope is `poc` (proof of concept). The org default for POC is "no extra new-test floor; existing suite remains green." However, since we are building from scratch, we are defining a floor for this project.

### Decision

Affirm **test-after methodology** with **70% line coverage floor** and **per-layer testing**.

### Reasoning

1. **Org-Level Default:** `org.md` § Testing Posture says POC scope has "no extra new-test floor" by default. We are defining a stricter posture locally because:
   - We are building a learning project; tests serve as executable documentation.
   - 70% is a realistic floor for a POC (pragmatic, not burdensome).
   - It's lower than enterprise (80%) because the scope is exploratory.

2. **Test-After Methodology:** We implement the feature (component, utility, CRUD flow), then write and run tests. This is appropriate for a POC where the design is evolving.
3. **Per-Layer Ordering:** We implement a layer (e.g., Task component), then test that layer (unit tests), before moving to the next layer (persistence, search). This reduces debugging complexity.
4. **CI Gating:** Tests run on PRs and merge commits. Failure blocks merge. This prevents untested code from reaching `main`.
5. **Coverage Measurement:** We measure line coverage; branching coverage is a stretch goal.

### Traceability

- Org default: `org.md` § Testing Posture (POC: no extra floor, but affirming 70% locally)
- Scope: `poc` → learning/exploratory
- Quality: Test layer-by-layer to catch integration errors early

---

## Code Style — Prettier + ESLint

### Context

The project is a React/JavaScript TODO app. The org default defers to project-level configs.

### Decision

Affirm **Prettier** (formatter) and **ESLint** (linter) with React plugin, camelCase naming.

### Reasoning

1. **Org-Level Default:** `org.md` § Code Style says "defer to project-level configurations; formatter, linter, and naming conventions are language idiomatic." We are affirming the JavaScript/React defaults.
2. **Prettier:** Industry standard for JS/TS formatting. Zero-config approach (default settings) reduces bikeshedding.
3. **ESLint + React:** Catches common mistakes (missing dependencies, incorrect hook usage, etc.). React plugin is essential for this scope.
4. **camelCase:** JavaScript/TypeScript idiomatic naming (functions, variables, imports). No custom renaming rules.
5. **CI Enforcement:** Linting and formatting are checked in CI; failures block merge. This ensures consistency.
6. **Error Handling:** Async operations include try/catch or .catch(); errors are logged in development and reported to an error boundary in production.

### Traceability

- Org default: `org.md` § Code Style (language idiomatic)
- Tech stack: React/JavaScript (POC learning scope)

---

## Deployment — Auto-to-Staging, Manual Gate for Production

### Context

The org default specifies "deploy on merge to staging environments" with "manual approval for production."

### Decision

Affirm **automatic deployment to staging** on merge to `main`, with **manual approval gate for production**.

### Reasoning

1. **Org-Level Default:** `org.md` § Deployment already specifies this pattern. We are affirming it.
2. **Staging Auto-Deploy:** After CI passes (linting, tests, build), the app auto-deploys to staging. This gives fast feedback without human ceremony.
3. **Production Manual Gate:** A tech lead must approve before production deployment. For a POC, this is tech lead approval only (not a full change advisory board).
4. **Smoke Tests:** Post-deploy health checks confirm the app loads, basic CRUD works, and localStorage syncs. If they fail, deployment is rolled back.
5. **Rollback Procedure:** If health checks fail, we revert the commit, redeploy, and verify. This is documented in a runbook.
6. **Strategy:** Simple rolling restart for POC phase (single instance or small cluster). Upgrade to blue-green or canary if we scale.

### Traceability

- Org default: `org.md` § Deployment
- Scope: `poc` (small, learning-friendly deployment ceremony)
- Safety: Smoke tests + manual production gate

---

## Deviations from Org Defaults

**None.** All affirmed practices align with or specialize the org-level defaults. No contradictions.

---

## Open Questions Resolved

1. **Coverage floor for POC?** Affirmed 70% (lower than enterprise 80%, pragmatic for learning).
2. **Formatter/Linter?** Affirmed Prettier + ESLint (industry standard for React/JS).
3. **Manual or automatic production deploy?** Affirmed manual gate (tech lead sign-off).
4. **Skeleton first or feature-major?** Affirmed skeleton-first (org default for `skeleton: on`).
5. **Test methodology?** Affirmed test-after (aligns with POC scope, appropriate for evolving design).

---

## Specialist Review Inputs

- **Quality Agent:** Validates 70% coverage floor and test-after methodology against scope.
- **Developer Agent:** Validates Prettier + ESLint configuration and project setup.
- **DevSecOps Agent:** Validates deployment gating and smoke test strategy.

(Inputs will be recorded below as specialists review.)

---

## Decision Log

- **2026-10-08, 19:45 UTC:** Team practices proposed and approved by human. Proceeding to specialist review.
