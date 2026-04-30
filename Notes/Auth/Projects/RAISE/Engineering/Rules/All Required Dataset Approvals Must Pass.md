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

# All Required Dataset Approvals Must Pass

## Current Rule
For private experiment results, every dataset marked `IsResultApprovalRequired` must have a positive approval before the result payload becomes accessible.

## Introduced By
- [[PR-216 Experiment Result Approval Gate]]

## Evidence
- `Raise.APIGateway/Services/ExperimentService.cs`
- `Raise.APIGateway/CoreServices/ExternalRequestService.cs`
- `Raise.FunctionalTests/ExperimentTests.cs`

## Edge Cases
- One missing approval blocks the full result, even if other datasets already approved.
- Public results bypass this rule.
