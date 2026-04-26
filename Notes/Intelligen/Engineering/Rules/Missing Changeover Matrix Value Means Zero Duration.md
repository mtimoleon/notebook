---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-26
updated: 2026-04-26
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/business-logic
---

# Missing Changeover Matrix Value Means Zero Duration

## Current Rule
When no matching changeover matrix value exists for a transition, the changeover time is treated as zero.

## Introduced By
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]

## Evidence
- `ChangeoverMatrix.GetChangeoverTime`
- `OperationEntry.GetDurationForEquipment`

## Edge Cases
- Symmetrical matrices can use the reverse transition.
- Null from or to values represent idle-state transitions.
