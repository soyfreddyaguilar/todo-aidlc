# Unit Test Instructions — TODO App

## Test Framework Setup

**Framework:** Vitest + React Testing Library
**Test Runner:** `npm run test`
**Coverage Report:** `npm run test:coverage`
**Coverage Target:** 40% line coverage (spec-review scope floor)

## Test Suite Organization

```
src/
├── features/
│   └── tasks/
│       └── __tests__/
│           ├── tasks.feature.test.js (10 BDD scenarios)
│           └── localStorage-integration.test.js (5 tests)
├── shared/
│   └── utils/
│       └── __tests__/
│           ├── validation.test.js (8 tests)
│           ├── localStorage.test.js (8 tests)
│           └── taskId.test.js (3 tests)
```

## Test Scope & Coverage

### BDD Scenarios (Mandatory)

**File:** `src/features/tasks/__tests__/tasks.feature.test.js`
**Total Scenarios:** 10 (one per acceptance criterion)
**Methodology:** Gherkin-style Given/When/Then

1. **Scenario: Create Task with Title and Description**
   - Given: Input form is displayed
   - When: User enters title, optional description, and clicks Create
   - Then: Task appears in list immediately with unique ID and timestamps

2. **Scenario: Form Resets After Creation**
   - Given: User has created a task
   - When: Form resets
   - Then: Input fields are cleared and ready for next entry

3. **Scenario: List Tasks on App Startup**
   - Given: Tasks exist in localStorage
   - When: App loads
   - Then: All tasks appear in descending order (newest first)

4. **Scenario: Show Empty State**
   - Given: No tasks in localStorage
   - When: App loads
   - Then: Empty state message is displayed

5. **Scenario: Toggle Task Completion**
   - Given: Task is displayed in list
   - When: User clicks completion checkbox
   - Then: Task toggles to completed state with visual feedback (strikethrough, green)

6. **Scenario: Filter Tasks by Status**
   - Given: Mixed completed and pending tasks exist
   - When: User selects "Completed" filter
   - Then: Only completed tasks display with correct count

7. **Scenario: Delete Task**
   - Given: Task exists in list
   - When: User clicks delete button
   - Then: Task is removed immediately and deleted from localStorage

8. **Scenario: Edit Task Inline**
   - Given: Task is displayed
   - When: User clicks to edit, modifies title/description, and saves (blur or Enter)
   - Then: Changes persist in list and localStorage

9. **Scenario: Responsive Layout on Mobile**
   - Given: App is viewed on mobile (320px)
   - When: User interacts with components
   - Then: Layout adapts without horizontal scrolling; touch targets are 44x44px

10. **Scenario: Dark Mode Toggle**
    - Given: App is running in light mode
    - When: User toggles dark mode
    - Then: Theme switches with persistent preference across refreshes

### Unit Tests (Mandatory)

**File:** `src/shared/utils/__tests__/validation.test.js` (8 tests)
- Test empty title validation
- Test max character limits (title 500, description 2000)
- Test valid title acceptance
- Test special characters in title/description
- Test whitespace-only title rejection
- Test alphanumeric title acceptance
- Test Unicode character handling
- Test error message formatting

**File:** `src/shared/utils/__tests__/localStorage.test.js` (8 tests)
- Test save task to localStorage
- Test load tasks from localStorage
- Test update task in localStorage
- Test delete task from localStorage
- Test JSON.stringify/parse round-trip
- Test localStorage quota exceeded handling
- Test malformed data handling on load
- Test localStorage.clear() behavior

**File:** `src/shared/utils/__tests__/taskId.test.js` (3 tests)
- Test ID generation format (YYYYMMDDHHMMSSMMM)
- Test ID uniqueness for rapid creation
- Test ID extraction from task object

### Integration Tests (Mandatory)

**File:** `src/features/tasks/__tests__/localStorage-integration.test.js` (5 tests)
- Test create → list → verify persistence
- Test edit → verify localStorage sync
- Test delete → verify removal from storage
- Test quota exceeded → verify error handling
- Test data validation on load → verify schema checking

## Test Execution Commands

### Run All Tests
```bash
npm run test
```

### Run Tests with Coverage
```bash
npm run test:coverage
```

### Run Specific Test File
```bash
npm run test -- src/shared/utils/__tests__/validation.test.js
```

### Watch Mode (Development)
```bash
npm run test:watch
```

### Update Snapshots (if using snapshots)
```bash
npm run test -- -u
```

## Mocking & Test Setup

### localStorage Mock
```javascript
const localStorageMock = {
  data: {},
  getItem: (key) => localStorageMock.data[key] || null,
  setItem: (key, value) => { localStorageMock.data[key] = value; },
  removeItem: (key) => { delete localStorageMock.data[key]; },
  clear: () => { localStorageMock.data = {}; }
};

Object.defineProperty(window, 'localStorage', { value: localStorageMock });
```

### React Testing Library Setup
```javascript
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { vi } from 'vitest';
```

## Test Data Management

### Sample Task Object
```javascript
{
  id: '20261009143000000',
  title: 'Buy groceries',
  description: 'Milk, bread, eggs',
  completed: false,
  createdAt: '2026-10-09T14:30:00Z',
  updatedAt: '2026-10-09T14:30:00Z'
}
```

### Sample localStorage Data
```javascript
localStorage.setItem('todos-app-data', JSON.stringify([
  { id: '20261009143000000', title: 'Task 1', description: '', completed: false, createdAt: '2026-10-09T14:30:00Z', updatedAt: '2026-10-09T14:30:00Z' },
  { id: '20261009143001000', title: 'Task 2', description: 'Description', completed: true, createdAt: '2026-10-09T14:31:00Z', updatedAt: '2026-10-09T14:31:00Z' }
]));
```

## Coverage Thresholds

```javascript
// vitest.config.js
coverage: {
  lines: 40,        // 40% line coverage floor (spec-review scope)
  functions: 40,
  branches: 30,
  statements: 40
}
```

## Expected Test Results

| Test Suite | Count | Expected Pass |
|------------|-------|---|
| BDD Scenarios | 10 | ✅ All green |
| Unit Tests | 19 | ✅ All green |
| Integration Tests | 5 | ✅ All green |
| **Total** | **34 tests** | **✅ 100% pass** |

**Coverage Target:** 40% (spec-review scope) — typically achieved by BDD scenarios + utility unit tests

## Continuous Integration

Tests run automatically on:
- ✅ Every pull request (before merge)
- ✅ Every merge commit to `main`
- ✅ Failed tests block merge
- ✅ Coverage below 40% blocks merge (CI enforces)

## Development Workflow

1. **Before Implementation:** Write BDD scenarios for the feature
2. **During Implementation:** Run `npm run test:watch` to verify scenarios are passing
3. **After Implementation:** Verify all 34 tests pass with 40%+ coverage
4. **Before Merge:** Run full suite `npm run test && npm run test:coverage`

## Troubleshooting

- **Test fails with "Cannot find module":** Ensure all imports use correct relative paths
- **localStorage not available:** Check that localStorage mock is setup before test runs
- **Component render errors:** Verify test setup includes React DOM and proper providers
- **Snapshot mismatches:** Run `npm run test -- -u` to update (review changes first)
- **Coverage below target:** Add more edge case tests for untested branches
