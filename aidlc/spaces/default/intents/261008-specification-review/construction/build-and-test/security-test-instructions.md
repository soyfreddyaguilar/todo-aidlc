# Security Test Instructions — TODO App

## Overview

Security tests validate that the TODO app meets Non-Functional Requirement (NFR4-6) security and code quality targets. These tests focus on input validation, data integrity, error handling, and secure coding practices.

**Security Scope:** Local, single-user app; no authentication or backend API.

**Test Methods:**
- Unit tests: input validation, error handling
- Manual code review: hardcoded secrets, unsafe patterns
- Integration tests: error boundaries, data flow
- Manual security testing: attempt to break validation

---

## Security Test 1: Input Validation (NFR4.1)

**Requirement:** All user inputs validated before storage; no unvalidated data written to localStorage.

**File:** `src/shared/utils/__tests__/validation.test.js`

### Test 1.1: Empty Title Rejected

**Test:** `should reject empty title`

```javascript
test('should reject empty title', () => {
  const validationError = validateTitle('');
  expect(validationError).toBeDefined();
  expect(validationError).toMatch(/required|empty/i);
});
```

**Expected Behavior:**
- Empty string title rejected
- Error message displayed to user
- No task created in state or localStorage

**Manual Verification:**
- Open app, leave title empty, click Create
- Verify error message appears
- Verify no task in localStorage

---

### Test 1.2: Title Max Length (500 chars)

**Test:** `should reject title exceeding 500 characters`

```javascript
test('should reject title exceeding 500 characters', () => {
  const longTitle = 'a'.repeat(501);
  const validationError = validateTitle(longTitle);
  expect(validationError).toBeDefined();
  expect(validationError).toMatch(/too long|max 500/i);
});
```

**Expected Behavior:**
- Title > 500 chars rejected
- Error message specifies limit
- Task not created

**Manual Verification:**
- Paste 600-character string into title
- Click Create
- Verify rejection and error message

---

### Test 1.3: Description Max Length (2000 chars)

**Test:** `should reject description exceeding 2000 characters`

```javascript
test('should reject description exceeding 2000 characters', () => {
  const longDesc = 'a'.repeat(2001);
  const validationError = validateDescription(longDesc);
  expect(validationError).toBeDefined();
  expect(validationError).toMatch(/too long|max 2000/i);
});
```

**Expected Behavior:**
- Description > 2000 chars rejected
- Error message specifies limit
- Task not created

---

### Test 1.4: Whitespace-Only Title Rejected

**Test:** `should reject title with only whitespace`

```javascript
test('should reject whitespace-only title', () => {
  const validationError = validateTitle('   ');
  expect(validationError).toBeDefined();
  expect(validationError).toMatch(/required|whitespace/i);
});
```

**Expected Behavior:**
- Trimmed title treated as empty
- Rejected with error message

---

### Test 1.5: Valid Titles Accepted

**Test:** `should accept valid titles`

```javascript
test('should accept valid title', () => {
  const validTitle = 'Buy groceries';
  const validationError = validateTitle(validTitle);
  expect(validationError).toBeUndefined();
});

test('should accept title at max length (500 chars)', () => {
  const maxTitle = 'a'.repeat(500);
  const validationError = validateTitle(maxTitle);
  expect(validationError).toBeUndefined();
});
```

**Expected Behavior:**
- Valid titles (1-500 chars) accepted
- No error message
- Task creation allowed

---

### Test 1.6: Special Characters Handled

**Test:** `should handle special characters in title and description`

```javascript
test('should accept special characters', () => {
  const specialTitle = '!@#$%^&*()_+-=[]{};":<>?,./';
  const validationError = validateTitle(specialTitle);
  expect(validationError).toBeUndefined();
});

test('should escape HTML in title', () => {
  const htmlTitle = '<script>alert("XSS")</script>';
  // Title should be treated as literal string, not executed
  expect(validateTitle(htmlTitle)).toBeUndefined();
  // When rendered, should display as text, not execute script
});
```

**Expected Behavior:**
- Special characters accepted (no rejection)
- HTML/script tags treated as literal text, not parsed
- React's JSX escaping prevents XSS

---

### Integration Test 1.7: Invalid Form Doesn't Create Task

**Test:** `should not create task with invalid input`

```javascript
test('should not create task with empty title', () => {
  localStorage.clear();
  render(<App />);

  // Try to submit with empty title
  fireEvent.change(screen.getByPlaceholderText('Task title'), { target: { value: '' } });
  fireEvent.click(screen.getByText('Create'));

  // Verify error message
  expect(screen.getByText(/required|empty/i)).toBeInTheDocument();

  // Verify task NOT in localStorage
  const saved = JSON.parse(localStorage.getItem('todos-app-data') || '[]');
  expect(saved).toHaveLength(0);
});
```

**Expected Behavior:**
- Invalid input blocked at UI level
- No task created
- localStorage remains clean

---

## Security Test 2: Data Integrity (NFR4.2)

**Requirement:** localStorage data must match schema; corrupted data handled gracefully.

**File:** `src/shared/utils/__tests__/localStorage.test.js`

### Test 2.1: Malformed JSON Handled

**Test:** `should handle malformed JSON in localStorage`

```javascript
test('should handle malformed JSON gracefully', () => {
  localStorage.setItem('todos-app-data', '{invalid json}');

  // App should not crash
  expect(() => render(<App />)).not.toThrow();

  // Should show error message or fallback to empty state
  expect(screen.getByText(/error|storage|could not load/i)).toBeInTheDocument();
});
```

**Expected Behavior:**
- JSON.parse() wrapped in try-catch
- Error message shown to user
- App doesn't crash
- Fallback to empty list or prompt to clear storage

---

### Test 2.2: Missing Required Fields Skipped

**Test:** `should skip tasks with missing required fields`

```javascript
test('should skip tasks missing required fields', () => {
  const malformedTasks = [
    { id: '1', title: 'Valid', description: '', completed: false, createdAt: now, updatedAt: now },
    { title: 'Missing ID', description: '', completed: false, createdAt: now, updatedAt: now }, // Missing id
    { id: '2', /* missing title */ description: '', completed: false, createdAt: now, updatedAt: now }
  ];
  localStorage.setItem('todos-app-data', JSON.stringify(malformedTasks));

  render(<App />);

  // Only valid task should appear
  expect(screen.getByText('Valid')).toBeInTheDocument();
  expect(screen.queryByText('Missing ID')).not.toBeInTheDocument();
});
```

**Expected Behavior:**
- Invalid tasks silently skipped
- Valid tasks loaded and displayed
- Console warning logged for each skipped task

---

### Test 2.3: Wrong Data Types Validated

**Test:** `should validate data types`

```javascript
test('should handle wrong data types', () => {
  const wrongTypes = [
    {
      id: '1',
      title: 123, // Should be string
      description: '',
      completed: 'yes', // Should be boolean
      createdAt: now,
      updatedAt: now
    }
  ];
  localStorage.setItem('todos-app-data', JSON.stringify(wrongTypes));

  render(<App />);

  // App should either skip or coerce types
  // Verify no crashes
  expect(screen.queryByRole('alert')).not.toBeInTheDocument(); // No error boundary
});
```

**Expected Behavior:**
- Type mismatches detected
- Invalid entries skipped or type-coerced
- App remains stable

---

### Test 2.4: Schema Validation on Load

**Test:** `should validate complete schema on load`

```javascript
const expectedSchema = {
  id: 'string (timestamp format)',
  title: 'string (1-500 chars)',
  description: 'string (0-2000 chars)',
  completed: 'boolean',
  createdAt: 'ISO 8601 timestamp',
  updatedAt: 'ISO 8601 timestamp'
};

test('should load only schema-compliant tasks', () => {
  const compliantTask = {
    id: '20261009120000000',
    title: 'Buy groceries',
    description: 'Milk, eggs',
    completed: false,
    createdAt: '2026-10-09T12:00:00Z',
    updatedAt: '2026-10-09T12:00:00Z'
  };

  localStorage.setItem('todos-app-data', JSON.stringify([compliantTask]));
  render(<App />);

  // Should display valid task
  expect(screen.getByText('Buy groceries')).toBeInTheDocument();
});
```

**Expected Behavior:**
- Only schema-compliant tasks loaded
- Validation enforced on every app startup

---

## Security Test 3: Error Handling (NFR4.3)

**Requirement:** localStorage errors handled gracefully; no crashes, no silent data loss.

**File:** `src/shared/utils/__tests__/localStorage.test.js` + integration tests

### Test 3.1: Quota Exceeded Caught

**Test:** `should catch and handle quota exceeded error`

```javascript
test('should handle localStorage quota exceeded', () => {
  const originalSetItem = localStorage.setItem;
  localStorage.setItem = vi.fn((key, value) => {
    const error = new Error('QuotaExceededError');
    error.code = 22;
    throw error;
  });

  render(<App />);

  // Attempt create
  fireEvent.change(screen.getByPlaceholderText('Task title'), { target: { value: 'New task' } });
  fireEvent.click(screen.getByText('Create'));

  // Verify error toast shown
  expect(screen.getByText(/storage full|quota/i)).toBeInTheDocument();

  localStorage.setItem = originalSetItem;
});
```

**Expected Behavior:**
- QuotaExceededError caught
- User-friendly error message displayed
- Create operation fails gracefully
- No data corruption

---

### Test 3.2: localStorage Disabled Handled

**Test:** `should handle disabled localStorage`

```javascript
test('should handle disabled localStorage', () => {
  const originalGetItem = localStorage.getItem;
  localStorage.getItem = vi.fn(() => {
    throw new Error('localStorage is disabled');
  });

  // App should load in memory-only mode
  expect(() => render(<App />)).not.toThrow();
  expect(screen.getByText(/storage unavailable|in-memory/i)).toBeInTheDocument();

  localStorage.getItem = originalGetItem;
});
```

**Expected Behavior:**
- App detects disabled storage
- Falls back to in-memory mode
- User informed of limitations
- App remains functional

---

### Test 3.3: Sync Failure Handled

**Test:** `should handle write failure after create`

```javascript
test('should handle failed localStorage write', () => {
  const originalSetItem = localStorage.setItem;
  let callCount = 0;
  localStorage.setItem = vi.fn((key, value) => {
    callCount++;
    if (callCount > 1) throw new Error('Write failed');
  });

  render(<App />);
  fireEvent.change(screen.getByPlaceholderText('Task title'), { target: { value: 'Task' } });
  fireEvent.click(screen.getByText('Create'));

  // Verify error shown
  expect(screen.getByText(/error|sync failed/i)).toBeInTheDocument();

  localStorage.setItem = originalSetItem;
});
```

**Expected Behavior:**
- Write failure caught
- Error message displayed
- State remains consistent
- Automatic retry on next operation (optional)

---

### Test 3.4: Console Errors Don't Leak Data

**Test:** `should not expose sensitive data in error messages`

```javascript
test('should not leak sensitive data in error messages', () => {
  const consoleErrorSpy = vi.spyOn(console, 'error');

  render(<App />);
  fireEvent.change(screen.getByPlaceholderText('Task title'), { target: { value: 'a'.repeat(1000) } });
  fireEvent.click(screen.getByText('Create'));

  // Check error messages don't contain stack traces or internal data
  const errorCalls = consoleErrorSpy.mock.calls;
  errorCalls.forEach(call => {
    const message = call[0];
    if (typeof message === 'string') {
      // Should be user-friendly, not verbose stack trace
      expect(message).not.toMatch(/at.*:.*:\d+/); // No stack trace
    }
  });

  consoleErrorSpy.mockRestore();
});
```

**Expected Behavior:**
- Error messages are user-friendly
- No stack traces exposed to user
- No internal state leaked

---

## Security Test 4: Code Security Practices (NFR4.4)

**Requirement:** No hardcoded secrets, no unsafe patterns, no XSS vulnerabilities.

### Manual Code Review Checklist

**Scan for secrets:**

```bash
# Check for hardcoded credentials
grep -r "password\|api.key\|secret\|token" src/ --include="*.js" --include="*.jsx"

# Check for AWS keys, database URLs, etc.
grep -r "aws_secret\|mongodb://\|DATABASE_URL" src/ --include="*.js" --include="*.jsx"
```

**Expected Result:** No secrets found.

---

### Test 4.1: No eval() or Function() Calls

**Test:** `should not use eval() or Function()`

```javascript
test('should not contain eval or Function constructors', () => {
  // Static analysis: scan source code
  const sourceCode = fs.readFileSync('src/App.jsx', 'utf-8');
  expect(sourceCode).not.toMatch(/eval\(/);
  expect(sourceCode).not.toMatch(/new Function\(/);
  expect(sourceCode).not.toMatch(/Function\(/);
});
```

**Manual Check:**
```bash
grep -r "eval\|Function(" src/ --include="*.js" --include="*.jsx"
```

**Expected Result:** No matches.

---

### Test 4.2: HTML Escaping (React JSX)

**Test:** `should escape HTML in user input`

```javascript
test('should escape HTML in task title', () => {
  const htmlTitle = '<img src=x onerror="alert(\'XSS\')">';
  localStorage.setItem('todos-app-data', JSON.stringify([{
    id: '1',
    title: htmlTitle,
    description: '',
    completed: false,
    createdAt: now,
    updatedAt: now
  }]));

  const { container } = render(<App />);

  // React escapes by default; title should be literal text
  expect(screen.getByText(htmlTitle)).toBeInTheDocument();

  // Should not find executable img tag
  expect(container.querySelector('img[onerror]')).not.toBeInTheDocument();
});
```

**Expected Behavior:**
- React's JSX automatically escapes HTML
- User input displayed as literal text
- No script execution
- No XSS vulnerability

---

### Test 4.3: No Hardcoded Secrets

**Test:** `should not contain hardcoded secrets`

```javascript
test('should not contain hardcoded API keys', () => {
  const sourceFiles = glob.sync('src/**/*.{js,jsx}');
  sourceFiles.forEach(file => {
    const content = fs.readFileSync(file, 'utf-8');
    expect(content).not.toMatch(/api[_-]?key\s*=\s*["']/i);
    expect(content).not.toMatch(/password\s*=\s*["']/i);
    expect(content).not.toMatch(/sk_[a-z0-9]{20,}/); // Stripe format
    expect(content).not.toMatch(/AKIA[0-9A-Z]{16}/); // AWS format
  });
});
```

**Manual Check:**
```bash
grep -r "AKIA\|sk_live\|sk_test\|password=" src/ --include="*.js" --include="*.jsx"
```

**Expected Result:** No secrets found.

---

### Test 4.4: Error Messages Don't Leak Info

**Test:** `should not expose stack traces to users`

```javascript
test('should not show stack traces in error UI', () => {
  // Trigger an error in the app
  localStorage.setItem('todos-app-data', 'not valid json');

  render(<App />);

  // Error message should be user-friendly
  const errorMessage = screen.getByText(/error|could not load/i);
  expect(errorMessage.textContent).not.toMatch(/\s+at\s+/); // No stack trace
  expect(errorMessage.textContent).not.toMatch(/TypeError|ReferenceError/); // No exception type
});
```

**Expected Behavior:**
- User sees: "An error occurred. Please try refreshing."
- User doesn't see: "TypeError: Cannot read property 'title' of undefined at line 123"

---

## Manual Security Testing

### 1. XSS Injection Attempts

**Test in browser console:**

```javascript
// Try to create task with XSS payload
const xssPayloads = [
  '<script>alert("XSS")</script>',
  '<img src=x onerror="alert(\'XSS\')">',
  '"><script>alert("XSS")</script><"',
  'javascript:alert("XSS")'
];

xssPayloads.forEach(payload => {
  console.log('Testing:', payload);
  // Manually create task in UI with this payload
  // Verify it displays as literal text, not executed
});
```

**Expected Result:**
- All payloads displayed as literal text
- No alerts or console errors
- No script execution

---

### 2. localStorage Manipulation

**Test in browser console:**

```javascript
// Try to corrupt localStorage
localStorage.setItem('todos-app-data', '{broken json');

// Reload app and verify:
// 1. App doesn't crash
// 2. Error message shown
// 3. Can still create new tasks

// Try to inject malicious task
const injected = [{
  id: '1',
  title: '<img src=x onerror="alert()">',
  description: 'malicious',
  completed: false,
  createdAt: new Date().toISOString(),
  updatedAt: new Date().toISOString()
}];
localStorage.setItem('todos-app-data', JSON.stringify(injected));

// Reload app and verify:
// 1. Injected task loaded
// 2. Payload displayed as literal text
// 3. No script execution
```

**Expected Result:** App handles gracefully, no execution.

---

### 3. Input Length Attacks

**Test in browser:**

```javascript
// Try to exceed max lengths
document.querySelector('input[placeholder*="title"]').value = 'a'.repeat(1000);
document.querySelector('button:contains("Create")').click();

// Verify:
// 1. Form rejects or truncates
// 2. Task not created with > 500 chars
// 3. Error message shown
```

**Expected Result:** Validation catches length violations.

---

## Security Test Summary

| Test | Method | Pass Criterion |
|------|--------|----------------|
| Input validation | Unit tests | All 6 tests pass |
| Data integrity | Integration tests | Schema enforced |
| Error handling | Unit + integration | Errors caught, no crashes |
| Code practices | Code review | No secrets, no eval, no XSS |
| Manual testing | Browser console | Injection attempts blocked |

---

## Failure Recovery

If security tests fail:

1. **Identify vulnerability** (XSS, injection, data leak, etc.)
2. **Assess risk** (critical, high, medium, low)
3. **Apply fix** (input validation, escaping, error handling)
4. **Re-test** (verify fix closes vulnerability)
5. **Document** (security learnings for team)

---

## Deferred Security (Phase 2)

Out of scope for skeleton, defer to Phase 2:
- localStorage encryption
- Advanced authentication/authorization
- HIPAA/SOC2 compliance logging
- Penetration testing

---

## Summary

Security tests ensure the TODO app follows secure coding practices, validates all inputs, handles errors gracefully, and prevents common web vulnerabilities. Combined with code review, they provide defense-in-depth security for a single-user, local-storage-only application.

