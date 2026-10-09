# Practices Discovery Metadata

## Stage Information

- **Stage Name:** Practices Discovery
- **Phase:** Inception
- **Intent:** 261008-specification-review
- **Scope:** poc (proof of concept)
- **Attempt:** 1

## Timeline

| Event | Timestamp | Notes |
|-------|-----------|-------|
| Stage start | 2026-10-08T18:00:00Z | Initial practices proposal |
| Practices proposal created | 2026-10-08T19:30:00Z | Full proposal with all sections |
| Human approval | 2026-10-08T20:15:00Z | All practices approved without modification |
| Artifact creation | 2026-10-08T21:00:00Z | Final artifacts created for specialist review |
| Quality Agent review | (pending) | Validates testing posture and coverage floor |
| Developer Agent review | (pending) | Validates code style and tooling |
| DevSecOps Agent review | (pending) | Validates deployment strategy and safety |
| Final integration | (pending) | Promote team-practices.md to team.md upon all approvals |

## Artifacts Created

- **team-practices.md:** Affirmed practices in final form (ready for promotion to `team.md`)
- **discovered-rules.md:** Reasoning and supporting evidence for each practice
- **evidence.md:** References, architecture, and specialist review checklist
- **practices-discovery-timestamp.md:** This metadata file

## Approval Status

| Approver | Role | Status | Signature | Notes |
|----------|------|--------|-----------|-------|
| Human | Project Owner | ✓ Approved | 2026-10-08 | Approved all practices without modification |
| Quality Agent | Quality Lead | (pending) | — | Reviewing testing posture and coverage |
| Developer Agent | Developer Lead | (pending) | — | Reviewing code style and project setup |
| DevSecOps Agent | Security/Deploy Lead | (pending) | — | Reviewing deployment strategy and safety |
| Pipeline Agent | Practices Integrator | (pending) | — | Final integration and promotion to team.md |

## Affirmed Practices Summary

1. **Way of Working:** Trunk-based development, squash-merge to main (aligns with org default)
2. **Walking Skeleton:** CRUD + localStorage, verified before secondary features (scope-specialized)
3. **Testing Posture:** Test-after, 70% coverage, per-layer ordering (stricter than POC default; justified by learning scope)
4. **Code Style:** Prettier + ESLint, camelCase, error handling in async operations (aligns with org/language defaults)
5. **Deployment:** Auto-staging, manual production gate, smoke tests, documented rollback (aligns with org default)

## Specialist Review Requirements

### Quality Agent Validation

Must confirm:
- 70% coverage floor is appropriate for POC scope
- Test-after methodology is sound for exploratory work
- Per-layer test ordering is documented and achievable
- CI gates are correctly placed (before merge)

### Developer Agent Validation

Must confirm:
- Prettier + ESLint configuration exists in project root or will be created during Code Generation
- React project structure is compatible with chosen test framework (Jest + React Testing Library)
- Build tooling (likely Vite or Create React App) is decided or deferred to Code Generation stage

### DevSecOps Agent Validation

Must confirm:
- Staging deployment automation is safe and reversible
- Production manual gate is enforced (no automation bypass)
- Smoke test strategy covers critical paths (load, CRUD, persistence)
- Rollback procedures are documented for both stages
- No hardcoded secrets or credentials in deployment config

## Decision Record

### Decisions Made in This Stage

| Decision | Rationale | Alternatives Rejected | Owner |
|----------|-----------|----------------------|-------|
| 70% coverage floor (vs. POC default of none) | Learning scope justifies documentation value; pragmatic floor | 80% (too high for POC), 50% (too low), none (misses learning opportunity) | Quality Agent |
| Test-after methodology (vs. TDD) | Exploratory scope, evolving design; test-after suits iteration | TDD (stronger discipline, but slower iteration), BDD (overkill for POC) | Quality Agent |
| Prettier + ESLint (vs. other formatters) | Industry standard, zero-config, React ecosystem dominance | StandardJS (less common), custom rules (higher maintenance) | Developer Agent |
| Auto-deploy staging, manual production | Fast staging feedback, safety gate for prod | Full automation to prod (risky for POC), no staging deploy (slower feedback) | DevSecOps Agent |
| Skeleton-first (vs. feature-major) | Org default for `skeleton: on`; catches integration issues early | Feature-major (misses early verification), all-at-once (risky) | Project Owner |

## Blockers and Risks

| Item | Status | Mitigation |
|------|--------|-----------|
| ESLint/Prettier config not yet created | Open | Will be created during Code Generation stage; Practices Discovery does not block on this |
| Test framework not yet selected (Jest vs. Vitest) | Open | Deferred to Code Generation stage; Practices Discovery affirms "Jest + React Testing Library" as default |
| Deployment infrastructure (staging/prod env) not yet provisioned | Open | Deferred to Infrastructure stage; assumes cloud-ready (AWS or similar) |
| Smoke test endpoints not yet defined | Open | Will be defined during Architecture Design; Practices Discovery affirms the requirement |

## Next Steps

1. **Quality Agent reviews** testing posture and coverage floor
2. **Developer Agent reviews** code style and project structure
3. **DevSecOps Agent reviews** deployment strategy and safety gates
4. **Pipeline Agent integrates feedback** and promotes `team-practices.md` to `aidlc/spaces/default/memory/team.md`
5. **Requirements Analysis stage** begins with affirmed practices in place

---

## Metadata Fields

- **Intent Record:** `/d/PROJECTS/POC/poc-test/aidlc/spaces/default/intents/261008-specification-review/`
- **Stage Record:** `/d/PROJECTS/POC/poc-test/aidlc/spaces/default/intents/261008-specification-review/inception/practices-discovery/`
- **Artifacts Directory:** Same as stage record (all files colocated)
- **Conversation Language:** English
- **Project Name:** TODO App Specification Review
- **Team:** Default (single-team POC)
- **Active Space:** default
