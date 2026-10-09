# Code Generation Plan — TODO App Specification Review

## Project Overview

Build a working React 18 + Vite TODO application that implements the complete specification defined in Requirements Analysis. The app demonstrates team mastery of React patterns, component-based architecture, BDD testing methodology, and localStorage persistence.

**Scope:** spec-review (Minimal depth, Learning-focused)
**Testing Methodology:** BDD (Behavior-Driven Development)
**Coverage Floor:** 40% line coverage (aligned with spec-review scope)
**Test Ordering:** Write executable BDD scenarios first, then implement features to satisfy those scenarios.

---

## Testing Contract JSON block

```json
{
  "methodology": "bdd",
  "ordering": "scenario-first BDD: write executable scenario examples from acceptance criteria before each observable feature slice, implement that slice across every required layer, run scenarios green, then refactor",
  "coverage_floor": "40% line coverage (spec-review scope)",
  "scope_floor_additive": "poc scope adds no extra new-test floor; existing test suite must remain green",
  "plan_profile": {
    "steps": [
      "Bootstrap minimal test runner (Vitest + React Testing Library)",
      "Write BDD scenarios for each of 10 acceptance criteria (Gherkin format)",
      "Implement feature layers (component, state, persistence)",
      "Run scenarios green",
      "Refactor while green",
      "Unit tests for utilities and integration tests for localStorage"
    ]
  }
}
```

---

## Implementation Plan

### Phase 1: Bootstrap & BDD Scenario Foundation

- [ ] **Step 1: Project Setup**
  - Initialize Vite + React 18 project structure
  - Install dependencies: React 18, React DOM, Vitest, React Testing Library, @testing-library/user-event
  - Configure Vitest with React Testing Library setup
  - Create `.prettierrc` and `.eslintrc.json` at repo root per team standards
  - Maps to: Setup foundation for all FRs

- [ ] **Step 2: Write BDD Scenarios for FR1 (Create Tasks)**
  - Create `src/features/tasks/tasks.feature.test.js` with Gherkin-style BDD scenarios
  - Scenario 1: User can input task title and description, create button submits
  - Scenario 2: Form resets after successful creation
  - Maps to: FR1 Acceptance Criteria (Create Tasks)

- [ ] **Step 3: Write BDD Scenarios for FR2 (List Tasks)**
  - Scenario 1: All tasks from localStorage appear on app startup
  - Scenario 2: Tasks display in descending order (newest first)
  - Scenario 3: Each task shows title, description, completion status
  - Scenario 4: Empty state messaging appears when no tasks exist
  - Maps to: FR2 Acceptance Criteria (List Tasks)

- [ ] **Step 4: Write BDD Scenarios for FR3 (Toggle Completion)**
  - Scenario 1: Clicking completion checkbox toggles task state
  - Scenario 2: Completed tasks show strikethrough and green indicator
  - Scenario 3: Filter counters update when completion status changes
  - Maps to: FR3 Acceptance Criteria (Mark Complete/Incomplete)

- [ ] **Step 5: Write BDD Scenarios for FR4 (Filter Tasks)**
  - Scenario 1: Three filter buttons (All, Pending, Completed) filter list correctly
  - Scenario 2: Filter selection persists across actions
  - Scenario 3: Filtered count updates dynamically
  - Maps to: FR4 Acceptance Criteria (Filter Tasks)

- [ ] **Step 6: Write BDD Scenarios for FR5 (Delete Tasks)**
  - Scenario 1: Delete button removes task from list immediately
  - Scenario 2: Deleted task is removed from localStorage
  - Scenario 3: List re-renders correctly after deletion
  - Maps to: FR5 Acceptance Criteria (Delete Tasks)

- [ ] **Step 7: Write BDD Scenarios for FR6 (Edit Tasks)**
  - Scenario 1: Edit mode activated by clicking task title/description
  - Scenario 2: Save triggered by blur event or Enter key; Cancel by Escape
  - Scenario 3: Edited task updates in list and localStorage
  - Scenario 4: Validation rules apply to edited content
  - Maps to: FR6 Acceptance Criteria (Edit Tasks)

- [ ] **Step 8: Write BDD Scenarios for FR7 (Responsive Design)**
  - Scenario 1: Layout adapts to mobile (320px+), tablet (768px+), desktop (1024px+)
  - Scenario 2: Touch targets are 44x44px minimum on mobile
  - Scenario 3: No horizontal scrolling required on mobile
  - Maps to: FR7 Acceptance Criteria (Responsive Design)

- [ ] **Step 9: Write BDD Scenarios for FR8 (Dark Mode)**
  - Scenario 1: Dark mode toggle button visible and functional
  - Scenario 2: Dark mode preference persists across page refreshes
  - Scenario 3: All UI elements visible and readable in both modes
  - Maps to: FR8 Acceptance Criteria (Dark Mode)

- [ ] **Step 10: Write BDD Scenarios for FR9 & FR10 (Form Validation & Storage)**
  - Scenario 1: Title field cannot be empty; validation error shown
  - Scenario 2: Character counters show remaining characters
  - Scenario 3: Validation errors display as toast notifications
  - Scenario 4: Tasks persist in localStorage and survive page refresh
  - Scenario 5: On localStorage failure, error is shown and save is disabled
  - Maps to: FR9 & FR10 Acceptance Criteria (Validation & Persistence)

### Phase 2: Component Architecture & Implementation

- [ ] **Step 11: Create Component Structure**
  - Directory structure: `src/features/tasks/components/`, `src/shared/utils/`, `src/shared/hooks/`
  - Create base components: `App.jsx`, `TaskList.jsx`, `TaskItem.jsx`, `InputForm.jsx`, `FilterButtons.jsx`, `ThemeToggle.jsx`
  - Create custom hook: `useTodos.js` for task management logic
  - Create utility functions: `localStorage.js`, `validation.js`, `taskId.js`
  - Maps to: Architecture foundation for all FRs

- [ ] **Step 12: Implement InputForm Component (FR1)**
  - Functional component with useState for title and description
  - Input fields with validation (non-empty title, char limits)
  - Character counter display
  - Create button and Enter key submission
  - Form reset after successful creation
  - Toast notification for validation errors
  - Run BDD scenarios for FR1 — all green

- [ ] **Step 13: Implement TaskList & TaskItem Components (FR2)**
  - TaskList renders array of TaskItem components
  - useEffect to load tasks from localStorage on mount
  - TaskItem displays title, description preview, completion checkbox, action buttons
  - Empty state when no tasks
  - Task list updates immediately on state changes
  - Run BDD scenarios for FR2 — all green

- [ ] **Step 14: Implement Completion Toggle (FR3)**
  - TaskItem checkbox toggles completion state
  - Completed tasks get strikethrough + green styling
  - Filter counters update dynamically
  - useEffect syncs to localStorage
  - Run BDD scenarios for FR3 — all green

- [ ] **Step 15: Implement Filter Buttons (FR4)**
  - FilterButtons component with three buttons (All, Pending, Completed)
  - Filter state stored in App component
  - TaskList receives filtered array
  - Counters show real-time counts
  - Run BDD scenarios for FR4 — all green

- [ ] **Step 16: Implement Delete Functionality (FR5)**
  - Delete button in TaskItem (trash icon or text)
  - Handler removes task from state array
  - useEffect syncs deletion to localStorage
  - List re-renders immediately
  - Run BDD scenarios for FR5 — all green

- [ ] **Step 17: Implement Inline Edit Mode (FR6)**
  - TaskItem switches between view and edit modes
  - Edit mode shows input fields for title and description
  - Save on blur or Enter; Cancel on Escape
  - Validation applied before save
  - useEffect syncs edit to localStorage
  - Run BDD scenarios for FR6 — all green

- [ ] **Step 18: Implement Responsive CSS (FR7)**
  - Mobile-first CSS with breakpoints (320px, 768px, 1024px)
  - Flexbox layout for responsive design
  - Touch targets 44x44px minimum
  - `App.css` defines responsive styles
  - Run BDD scenarios for FR7 — all green

- [ ] **Step 19: Implement Dark Mode Toggle (FR8)**
  - ThemeToggle component in header
  - App component manages theme state (or uses CSS media query)
  - Root div gets `data-theme="dark"` / `data-theme="light"` attribute
  - CSS defines color variables for both themes
  - Theme preference stored in localStorage
  - Run BDD scenarios for FR8 — all green

- [ ] **Step 20: Implement Form Validation & Error Handling (FR9)**
  - InputForm validates on input change and submit
  - Toast notification component for user feedback
  - Character counters
  - Validation errors show as toast notifications
  - Form does not submit with invalid data
  - Run BDD scenarios for FR9 — all green

- [ ] **Step 21: Implement localStorage Persistence (FR10)**
  - App loads tasks from localStorage on mount
  - useEffect syncs state to localStorage after each change
  - JSON.stringify/parse handles serialization
  - Try-catch handles quota errors
  - Toast notification on error; save button disabled on quota
  - Run BDD scenarios for FR10 — all green

### Phase 3: Quality & Integration Testing

- [ ] **Step 22: Create Unit Tests for Utilities**
  - `src/shared/utils/__tests__/validation.test.js` (5-8 tests)
  - `src/shared/utils/__tests__/localStorage.test.js` (5-8 tests)
  - `src/shared/utils/__tests__/taskId.test.js` (2-3 tests)
  - Test happy path + error cases
  - Mock localStorage API for tests

- [ ] **Step 23: Create Integration Tests**
  - `src/features/tasks/__tests__/localStorage-integration.test.js` (3-5 tests)
  - Test persistence across multiple operations
  - Test quota exceeded scenario
  - Test data validation on load

- [ ] **Step 24: Verify BDD Scenario Coverage**
  - All 10 BDD scenarios passing
  - Each scenario validates one FR acceptance criterion
  - Gherkin format documented in test files
  - No skipped tests

- [ ] **Step 25: Configure Test Runner & Coverage**
  - `vitest.config.js` configured for React Testing Library
  - Coverage thresholds set to 40% (spec-review scope floor)
  - `npm run test` runs full suite
  - `npm run test:coverage` generates coverage report
  - CI will block merge if coverage < 40%

- [ ] **Step 26: Linting & Formatting**
  - Run `npm run lint -- --fix` (ESLint)
  - Run `npm run format` (Prettier)
  - All code passes without errors or warnings
  - React Hooks rules enforced

### Phase 4: Build & Verification

- [ ] **Step 27: Build Configuration**
  - `vite.config.js` configured for React
  - `npm run build` produces optimized dist/
  - `npm run dev` runs dev server
  - Production build < 2 seconds on 4G (NFR1)

- [ ] **Step 28: End-to-End Verification**
  - Launch app in browser
  - Manually verify all 10 acceptance criteria work
  - Test on mobile, tablet, desktop viewports
  - Test in Chrome, Firefox, Safari
  - Verify localStorage persistence
  - Verify dark mode toggle and persistence
  - No console errors or warnings

- [ ] **Step 29: Documentation & Cleanup**
  - Remove all console.log statements from production code
  - Add inline comments for complex logic
  - Document custom hook `useTodos` with JSDoc
  - Update `.gitignore` for node_modules, dist/, coverage/

- [ ] **Step 30: Create Code Summary**
  - Document files created/modified
  - List key implementation decisions
  - Summarize test coverage (40% + 10 BDD scenarios)
  - Note any deviations from plan

---

## Quality Targets

- **Line Coverage:** 40% minimum (spec-review scope floor)
- **Test Count:** 10 BDD scenarios + 15-20 unit/integration tests = 25-30 total tests
- **Linting:** ESLint passes, zero errors/warnings
- **Formatting:** Prettier applied, consistent formatting
- **Browser Support:** Chrome, Firefox, Safari, Edge (latest 2 versions)
- **Accessibility:** WCAG 2.1 AA (keyboard navigation, color contrast, focus indicators)
- **Performance:** Initial load < 2 seconds on 4G throttling

---

## Traceability Matrix

| Step | Functional Requirement | NFR | Phase |
|------|------------------------|-----|----------|
| 2-7 | FR1-FR6 | Code Quality, Testing | BDD Scenarios |
| 8 | FR7 | Responsive Design | BDD Scenarios |
| 9 | FR8 | Accessibility, Dark Mode | BDD Scenarios |
| 10 | FR9-FR10 | Form Validation, Persistence | BDD Scenarios |
| 12-21 | FR1-FR10 | All NFRs | Implementation |
| 22-25 | All FRs | Testing, Coverage | Quality Testing |
| 26-29 | All FRs | Code Quality, Performance | Build & Verification |

---

## [Approval Fingerprint]

This plan covers:
- ✅ 30 sequential implementation steps
- ✅ BDD scenario-first testing methodology (10 scenarios → 10 FRs)
- ✅ 40% line coverage floor (spec-review scope)
- ✅ Unit, integration, and E2E verification
- ✅ All 10 functional requirements (FR1-FR10)
- ✅ All 10 non-functional requirements (NFR1-NFR10)
- ✅ Responsive design, dark mode, localStorage persistence
- ✅ Code quality (linting, formatting, accessibility)
- ✅ Traceability to requirements

**Status:** Ready for Plan Approval
