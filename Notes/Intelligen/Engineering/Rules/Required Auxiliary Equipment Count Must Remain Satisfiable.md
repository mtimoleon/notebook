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

# Required Auxiliary Equipment Count Must Remain Satisfiable

## Current Rule
When an operation uses `SpecificNumber` auxiliary selection, the required count must remain satisfiable after compatibility filtering against the selected main equipment.

## Introduced By
- [[PR-feature-568-implement-multiple-aux-equip-assignment Multiple Auxiliary Equipment Assignment]]

## Evidence
- `OperationBase`
- `OperationEntry`
- `Campaign.AssignAuxEquipmentRoundRobin`
- `SchedulingService`

## Edge Cases
- A total auxiliary pool can look valid while the main-compatible subset is too small to satisfy the requested count.
- `All` mode intentionally collapses to the compatible subset instead of enforcing an explicit numeric minimum.
