# Integration Test Instructions — TODO App

## Overview

Integration tests verify cross-unit interactions and end-to-end task workflows. These tests validate that components work together correctly and that localStorage persistence functions as expected.

**Framework:** Vitest + React Testing Library
**Test Runner:** `npm run test`
**Target File:** `src/features/tasks/__tests__/localStorage-integration.test.js`

## Test Execution Commands

### Run All Tests

```bash
npm run test
```

### Run Only Integration Tests

```bash
npm run test -- src/features/tasks/__tests__/localStorage-integration.test.js
```

### Run with Coverage

```bash
npm run test:coverage
```

### Watch Mode (Development)

```bash
npm run test:watch
```

## Integration Test Suite (5 Tests)

**File:** `src/features/tasks/__tests__/localStorage-integration.test.js`

---

### Test 1: Create → List → Verify Persistence

**Test Name:** `should persist task to localStorage and retrieve on app reload`

**Scenario:** User creates a task, app reloads, task still exists (simulating page refresh).

**Setup:**
- Clear localStorage before test
- Render App component
- Mock localStorage persistence

**Steps:**
1. Find input form (title and description fields)
2. Type "Buy groceries" into title field
3. Type "Milk, eggs, bread" into description field
4. Click Create button or press Enter
5. Verify task appears in TaskList with correct title and description
6. Simulate localStorage save and app reload (re-render component)
7. Verify task reappears in list with same ID, title, description

**Expected Behavior:**
- Task created successfully with unique ID
- Task visible in list immediately after creation
- After simulated reload, task persists with identical data
- No console errors

**Acceptance Criteria:**
- ✅ Task created in state
- ✅ Task written to localStorage
- ✅ Task retrieved from localStorage on app restart
- ✅ Task data integrity maintained across reload

**Code Example (Pseudocode):**
```javascript
test('should persist task to localStorage and retrieve on app reload', () => {
  localStorage.clear();
  const { rerender } = render(<App />);

  // User creates task
  fireEvent.change(screen.getByPlaceholderText('Task title'), { target: { value: 'Buy groceries' } });
  fireEvent.click(screen.getByText('Create'));

  // Verify task in list
  expect(screen.getByText('Buy groceries')).toBeInTheDocument();
  const savedData = JSON.parse(localStorage.getItem('todos-app-data'));
  expect(savedData).toHaveLength(1);
  expect(savedData[0].title).toBe('Buy groceries');

  // Simulate reload
  rerender(<App />);

  // Verify task still exists after reload
  expect(screen.getByText('Buy groceries')).toBeInTheDocument();
});
```

---

### Test 2: Edit → Verify localStorage Sync

**Test Name:** `should sync task edit to localStorage immediately`

**Scenario:** User edits a task; changes are immediately written to localStorage (no lag).

**Setup:**
- Pre-load localStorage with one task
- Render App component
- Task appears in list

**Steps:**
1. Click Edit on task (or enter edit mode)
2. Change title from "Buy groceries" to "Buy groceries & cook dinner"
3. Save edit (blur or click Save button)
4. Verify updated title appears in list
5. Check localStorage to verify new title persisted
6. Verify updatedAt timestamp changed

**Expected Behavior:**
- Edit mode activates inline
- Title updated in state
- localStorage updated synchronously
- No console errors
- updatedAt timestamp reflects edit

**Acceptance Criteria:**
- ✅ Edit mode works for title and description
- ✅ Changes reflected in list
- ✅ localStorage synced within 100ms
- ✅ Metadata (updatedAt) updated

**Code Example (Pseudocode):**
```javascript
test('should sync task edit to localStorage immediately', () => {
  const task = { id: '123', title: 'Buy groceries', description: '', completed: false, createdAt: now, updatedAt: now };
  localStorage.setItem('todos-app-data', JSON.stringify([task]));

  render(<App />);

  // Enter edit mode and change title
  const editButton = screen.getByText('Edit');
  fireEvent.click(editButton);

  const titleInput = screen.getByDisplayValue('Buy groceries');
  fireEvent.change(titleInput, { target: { value: 'Buy groceries & cook' } });
  fireEvent.blur(titleInput); // Save on blur

  // Verify list updated
  expect(screen.getByText('Buy groceries & cook')).toBeInTheDocument();

  // Verify localStorage updated
  const saved = JSON.parse(localStorage.getItem('todos-app-data'));
  expect(saved[0].title).toBe('Buy groceries & cook');
  expect(saved[0].updatedAt).not.toBe(task.updatedAt);
});
```

---

### Test 3: Delete → Verify Removal from Storage

**Test Name:** `should remove task from localStorage on delete`

**Scenario:** User deletes a task; task removed from list and localStorage.

**Setup:**
- Pre-load localStorage with 2 tasks
- Render App component
- Both tasks visible

**Steps:**
1. Locate first task in list
2. Click Delete button for first task
3. Verify task removed from list
4. Check localStorage to confirm deletion
5. Verify remaining task still exists
6. Count of tasks in localStorage should be 1

**Expected Behavior:**
- Delete confirmation (optional, per UX)
- Task removed from DOM
- localStorage updated immediately
- Remaining tasks unaffected

**Acceptance Criteria:**
- ✅ Task removed from list
- ✅ Task removed from localStorage
- ✅ Other tasks preserved
- ✅ localStorage count reflects deletion

**Code Example (Pseudocode):**
```javascript
test('should remove task from localStorage on delete', () => {
  const tasks = [
    { id: '1', title: 'Task 1', description: '', completed: false, createdAt: now, updatedAt: now },
    { id: '2', title: 'Task 2', description: '', completed: false, createdAt: now, updatedAt: now }
  ];
  localStorage.setItem('todos-app-data', JSON.stringify(tasks));

  render(<App />);
  expect(screen.getByText('Task 1')).toBeInTheDocument();
  expect(screen.getByText('Task 2')).toBeInTheDocument();

  // Delete first task
  const deleteButtons = screen.getAllByText('Delete');
  fireEvent.click(deleteButtons[0]);

  // Verify removal
  expect(screen.queryByText('Task 1')).not.toBeInTheDocument();
  expect(screen.getByText('Task 2')).toBeInTheDocument();

  // Verify localStorage
  const saved = JSON.parse(localStorage.getItem('todos-app-data'));
  expect(saved).toHaveLength(1);
  expect(saved[0].id).toBe('2');
});
```

---

### Test 4: Quota Exceeded → Verify Error Handling

**Test Name:** `should handle localStorage quota exceeded gracefully`

**Scenario:** Browser localStorage is full; create operation fails; user informed via error toast.

**Setup:**
- Mock localStorage.setItem to throw QuotaExceededError
- Render App component with tasks already in localStorage

**Steps:**
1. Attempt to create a new task
2. Verify error toast appears ("Storage full" or similar message)
3. Verify task not added to list or localStorage
4. Verify app remains usable (can still view, filter, edit existing tasks)
5. No console exceptions

**Expected Behavior:**
- Error caught and handled
- User-friendly error message displayed
- App doesn't crash
- Create disabled until space available

**Acceptance Criteria:**
- ✅ Error message shown to user
- ✅ App remains usable
- ✅ No silent data loss
- ✅ No uncaught exceptions

**Code Example (Pseudocode):**
```javascript
test('should handle localStorage quota exceeded gracefully', () => {
  const saveItem = localStorage.setItem;
  localStorage.setItem = vi.fn((key, value) => {
    if (key === 'todos-app-data') {
      const error = new Error('QuotaExceededError');
      error.code = 22;
      throw error;
    }
  });

  render(<App />);

  // Attempt to create task
  fireEvent.change(screen.getByPlaceholderText('Task title'), { target: { value: 'New task' } });
  fireEvent.click(screen.getByText('Create'));

  // Verify error toast
  expect(screen.getByText(/Storage full|quota exceeded/i)).toBeInTheDocument();

  // Verify task not added
  expect(screen.queryByText('New task')).not.toBeInTheDocument();

  // Restore and cleanup
  localStorage.setItem = saveItem;
});
```

---

### Test 5: Data Validation on Load → Verify Schema Checking

**Test Name:** `should skip malformed tasks and validate schema on load`

**Scenario:** localStorage contains corrupted or malformed task data; app loads, validates, skips bad data.

**Setup:**
- Pre-load localStorage with mixed valid and invalid tasks
- Invalid tasks: missing required fields, wrong data types, extra fields

**Steps:**
1. Render App component
2. Verify valid tasks appear in list
3. Verify invalid tasks are skipped (not displayed)
4. Check console for validation warnings (dev mode)
5. Verify app doesn't crash

**Expected Behavior:**
- Valid tasks loaded and displayed
- Invalid tasks silently skipped with warning log
- App functional with valid subset
- No render errors

**Acceptance Criteria:**
- ✅ Valid tasks loaded
- ✅ Invalid tasks skipped
- ✅ App remains stable
- ✅ Warnings logged for debugging

**Sample Malformed Data:**
```json
[
  { "id": "1", "title": "Valid task", "description": "", "completed": false, "createdAt": "2026-10-09T00:00:00Z", "updatedAt": "2026-10-09T00:00:00Z" },
  { "id": "2", "title": "Missing description", "completed": false },
  { "title": "Missing required ID", "description": "", "completed": false, "createdAt": "2026-10-09T00:00:00Z", "updatedAt": "2026-10-09T00:00:00Z" },
  { "id": "3", "title": 123, "description": "", "completed": false, "createdAt": "2026-10-09T00:00:00Z", "updatedAt": "2026-10-09T00:00:00Z" }
]
```

**Code Example (Pseudocode):**
```javascript
test('should skip malformed tasks and validate schema on load', () => {
  const malformedData = [
    { id: '1', title: 'Valid', description: '', completed: false, createdAt: now, updatedAt: now },
    { id: '2', title: 'Missing description', completed: false },
    { title: 'Missing ID', description: '', completed: false, createdAt: now, updatedAt: now },
    { id: '3', title: 123, description: '', completed: false, createdAt: now, updatedAt: now }
  ];
  localStorage.setItem('todos-app-data', JSON.stringify(malformedData));

  render(<App />);

  // Verify only valid task appears
  expect(screen.getByText('Valid')).toBeInTheDocument();
  expect(screen.queryByText('Missing description')).not.toBeInTheDocument();
  expect(screen.queryByText('Missing ID')).not.toBeInTheDocument();

  // Verify no render errors
  expect(screen.queryByRole('alert')).not.toBeInTheDocument(); // no uncaught error boundary
});
```

---

## Coverage Expectations

**Expected Coverage from Integration Tests:**
- React component integration: 15-20%
- localStorage operations: 20-30%
- Data validation and error paths: 10-15%
- Overall contribution to 40% floor: ~30-40%

**Combined with BDD scenarios + unit tests, 40% line coverage should be achieved.**

## Test Data Management

### Sample Data for Tests

```javascript
const sampleTasks = [
  {
    id: '20261009120000000',
    title: 'Buy groceries',
    description: 'Milk, eggs, bread',
    completed: false,
    createdAt: '2026-10-09T12:00:00Z',
    updatedAt: '2026-10-09T12:00:00Z'
  },
  {
    id: '20261009120100000',
    title: 'Finish project',
    description: '',
    completed: true,
    createdAt: '2026-10-09T12:01:00Z',
    updatedAt: '2026-10-09T12:05:00Z'
  }
];
```

### localStorage Mock Setup

Tests should include setup/teardown:

```javascript
beforeEach(() => {
  localStorage.clear();
  vi.clearAllMocks();
});

afterEach(() => {
  localStorage.clear();
});
```

## Running Integration Tests

```bash
# Run all integration tests
npm run test -- src/features/tasks/__tests__/localStorage-integration.test.js

# Run with coverage
npm run test:coverage

# Watch mode for development
npm run test:watch

# View detailed output
npm run test -- --reporter=verbose
```

## Success Criteria

| Metric | Target |
|--------|--------|
| All 5 integration tests | ✅ Pass |
| localStorage persistence | ✅ Verified |
| Cross-unit interactions | ✅ Functional |
| Error handling | ✅ Graceful |
| No console errors | ✅ Zero |

## Failure Handling

If integration tests fail:
1. Review test error message and stack trace
2. Check if issue is test setup (mock, fixtures) or app code
3. Add `console.log()` or debugger to isolate failure point
4. If app code issue: loop back to Code Generation for fix
5. Re-run tests after fix

