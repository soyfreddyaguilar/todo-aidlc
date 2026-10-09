# Performance Test Instructions — TODO App

## Overview

Performance tests validate that the TODO app meets Non-Functional Requirement (NFR1) targets for speed, responsiveness, and resource efficiency.

**Target Metrics:**
- First Contentful Paint (FCP): < 1.5s on 4G network
- Time to Interactive (TTI): < 2s on 4G network
- Bundle size (gzipped): < 100 KB
- Runtime memory: < 50 MB idle
- CPU during CRUD: < 10% average
- Sustained performance: consistent response time with 100+ tasks

**Tools:** Lighthouse, Chrome DevTools, Vitest performance benchmarks, manual testing

---

## Pre-Test Setup

### 1. Production Build Required

Performance tests must run against production build (optimized code):

```bash
npm run build
npm run preview
```

**Verify:**
- `dist/` directory exists with optimized bundles
- Preview server running at http://localhost:4173/

### 2. Browser Configuration

**Recommended:** Chrome (latest) with DevTools

**Settings:**
- Disable browser extensions
- Close other tabs to avoid memory contention
- Disable auto-play media
- Use normal browsing mode (not incognito, to allow localStorage)

### 3. Network Throttling (for FCP/TTI tests)

Chrome DevTools → Network tab:
- Select "Custom" throttle preset
- Download: 400 kbps, Upload: 400 kbps, Latency: 400ms (simulates 4G)
- Disable cache (to simulate first visit)

---

## Performance Test 1: First Contentful Paint (FCP)

**Target:** < 1.5 seconds on 4G network (NFR1.1)

### Manual Lighthouse Test

**Steps:**

1. Open http://localhost:4173/ in Chrome
2. Open DevTools (F12) → Lighthouse tab
3. Configure:
   - Device: Mobile
   - Throttling: Applied
   - Disable cache: ✓
   - Categories: Performance only
4. Click "Analyze page load"
5. Wait for report to complete

**Expected Output:**
```
First Contentful Paint: 0.8s - 1.4s (Desired)
Performance Score: 90+
```

**Pass Criteria:**
- FCP < 1.5s
- Performance score ≥ 90

**If Failed:**
- Check "Performance" section for bottlenecks
- Common issues: Large JavaScript, slow CSS parsing, unoptimized images
- Review Vite bundle analysis: `npm run build -- --analyze`
- Consider code splitting or dependency optimization

### Automated Performance Test (Vitest)

**File:** `src/__tests__/performance.test.js` (if implementing automated checks)

```javascript
test('should render FCP within 1.5 seconds', async () => {
  // This requires a headless browser or performance API
  // Can use web-vitals npm package to measure FCP programmatically

  const { performance } = require('perf_hooks');
  const startTime = performance.now();

  render(<App />);

  // Simulate user interaction (first contentful paint)
  await screen.findByText(/Task/); // Wait for first content

  const fcpTime = performance.now() - startTime;
  expect(fcpTime).toBeLessThan(1500); // 1.5 seconds in ms
});
```

---

## Performance Test 2: Time to Interactive (TTI)

**Target:** < 2 seconds on 4G network (NFR1.2)

### Manual TTI Test

**Steps:**

1. Follow same setup as FCP test (Lighthouse, 4G throttle)
2. Review Lighthouse report for "Time to Interactive" metric
3. Expected value: < 2s

**Manual Verification:**
1. Load page on throttled network
2. After page renders, verify buttons are clickable:
   - Try clicking "Create" button
   - Try typing in title field
   - Verify form responds within 2 seconds

**Pass Criteria:**
- TTI < 2s
- Buttons respond to clicks within 2s
- No blocking JavaScript

**If Failed:**
- Check for long-running main thread tasks
- Review React hydration time (how long React takes to initialize)
- Verify third-party scripts aren't blocking (e.g., analytics)
- Consider React.lazy() for component code splitting

---

## Performance Test 3: Bundle Size

**Target:** < 100 KB gzipped (NFR1.3)

### Automatic Build Check

Run production build and check output:

```bash
npm run build
```

**Expected Output:**
```
dist/assets/index-abc1234.js      55.28 kB │ gzip: 18.50 kB
dist/assets/index-abc5678.css     3.21 kB │ gzip: 1.15 kB
```

**Pass Criteria:**
- Total gzipped JS < 100 KB
- Typical breakdown for small React app: 15-25 KB

**If Exceeded:**
1. Analyze bundle composition:
   ```bash
   npm run build -- --analyze
   ```
   - Review HTML report to identify large dependencies

2. Optimization strategies:
   - Remove unused dependencies: `npm ls` + `npm audit`
   - Check for duplicate packages: `npm dedupe`
   - Use production build: Ensure `NODE_ENV=production` during build
   - Consider smaller alternatives (e.g., `preact` instead of `react`)
   - Lazy-load routes or components

### Manual Bundle Inspection

```bash
# Check gzipped size of key files
gzip -c dist/assets/index-*.js | wc -c  # Should be < 102,400 bytes (100 KB)
```

---

## Performance Test 4: Resource Utilization

**Target:**
- Runtime memory: < 50 MB idle
- CPU during CRUD: < 10% average

### Memory Profiling

**Steps:**

1. Open http://localhost:4173/ in Chrome
2. DevTools → Memory tab
3. Click "Take heap snapshot" (baseline)
4. Allow page to fully load and settle (2 seconds)
5. Perform 10 CRUD operations (create, edit, delete tasks)
6. Take another heap snapshot (after operations)
7. Review memory growth

**Pass Criteria:**
- Idle heap: < 50 MB
- After 10 operations: no persistent growth > 2 MB
- Memory returned to baseline after operations complete

**If Exceeded:**
- Common causes: React component re-renders, event listener leaks, closure capturing large objects
- Debug with DevTools:
  - Take heap snapshot
  - Filter by retained objects
  - Look for unexpected data structures in memory
- Review useEffect cleanup functions (should remove listeners/timers)

### CPU Profiling

**Steps:**

1. DevTools → Performance tab
2. Click "Record" circle icon
3. Perform 5 rapid CRUD operations (add, edit, delete tasks)
4. Stop recording
5. Analyze "Main" thread section for long tasks

**Pass Criteria:**
- No task longer than 50ms (blocks UI responsiveness)
- Overall CPU during operations: < 10% average
- React rendering and reconciliation should be < 10ms per update

**If Exceeded:**
- Look for long tasks in Performance tab
- Common causes: expensive computations, O(n²) list filtering
- Optimize with React.memo, useMemo, useCallback
- Verify no synchronous blocking operations during render

---

## Performance Test 5: Sustained Performance with 100+ Tasks

**Target:** Consistent response time with 100-200 tasks in localStorage (NFR1.4)

### Bulk Task Load Test

**Manual Steps:**

1. Clear app data: `localStorage.clear()`
2. Create 100 tasks programmatically via DevTools console:

```javascript
const tasks = [];
for (let i = 0; i < 100; i++) {
  tasks.push({
    id: `${Date.now()}_${i}`,
    title: `Task ${i + 1}`,
    description: `Description for task ${i + 1}`,
    completed: i % 3 === 0, // ~33% completed
    createdAt: new Date(Date.now() - i * 60000).toISOString(),
    updatedAt: new Date(Date.now() - i * 60000).toISOString()
  });
}
localStorage.setItem('todos-app-data', JSON.stringify(tasks));
```

3. Reload app (F5)
4. Measure performance:
   - Time to load list: should be < 1s
   - Scroll performance: should be smooth (60 fps)
   - Response to filter/search: < 100ms
   - Response to edit/delete: < 50ms

### Automated Load Test (Vitest)

```javascript
test('should maintain performance with 100+ tasks', () => {
  // Create 100 tasks in localStorage
  const tasks = Array.from({ length: 100 }, (_, i) => ({
    id: `${i}`,
    title: `Task ${i}`,
    description: '',
    completed: i % 3 === 0,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  }));

  localStorage.setItem('todos-app-data', JSON.stringify(tasks));

  const startTime = performance.now();
  render(<App />);
  const loadTime = performance.now() - startTime;

  // Expect app to load within 1 second even with 100 tasks
  expect(loadTime).toBeLessThan(1000);

  // Verify all tasks rendered
  expect(screen.getAllByRole('listitem')).toHaveLength(100);

  // Test filter performance
  const filterStart = performance.now();
  fireEvent.click(screen.getByText('Completed'));
  const filterTime = performance.now() - filterStart;

  // Filter should complete within 100ms
  expect(filterTime).toBeLessThan(100);
});
```

### Expected Results

| Operation | 10 Tasks | 100 Tasks | 200 Tasks |
|-----------|----------|-----------|-----------|
| App load | < 200ms | < 500ms | < 800ms |
| List render | < 100ms | < 300ms | < 500ms |
| Filter/search | < 50ms | < 100ms | < 200ms |
| Create task | < 50ms | < 50ms | < 50ms |
| Edit task | < 50ms | < 50ms | < 50ms |
| Delete task | < 50ms | < 50ms | < 50ms |

**Pass Criteria:**
- All operations complete within target times
- No memory growth (heap returns to baseline)
- 60 fps scrolling (no jank)
- CPU stays < 10% average during operations

**If Sustained Performance Fails:**
- Profile list rendering: may need virtualization (react-window, react-virtualized)
- Optimize filter logic: avoid O(n²) array operations
- Check for unnecessary re-renders: use React DevTools Profiler
- Consider memoization for filtered lists (useMemo)

---

## Performance Test 6: Memory Leak Detection

**Target:** No memory leaks; memory returns to baseline

### Automated Detection (Vitest)

```javascript
test('should not leak memory during task operations', async () => {
  localStorage.setItem('todos-app-data', JSON.stringify([]));

  const { unmount } = render(<App />);

  // Baseline memory
  if (global.gc) global.gc();
  const baselineMemory = process.memoryUsage().heapUsed;

  // Perform 50 CRUD operations
  for (let i = 0; i < 50; i++) {
    // Create, edit, delete
    fireEvent.change(screen.getByPlaceholderText('Task title'), { target: { value: `Task ${i}` } });
    fireEvent.click(screen.getByText('Create'));
    const deleteButton = screen.getAllByText('Delete')[0];
    if (deleteButton) fireEvent.click(deleteButton);
  }

  // Force garbage collection
  if (global.gc) global.gc();
  const finalMemory = process.memoryUsage().heapUsed;

  // Memory growth should be minimal (< 5 MB)
  const growth = (finalMemory - baselineMemory) / 1024 / 1024;
  expect(growth).toBeLessThan(5);

  unmount();
});
```

**Run with GC flag:**
```bash
npm run test -- --inspect-brk  # Allows manual GC
# Or use node --expose-gc:
node --expose-gc ./node_modules/.bin/vitest
```

---

## Performance Test Checklist

| Test | Method | Target | Evidence |
|------|--------|--------|----------|
| FCP | Lighthouse | < 1.5s | Screenshot or JSON report |
| TTI | Lighthouse | < 2s | Lighthouse report |
| Bundle Size | `npm run build` | < 100 KB gzip | Build output |
| Memory (idle) | DevTools Memory | < 50 MB | Heap snapshot |
| CPU (CRUD) | DevTools Performance | < 10% avg | CPU profile |
| Sustained (100+) | Load test | Consistent < 100ms | Test output |
| Memory leaks | Heap snapshots | No growth | Baseline → final |

---

## Continuous Integration: Performance Baseline

For ongoing performance tracking, store baseline metrics:

**File:** `.github/workflows/performance-baseline.yml` (or similar)

```yaml
- name: Build and measure performance
  run: |
    npm run build
    node scripts/measure-performance.js > perf-report.json

- name: Compare against baseline
  run: |
    # If gzipped size exceeds baseline by > 10%, fail
    node scripts/check-performance.js perf-report.json baseline.json
```

**Baseline JSON Example:**
```json
{
  "bundleSize": 18500,  // bytes, gzipped
  "bundleSizeTarget": 102400,
  "performance": {
    "fcp": 1200,  // ms
    "tti": 1800,
    "memory": 45000000  // bytes
  }
}
```

---

## Failure Recovery

If performance tests fail:

1. **Identify bottleneck** (FCP, TTI, bundle, memory, CPU)
2. **Analyze root cause** (DevTools profiling, bundle analysis)
3. **Apply fix** (code optimization, dependency change)
4. **Re-run tests** (verify fix effectiveness)
5. **If persists:** Loop back to Code Generation for architectural review

---

## Summary

Performance tests ensure the TODO app is snappy, responsive, and resource-efficient. Combined with unit and integration tests, they provide comprehensive quality assurance before deployment.

