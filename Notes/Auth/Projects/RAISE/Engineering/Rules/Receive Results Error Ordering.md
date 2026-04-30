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

# Receive Results Error Ordering

## Current Rule
In the current receive-results flow, approval-pending state is evaluated before the final unauthorized-user branch for private results.

## Introduced By
- [[PR-216 Experiment Result Approval Gate]]

## Evidence
- `Raise.APIGateway/CoreServices/ExternalRequestService.cs`

## Edge Cases
- An unauthorized authenticated caller can observe an approval error instead of a plain access-denied response when approvals are still pending.
