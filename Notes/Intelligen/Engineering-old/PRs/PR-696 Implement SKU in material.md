---
type: pr-note
pr: 696
task: 430
created: 2026-04-23
source: Codex analysis
tags:
  - pr
  - topic/business-logic
  - topic/domain
  - risk/scheduling
---
# PR-696 Implement SKU in material

## Summary
- Replaces recipe classifications/types with recipe attributes and recipe attribute values.
- Uses recipe attribute values as SKU-like product context across recipes, materials, batches, equipment rates and changeover calculations.
- Introduces adaptive recipe/BOM support, where operation entry streams can be generated from BOM stream definitions linked to recipe operations.
- Extends scheduling with dynamic tasks, including conditional operations and changeover-matrix-based durations.

## Domain Impact
- [[Production Model]]
- [[Notes/Intelligen/Engineering-old/Domains/Materials]]
- [[Recipes]]
- [[BOM]]
- [[Campaign Scheduling]]
- [[Equipment Rates]]
- [[Changeover Matrix]]
- [[Import Export Semantics]]

## Business Logic Impact
- Batch resolves effective product context from BOM product material when a BOM exists.
- Batch falls back to recipe default attribute values when no BOM exists.
- Equipment processing rate may depend on the batch selected recipe attribute value.
- Changeover duration may depend on previous/current/next SKU state on the same equipment.
- Campaign BOM must match the campaign recipe.
- Dynamic operations require recalculation during scheduling and conflict resolution.

## Risks
- Import/export round-trip for material attribute values appears incomplete.
- `RecipeAttributeValue` external references are keyed only by value name, while uniqueness is `(RecipeAttributeId, Name)`.
- Equipment recipe-attribute-dependent rates appear incompletely wired in facility/workspace import/export.
- Deletes for recipe attributes and values rely on DB FK behavior instead of explicit business validation.
- Slot search complexity increases because dynamic durations may change after recalculation.

## Follow-up
- Add tests for BOM-driven batch fill.
- Add tests for recipe-default fallback.
- Add tests for equipment-rate resolution by selected recipe attribute value.
- Add tests for changeover matrix transitions and idle-state behavior.
- Fix external reference keying for `RecipeAttributeValue`.
- Verify workspace import/export round-trip.

## Diagrams
See linked domain notes:
- [[Production Model]]
- [[BOM]]
- [[Campaign Scheduling]]
- [[Changeover Matrix]]
- [[Import Export Semantics]]

## Tech Debt
- [[Material attribute values import-export round-trip incomplete]]
- [[RecipeAttributeValue external references keyed only by value name]]
- [[Equipment attribute rates import-export wiring incomplete]]
- [[Recipe attribute deletes rely on FK checks]]
- [[Recipe attribute pagination uses wrong sort-filter shape]]

## Raw Analysis
- [[PR-696 Raw Codex Analysis]]
