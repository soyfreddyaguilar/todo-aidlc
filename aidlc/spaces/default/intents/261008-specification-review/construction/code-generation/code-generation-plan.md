# Code Generation Plan — TODO App Specification Review

## Project Overview

Build a working React 18 + Vite TODO application that implements the complete specification defined in Requirements Analysis. The app demonstrates team mastery of React patterns, component-based architecture, BDD testing methodology, and localStorage persistence.

**Target folder:** `D:\PROJECTS\POC\poc-test\projects\todo-app` — the existing fresh Vite + React template (React 19, Vite 8, `oxlint` configured). All application code, tests, and configuration are generated directly in this folder, extending the template. Nothing is generated inside the record folder except the planning artifacts.

**Scope:** spec-review (Learning-focused)
**Testing Methodology:** BDD (Behavior-Driven Development)
**Coverage Floor:** 40% line coverage (aligned with spec-review scope)
**Test Ordering:** Write executable BDD scenarios first, then implement features to satisfy those scenarios.

---

## Testing Contract

```json
{
  "version": 1,
  "methodology": "bdd",
  "source": "team",
  "ordering": "** Write scenarios from acceptance criteria first, then implement features to satisfy those scenarios.",
  "scope": "spec-review",
  "test_strategy": "standard",
  "project_type": "greenfield",
  "applicable_notes": [
    {
      "layer": "org",
      "text": "We treat tests as a first-class deliverable in every Bolt. The specific\nmethodology (TDD, BDD, ATDD, or classic test-after) is affirmed at\npractices-discovery and recorded in `team.md` under this heading with explicit\n`Methodology` and `Ordering` fields; Code Generation resolves those fields\nindependently from coverage, tooling, and scope notes.\n\nWhen no posture has been affirmed, our default per scope is:\n- **Methodology**: test-after\n- **Ordering**: implement each applicable testable layer, then write and run\n  that layer's tests.\n- `mvp`, `enterprise`, `feature`, `infra`, `classic` add an 80% line-coverage\n  floor and CI execution before merge.\n- `bugfix`, `security-patch` add a targeted regression for the specific\n  bug/vulnerability and require the existing suite to remain green.\n- `express` uses the Minimal strategy: requirement-driven unit tests (one per\n  requirement, with a happy-path floor per component); existing tests remain\n  green.\n- `poc`, `refactor`, `workshop` add no extra new-test floor and require the\n  existing suite to remain green.\n\nThe active `Test Strategy` still applies in every scope and determines test\nvolume/types. Scope floors are additive; they never reduce or replace the\nselected strategy.\n\nBuild and Test verifies defined coverage floors and affirmed quality targets;\nthey may not be weakened to make a step pass.\n\nAffirm a stricter posture in `team.md` if the team commits to one."
    },
    {
      "layer": "team",
      "text": "- **Methodology:** bdd\n- **Ordering:** Write scenarios from acceptance criteria first, then implement features to satisfy those scenarios.\n- **Coverage Floor:** 40% line coverage (aligned with spec-review scope; no extra floor beyond org defaults)\n- **Scenario Mapping:** 10 acceptance criteria map directly to test scenarios; each scenario validates one acceptance criterion\n- **CI Execution:** Tests run on all PRs and merge commits; test failure blocks merge to `main`\n- **Test Scope:** Feature scenarios (Gherkin format or equivalent) for the 10 acceptance criteria; unit tests for utilities and components; integration tests for localStorage persistence\n- **Rationale:** Specification-driven validation ensures the app meets the recorded acceptance criteria; BDD scenarios create a executable specification that serves as both documentation and verification\n\nAffirmed: 2026-10-08, Practices Discovery stage (revised per quality specialist feedback; Option C from testing practices review)"
    }
  ],
  "obligations": {
    "strategy": "standard",
    "strategy_volume": [
      "Five to eight tests per component.",
      "Unit tests plus integration tests for key boundaries.",
      "Add E2E, performance, or security tests when requirements demand them."
    ],
    "scope_floor": [
      "Keep the existing test suite green.",
      "This scope adds no extra new-test floor beyond the selected test strategy."
    ],
    "combination_rule": "Apply every selected-strategy obligation and every scope-floor obligation; neither replaces the other, and a targeted scope regression may add the narrowest necessary test type beyond the strategy default."
  },
  "plan_profile": {
    "methodology": "bdd",
    "runner_step": "Bootstrap the minimal test runner/configuration and record the exact unit-scoped command.",
    "runner_ready_before_first_test": true,
    "testable_layers": [
      "Data model / database behavior",
      "Repository / data access",
      "Business logic",
      "API / endpoint",
      "Frontend behavior"
    ],
    "steps": [
      "Project structure and production configuration skeleton.",
      "Bootstrap the minimal test runner/configuration and record the exact unit-scoped command.",
      "Behavior scenarios - define executable examples for the observable feature slice before implementation.",
      "Feature slice - implement the required data, repository, business, API, and frontend layers.",
      "Behavior scenarios - run the scenarios until they pass.",
      "Feature slice - refactor while the scenarios stay green.",
      "Environment/build configuration.",
      "Documentation and traceability."
    ]
  },
  "input_sha256": "sha256:178f74f33bf6cd97f3bb285b6fcb3bdec2d13e7daef71b1824e168da981e5004",
  "contract_sha256": "sha256:69f8f597da01a3884bd026f13f20206d0df6996127da681054d68bd7b4234fcd"
}
```

---

## Implementation Plan

### Phase 1: Bootstrap & BDD Scenario Foundation

This phase sets up the project and creates BDD scenarios for all acceptance criteria before implementation.

- [ ] **Step 1: Project Setup** — Initialize Vite + React 18 project structure, install dependencies (React 18, React DOM, Vitest, React Testing Library)
- [ ] **Step 2-10: Write BDD Scenarios** — Create `src/features/tasks/tasks.feature.test.js` with 10 Gherkin-style scenarios (one per acceptance criterion)

### Phase 2: Component Architecture & Implementation

Implement feature components across all layers while keeping BDD scenarios green.

- [ ] **Step 11: Create Component Structure** — Set up `src/features/tasks/components/`, `src/shared/utils/`, `src/shared/hooks/`
- [ ] **Step 12-21: Implement Features** — Build InputForm, TaskList, TaskItem, Filters, DarkMode, Validation, Persistence (one step per FR)
- [ ] **Run scenarios green after each feature implementation**

### Phase 3: Quality & Integration Testing

Finalize test suite and verify coverage.

- [ ] **Step 22: Unit Tests for Utilities** — Create validation.test.js, localStorage.test.js, taskId.test.js (19 tests total)
- [ ] **Step 23: Integration Tests** — Create localStorage-integration.test.js (5 tests for CRUD workflows)
- [ ] **Step 24: Coverage Verification** — Verify ≥ 40% line coverage

### Phase 4: Build & Verification

- [ ] **Step 25: Build Configuration** — Configure Vite production build (target < 100 KB gzipped)
- [ ] **Step 26: Code Summary & Traceability** — Document code structure and FR/NFR mappings

---

## Quality Targets

- **Methodology**: BDD (scenario-first, 10 BDD scenarios before implementation)
- **Line Coverage**: 40% minimum (spec-review scope floor)
- **Test Breakdown**: 10 BDD scenarios + 19 unit tests + 5 integration tests = 34 tests total
- **Build Size**: < 100 KB gzipped (Vite production)
- **Code Quality**: ESLint passes with 0 errors, Prettier formatting applied

---

## Loop-Back Context

**Attempt**: 1/3
**Root Cause**: Previous generation produced planning artifacts but not workspace source files
**Fix Required**: Ensure complete source code output to workspace root (package.json, src/, config files, build scripts)
