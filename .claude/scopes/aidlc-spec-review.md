---
name: spec-review
depth: Standard
keywords: []
description: Review and analyze a specification document
skeleton: off
runner: true
review_cap: advisory
guard_policy: relaxed
sensors: on
learnings: on
summary_confirmation: on
---

# spec-review scope

Standard depth for reviewing and analyzing a specification document. This scope
captures requirements and non-functional requirements from the spec, designs the
system to meet those requirements, validates performance characteristics, and
sets up observability. It is tailored for specification-driven work where the
primary goal is understanding the requirements and validating the design against
them.

Guard Policy defaults to relaxed: changed inputs are recorded and announced
rather than reopening approval; plan approval and review freeze are lowered for
undirected work.

## Why these stages, why skip those

Specification review work is requirements-led. It needs to capture the
intent and requirements from the provided spec (intent-capture,
scope-definition, requirements-analysis), design the system to meet them
(nfr-requirements, nfr-design), implement the design (code-generation,
build-and-test), set up observability and validate performance
(observability-setup, performance-validation), and establish CI practices
(ci-pipeline, practices-discovery).

It does not need market research (the spec is the input), feasibility
exploration (we trust the spec), team formation (likely solo), wireframes
(no UX work), reverse engineering (no existing code baseline),
user stories (captured in requirements), domain design (architectural
decisions embedded in the spec), delivery planning (single focus area),
deployment infrastructure (test/demo only), or incident response planning
(pre-operational).

This scope focuses on understanding requirements, designing a solution, and
validating that the design meets the requirements.

## Membership

Initialization, intent-capture, scope-definition, requirements-analysis,
practices-discovery, nfr-requirements, nfr-design, code-generation,
build-and-test, ci-pipeline, observability-setup, and performance-validation
execute; the rest is SKIP.
