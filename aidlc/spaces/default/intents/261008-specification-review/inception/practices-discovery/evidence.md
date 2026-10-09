# Evidence and References

## Org-Level Defaults Consulted

All affirmed practices are aligned with or specialize org-level defaults from `aidlc/spaces/default/memory/org.md`:

| Practice | Org Default | Specialist | Alignment |
|----------|-------------|-----------|-----------|
| Trunk-based development | § Way of Working | Pipeline | Direct affirmation; no deviation |
| Squash-merge to main | § Way of Working | Pipeline | Direct affirmation |
| Walking skeleton strategy | § Walking Skeleton | Developer, Quality | Specialization for spec-review scope; skeleton-first affirmation |
| BDD methodology | § Testing Posture | Quality | Scenario-driven validation better aligns with specification validation |
| 40% coverage floor | § Testing Posture | Quality | Aligns with spec-review scope defaults (no extra floor beyond org) |
| Prettier formatter | § Code Style | Developer | Language idiomatic for JS/TS; org defers to project config |
| ESLint linter | § Code Style | Developer | Aligned with org; project-level enforcement in CI |
| PascalCase components | § Code Style | Developer | React convention; essential for hooks/component rules |
| camelCase variables | § Code Style | Developer | Language idiomatic for JS/TS |
| Auto-deploy to staging | § Deployment | Pipeline | Direct affirmation |
| Manual gate for production | § Deployment | Pipeline | Direct affirmation; tech lead sign-off |

## Scope and Project Context

- **Scope:** `spec-review` (specification validation, learning-focused)
- **Project:** TODO app specification review (`261008-specification-review`)
- **Phase:** Inception (Practices Discovery stage)
- **Team Size:** 1–2 developers
- **Tech Stack:** React/JavaScript/TypeScript with localStorage

### Scope-Specific Decisions

**Spec-Review Scope Coverage Floor:**
- Org default (`org.md`): "spec-review, refactor, bugfix, security-patch ... add no extra new-test floor and require the existing suite to remain green."
- **Original Proposal:** 70% coverage floor (test-after methodology)
- **Quality Specialist Finding:** Original 70% contradicted org defaults; misaligned with learning objectives.
- **Team Affirmation:** 40% coverage floor with BDD methodology (Option C).
- **Rationale:** BDD provides better specification validation than test-after. Scenarios document and validate requirements simultaneously. 40% aligns with spec-review defaults; learning/documentation value > test burden.

**Deployment Ceremony:**
- Org default: Staging auto-deploy + manual production approval.
- **Team Affirmation:** Same (no specialization needed).
- **Rationale:** POC phase is learning-friendly; manual gate prevents premature production exposure.

**Security Enhancements:**
- Org default: Defer to Phase 2 for spec-review scope.
- **Team Affirmation:** Phase 2 defers secrets management, localStorage validation, npm scanning.
- **Rationale:** POC phase focuses on specification validation; security hardening comes in Phase 2.

## Architecture and Design

### Skeleton Architecture

The walking skeleton covers:
- **UI Layer:** React components (Task list, Task item, Add task form)
- **Business Logic:** Task CRUD operations (add, view, edit, delete)
- **Persistence:** localStorage API for cross-session state
- **Integration:** Component ↔ localStorage sync
- **Verification:** Human-authorized command: "Launch app → add task → refresh → confirm persistence → edit → delete → confirm changes persist"

Excluded from skeleton (secondary features):
- Filtering and search
- Dark mode
- Styling (basic CSS only; Tailwind added later)
- Due dates and priority levels

### CI/CD Pipeline

**Stages:**
1. Lint (ESLint on all commits)
2. Format check (Prettier on all commits)
3. Build (React build)
4. Test (Jest + React Testing Library)
5. Coverage report (must meet 40% floor)
6. Deploy to staging (automatic on merge)
7. Smoke tests (post-deploy health checks)
8. Manual approval gate (before production)

**Failure Behavior:**
- Lint or format failure → blocks merge
- Test or coverage failure → blocks merge
- Build failure → blocks merge
- Smoke test failure (staging) → automatic rollback
- Production deploy → requires manual approval (cannot block via automation)

## Specification Alignment

From `261008-specification-review` project description:

> "A TODO app where users can manage tasks with add, view, edit, and delete functionality. Initial storage is localStorage for simplicity."

**Mapping to Skeleton:**
- ✓ Add tasks (title, optional description)
- ✓ View all tasks (list display)
- ✓ Edit tasks
- ✓ Delete tasks
- ✓ localStorage persistence

**Secondary Features (post-skeleton):**
- Search/filter by title, status
- Dark mode toggle
- Styling enhancements
- Due dates and priority (if scope expands)

## Testing Strategy Alignment

**BDD Approach (Scenario-Driven):**

From `org.md` Testing Posture § Methodology:
- "Affirm a stricter posture in `team.md` if the team commits to one."

**Team Affirmation:** BDD (Behavior-Driven Development)
- **Methodology:** Scenario-first from acceptance criteria
- **Ordering:** Write scenarios from acceptance criteria first, then implement features
- **Scenario Mapping:** 10 acceptance criteria map to BDD scenarios (1:1)
- **Test Scope:** Feature scenarios (Gherkin format) + unit tests (utilities/components) + integration tests (localStorage)
- **Coverage:** 40% line coverage floor (appropriate for learning project)

**Per-Layer Implementation:**
1. Task component (unit tests for rendering, event handling)
2. Task list component (unit tests for list operations)
3. Task utilities (unit tests for validation, formatting)
4. localStorage integration (integration tests for persistence)
5. CRUD flows (scenario tests validating end-to-end workflows)

**Coverage Tracking:**
- Jest + Babel coverage reporter
- CI enforces 40% line coverage floor
- Branching coverage tracked but not gated

## Code Style Alignment

From `org.md` Code Style:
> "Formatter: Prettier (JS/TS), ... Linter: ESLint, Ruff, golangci-lint, etc. Run in CI before merge; failure blocks the PR."

**Configuration:**
- `.prettierrc`: Default Prettier settings (2-space indent, trailing commas, etc.)
- `.eslintrc.json`: ESLint with React plugin, `eslint-plugin-react-hooks` for hooks enforcement
- **Component Naming:** PascalCase (TaskList, TaskForm, TaskItem) — React convention
- **Variable Naming:** camelCase (taskList, addTask, isComplete) — JavaScript idiomatic
- **File Organization:** Feature-based structure (`src/features/<feature>/components`, `src/shared/utils`, `src/shared/hooks`)
- **Error Handling:** Try/catch or .catch() for async; localStorage operations validate/handle parse errors
- **CI Enforcement:** Pre-commit hook (husky) + CI pipeline both enforce format and lint

## Deployment Strategy Alignment

From `org.md` Deployment:
> "We deploy on merge to staging environments. Production deploys gate on a separate manual approval — typically tech lead + product owner sign-off."

**Staging:**
- Trigger: Merge to `main` after CI passes
- Frequency: Continuous (every commit)
- Health Checks: App loads, basic CRUD operations work, localStorage syncs correctly

**Production:**
- Trigger: Manual approval (tech lead sign-off)
- Frequency: Ad-hoc (human-gated)
- Rollback: Automated if health checks fail; documented manual procedure if needed
- Strategy: Simple rolling restart (POC phase); upgrade to blue-green or canary if multi-instance

## Specialist Review Process

| Specialist | Focus Area | Finding | Resolution |
|-----------|-----------|---------|-----------|
| **Quality Agent** | Testing methodology, coverage floor, CI gating | Original 70% contradicted org defaults for spec-review | Recommended Option C: BDD + 40% coverage (better specification validation) |
| **Developer Agent** | Code style, project setup, file organization | Gaps in component naming, hooks enforcement, file structure | PascalCase components, react-hooks ESLint plugin, feature-based structure |
| **DevSecOps Agent** | Deployment safety, security guardrails, rollback procedures | Validated auto-deploy to staging, manual production gate, smoke tests; identified Phase 2 security gaps | Affirmed deferral of secrets, localStorage validation, npm scanning to Phase 2 |

## Sign-Off Tracking

- **Human Approval:** 2026-10-08 (practices proposal approved)
- **Quality Agent Review:** 2026-10-08 (affirmed Option C)
- **Developer Agent Review:** 2026-10-08 (affirmed refinements)
- **DevSecOps Agent Review:** 2026-10-08 (affirmed Phase 2 deferral)
- **Practices Promotion:** 2026-10-09 (PRACTICES_AFFIRMED audit event)
- **Learnings Recording:** 2026-10-09 (7 learnings recorded to project.md)

---

## Related Artifacts

- **team-practices.md:** Final affirmed practices (in aidlc/spaces/default/memory/team.md)
- **practices-discovery-timestamp.md:** Metadata (stage, dates, affirmation timestamp)
- **aidlc/spaces/default/memory/org.md:** Org-level defaults (framework baseline)
- **aidlc/spaces/default/memory/project.md:** Project-level specialization and learnings
- **261008-specification-review/inception/practices-discovery-questions.md:** Team interview responses
