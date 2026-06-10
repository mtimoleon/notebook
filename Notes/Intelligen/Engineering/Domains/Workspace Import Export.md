---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-26
updated: 2026-06-10
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/domain
---

# Workspace Import Export

## Overview
Workspace import/export serializes recipe attributes and recipe attribute values across options, materials, recipes, equipment, BOMs, and BOM streams, and it also carries original operation baseline data as an object-shaped snapshot instead of flattened original timing fields.

## Current Behavior
- Export options contain `recipeAttributes`.
- Export payloads can contain BOMs and BOM input/output stream references.
- Recipe exports contain `recipeAttributeValues`.
- Material exports can contain recipe attribute values.
- Equipment exports include attribute-dependent rate information.
- Equipment adaptive exports can also carry per-value incompatibility metadata.
- Import resolves recipe attributes and recipe attribute values as external references.
- Operation entry import/export maps original baseline data through an `OriginalInformation` object rather than `OriginalStart` and `OriginalDuration` fields.
- Original auxiliary equipment and staff baseline data can travel through import/export together with original timing.

## Risks
- Old exported JSON with `recipeClassifications` and `recipeTypes` is not represented by the new contract.
- External consumers expecting the previous options/material/recipe payload shape will break unless migrated.
- Old flattened original timing payloads are not represented by the new object-shaped original baseline contract.

## Related PRs
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]
- [[PR-task-566-Wrap-original-start-end-into-info-object Original Baseline Snapshot and Production Original Views]]
- [[PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review]]
