---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-06-22
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

## Modified By
- [[PR-340 Extend Notifications]]

## Evidence
- `Raise.APIGateway/Services/ExperimentService.cs`
- `RaiseServices.Domain/Aggregates/Experiment/ExperimentResultDatasetApproval.cs`
- `Raise.FunctionalTests/ExperimentTests.cs`

## Edge Cases
- A caller may see experiment metadata while `HasResultAccess` is still `false`.
- Owners and dataset owners no longer bypass pending approvals for private results.
- Self-owned approval-required datasets auto-approve immediately when the approval row is created.
- A completed experiment run may still leave `HasResultAccess = false` until all third-party dataset owners approve.
