---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-22
updated: 2026-06-22
product: RAISE
component: Experiments
tags:
  - documentation/raise
  - topic/business-logic
---

# Self-Owned Result Approvals Auto-Approve

## Current Rule
If an experiment runner also owns a dataset that requires result approval, the created `ExperimentResultDatasetApproval` row starts in an approved state and does not block result availability by itself.

## Introduced By
- [[PR-340 Extend Notifications]]

## Evidence
- `RaiseServices.Domain/Aggregates/Experiment/ExperimentResultDatasetApproval.cs`
- `Raise.FunctionalTests/ExperimentTests.cs`

## Edge Cases
- Mixed-owner experiments still wait for approvals from third-party dataset owners.
- The rule depends on correctly identifying owner equality at approval-row creation time.
