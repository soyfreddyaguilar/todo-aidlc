# Team-Level Rules

> This team's affirmed practices and corrections. Loaded after `org.md` as
> strict-additive guidance; contradictions with broader policy are rejected.
> Populated by the practices-discovery affirmation gate. Edit at the gate,
> not directly.

## Way of Working

We use **trunk-based development**:

- All work branches off `main` and merges back via short-lived feature branches (target: < 2 days)
- No long-lived branches; they accumulate merge debt
- Each completed Bolt **squash-merges** to `main` as a single commit, named by Bolt slug
- Full Bolt commit history is preserved on the source branch until worktree discard
- This gives us a clean, linear `main` history (1:1 mapping to Bolt sequence) while preserving auditability via the event log

Affirmed: 2026-10-08, Practices Discovery stage

## Walking Skeleton

For this specification-review project, the walking skeleton is:

**V1 Skeleton:** Build a working TODO app with core CRUD functionality stored in localStorage. The skeleton demonstrates:
- Add a task (title, optional description)
- View all tasks (list display)
- Edit a task (title, description)
- Delete a task
- Persistence across browser refresh (localStorage)

**Skeleton Verification Command:** Launch the app, add a TODO task, refresh the browser, confirm the task persists. Edit it, delete it, confirm changes persist.

**After Skeleton Approval**, iterate on secondary features:
- Task filtering (completed, active, all)
- Search/filter by title
- Dark mode toggle
- Enhanced custom CSS styling
- Due dates and priority levels

Affirmed: 2026-10-08, Practices Discovery stage

## Testing Posture

- **Methodology:** BDD (behavior-driven development; scenario-driven testing)
- **Ordering:** Write scenarios from acceptance criteria first, then implement features to satisfy those scenarios.
- **Coverage Floor:** 40% line coverage (aligned with spec-review scope; no extra floor beyond org defaults)
- **Scenario Mapping:** 10 acceptance criteria map directly to test scenarios; each scenario validates one acceptance criterion
- **CI Execution:** Tests run on all PRs and merge commits; test failure blocks merge to `main`
- **Test Scope:** Feature scenarios (Gherkin format or equivalent) for the 10 acceptance criteria; unit tests for utilities and components; integration tests for localStorage persistence
- **Rationale:** Specification-driven validation ensures the app meets the recorded acceptance criteria; BDD scenarios create a executable specification that serves as both documentation and verification

Affirmed: 2026-10-08, Practices Discovery stage (revised per quality specialist feedback; Option C from testing practices review)

## Guard Policy

<!-- Affirmed by the team. Mode: strict, relaxed, or off. Strict here holds for every intent and cannot be changed from chat. A section under the retired Change Control heading, written by an earlier release, is still read. -->

## Deployment

- **Staging Environment:** Automatic deployment on merge to `main` (after CI passes: linting, tests, build)
- **Production Environment:** Manual approval gate; requires tech lead sign-off before production deployment
- **Smoke Tests:** Post-deployment health checks confirm app loads, basic CRUD operations work, localStorage syncs correctly
- **Rollback:** Automated rollback if health checks fail; manual rollback procedure documented (revert commit, redeploy, verify)
- **Deployment Strategy:** Simple rolling restart for POC phase; upgrade to blue-green or canary if multi-instance needed
- **Phase 2 Security Enhancements (Deferred):** Environment variable secrets management, localStorage data validation/schema checking, npm dependency vulnerability scanning

Affirmed: 2026-10-08, Practices Discovery stage (security refinements deferred to Phase 2 per team decision)

## Code Style

- **Formatter:** Prettier (JavaScript/TypeScript default settings)
- **Linter:** ESLint with React plugin, react-hooks enforcement, and recommended rules
- **Component Naming:** PascalCase for React components (e.g., TaskList, TaskForm)
- **Naming Conventions:** camelCase for JavaScript/TypeScript variables, functions, and imports (language idiomatic)
- **File Organization:** Feature-based structure with `src/features/<feature>/components`, `src/shared/utils`, `src/shared/hooks` for reusable logic
- **Configuration:** `.prettierrc` and `.eslintrc.json` at repo root; CI enforces both before merge
- **Import/Export:** Both named and default exports allowed; no team restriction
- **Error Handling:** All async operations include try/catch or .catch() handlers; localStorage operations validate and handle parse errors; errors logged to console in development, reported to error boundary in production

Affirmed: 2026-10-08, Practices Discovery stage (includes all refinements from developer specialist review)

## Forbidden

<!-- Team-specific forbidden patterns -->

## Mandated

<!-- Team-specific mandates -->

## Corrections

<!-- Self-learning loop appends here. -->
