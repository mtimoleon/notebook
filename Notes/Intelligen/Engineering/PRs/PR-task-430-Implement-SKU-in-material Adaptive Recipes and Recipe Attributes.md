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
- Makes scheduling and conflict resolution aware of dynamic changeover operations, loop-producing conflicts, and BOM-driven batch attributes.
- Adds Planning API/BFF and WebPlanning UI for managing BOMs, recipe attributes, and recipe attribute values.
- Changes the workspace import/export contract to carry recipe attribute/value data across options, materials, recipes, and equipment.

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
- [[Discrete Materials Cannot Be Stock Mixtures]]

## Risks
- The import/export contract breaks older payloads based on recipe classifications/types.
- Changeover-aware slot search and dynamic task recalculation increase scheduling regression risk.
- At review time, `Campaign.UpdateDynamicTasks()` could hide an earlier batch change because it overwrote the accumulated change flag instead of OR-ing it. This was later resolved on master.
- Re-associating a BOM with a different recipe clears existing BOM streams and needs clear UX expectations.

## Follow-up
- The `Campaign.UpdateDynamicTasks()` aggregation bug identified here was later resolved on master; keep the multi-batch regression scenario covered.
- Add or verify production data migration strategy for recipe classifications/types.
- Add backward-compatible import handling or explicit migration guidance for old exports.
- Expand regression coverage around dynamic-only procedures, changeover slot search, and cache invalidation.

## Diagrams
- [[Recipe Attributes]]
- [[Adaptive Recipes and BOMs]]
- [[Changeover Matrices]]
- [[Scheduling Conflict Resolution]]

## Tech Debt
- [[Recipe Classification Data Migration Risk]]
- [[Dynamic Scheduling Regression Surface]]
- The campaign-level dynamic-task aggregation defect identified during this review was later resolved on master.

## Raw Analysis
- `.local/PR-430 Engineering Analysis.md`
