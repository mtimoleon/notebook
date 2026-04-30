---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
source: PR Analysis
pr: 209
task: RAI-329 Implement Credit System
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-209 Credit System Foundations

## Summary
- Consolidated the credit subsystem into a documented model around wallets, escrows, ledgers, price definitions, and access grants.
- Defined a one-wallet-per-owner invariant and moved the unique owner index into the main credits migration.
- Captured durable rules for experiment cost estimation, settlement, repricing cleanup, and admin credit grants.

## Domain Impact
- [[Credit System]]
- [[Wallet Ownership]]
- [[Credit Escrow Lifecycle]]
- [[Price Definitions]]

## Business Logic Impact
- `EstimatedCost = BaseCost + DatasetCost + ScriptCost + NodeCost`.
- Commission affects settlement allocations, not the payer-facing estimate.
- Failed or non-registered experiment runs release escrow and do not write run-ledger rows.
- Free-to-paid repricing removes or unbinds stale free-access artifacts.

## Risks
- [[Migration History Rewrite Risk]]
- [[Nullable Wallet Owner Type Under Unique Index]]
- [[Documentation Drift Risk]]

## Follow-up
- Validate migration rollout strategy for environments that already applied earlier credit migration ids.
- Check for duplicate wallets before enforcing the owner uniqueness invariant.
- Keep `Documentation/Credits.md` aligned with code changes.

## Diagrams
- [[Credit System]]
- [[Wallet Ownership]]

## Tech Debt
- [[Migration History Rewrite Risk]]
- [[Nullable Wallet Owner Type Under Unique Index]]
- [[Documentation Drift Risk]]

## Raw Analysis
- `C:\Users\michael\developer\raise-services\artifacts\PR-209 Engineering Analysis.md`
