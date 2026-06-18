---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-10
source: PR Analysis
pr: feature/578-Adaptive-recipes-pt.4
task: Review of adaptive recipes pt.4 changes across BOMs, recipe attributes, import-export, and scheduling behavior
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review

## Summary
- Extends the adaptive recipe model across BOM CRUD, BOM streams, recipe attributes, recipe attribute values, import/export, and planning UI flows.
- Pushes recipe attribute values deeper into scheduling so equipment rates and changeover logic can read batch-specific adaptive context.
- Expands the transport and persistence surface for adaptive recipes through Planning API, gRPC, BFF, EF mappings, migrations, and workspace serialization.
- Leaves behind a few important correctness gaps in scheduling and dynamic-task propagation.

## Domain Impact
- [[Adaptive Recipes and BOMs]]
- [[Recipe Attributes]]
- [[Equipment Processing Rates]]
- [[Changeover Matrices]]
- [[Scheduling Conflict Resolution]]
- [[Workspace Import Export]]

## Business Logic Impact
- [[Campaign BOM Must Match Recipe]]
- [[One Recipe Attribute Value Per Attribute]]
- [[Equipment Attribute Dependent Rate]]

## Risks
- Equipment incompatibility is stored but not enforced by the scheduling rate lookup path.
- Default equipment assignment still depends on procedure order even after the old precedence protection was removed.
- `ScheduleIndependentCampaign(...)` uses a weaker validation gate than the board-oriented scheduling paths.
- `Campaign.UpdateDynamicTasks()` can lose an earlier batch change when the final batch reports no change.
- The recipe list inline filter state is fragile after the `{ current, initial }` refactor.

## Follow-up
- Enforce `EquipmentRecipeAttributeValue.IsIncompatible` in a scheduling-critical path and add regression coverage.
- Reintroduce or replace the removed procedure/master precedence protection for default equipment assignment.
- Decide whether `ScheduleIndependentCampaign(...)` is a full public scheduling contract and align validation accordingly.
- Fix `Campaign.UpdateDynamicTasks()` to aggregate batch changes with OR semantics.
- Add UI coverage for combined inline recipe filters.

## Diagrams
- [[Adaptive Recipes and BOMs]]
- [[Recipe Attributes]]
- [[Changeover Matrices]]
- [[Scheduling Conflict Resolution]]

## Tech Debt
- [[Dynamic Scheduling Regression Surface]]
- The campaign-level dynamic-task aggregation defect identified during this review was later resolved on master.
- [[Equipment Incompatibility Is Not Enforced]]
- [[Scheduling Entry Point Validation Drift]]

## Raw Analysis
- `C:\Users\michael\developer\scpCloud\.local\PR-feature-578-Adaptive-recipes-pt.4 Engineering Analysis.md`
