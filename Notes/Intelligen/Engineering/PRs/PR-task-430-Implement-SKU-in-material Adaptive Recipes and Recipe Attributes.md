---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-26
source: PR Analysis
pr: task/430-Implement-SKU-in-material
task: Implement SKU/material recipe attributes, adaptive recipes, BOMs, and changeover-aware scheduling
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes

## Summary
- Replaces recipe classifications/types with recipe attributes and recipe attribute values.
- Adds recipe attribute values to recipes, materials, batches, and equipment.
- Adds BOM/adaptive recipe structures and changeover matrices.
- Makes scheduling and conflict resolution aware of dynamic changeover operations and BOM-driven batch attributes.
- Adds Planning API/BFF and WebPlanning UI for managing recipe attributes and values.

## Domain Impact
- [[Recipe Attributes]]
- [[SKU Attribute Values]]
- [[Adaptive Recipes and BOMs]]
- [[Changeover Matrices]]
- [[Scheduling Conflict Resolution]]
- [[Workspace Import Export]]
- [[Equipment Processing Rates]]

## Business Logic Impact
- [[One Recipe Attribute Value Per Attribute]]
- [[Campaign BOM Must Match Recipe]]
- [[Missing Changeover Matrix Value Means Zero Duration]]
- [[Recipe Attribute Value Attribute Is Immutable]]
- [[Equipment Attribute Dependent Rate]]

## Risks
- Existing recipe classification/type data is dropped by the migration rather than visibly migrated.
- Workspace import/export contracts change from recipe classifications/types to recipe attributes/values.
- Changeover-aware slot search and dynamic task recalculation increase scheduling regression risk.
- Name-only import references for recipe attribute values can be ambiguous.

## Follow-up
- Add or verify production data migration strategy for recipe classifications/types.
- Add backward-compatible import handling or explicit migration guidance for old exports.
- Expand regression coverage around dynamic-only procedures, changeover slot search, and cache invalidation.
- Validate duplicate recipe attribute value names across different attributes during import.

## Diagrams
- [[Recipe Attributes]]
- [[Adaptive Recipes and BOMs]]
- [[Changeover Matrices]]
- [[Scheduling Conflict Resolution]]

## Tech Debt
- [[Recipe Classification Data Migration Risk]]
- [[Ambiguous Recipe Attribute Value Import References]]
- [[Dynamic Scheduling Regression Surface]]

## Raw Analysis
- `artifacts/PR-task-430-Implement-SKU-in-material Engineering Analysis.md`
