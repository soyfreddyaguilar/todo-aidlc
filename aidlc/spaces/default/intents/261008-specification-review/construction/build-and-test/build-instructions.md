# Build Instructions — TODO App

## Prerequisites

- Node.js >= 18.x
- npm >= 9.x or yarn >= 1.22.x
- Git (for cloning, if applicable)

## Dependency Installation

```bash
npm install
```

**Expected output:** All dependencies resolved, node_modules/ created (~300-500 MB), package-lock.json updated.

**Troubleshooting:**
- If npm install fails: clear npm cache with `npm cache clean --force` and retry
- If conflicting peer dependencies: use `npm install --legacy-peer-deps` (last resort)
- If specific module fails: check network connection and retry that module: `npm install <module-name>`

## Environment Setup

### Development Environment

Create a `.env.local` file (optional, for development overrides):

```bash
# .env.local (development)
VITE_API_URL=http://localhost:3000  # (if backend added in future)
VITE_LOG_LEVEL=debug                # (development logging)
```

**Note:** Current skeleton uses localStorage only; no backend API required.

### Build Configuration Files

Verify the following files are present at repo root:

- `.prettierrc` — Prettier formatting config
- `.eslintrc.json` — ESLint linting config
- `vite.config.js` — Vite build bundler config
- `vitest.config.js` — Vitest test runner config
- `package.json` — npm dependency and script definitions

## Build Commands

### Development Build

```bash
npm run dev
```

**Purpose:** Start local dev server with hot-module reloading (HMR).

**Expected output:**
```
VITE v4.x.x  ready in xxx ms

➜  Local:   http://localhost:5173/
➜  Network: use --host to access from network
```

**Verification:**
- Dev server starts without errors
- Navigate to http://localhost:5173/ in browser
- App loads, can add/edit/delete tasks
- Console shows no errors

### Production Build

```bash
npm run build
```

**Purpose:** Create optimized production bundle.

**Expected output:**
```
vite v4.x.x building for production...
✓ xxx modules transformed
dist/index.html                   0.50 kB │ gzip: 0.35 kB
dist/assets/index-abc1234.js      55.28 kB │ gzip: 18.50 kB
dist/assets/index-abc5678.css     3.21 kB │ gzip: 1.15 kB
```

**Bundle Size Verification (NFR1.3 Target: < 100 KB gzipped):**
- Check output: gzipped JS size should be < 100 KB
- If > 100 KB: run `npm run build -- --debug` to analyze bundle composition
- If needed: investigate large dependencies with `npm ls` or Vite plugin analysis

**Build Artifacts:**
- `dist/index.html` — Entry point
- `dist/assets/*.js` — Bundled JavaScript
- `dist/assets/*.css` — Bundled CSS

### Preview Production Build

```bash
npm run preview
```

**Purpose:** Local preview of production build (Vite's native server).

**Expected output:**
```
➜  Local:   http://localhost:4173/
```

**Verification:**
- Preview server starts without errors
- Load http://localhost:4173/ in browser
- App works identically to dev build
- No console errors

## Linting and Formatting

### Format Code (Prettier)

```bash
npm run format
```

**Purpose:** Auto-format all JS/JSX/CSS files.

**Expected output:** Silently reformats files (or reports no changes if already formatted).

### Check Linting (ESLint)

```bash
npm run lint
```

**Purpose:** Check code for linting violations (no-unused-vars, react-hooks, etc.).

**Expected output:**
```
0 errors and 0 warnings in XX files
```

Or, if violations found:
```
/path/to/file.jsx
  5:10  error  'unused' is defined but never used  no-unused-vars

1 error in 1 file
```

**Failure handling:** ESLint must pass (0 errors) before build is considered successful. Fix violations and re-run.

### Fix Linting Automatically

```bash
npm run lint:fix
```

**Purpose:** Auto-fix common linting issues (trailing commas, indentation, etc.).

**Expected output:** Fixes applied; some violations may require manual review.

## Build Verification Steps

### 1. Clean Build

```bash
npm run clean
npm install
npm run build
```

**Purpose:** Ensure no stale artifacts interfere with build.

**Verification:**
- No errors during install or build
- `dist/` directory created with expected files

### 2. Type Checking (TypeScript/JSX)

```bash
npm run type-check
```

**Purpose:** Verify TypeScript types and JSX syntax (if .ts/.tsx files present).

**Expected output:**
```
✓ 0 errors
```

Or, if violations found, list of type errors by file/line.

**Failure handling:** Type errors must be fixed before merge. Review errors and correct type annotations.

### 3. Bundle Analysis

```bash
npm run build -- --analyze
```

**Purpose:** Visualize bundle composition (if build-plugin supports --analyze).

**Expected output:** HTML report showing which modules contribute to bundle size.

**Use case:** Identify large dependencies or unused code if bundle exceeds NFR1.3 target (< 100 KB gzipped).

## Troubleshooting Build Issues

| Issue | Diagnosis | Resolution |
|-------|-----------|-----------|
| `npm install` fails | Network or peer dependency conflict | Check npm logs (`npm install --verbose`); try `npm cache clean --force` |
| Build fails with "Cannot find module" | Missing dependency or typo in import | Verify import path; re-run `npm install` |
| ESLint errors block build | Code violates linting rules | Run `npm run lint:fix` or manually fix violations |
| Type errors (TypeScript) | JSX or type annotation error | Review error message; correct types or JSX syntax |
| Bundle size > 100 KB gzipped | Large dependencies or code duplication | Analyze bundle with `--analyze`; consider code splitting or dependency replacement |
| Dev server won't start (HMR) | Port 5173 in use or misconfigured vite.config.js | Check for port conflicts; restart dev server |
| Production build inconsistent from dev | React Strict Mode or environment variable mismatch | Verify `.env` is loaded; check React dev vs. prod behavior |

## Continuous Integration (CI) Build

The CI pipeline (GitHub Actions, GitLab CI, or Jenkins) will run:

```bash
npm install
npm run lint
npm run type-check
npm run build
npm run test
npm run test:coverage
```

**CI Pass criteria:**
- ✅ npm install succeeds
- ✅ ESLint: 0 errors
- ✅ TypeScript: 0 errors
- ✅ npm run build: dist/ created, no errors
- ✅ npm run test: all tests pass
- ✅ Coverage ≥ 40% (spec-review floor)

**CI Failure:** Blocks merge to main. Fix issues and retry CI.

## Summary

**Build Status Checklist:**
- [ ] `npm install` completes successfully
- [ ] `npm run lint` passes (0 errors)
- [ ] `npm run type-check` passes (0 errors, if TypeScript)
- [ ] `npm run build` creates `dist/` with bundle < 100 KB gzipped
- [ ] `npm run dev` starts without errors
- [ ] App loads and functions in browser
- [ ] Ready for test execution

