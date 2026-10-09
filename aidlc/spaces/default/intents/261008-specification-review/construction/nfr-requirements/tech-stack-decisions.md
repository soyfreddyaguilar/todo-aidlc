# Technology Stack Decisions

**Stage:** NFR Requirements (Construction)
**Unit:** Walking Skeleton (CRUD + localStorage)
**Approved By:** Team Practices Discovery (affirmed 2026-10-08)

---

## Tech Stack Overview

| Layer | Technology | Version | Justification |
|---|---|---|---|
| **Runtime** | Node.js + npm | 18+ | Standard JavaScript/React tooling |
| **Framework** | React | 18+ | Modern component-based UI, team mandate |
| **Build Tool** | Vite | 5+ | Fast dev experience, optimized production bundles |
| **Styling** | CSS3 (Modules or inline) | N/A | No external UI framework (team mandate: pure CSS) |
| **State Mgmt** | React Hooks (useState) | React 18 | Minimal, no Redux/Zustand (team mandate) |
| **Persistence** | localStorage API | Browser native | No backend, local-only per specification |
| **Testing** | Jest + React Testing Library | Latest | BDD-friendly, component-focused testing |
| **Code Formatting** | Prettier | Default config | Zero-config code style enforcement |
| **Linting** | ESLint + React plugin | Latest | Catch common React mistakes, enforce best practices |
| **Package Manager** | npm | Latest | Aligned with Node.js, standard ecosystem |

---

## Detailed Decisions

### 1. React 18 (Framework)

**Decision:** Use React 18 with functional components and Hooks exclusively.

**Rationale:**
- Team mandate: "React 18+"
- Modern patterns (Hooks) simplify component logic
- Focus on learning React patterns, not legacy class components
- Concurrent features (Suspense, transitions) available for future enhancements

**Constraints:**
- No class components
- No HOCs (use Hooks instead)
- No library dependencies for state (Redux, MobX forbidden)

**Tradeoff:**
- Hooks require careful dependency array management (small learning curve)
- Worth it for code clarity and team skill development

---

### 2. Vite (Build Tool)

**Decision:** Use Vite as build tool and dev server.

**Rationale:**
- Team mandate: "Vite Build Tool"
- Extremely fast dev server (instant feedback during development)
- Optimized production builds (tree-shaking, code-splitting)
- Small bundle size (< 100 KB gzipped target)
- Modern ES module support
- Native TypeScript support (optional later)

**Constraints:**
- No Webpack-specific plugins
- Build target: ES2020+
- Public assets in `/public` directory

**Tradeoff:**
- Smaller ecosystem than Webpack (not an issue for simple app)
- Worth it for development velocity

---

### 3. localStorage (Persistence)

**Decision:** Use browser localStorage API for all data persistence.

**Rationale:**
- Specification mandate: "localStorage Only"
- No backend infrastructure required (learning focus)
- Synchronous API (simpler state management)
- Adequate for single-device, single-user, <500 tasks
- Universal browser support

**Constraints:**
- 5-10 MB quota per origin (practical limit: ~500 tasks)
- No cross-device sync (single device only)
- No server-side data access
- Subject to browser privacy modes (data cleared on close)

**Tradeoff:**
- Limited scale (Phase 2 adds backend for multi-device)
- Worth it for skeleton simplicity

---

### 4. Functional Components + Hooks (Patterns)

**Decision:** React functional components with Hooks (useState, useEffect, custom hooks).

**Rationale:**
- Modern React best practice
- Simpler code than class components
- Easier to test and reason about
- Composition via custom Hooks (e.g., `useTodos`)

**Implementation:**
- Custom `useTodos` hook encapsulates task CRUD logic
- useEffect for side effects (localStorage sync, init)
- useState for component-level state (form inputs, filter)
- No Context API needed for skeleton (props drilling acceptable)

**Constraints:**
- Dependency arrays must be correct (prevents bugs)
- No lifecycle method getters/setters
- useCallback needed for stable event handlers (if passing to memo'd components)

**Tradeoff:**
- Learning curve on dependency arrays
- Much cleaner than class component lifecycle methods

---

### 5. Pure CSS3 (No UI Framework)

**Decision:** Write all styles directly as CSS, no Bootstrap/Tailwind/Material-UI.

**Rationale:**
- Team mandate: "No External UI Framework"
- Learning CSS skills (not framework-specific tricks)
- Full control over styling
- Smaller bundle size (no framework CSS)
- Responsive design via media queries (Flexbox/Grid)

**Implementation:**
- CSS Modules or inline styles for scoped styling
- Responsive breakpoints: mobile (320px), tablet (768px), desktop (1024px)
- Variables for colors, spacing (custom properties)
- Touch targets: 44x44 px minimum for mobile

**Constraints:**
- No pre-built components (must build from HTML + CSS)
- More CSS code than using a framework
- Accessibility responsibility (no framework defaults)

**Tradeoff:**
- More CSS to write (300-500 lines typical)
- Worth it for learning and control

---

### 6. Jest + React Testing Library (Testing)

**Decision:** Use Jest for test runner and React Testing Library for component testing.

**Rationale:**
- Team affirmation: "BDD + 40% coverage"
- Jest: zero-config, fast, great React support
- React Testing Library: encourages testing behavior, not implementation
- Gherkin scenarios supported (jest + babel for feature parsing)
- Adequate for 40% coverage floor

**Implementation:**
- Test files: `__tests__/` directory or `.test.js` suffix
- Component tests with `render()` and user-event queries
- Unit tests for utility functions (custom Hooks, helpers)
- Integration tests for localStorage persistence
- Coverage target: 40% line coverage

**Constraints:**
- No Enzyme or shallow rendering (RTL encourages integration-level tests)
- Snapshots used sparingly (brittle, hard to maintain)
- Mocking: localStorage mocked in tests

**Tradeoff:**
- RTL has steeper learning curve than Enzyme
- Better test quality (tests real behavior)

---

### 7. Prettier + ESLint (Code Quality)

**Decision:** Enforce code style with Prettier and linting with ESLint (React plugin).

**Rationale:**
- Zero-config Prettier (no bikeshedding on style)
- ESLint with React plugin catches common mistakes
- Team affirmation: "Prettier + ESLint standard"
- CI enforces both before merge

**Implementation:**
- `.prettierrc` with default settings (2-space indent)
- `.eslintrc.json` with React plugin and react-hooks plugin
- Pre-commit hook optional (husky) but CI enforces
- No manual linting review (automated)

**Constraints:**
- Prettier formatting is non-negotiable (no per-file exceptions)
- ESLint rules inherited from recommended config (can be disabled with justification)

**Tradeoff:**
- Initial setup time
- Huge time savings in code review (no style debates)

---

### 8. npm (Package Manager)

**Decision:** Use npm as package manager.

**Rationale:**
- Standard with Node.js
- Large ecosystem (React, Vite, Jest, etc.)
- Lock file (package-lock.json) ensures deterministic installs
- CI integration straightforward

**Constraints:**
- npm v9+ required for workspace support (if monorepo later)
- No yarn or pnpm for skeleton

---

## Deferred Technology Decisions (Phase 2)

The following tech stack decisions are intentionally deferred:

1. **TypeScript:** Optional in Phase 2 if type safety becomes valuable
2. **CSS Preprocessor:** SCSS/LESS optional if CSS grows complex
3. **State Management Library:** Redux/Zustand if app grows beyond useState scope
4. **HTTP Client:** Only if Phase 2 adds backend API (fetch works for skeleton)
5. **Component Library:** Custom components or design system Phase 2+
6. **Database:** localStorage sufficient for skeleton; Phase 2 evaluates real database
7. **Authentication:** N/A for skeleton (single-user); Phase 2 if multi-user
8. **Analytics/Monitoring:** Phase 2 if measuring usage

---

## Verification

**Tech Stack Validation:**
- `npm list` confirms all dependencies installed
- Build runs without warnings: `npm run build`
- Dev server starts without errors: `npm run dev`
- Tests pass: `npm test`
- Linting passes: `npm run lint`
- Prettier check passes: `npm run format:check`

---

## Traceability

| Inception NFR | Construction Requirement | Status |
|---|---|---|
| NFR1 (Performance) | Tech stack optimized for Vite bundling | Confirmed |
| NFR2 (Accessibility) | React 18 + semantic HTML enables WCAG | Confirmed |
| NFR4 (Code Quality) | Hooks + Jest + ESLint enforce quality | Confirmed |
| NFR5 (Code Style) | Prettier + ESLint configured | Confirmed |
| NFR10 (State Mgmt) | Custom Hooks + localStorage | Confirmed |

