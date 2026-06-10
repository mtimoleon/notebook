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
  - topic/business-logic
---

# Campaign BOM Must Match Recipe

## Current Rule
If a campaign uses a BOM, that BOM must be associated with the same recipe as the campaign.

## Introduced By
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]

## Modified By
- [[PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review]]

## Evidence
- `Campaign.CheckValidationStatus`
- `Campaign.UpdateBom`
- `Batch.Fill(Recipe recipe, Bom bom)`

## Edge Cases
- A campaign without a BOM can still use recipe-level attribute values.
- A campaign with a missing recipe is invalid before layout.
- `ScheduleIndependentCampaign(...)` does not currently enforce the same validation gate as the board-oriented scheduling entry points.
