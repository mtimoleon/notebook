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

# Auxiliary Equipment Move Must Identify Source and Destination

## Current Rule
When an operation entry holds multiple selected auxiliary resources, a move request must identify both the auxiliary resource being replaced and the destination resource receiving the assignment.

## Introduced By
- [[PR-feature-568-implement-multiple-aux-equip-assignment Multiple Auxiliary Equipment Assignment]]

## Evidence
- `MoveEquipmentOperationEntryCommandHandler`
- `OperationEntryServer`
- `AutoMapperCoreProfile`

## Edge Cases
- A legacy single-destination move remains unambiguous only when exactly one auxiliary resource is selected.
- Multi-selection entries become ambiguous if the contract carries only a destination equipment id.
