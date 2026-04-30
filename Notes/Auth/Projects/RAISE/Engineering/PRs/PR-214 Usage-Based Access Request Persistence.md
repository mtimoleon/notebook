---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
source: PR Analysis
pr: 214
task: RAI-329 Implement Credit System additional 2
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-214 Usage-Based Access Request Persistence

## Summary
- Public usage-based access for datasets and scripts now persists approved access-request rows instead of returning response-only instant grants.
- The instant path now records `PriceDefinitionId` and exposes a durable `AccessRequestId`.
- Cancelling pending access requests now releases escrow and deletes the request row instead of soft-cancelling it.

## Domain Impact
- [[Credit System]]
- [[Usage-Based Pricing]]
- [[Dataset Access Requests]]
- [[Script Access Requests]]

## Business Logic Impact
- Public `UsageBased` access without approval persists an approved request row immediately.
- Cancellation semantics changed from row retention to hard delete.
- Existing approved rows are reused, keeping the initiation path idempotent.

## Risks
- [[Soft-Cancel Model Bypassed By Services]]
- [[Auto-Approved Request Notifications]]

## Follow-up
- Decide whether cancelled access requests should remain auditable at the persistence level.
- Review whether auto-approved request creation should also generate owner notifications.
- Verify downstream analytics/reporting assumptions about request history retention.

## Diagrams
- [[Usage-Based Pricing]]
- [[Dataset Access Requests]]

## Tech Debt
- [[Soft-Cancel Model Bypassed By Services]]
- [[Auto-Approved Request Notifications]]

## Raw Analysis
- `C:\Users\michael\developer\raise-services\artifacts\PR-214 Engineering Analysis.md`
