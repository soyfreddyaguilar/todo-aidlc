**Collaborator:** aidlc-devsecops-agent

## Contribution

The proposed Deployment section establishes a reasonable foundation for a spec-review, greenfield React 18 application with automatic staging deployment and manual production approval. The deployment strategy aligns with org-level policy (deploy on merge to staging, manual production gate) and is appropriately scoped for a POC-phase, browser-based application with no backend server component.

### Deployment Strategy Assessment

**Strengths:**
- Automatic staging deployment on merge aligns with org-level deployment defaults and supports rapid iteration for a spec-review scope
- Manual production approval gate (tech lead sign-off) is appropriate for greenfield work and provides a human control point before customer/end-user exposure
- Health checks post-deployment demonstrate awareness of verification requirements (aligned with operation phase guardrails)
- Rollback procedures are documented (both automated and manual), meeting the operation phase requirement: "All deployment procedures must include rollback steps"

**Scope alignment:**
- Rolling restart is adequate for POC phase; the practice appropriately flags upgrade path to blue-green/canary if needed later
- This matches org-level guidance ("Teams that have invested in test coverage and observability sometimes graduate to continuous deployment to production; that's a team decision")

### Critical Security Gaps

The Deployment section covers deployment mechanics but **fails to address critical security requirements** that are mandatory for browser-based applications with persistent data storage. Three security gaps must be resolved before implementation:

#### 1. Secrets and Credentials Management (CRITICAL)

The Deployment section does not mention how secrets, API keys, environment-specific configuration, or credentials are handled. For a greenfield React application:

**Missing requirements:**
- **Environment variables:** No guidance on `.env`, `.env.local`, `.env.production` separation or how they are injected at build time vs. runtime
- **Build-time vs. runtime secrets:** React/Vite applications are static assets; secrets cannot be injected at runtime post-deployment. All environment-specific configuration must be baked into the build artifact or injected at build time via GitHub Actions/CI/CD environment variables
- **Credential exposure risk:** Vite's `VITE_` prefix exposes variables to the client bundle if not handled correctly. The team should understand that `VITE_PUBLIC_*` variables are intentionally exposed, while `VITE_*` (without `PUBLIC`) are build-time only and not leaked to the browser
- **Secrets manager integration:** No mention of whether secrets are stored in GitHub Secrets, AWS Secrets Manager, or another vault; this must be documented
- **No hardcoding enforcement:** Code Style section mentions error handling but does not explicitly forbid hardcoded API keys, tokens, or secrets in source code

**Risk:** If secrets are hardcoded, committed to `main`, or exposed through environment variables in the build output, they can be extracted by any user with access to the deployed JavaScript bundle.

**Recommendation:** Add a subsection "Secrets & Environment Variables" to the Deployment section documenting:
- How staging vs. production environment variables are injected (CI/CD environment secrets)
- Use of `VITE_PUBLIC_*` for intentionally exposed config (API endpoints) and `VITE_*` for build-time secrets
- Prohibition on hardcoding secrets anywhere in source code
- Reference to OWASP guidelines for client-side secret handling

#### 2. localStorage Security and Data Integrity (CRITICAL)

The team's Walking Skeleton and Testing Posture depend heavily on localStorage for persistence ("persist across browser refresh"). However, the Deployment section provides **no security guidance** for localStorage operations, creating multiple risks:

**Missing requirements:**
- **Data validation:** localStorage data is user-controlled (via browser DevTools) and can be maliciously modified before the application consumes it. No validation guidance exists
- **Serialization/deserialization:** JSON.parse/JSON.stringify on untrusted data can fail silently or be exploited. No error handling strategy is documented
- **Data versioning:** If the TODO schema changes (add new fields, rename fields), what happens to stored tasks from older versions? No migration strategy exists
- **Storage quota handling:** localStorage has a 5-10 MB limit per domain; no handling of quota-exceeded errors
- **XSS attack surface:** localStorage is accessible to any JavaScript on the same domain (including injected scripts). If the application is vulnerable to XSS, localStorage data is compromised
- **No encryption:** TODO items stored in plaintext localStorage can be read by browser DevTools or malicious scripts; no guidance on whether sensitive fields should be encrypted

**Risk:** Tasks stored in localStorage can be corrupted by user or attacker, causing data loss, app crashes, or unexpected behavior. The application may fail to handle quota exceeded errors, causing silent failures.

**Recommendation:** Add a subsection "Client-Side Data Persistence" to the Deployment section or reference it from Code Style:
- Require JSON schema validation (use a library like `zod`, `joi`, or `ajv`) before consuming localStorage data
- Document error handling for parse failures, quota exceeded, and schema mismatches
- Add versioning scheme for TODO schema; document migration strategy for old data formats
- Recommend encryption for sensitive fields (if applicable; less critical for a TODO app, but sets precedent)
- Add localStorage security note to Code Style error handling guidance

#### 3. CI/CD Security and Build Artifact Verification (IMPORTANT)

The Deployment section states "CI passes: linting, tests, build" but provides no security details about the CI/CD pipeline itself:

**Missing requirements:**
- **Build artifact verification:** How are build artifacts verified? Is there an integrity check (SRI, hash verification) for deployed assets?
- **Dependency scanning:** No mention of scanning npm dependencies for known vulnerabilities. This is standard practice (e.g., `npm audit`, Snyk, Dependabot)
- **SBOM/supply chain:** No mention of software bill of materials (SBOM) or supply chain security verification
- **CI/CD secrets isolation:** GitHub Actions (or other CI/CD system) must use encrypted environment secrets; the practice should reference this
- **Artifact retention/cleanup:** No guidance on how long old build artifacts are retained or when they are cleaned up (potential data retention risk)

**Risk:** A compromised dependency could inject malicious code into the build artifact. Without dependency scanning, this would not be detected before deployment.

**Recommendation:** Enhance the Deployment section to include:
- Requirement for dependency scanning in CI (npm audit or equivalent in each PR; fail the build if high/critical vulnerabilities are found)
- Baseline guidance on CI/CD secrets management (use GitHub Secrets or equivalent for staging/production credentials)
- Document expected artifact retention policy (e.g., "artifacts retained for 30 days")

### Health Checks Assessment

**Strengths:**
- Post-deployment health checks are mentioned ("confirm app loads, basic CRUD operations work, localStorage syncs correctly")
- This aligns with operation phase guardrails: "Deployments to production must have a defined smoke test or health check to verify success"

**Gap:**
- Health checks are listed at a high level but not formalized as an automated step; the team should document:
  - Whether health checks run automatically post-deploy or require manual verification
  - What tool/script runs the checks (e.g., Playwright for E2E, custom shell script for endpoints, manual steps)
  - Pass/fail criteria for each check
  - Failure handling (automated rollback vs. manual intervention decision)

**Recommendation:** Document health check automation in the Deployment section; formalize the checks as reproducible, automated steps (not manual verification).

### Rollback Procedures Assessment

**Strengths:**
- Rollback is documented: "Automated rollback if health checks fail; manual rollback procedure documented (revert commit, redeploy, verify)"
- Aligns with operation phase requirement: "All deployment procedures must include rollback steps — document how to reverse every change"

**Gaps:**
1. **Automated rollback clarity:** If a health check fails, what triggers rollback? Which service/process performs it? How long does rollback take?
2. **Manual rollback completeness:** The procedure (revert commit, redeploy, verify) is stated but not detailed; should include:
   - Who has authority to trigger rollback (tech lead, on-call engineer)?
   - What does "revert commit" mean in a squash-merge workflow (git revert? Force push? Tag-based rollback)?
   - How is cache invalidation handled (CDN, browser cache, service worker)? Static asset caching could serve stale code after rollback
   - Post-rollback verification steps (check staging smoke tests, production health checks, user-reported issues)
3. **Time-to-rollback:** No SLO or expected duration for rollback completion (e.g., "rollback completes within 5 minutes")

**Recommendation:** Expand the rollback section with:
- Automation triggers and timeline for automated rollback
- Detailed manual rollback procedure including cache invalidation and verification steps
- Authority and escalation path for rollback decisions
- Expected time-to-rollback SLO

### Browser/Client-Side Deployment Considerations

This project deploys to the browser (no backend server). The Deployment section should acknowledge client-specific concerns not present in traditional server deployments:

**Missing guidance:**
- **Service Workers:** If the team uses service workers for offline functionality or caching, how are they versioned and updated? Service worker cache can serve stale code even after new deployments
- **Browser cache invalidation:** Static assets (JS, CSS) are cached by browsers; how is cache-busting handled? (Typically via content-hash filenames in production builds, which Vite does by default, but this should be verified)
- **Progressive enhancement:** No guidance on what happens if a user has an older version of the app loaded before a new deployment; should they refresh, or does the app auto-detect and reload?
- **Downtime visibility:** Browser-based apps have no traditional "downtime"; however, a broken deployment is immediately visible to all users. How does the team handle user-facing errors during deployment transitions?

**Recommendation:** Add a subsection "Client-Side Deployment Specifics" documenting:
- Cache-busting strategy (confirm Vite's default content-hash behavior)
- Service worker versioning strategy (if applicable)
- Guidance on auto-refresh vs. user-initiated refresh for new app versions
- Error boundary and user notification strategy for deployment failures

### Summary of Technical Fit

The Deployment section is **appropriate for the scope** (greenfield, spec-review, POC-phase browser app) and correctly implements org-level policy (auto-staging, manual production gate, rollback procedures). However, it is **incomplete on critical security fronts**:

**Ready to affirm:**
- Automatic staging deployment on merge aligns with org policy and supports iteration
- Manual production approval gate (tech lead sign-off) is appropriate for greenfield work
- Health checks post-deployment are mentioned; formalization of automated checks is needed
- Rollback procedures are documented; expansion on manual procedure and cache handling is needed

**Requires refinement before implementation:**
- **CRITICAL:** Add secrets and environment variables management guidance (environment injection, VITE_PUBLIC_ vs. VITE_ distinction, CI/CD secrets)
- **CRITICAL:** Add localStorage data validation and integrity requirements (schema validation, error handling, versioning)
- **IMPORTANT:** Add dependency scanning requirement to CI/CD pipeline
- **IMPORTANT:** Formalize health checks as automated, reproducible steps with pass/fail criteria
- **IMPORTANT:** Expand rollback procedure with cache invalidation, authority, and time-to-rollback SLO
- **NICE-TO-HAVE:** Document client-side deployment specifics (cache-busting, service worker versioning, auto-refresh strategy)

---

## Positions

AGREE: Automatic deployment to staging environment on merge to `main` aligns with org-level policy and supports the team's trunk-based development workflow and rapid iteration for spec-review scope.

AGREE: Manual production approval gate requiring tech lead sign-off is appropriate for greenfield work and provides a necessary human control point before production exposure.

AGREE: Post-deployment health checks (app loads, CRUD operations, localStorage sync) demonstrate awareness of verification requirements and align with operation phase guardrails.

AGREE: Rollback procedures are documented with both automated failure-triggered rollback and manual revert procedure, meeting the operation phase requirement for rollback guidance.

AGREE: Rolling restart deployment strategy is appropriate for POC phase; the practice correctly identifies upgrade path to blue-green or canary if multi-instance deployment becomes necessary.

OBJECT: The Deployment section must include explicit guidance on secrets and environment variables management: environment-specific injection via CI/CD, prohibition on hardcoding secrets, distinction between VITE_PUBLIC_* (client-exposed) and VITE_* (build-time only) in Vite projects, and reference to the secrets manager used (GitHub Secrets, AWS Secrets Manager, etc.). This is critical to prevent credential exposure in the deployed JavaScript bundle.

OBJECT: The Deployment section or Code Style section must mandate localStorage data validation using a schema validator (zod, joi, ajv) before consuming persisted data, document error handling for parse failures and quota exceeded scenarios, and define a schema versioning strategy for TODO task format migrations. This is critical to prevent data corruption and application crashes from user-modified or malicious localStorage data.

OBJECT: The CI/CD pipeline description must include dependency scanning requirement (npm audit or equivalent vulnerability scanner) to prevent known-vulnerable packages from being deployed; CI should fail the build on high/critical vulnerabilities.

OBJECT: Health checks must be formalized as automated, reproducible steps with documented pass/fail criteria and failure handling (automated rollback trigger, notification, or manual decision gate); current description is too high-level to be actionable.

OBJECT: The manual rollback procedure must be expanded to include cache invalidation strategy (how browser/CDN cache is cleared), authority and escalation path for rollback decisions, and expected time-to-rollback SLO. Current procedure (revert commit, redeploy, verify) does not address cache-stale code risk in browser deployments.

OBJECT: Client-side deployment specifics must be documented or referenced: confirm cache-busting strategy (content-hash filenames, typically Vite default), document service worker versioning if applicable, and define user notification/auto-refresh strategy when new app versions are deployed (users may have stale code loaded).
