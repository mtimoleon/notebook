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

# Equipment Attribute Dependent Rate

## Current Rule
When equipment has recipe-attribute-dependent rates, operation duration uses the batch's selected value for that equipment attribute to choose the processing rate.

## Introduced By
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]

## Evidence
- `Equipment.UpdateProcessingRate`
- `Equipment.GetEquipmentProcessingRate`
- `OperationEntry.GetDurationForEquipment`

## Edge Cases
- If no per-value rate matches the batch attribute value, the base equipment processing rate is used.
- Per-value rate entries must belong to the equipment's selected recipe attribute.
