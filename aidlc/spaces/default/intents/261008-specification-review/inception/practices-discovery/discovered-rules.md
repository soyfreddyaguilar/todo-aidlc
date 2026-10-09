# Discovered Rules — Supporting Evidence and Reasoning

## Overview

This document explains the reasoning behind each affirmed practice and traces them to the specification, team context, and org-level defaults.

---

## Way of Working — Trunk-Based Development

### Context

The project is a learning/POC for a TODO app specification review. The team is small and work is expected to be incremental with frequent integration.

### Decision

Affirm **trunk-based development** with squash-merge to `main`.

### Reasoning

1. **Org-Level Default:** `org.md` specifies trunk-based development with short-lived feature branches (< 2 days) and squash-merge pattern.
2. **Scope Fit:** POC/learning scope suits short-lived branches for frequent integration.
3. **Auditability:** Squash-merge preserves clean `main` history (1:1 with Bolts) while event log captures full commit history.
4. **No Long-Lived Branches:** Avoid release/staging/develop branches; use tags and environment configs for gating.

### Traceability

- Org default: `org.md` § Way of Working
- Scope: `spec-review` (POC scope → short iteration cycles)

---

## Walking Skeleton — Core CRUD + localStorage

### Context

The specification describes a TODO app. Team wants to build iteratively and verify working software early. Skeleton strategy enabled (`skeleton: on`).

### Decision

Affirm a **walking skeleton** of Add/Edit/Delete/View tasks with localStorage persistence.

### Reasoning

1. **Org-Level Default:** `org.md` requires smallest working integrated slice when `skeleton: on`.
2. **V1 Scope:** Covers absolute minimum: add, view, edit, delete, persistence. Excludes filtering, search, styling.
3. **Verification:** Human-authorized command: "Launch app → add task → refresh → confirm persistence → edit → delete → confirm changes persist."
4. **Checkpoint Approval:** Human approves skeleton before iterating on secondary features.
5. **Risk Reduction:** Core domain logic (CRUD) tested independently of styling and secondary features.

### Traceability

- Org default: `org.md` § Walking Skeleton
- Scope: `spec-review` (POC scope → early verification)
- Specification: TODO app with add/edit/delete/view

---

## Testing Posture — BDD with 40% Coverage

### Context

Scope is `spec-review`. Org default for spec-review is "no extra new-test floor." Quality specialist identified that original proposal (70% test-after) contradicted org defaults and misaligned with learning objectives.

### Decision

Affirm **BDD (behavior-driven development)** with **40% line coverage floor**, mapped to 10 acceptance criteria.

### Reasoning

1. **Org-Level Default:** `org.md` § Testing Posture says spec-review adds "no extra new-test floor beyond org defaults." Option C aligns with this.
2. **Methodology:** BDD (scenario-first) better validates specifications than test-after. Scenarios document requirements while validating them.
3. **Coverage Floor:** 40% is pragmatic for learning project; aligns with spec-review scope defaults.
4. **Scenario Mapping:** 10 acceptance criteria map to BDD scenarios (1:1). Each scenario validates one criterion.
5. **CI Gating:** Tests run on PRs and merge commits. Test failure blocks merge to `main`.
6. **Test Scope:** Feature scenarios (Gherkin format) for 10 ACs; unit tests for utilities/components; integration tests for localStorage.

### Traceability

- Org default: `org.md` § Testing Posture (spec-review scope + no extra floor)
- Quality specialist feedback: Option C recommended for specification validation
- Scope: `spec-review` → learning/documentation value > test burden

---

## Code Style — Prettier + ESLint with React Specialization

### Context

Project is React/JavaScript TODO app. Org default defers to project-level configs and language idiom.

### Decision

Affirm **Prettier** (formatter) and **ESLint** (linter) with React plugin, PascalCase component naming, camelCase variables.

### Reasoning

1. **Org-Level Default:** `org.md` § Code Style defers to language idiomatic conventions.
2. **Prettier:** Industry standard for JS/TS; zero-config defaults reduce bikeshedding.
3. **ESLint + React:** Catches common mistakes; React plugin essential for hooks/component rules.
4. **Component Naming:** PascalCase for React components (TaskList, TaskForm); camelCase for variables/functions/imports.
5. **File Organization:** Feature-based structure (`src/features/<feature>/components`, `src/shared/utils`) supports BDD scenario mapping.
6. **Error Handling:** Async operations include try/catch or .catch(); localStorage validates/handles parse errors.
7. **CI Enforcement:** Linting and formatting checked in CI; failures block merge.

### Traceability

- Org default: `org.md` § Code Style (language idiomatic)
- Developer specialist feedback: All refinements affirmed (PascalCase, hooks enforcement, feature-based structure)
- Tech stack: React/JavaScript/TypeScript

---

## Deployment — Auto-to-Staging, Manual Gate for Production

### Context

Org default specifies "deploy on merge to staging" with "manual approval for production."

### Decision

Affirm **automatic deployment to staging** on merge to `main`, with **manual approval gate for production**.

### Reasoning

1. **Org-Level Default:** `org.md` § Deployment specifies this pattern already.
2. **Staging Auto-Deploy:** After CI passes (linting, tests, build), app auto-deploys to staging for fast feedback.
3. **Production Manual Gate:** Tech lead approval required before production deployment (POC phase).
4. **Smoke Tests:** Post-deploy health checks confirm app loads, basic CRUD works, localStorage syncs.
5. **Rollback:** Automated rollback if health checks fail; manual procedure documented (revert commit, redeploy, verify).
6. **Strategy:** Simple rolling restart for POC phase; upgrade to blue-green or canary if multi-instance.
7. **Phase 2 Deferral:** Security enhancements (secrets management, localStorage validation, npm scanning) deferred to Phase 2.

### Traceability

- Org default: `org.md` § Deployment
- Scope: `spec-review` (POC phase → simple deployment ceremony)
- DevSecOps specialist feedback: Security refinements deferred to Phase 2

---

## Deviations from Org Defaults

**None.** All affirmed practices align with or specialize org-level defaults. No contradictions detected.

---

## Learnings & Specialist Inputs

### Quality Specialist Review
- **Finding:** Original 70% coverage floor contradicted org defaults for spec-review scope.
- **Recommendation:** Option C (BDD + 40% coverage) better aligns with specification validation and learning objectives.
- **Status:** Affirmed 2026-10-09.

### Developer Specialist Review
- **Findings:** Identified gaps in component naming clarity, hooks enforcement, file organization guidance.
- **Enhancements:** PascalCase components, ESLint react-hooks plugin, feature-based structure, localStorage validation.
- **Status:** All refinements affirmed 2026-10-09.

### DevSecOps Specialist Review
- **Findings:** Identified security gaps (secrets management, localStorage data integrity, npm vulnerability scanning, health check formalization).
- **Resolution:** Affirmed deferral of security enhancements to Phase 2 as appropriate for POC phase.
- **Status:** Affirmed 2026-10-09.

---

## Decision Timeline

- **2026-10-08:** Team practices proposed with initial options (Way of Working, Walking Skeleton, Testing Posture, Deployment, Code Style).
- **2026-10-08:** Quality specialist identified testing posture misalignment; proposed Option C (BDD + 40%).
- **2026-10-08:** Developer and DevSecOps specialists reviewed and provided refinements.
- **2026-10-08–2026-10-09:** Team affirmed practices across all five areas.
- **2026-10-09:** Seven learnings recorded to project memory (interpretations, deviations, tradeoffs).
- **2026-10-09:** Practices promoted to team.md with PRACTICES_AFFIRMED audit event.
