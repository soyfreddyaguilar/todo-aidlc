# Security Requirements

**Stage:** NFR Requirements (Construction)
**Unit:** Walking Skeleton (CRUD + localStorage)
**Upstream:** Phase 2 deferral for advanced security; skeleton addresses baseline controls

---

## Security Scope: Walking Skeleton

This is a **single-device, single-user, local-storage-only** application. No authentication, no backend, no network API. Security focus is on data integrity and preventing accidental data loss, not protection against remote attackers.

**Phase 2 Deferral (Out of Scope for Skeleton):**
- Encryption of localStorage (luxury for local app)
- Advanced authentication/authorization (N/A for single-user)
- Compliance logging (HIPAA, SOC 2 — not required for POC)
- Secrets management (no backend secrets)

**Skeleton Focus:**
- Input validation and sanitization
- Error handling for localStorage failures
- Clean code practices (no hardcoded secrets)
- Data integrity (no silent data loss)

---

## NFR4-6 (Security Baseline): Detailed Requirements

### NFR4.1: Input Validation

**Requirement:** All user inputs (task title, description) must be validated before processing or storage.

**Targets:**
- Title field: non-empty, max 500 characters
- Description field: optional, max 2000 characters
- Validation errors: shown via toast notification
- No unvalidated data written to localStorage

**Implementation:**
- Client-side validation in InputForm component (synchronous)
- Validation rules enforced before `createTask()` or `updateTask()` calls
- Validation errors logged to console in development

**Testing:**
- Unit test: empty title rejected
- Unit test: title > 500 chars rejected
- Unit test: description > 2000 chars rejected
- Integration test: invalid form doesn't create/update task in localStorage

**Acceptance Criteria:**
- Form validation prevents invalid data entry
- Validation errors displayed to user
- localStorage contains only validated data

---

### NFR4.2: Data Integrity (localStorage)

**Requirement:** localStorage data structure must match schema; corrupted or malformed data must be handled gracefully.

**Schema:**
```json
{
  "todos": [
    {
      "id": "20261009143300001",
      "title": "string (1-500 chars)",
      "description": "string or empty (0-2000 chars)",
      "completed": "boolean",
      "createdAt": "ISO 8601 timestamp",
      "updatedAt": "ISO 8601 timestamp"
    }
  ]
}
```

**Handling Corrupted Data:**
- On app load, `JSON.parse()` wrapped in try-catch
- If parse fails: show error toast, log to console, offer to clear localStorage
- If parse succeeds but data doesn't match schema: validate each task, skip malformed entries
- User notified of data loss

**Implementation:**
- `useTodos` hook includes data validation
- localStorage read in useEffect includes error boundary

**Testing:**
- Unit test: malformed JSON in localStorage handled gracefully
- Unit test: missing required fields in task objects skipped/logged
- Integration test: app loads with corrupted localStorage (shows error, doesn't crash)

**Acceptance Criteria:**
- Corrupted localStorage doesn't crash app
- User informed of data issue
- App remains usable (in-memory mode or cleared storage)

---

### NFR4.3: Error Handling (localStorage)

**Requirement:** localStorage quota exceeded and other errors must be handled gracefully.

**Scenarios:**
1. **Quota Exceeded:** User has added too many tasks, localStorage is full
   - Action: show error toast "Storage full"
   - Effect: create/update operations disabled
   - Recovery: user must delete tasks to free space, or clear all data

2. **localStorage Disabled:** Browser privacy settings disable storage
   - Action: show error toast "Storage unavailable"
   - Effect: in-memory only, data lost on refresh
   - Recovery: user enables storage or continues in-memory

3. **Sync Failure:** write to localStorage fails after a CRUD operation
   - Action: log to console, show error toast, mark operation as "pending sync"
   - Effect: state updated locally, localStorage sync retried on next operation
   - Recovery: automatic retry

**Implementation:**
- All `localStorage.setItem()` calls wrapped in try-catch
- Errors logged to console (dev) and error boundary (prod)
- Toast notifications for user feedback

**Testing:**
- Unit test: quota exceeded error caught and logged
- Unit test: disabled storage error caught and logged
- Integration test: create task with disabled storage (in-memory, data lost on refresh)

**Acceptance Criteria:**
- localStorage errors don't crash app
- User informed of errors via toast
- Operations fail gracefully (no silent data loss)

---

### NFR4.4: Code Security Practices

**Requirement:** Code must follow security best practices to prevent common vulnerabilities.

**Checklist:**
- No hardcoded secrets, API keys, or credentials in code
- No eval() or Function() calls
- Input sanitization: prevent XSS (React's JSX escaping is default)
- Error messages don't leak sensitive data (e.g., full error stack traces to user)

**Implementation:**
- Code review before merge checks for secrets
- Linting rules (ESLint) enforce no-eval, etc.
- Error messages are user-friendly, not verbose stack traces

**Testing:**
- Manual review: scan for hardcoded secrets
- Linting: ESLint with security plugin (if used)
- Integration test: console errors don't include stack traces

**Acceptance Criteria:**
- No secrets in code
- No unsafe patterns detected in code review
- Error messages are appropriate for users

---

## Security Testing Strategy

**Skeleton Phase:**
- Code review focused on input validation and error handling
- Manual testing: attempt to break input validation (SQL injection patterns, XSS, overlong strings)
- localStorage error simulation (disable storage, fill quota)

**Phase 2 (Deferred):**
- Penetration testing (if deemed necessary)
- Security scanning via npm audit
- localStorage encryption

---

## Traceability

| Inception NFR | Construction Requirement | Status |
|---|---|---|
| NFR4 (Code Quality) | NFR4.1, NFR4.2, NFR4.3, NFR4.4 | Detailed |

**Note:** NFR2 (Accessibility) and NFR5 (Code Style/Linting) also contribute to security posture via code cleanliness and maintainability; see those artifacts for details.

