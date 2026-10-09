# Evidence and References

## Org-Level Defaults Consulted

All affirmed practices are aligned with or specialize org-level defaults from `aidlc/spaces/default/memory/org.md`:

| Practice | Org Default | Specialist | Alignment |
|----------|-------------|-----------|-----------|
| Trunk-based development | § Way of Working | Pipeline | Direct affirmation; no deviation |
| Squash-merge to main | § Way of Working | Pipeline | Direct affirmation |
| Walking skeleton strategy | § Walking Skeleton | Developer, Quality | Specialization for POC scope; skeleton-first affirmation |
| Test-after methodology | § Testing Posture | Quality | Affirmation for POC scope; default for exploratory work |
| Prettier formatter | § Code Style | Developer | Language idiomatic for JS/TS; org defers to project config |
| ESLint linter | § Code Style | Developer | Aligned with org; project-level enforcement in CI |
| camelCase naming | § Code Style | Developer | Language idiomatic for JS/TS |
| Auto-deploy to staging | § Deployment | Pipeline | Direct affirmation |
| Manual gate for production | § Deployment | Pipeline | Direct affirmation; tech lead sign-off |

## Scope and Project Context

- **Scope:** `poc` (proof of concept, learning-focused)
- **Project:** TODO app specification review (`261008-specification-review`)
- **Phase:** Inception (Practices Discovery stage)
- **Team Size:** 1–2 developers
- **Tech Stack:** React/JavaScript/TypeScript with localStorage

### Scope-Specific Decisions

**POC Scope Default Coverage Floor:**
- Org default (`org.md`): "poc ... add no extra new-test floor and require the existing suite to remain green."
- **Team Affirmation:** 70% coverage floor (stricter than org default) to support learning and executable documentation.
- **Rationale:** Exploratory scope, but documentation value justifies higher floor; 70% is pragmatic (not burdensome), lower than enterprise (80%).

**POC Deployment Ceremony:**
- Org default: Staging auto-deploy + manual production approval (recommended).
- **Team Affirmation:** Same (no specialization needed).
- **Rationale:** POC scope is learning-friendly; manual gate prevents premature production exposure.

## Architecture and Design

### Skeleton Architecture

The walking skeleton covers:
- **UI Layer:** React components (Task list, Task item, Add task form)
- **Business Logic:** Task CRUD operations (add, view, edit, delete)
- **Persistence:** localStorage API for cross-session state
- **Integration:** Component ↔ localStorage sync

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
5. Coverage report (must meet 70% floor)
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

From `org.md` Testing Posture § Test-After:

> "Implement each applicable testable layer, then write and run that layer's tests."

**Per-Layer Implementation:**
1. Task component (unit tests for rendering, event handling)
2. Task list component (unit tests for list operations)
3. Task utilities (unit tests for validation, formatting)
4. localStorage integration (integration tests for persistence)
5. CRUD flows (end-to-end or integration tests for full workflows)

**Coverage Tracking:**
- Jest + Babel coverage reporter
- CI enforces 70% line coverage floor
- Branching coverage tracked but not gated

## Code Style Alignment

From `org.md` Code Style:

> "Formatter: Prettier (JS/TS), ... Linter: ESLint, Ruff, golangci-lint, etc. Run in CI before merge; failure blocks the PR."

**Configuration:**
- `.prettierrc`: Default Prettier settings (2-space indent, trailing commas, etc.)
- `.eslintrc.json`: ESLint with React plugin, extends `eslint:recommended` and `plugin:react/recommended`
- **CI Enforcement:** Pre-commit hook (husky) + CI pipeline both enforce format and lint

## Deployment Strategy Alignment

From `org.md` Deployment:

> "We deploy on merge to staging environments. Production deploys gate on a separate manual approval — typically tech lead + product owner sign-off."

**Staging:**
- Trigger: Merge to `main` after CI passes
- Frequency: Continuous (every commit)
- Health Check: App loads, CRUD endpoints respond, localStorage sync works

**Production:**
- Trigger: Manual approval (tech lead sign-off)
- Frequency: Ad-hoc (human-gated)
- Rollback: Automated if health checks fail; documented manual procedure if needed

## Specialist Review Process

| Specialist | Focus Area | Review Checklist |
|-----------|-----------|-----------------|
| **Quality Agent** | Testing methodology, coverage floor, CI gating | Validates 70% floor is appropriate for POC; test-after methodology is sound; layer-by-layer ordering prevents integration surprises |
| **Developer Agent** | Code style, project setup, build tooling | Validates Prettier + ESLint configuration; project structure supports test setup; no build or tool conflicts |
| **DevSecOps Agent** | Deployment safety, security guardrails, rollback procedures | Validates staging auto-deploy is safe; production manual gate is enforced; smoke tests cover critical paths; rollback is documented |

## Sign-Off Tracking

- **Human Approval:** 2026-10-08 (practices proposal approved)
- **Quality Agent Review:** (pending)
- **Developer Agent Review:** (pending)
- **DevSecOps Agent Review:** (pending)
- **Final Integration:** After all specialists approve, promote `team-practices.md` to `aidlc/spaces/default/memory/team.md` and mark Practices Discovery stage complete.

---

## Related Artifacts

- **team-practices.md:** Final affirmed practices (this intent)
- **practices-discovery-timestamp.md:** Metadata (stage, date, approvers)
- **aidlc/spaces/default/memory/org.md:** Org-level defaults (framework baseline)
- **261008-specification-review/inception/ideation-summary.md:** Initial scope and requirements
- **261008-specification-review/inception/specification-summary.md:** Detailed specification
