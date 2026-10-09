# Observability Requirements

**Stage:** NFR Requirements (Construction)
**Unit:** Walking Skeleton (CRUD + localStorage)
**Upstream:** NFR9 (No Console Errors), Team Practices (error logging)

---

## Observability Scope: Skeleton

The walking skeleton uses **console logging for development** and **error boundaries for production**. No structured logging, metrics, or alerts—those are Phase 2 topics. The goal is visibility into errors and unexpected behavior.

**Skeleton Observability:**
- Console logging of key operations (development only)
- Error logging via console.error (development) and error boundary (production)
- No external services or APM
- Browser DevTools sufficient for debugging

---

## NFR9.1: Console Error Logging

**Requirement:** No JavaScript errors or warnings in browser console during normal operation.

**Targets:**
- Zero console errors on load
- Zero console errors during CRUD operations
- Zero console warnings from React (dependency arrays, etc.)

**Implementation:**
- Proper error handling: try-catch around risky operations
- React dependency arrays correct to prevent useEffect warnings
- Linting: ESLint with React plugin catches common issues
- Error boundary catches rendering errors

**Testing:**
- Open app, verify console is clean (no errors, no warnings)
- Perform CRUD operations, verify console stays clean
- Simulate failures (quota exceeded, corrupted data), verify errors logged properly

**Acceptance Criteria:**
- No errors or warnings in console during normal use
- Errors are logged when they occur (intentional logging)
- No unhandled promise rejections

---

## NFR9.2: Development vs. Production Logging

**Requirement:** Verbose logging in development; minimal logging in production.

**Development:**
- Task creation logged: `console.log("Task created:", task)`
- Task updates logged: `console.log("Task updated:", id, changes)`
- Task deletion logged: `console.log("Task deleted:", id)`
- localStorage operations logged: `console.log("Storage written:", key, size)`
- Filter changes logged: `console.log("Filter changed:", filter)`

**Production:**
- Errors only: `console.error(message, error)`
- No debug logs (keep console clean for users)
- Error boundary logs to console (not to external service)

**Implementation:**
- Environment check: `if (process.env.NODE_ENV === 'development')`
- Conditional logging: `console.log` wrapped in development check
- Error handling: `console.error` in both environments

**Testing:**
- Verify dev build has verbose logs
- Verify production build has only errors (no debug logs)
- Linting: rule to forbid console.log in production code

**Acceptance Criteria:**
- Development build has readable debug logs
- Production build has minimal logs (errors only)
- CI enforces no console.log in production code

---

## NFR9.3: Error Boundary

**Requirement:** React error boundary catches rendering errors and prevents white-screen crashes.

**Targets:**
- Unexpected component errors caught and logged
- Fallback UI shown to user (e.g., "Something went wrong")
- Error logged to console with stack trace

**Implementation:**
- Error boundary wrapper at App level
- Catches rendering errors only (not async errors)
- Logs error to console
- Shows user-friendly fallback message

**Testing:**
- Unit test: render component that throws, verify error boundary catches it
- Manual test: intentionally trigger error, verify fallback shown

**Acceptance Criteria:**
- Rendering errors don't crash app
- Error boundary logs details to console
- User sees helpful error message

---

## NFR9.4: Storage Error Logging

**Requirement:** localStorage errors must be logged with sufficient detail for debugging.

**Targets:**
- Quota exceeded errors logged with operation (add/edit/delete)
- Disabled storage errors logged with detection method
- Corrupted data errors logged with parse details
- All errors include timestamp and context

**Implementation:**
- Try-catch around `localStorage.setItem/getItem/removeItem`
- Error logged with: `console.error("Storage error:", { operation, error, details })`
- Toast notification shown to user (separate from logging)

**Testing:**
- Simulate quota exceeded, verify error logged
- Simulate disabled storage, verify error logged
- Simulate corrupted JSON, verify error logged

**Acceptance Criteria:**
- Storage errors logged to console with context
- User informed via toast notification
- Logs include enough detail for debugging

---

## NFR9.5: Async Operation Tracking (Optional)

**Requirement:** Track async operations (localStorage writes) to catch silent failures.

**Targets:**
- localStorage.setItem wrapped in try-catch
- Failures logged and reported to user
- No operations silently fail

**Implementation:**
- All `localStorage.setItem()` calls wrapped in try-catch
- Success logged in development: `console.log("Storage written: ok")`
- Failure logged in both environments: `console.error("Storage write failed:", error)`

**Testing:**
- Mock localStorage.setItem to throw error
- Verify error is caught and logged

**Acceptance Criteria:**
- Storage operations logged
- Failures are visible to developer
- No silent data loss

---

## Phase 2 Observability Enhancements (Deferred)

**Future Topics:**
- Structured logging (JSON format, correlation IDs)
- Metrics collection (operation latency, error rates)
- Analytics (feature usage, user behavior)
- External log aggregation (if multi-user)
- Performance monitoring (Lighthouse CI, WebVitals)
- Error tracking service (Sentry, Rollbar) if deploying publicly

---

## Traceability

| Inception NFR | Construction Requirement | Status |
|---|---|---|
| NFR9 (No Console Errors) | NFR9.1, NFR9.2, NFR9.3, NFR9.4, NFR9.5 | Detailed |

**Related:** Logging strategy supports NFR4 (Code Quality), NFR10 (State Management), and NFR4.3 (Error Handling).

