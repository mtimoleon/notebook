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

# Price Drift Escrow Cap

## Current Rule
When prices rise after credits were already held, settlement must be scaled so the gross total does not exceed `escrow.AmountHeld`.

## Introduced By
- [[PR-209 Credit System Foundations]]

## Evidence
- `Documentation/Credits.md`

## Edge Cases
- Historical escrow size wins over newer higher prices.
