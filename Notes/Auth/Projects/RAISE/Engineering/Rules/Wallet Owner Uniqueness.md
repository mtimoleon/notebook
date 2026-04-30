---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Credits
tags:
  - documentation/raise
  - topic/business-logic
---

# Wallet Owner Uniqueness

## Current Rule
Each payer identity should have exactly one wallet for a given `(OwnerType, OwnerId)` pair.

## Introduced By
- [[PR-209 Credit System Foundations]]

## Evidence
- `RaiseServices.Infrastructure/Migrations/20260423135239_Credits.cs`
- `RaiseServices.Infrastructure/Migrations/RaiseDbContextModelSnapshot.cs`
- `Documentation/Credits.md`

## Edge Cases
- Existing duplicate wallets can break unique-index creation during migration.
- Null `OwnerType` weakens the database-level invariant on MySQL.
- Concurrent creation depends on duplicate-key retry behavior to converge.
