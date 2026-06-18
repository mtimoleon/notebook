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
  - topic/domain
---

# Workspace Import Export

## Overview
Workspace import/export serializes recipe attributes and recipe attribute values across options, materials, recipes, equipment, BOMs, and BOM streams, and it also carries scheduling-board state whose override context now lives at campaign scope instead of batch scope.

## Current Behavior
- Export options contain `recipeAttributes`.
- Export payloads can contain BOMs and BOM input/output stream references.
- Recipe exports contain `recipeAttributeValues`.
- Material exports can contain recipe attribute values.
- Equipment exports include attribute-dependent rate information.
- Equipment adaptive exports can also carry per-value incompatibility metadata.
- Campaign exports can contain `bom` and `recipeAttributeValueOverrides`.
- Batch exports no longer carry their own `bom` or `recipeAttributeValues` fields.
- Import resolves campaign-level recipe attribute override references before batch procedural data.
- Operation entry import/export maps original baseline data through an `OriginalInformation` object rather than `OriginalStart` and `OriginalDuration` fields.
- Original auxiliary equipment and staff baseline data can travel through import/export together with original timing.

## Risks
- Old exported JSON that expected batch-level scheduling override fields will not match the current scheduling board contract.
- External consumers expecting the previous options/material/recipe payload shape will break unless migrated.
- Campaign-level override references and campaign BOM context now matter for successful scheduling board rehydration, not only for recipe/material metadata.

## Related PRs
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]
- [[PR-task-566-Wrap-original-start-end-into-info-object Original Baseline Snapshot and Production Original Views]]
- [[PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review]]
- [[PR-task-584-Improve-batch-scheduling Campaign-Level Batch Scheduling]]
