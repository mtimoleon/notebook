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

# One Recipe Attribute Value Per Attribute

## Current Rule
A recipe or material cannot contain more than one selected recipe attribute value for the same recipe attribute. Batch attribute values derived from a recipe or BOM product must therefore also remain unique per attribute.

## Introduced By
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]

## Modified By
- [[PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review]]

## Evidence
- `Recipe.UpdateRecipeAttributeValues`
- `Material.UpdateAttributeValues`
- `Batch.UpdateRecipeAttributeValues`
- `Equipment.UpdateProcessingRate`
- `Batch.Fill(Recipe recipe, Bom bom)`
- `Batch.CleanRecipeAttributeValues`

## Edge Cases
- Duplicate values from different attributes are allowed by this rule.
- Two values from the same attribute throw a domain exception during update.
- A batch without a BOM inherits recipe values; a batch with a BOM inherits the BOM product material values.
