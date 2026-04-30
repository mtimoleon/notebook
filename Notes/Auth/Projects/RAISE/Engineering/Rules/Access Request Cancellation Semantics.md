---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Access
tags:
  - documentation/raise
  - topic/business-logic
---

# Access Request Cancellation Semantics

## Current Rule
Cancelling a pending dataset or script access request releases any held escrow and removes the request row instead of marking it cancelled in place.

## Introduced By
- [[PR-214 Usage-Based Access Request Persistence]]

## Evidence
- `Raise.APIGateway/Services/DatasetService.cs`
- `Raise.APIGateway/Services/ScriptService.cs`
- `RaiseServices.Domain/Aggregates/Dataset/DatasetAccessRequest.cs`
- `RaiseServices.Domain/Aggregates/Script/ScriptAccessRequest.cs`

## Edge Cases
- Notification rows rely on cascade delete from the access-request relation.
- Historical cancellation metadata is no longer queryable after deletion.
