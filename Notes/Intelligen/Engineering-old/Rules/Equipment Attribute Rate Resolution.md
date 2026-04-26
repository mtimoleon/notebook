---
type: rule-note
tags:
  - rule/equipment
  - domain/scheduling
---
# Equipment Attribute Rate Resolution

## Current Rule
When an operation uses equipment-dependent rate duration, the effective equipment rate may be selected from the batch recipe attribute value matching the equipment configured recipe attribute.

If no matching attribute value/rate exists, the default equipment processing rate is used.

## Introduced By
- [[PR-696 Implement SKU in material]]

## Evidence
- `Equipment.RecipeAttribute`
- `EquipmentRecipeAttributeValue`
- `Equipment.GetEquipmentProcessingRate(...)`

## Edge Cases
- Equipment configured attribute differs from batch selected attributes.
- Attribute value exists but is marked incompatible.
- Multiple batch values accidentally map to same attribute.
