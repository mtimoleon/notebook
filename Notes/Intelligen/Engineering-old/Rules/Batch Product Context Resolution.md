---
type: rule-note
tags:
  - rule/batch
  - domain/production-model
---
# Batch Product Context Resolution

## Current Rule
A batch resolves its effective recipe attribute values from the selected BOM product material when a BOM exists.

If no BOM exists, the batch uses the recipe default attribute values.

## Introduced By
- [[PR-696 Implement SKU in material]]

## Evidence
- `Batch.Fill(...)` accepts `Recipe` and optional `Bom`.
- `Batch.RecipeAttributeValues` stores the resolved runtime product context.

## Edge Cases
- BOM product material has incomplete attribute values.
- Recipe defaults contain attributes not present on the material.
- Attribute values are deleted after batches were scheduled.
