---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-03
updated: 2026-06-03
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/business-logic
---

# Discrete Materials Cannot Be Stock Mixtures

## Current Rule
A material with a discrete basis cannot use the `StockMixture` composition type. Discrete materials must remain pure components.

## Introduced By
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]

## Evidence
- `Material.UpdateType`
- `Material.UpdateComposition`
- `MaterialError.DiscreteMaterialsCannotBeStockMixturesError`

## Edge Cases
- Discrete materials can still exist as pure components.
- Non-discrete stock mixtures must still satisfy ingredient physical quantity compatibility checks.
