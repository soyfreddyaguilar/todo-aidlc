# Practices Discovery Interview

## Sources

This interview captures team affirmation of practices across five dimensions. Specialist feedback from quality, developer, and devsecops agents has identified gaps that require explicit team decisions.

---

## Q1: Way of Working — Version Control & Branching

**Question:** How should the team handle version control and feature integration?

**Context:** Org default is trunk-based development with short-lived branches (1-2 days) and squash-merge to main.

**Options:**

A. Trunk-based with short-lived branches (1-2 days), squash-merge to main
B. GitHub Flow with feature branches (3-5 days), squash-merge to main
C. Git Flow with develop + main, traditional merge commits
D. Other (specify)
X. Unclear — needs discussion

[Answer]: A

---

## Q2: Walking Skeleton — Vertical Slice First?

**Question:** Should the team build a thin end-to-end slice first? A walking skeleton is a minimal version that runs the whole way through, built first to prove the pieces connect before the real features go in.

**Context:** Org default is to build walking skeleton when scope declares it. For spec-review, the initial skeleton would be: task data model + create + list + localStorage persistence.

**Options:**

A. Yes — build walking skeleton first (CRUD + localStorage), then iterate
B. No — proceed directly to full feature build without skeleton checkpoint
C. Build skeleton only if time permits; prioritize full AC validation otherwise
D. Other
X. Unclear

[Answer]: A

---

## Q3: Testing Posture — BDD + 40% Coverage

**Question:** Does the team affirm BDD (behavior-driven development) with 40% coverage for specification validation?

**Context:** Specialist feedback resolved earlier misalignment by proposing scenario-driven testing mapped to the 10 acceptance criteria. This replaces test-after + 70% coverage with:

- **Methodology:** BDD (write scenarios from acceptance criteria first, then implement)
- **Coverage floor:** 40% (aligned with spec-review scope)
- **Ordering:** Scenario-first approach where scenarios document and validate spec requirements

This approach better validates the specification while remaining achievable for a learning project.

**Options:**

A. Affirm BDD + 40% — scenario-driven testing mapped to acceptance criteria
B. Keep test-after + 50% coverage (alternative from specialist)
C. Maintain original test-after + 70% coverage + CI enforcement
D. Other approach
X. Unclear

[Answer]: A

---

## Q4: Deployment — Security & Release Strategy

**Question:** Does the team affirm the deployment strategy with explicit attention to secrets, localStorage validation, and dependency scanning?

**Context:** DevSecOps specialist identified critical gaps:

- **Secrets Management:** Environment variables (VITE_PUBLIC_ vs VITE_ in Vite builds) must not expose credentials
- **localStorage Validation:** All data read from storage must be validated/schema-checked before use
- **Dependency Scanning:** CI/CD should scan npm packages for known vulnerabilities
- **Health Checks:** Auto-staging includes smoke tests; manual production gate requires tech lead sign-off

**Options:**

A. Affirm strategy with all four security refinements (secrets, validation, scanning, health checks)
B. Affirm strategy but defer security refinements to Phase 2
C. Modify strategy (specify which refinements to include/defer)
D. Other
X. Unclear

[Answer]: B

---

## Q5: Code Style — Naming, Linting, Organization

**Question:** Does the team affirm Prettier + ESLint with explicit guidance on React component naming, hooks rules, and file organization?

**Context:** Developer specialist identified gaps:

- **Component Naming:** React components must use PascalCase (not camelCase)
- **Hooks Rules:** ESLint must enforce Rules of Hooks via `eslint-plugin-react-hooks`
- **File Organization:** Feature-based structure (`src/features/<feature>/components`, `src/shared/utils`) recommended for BDD scenario mapping
- **localStorage:** Validation logic must handle parse errors and data type checking

**Options:**

A. Affirm Prettier + ESLint with all four refinements (component naming, hooks rules, file structure, localStorage validation)
B. Affirm existing linting stack but defer file organization guidance to Phase 2
C. Modify approach (specify which refinements to include/defer)
D. Other
X. Unclear

[Answer]: A

---

## Consolidated Summary Confirmation

Based on your responses above, the affirmed practices will be:

- **Way of Working:** Trunk-based development with short-lived branches (1-2 days), squash-merge to main
- **Walking Skeleton:** Build minimal CRUD + localStorage slice first, then iterate
- **Testing Posture:** BDD (scenario-driven) with 40% coverage, mapped to the 10 acceptance criteria
- **Deployment:** Auto-staging on merge, manual production gate; defer security refinements to Phase 2
- **Code Style:** Prettier + ESLint with PascalCase naming, React Hooks enforcement, feature-based structure

Does this summary capture the team's intent correctly?

**Options:**

- **Looks correct** — Promote affirmed practices to team memory
- **Request changes** — I need to clarify or adjust these responses

[Answer]: Looks correct
