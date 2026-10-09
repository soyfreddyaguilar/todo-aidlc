# Project-Level Rules

> Project-specific specialisation and corrections. Loaded after `org.md` and
> `team.md` as strict-additive guidance; contradictions with broader policy
> are rejected. Populated by practices-discovery and the self-learning loop.
>
> Use sparingly: most teams don't need a project layer. Reach for it
> only when this specific project needs stable, durable guidance beyond the
> team practice (for example, package-specific release checks or an additional
> regression suite for a legacy component).

## Way of Working

<!-- Project-specific specialisation. Example: -->
<!-- This monorepo requires package-scoped branch names and a package owner -->
<!-- review in addition to the team's normal merge policy. -->

## Walking Skeleton

<!-- Project-specific specialisation. Example: -->
<!-- The walking skeleton must exercise the legacy service adapter as well -->
<!-- as the new service boundary. -->

## Testing Posture

<!-- Project-specific specialisation. -->

## Guard Policy

<!-- Project-specific. Mode: strict, relaxed, or off. Strict here holds for every intent and cannot be changed from chat. A section under the retired Change Control heading, written by an earlier release, is still read. -->

## Deployment

<!-- Project-specific specialisation. -->

## Code Style

<!-- Project-specific specialisation. -->

## Tech Stack

<!-- Technology choices locked for this project. -->

## Decided

<!-- Decisions made in earlier stages that should not be re-asked. -->
<!-- Format: DECIDED: [decision] (Stage [slug], [date]) -->

## Scope Overrides

<!-- Custom scope rules for this project. -->

## Forbidden

<!-- Populated by practices-discovery affirmation gate. -->
<!-- Format: NEVER [behavior] (affirmed [date]) -->
<!-- Example: NEVER throw exceptions across service layer boundaries (affirmed 2026-05-17) -->

## Mandated

<!-- Populated by practices-discovery affirmation gate. -->
<!-- Format: ALWAYS [behavior] (affirmed [date]) -->
<!-- Example: ALWAYS use Result<T,E> for fallible operations in service layer (affirmed 2026-05-17) -->

## Corrections

<!-- Project-specific corrections from human feedback. -->
<!-- Format: NEVER/ALWAYS [behavior] (learned [date]) -->

## Interpretations
- POC scope justifies 40% coverage floor (aligned with org default for spec-review) because learning/documentation value outweighs additional test burden (learned 2026-10-09) <!-- cid:261008-specification-review:practices-discovery:4ae282fde4fcd1dcdadbc5569c6b3e6f41bb353776ef2d3ad9f99c320fc2ecd1 -->
- Walking skeleton strategy affirmed for scope with `skeleton: on`; smallest integrated slice is CRUD + persistence (learned 2026-10-09) <!-- cid:261008-specification-review:practices-discovery:58bc32b3eddd843b6408ec4edb375a8feecca03164c5251e51201f19dbbfd22e -->
- Deployment manual gate for production affirmed; appropriate for POC to prevent premature exposure (learned 2026-10-09) <!-- cid:261008-specification-review:practices-discovery:b7b95c4869d8a031f0cd2f39a274650fd9174dcef66c6ea10f994ce2a8d78575 -->

## Deviations
- None. All affirmed practices align with or specialize org-level defaults. No contradictions detected. (learned 2026-10-09) <!-- cid:261008-specification-review:practices-discovery:0a5fca4a66caad25531d7368c26986e9c38fd014c2113615be82aa6f44a7089c -->

## Tradeoffs
- Chose BDD over test-after; specification-driven validation with 40% coverage floor better aligns with learning objectives (learned 2026-10-09) <!-- cid:261008-specification-review:practices-discovery:6cb76b407ca58d88372e1e5316c6365ea04252ced81ad2711da37ea5fa68b6f8 -->
- Chose Prettier + ESLint (zero-config standard) over custom linting rules; reduces bikeshedding (learned 2026-10-09) <!-- cid:261008-specification-review:practices-discovery:031aedf2b7ea36b2b466a7ed594a31133447340bc25791be4c9f400e387899a2 -->
- Chose skeleton-first over feature-major; early verification catches integration issues (learned 2026-10-09) <!-- cid:261008-specification-review:practices-discovery:60907b90cd54cecc3fee413096742275f2a62e962750e2aeb8da0a797208bdb8 -->
