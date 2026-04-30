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

# Public Usage-Based Access Persistence

## Current Rule
Public `UsageBased` access without owner approval should still create or reuse an approved access-request row and persist the chosen `PriceDefinitionId`.

## Introduced By
- [[PR-214 Usage-Based Access Request Persistence]]

## Evidence
- `Raise.APIGateway/Services/DatasetService.cs`
- `Raise.APIGateway/Services/ScriptService.cs`
- `Raise.FunctionalTests/CreditTests.cs`

## Edge Cases
- The requester receives an `AccessRequestId` even though access is granted instantly.
- Private datasets still reject the instant public path.
