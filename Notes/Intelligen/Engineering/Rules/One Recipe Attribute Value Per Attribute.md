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

# One Recipe Attribute Value Per Attribute

## Current Rule
A recipe or material cannot contain more than one selected recipe attribute value for the same recipe attribute. During scheduling, the effective campaign attribute set is reduced to one value per attribute after combining overrides or BOM-product values with recipe defaults.

## Introduced By
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]

## Modified By
- [[PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review]]
- [[PR-task-584-Improve-batch-scheduling Campaign-Level Batch Scheduling]]

## Evidence
- `Recipe.UpdateRecipeAttributeValues`
- `Material.UpdateAttributeValues`
- `Campaign.UpdateOverrideRecipeAttributeValues`
- `Campaign.EffectiveRecipeAttributeValues`
- `Equipment.UpdateProcessingRate`

## Edge Cases
- Duplicate values from different attributes are allowed by this rule.
- Two values from the same attribute still throw a domain exception during recipe or material update.
- Campaign effective values keep the first value per attribute, so campaign overrides or BOM-product values take precedence over recipe defaults when both exist.
