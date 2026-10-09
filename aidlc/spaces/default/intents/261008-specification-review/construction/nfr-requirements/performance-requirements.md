# Performance Requirements

**Stage:** NFR Requirements (Construction)
**Unit:** Walking Skeleton (CRUD + localStorage)
**Upstream:** NFR1 (Performance — Page Load Time)

---

## Performance Targets

### NFR1.1: First Contentful Paint (FCP)

**Target:** < 1.5 seconds on standard 4G network (throttling: 4G via Chrome DevTools)

**Rationale:** React + Vite bundle should be small enough to render initial UI promptly. localStorage does not require network, so data load is synchronous after paint.

**Measurement Method:**
- Lighthouse performance audit (standard 4G throttle)
- Chrome DevTools Performance tab (FCP metric)
- Vite build analysis to verify no unnecessary code bundled

**Acceptance Criteria:**
- Initial page load renders UI < 1.5s
- FCP captured in CI build performance report

---

### NFR1.2: Time to Interactive (TTI)

**Target:** < 2 seconds total on standard 4G network

**Rationale:** App must be clickable and responsive immediately after load. React hydration + localStorage read should complete well within budget.

**Measurement Method:**
- Lighthouse TTI metric (standard 4G throttle)
- Manual testing: verify buttons are clickable within 2 seconds

**Acceptance Criteria:**
- Interactive elements (form, buttons) respond within 2 seconds of load
- No blocking JavaScript after FCP

---

### NFR1.3: Resource Utilization

**Target:**
- Bundle size (minified + gzipped): < 100 KB total
- Runtime memory: < 50 MB on idle
- CPU load during CRUD: < 10% average

**Rationale:** Single-device app with localStorage only; no streaming, no background workers. Lean bundle validates Vite optimization.

**Measurement Method:**
- `npm run build` output reports gzipped size
- Chrome DevTools Memory tab (heap snapshot on idle)
- Chrome DevTools Performance tab (CPU profile during task add/edit/delete)

**Acceptance Criteria:**
- Vite production build < 100 KB gzipped
- Idle memory < 50 MB (after initial load + data load)
- CRUD operations complete in < 100 ms (CPU spike < 10%)

---

### NFR1.4: Sustained Performance

**Target:** No memory leaks; consistent response time across 100+ task operations

**Rationale:** Walking skeleton will be tested with realistic task volumes (50-200 tasks in localStorage). Response time must not degrade.

**Measurement Method:**
- Create 100+ tasks in sequence, measure add/edit/delete latency
- Monitor heap usage for memory leaks (should return to baseline after operations)
- Visual regression: verify no rendering jank

**Acceptance Criteria:**
- Add/edit/delete operations complete in < 50 ms regardless of task count
- Memory returns to baseline after task operations (no persistent heap growth)
- UI remains responsive (60 fps target, no layout thrashing)

---

## Optimization Constraints

### Build Optimization (Vite)

- Code splitting: lazy-load routes (if any)
- Minification: enabled in production build
- Tree-shaking: unused dependencies removed
- CSS optimization: minify and deduplicate

### Runtime Optimization

- React.memo: use for components that receive static props
- useMemo: cache expensive computations (e.g., filtered task lists)
- useCallback: stable callback references for event handlers
- Dependency arrays: ensure correct useEffect/useMemo dependencies to prevent unnecessary re-renders

---

## Testing Strategy

**Performance Validation:**
- Lighthouse CI on merge commits (target score ≥ 90)
- Manual performance profiling on skeleton completion
- Load test with 100+ tasks to verify sustained performance

---

## Traceability

| Inception NFR | Construction Requirement | Status |
|---|---|---|
| NFR1 | NFR1.1, NFR1.2, NFR1.3, NFR1.4 | Detailed |

