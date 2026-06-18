---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-26
updated: 2026-06-18
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/business-logic
---

# Campaign BOM Must Match Recipe

## Current Rule
If a campaign schedules from BOM/material context, its BOM must be valid and associated with the same recipe as the campaign. Recipe-based campaigns can still schedule without a BOM.

## Introduced By
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]

## Modified By
- [[PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review]]
- [[PR-task-584-Improve-batch-scheduling Campaign-Level Batch Scheduling]]

## Evidence
- `Campaign.Layout`
- `Campaign.UpdateBom`
- `Bom.CheckValidationStatus`
- `Batch.Fill(Bom)`

## Edge Cases
- A `RecipeBased` campaign without a BOM can still use campaign overrides plus recipe defaults.
- A `MaterialBased` campaign without a valid `Bom.Recipe` is invalid before layout.
- Missing `Material`, `AdaptiveInput`, or `AdaptiveOutput` on BOM streams also make the material-based campaign invalid on the layout path.
