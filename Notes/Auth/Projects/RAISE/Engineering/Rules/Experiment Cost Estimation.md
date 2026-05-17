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

# Experiment Cost Estimation

## Current Rule
Experiment cost estimation is the sum of base cost, dataset cost, script cost, and node cost, without adding commission to the payer-facing estimate.

## Introduced By
- [[PR-209 Credit System Foundations]]

## Evidence
- `Documentation/Credits.md`
- `CreditService.ResolveExperimentRunCost`

## Edge Cases
- Private resources should not leak information through cost-preview behavior.
- Active permanent or lease grants can waive a usage-based line item.
