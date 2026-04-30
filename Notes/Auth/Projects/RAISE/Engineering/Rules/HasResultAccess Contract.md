---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Experiments
tags:
  - documentation/raise
  - topic/business-logic
---

# HasResultAccess Contract

## Current Rule
`HasResultAccess` signals whether the caller should currently be treated as allowed to access experiment results, based on public visibility, approval completeness, and caller role.

## Introduced By
- [[PR-216 Experiment Result Approval Gate]]

## Evidence
- `Raise.APIGateway/Services/ExperimentService.cs`
- `Raise.FunctionalTests/ExperimentTests.cs`

## Edge Cases
- A caller may see experiment metadata while `HasResultAccess` is still `false`.
- Owners and dataset owners no longer bypass pending approvals for private results.
