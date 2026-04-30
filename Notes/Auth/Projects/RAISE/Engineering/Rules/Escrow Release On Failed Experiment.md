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

# Escrow Release On Failed Experiment

## Current Rule
If an experiment does not reach the successful terminal state used for settlement, escrow is released and no experiment-run ledger rows are written.

## Introduced By
- [[PR-209 Credit System Foundations]]

## Evidence
- `Documentation/Credits.md`

## Edge Cases
- Partial work does not imply partial settlement based on the documented rule.
