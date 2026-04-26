---
type: domain-note
tags:
  - domain/equipment
---
# Equipment Rates

## Overview
Equipment processing rate may be product-specific. The effective processing rate can depend on a selected recipe attribute value of the batch.

## Current Behavior
- Equipment may have an optional configured `RecipeAttribute`.
- Equipment may define per-value processing rates through `EquipmentRecipeAttributeValue` rows.
- Selected per-value rates must belong to the configured equipment recipe attribute.
- If an operation uses equipment-dependent duration, the selected batch attribute value can override the default equipment processing rate.

## Example
- Default rate: `1000 kg/h`
- `SKU A`: `900 kg/h`
- `SKU B`: `700 kg/h`

## Rule
- [[Equipment Attribute Rate Resolution]]

## Risks
- [[Equipment attribute rates import-export wiring incomplete]]

## Related PRs
- [[PR-696 Implement SKU in material]]
