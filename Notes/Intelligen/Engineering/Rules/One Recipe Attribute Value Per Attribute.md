---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-26
updated: 2026-04-26
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/business-logic
---

# One Recipe Attribute Value Per Attribute

## Current Rule
A recipe, material, or batch cannot contain more than one selected recipe attribute value for the same recipe attribute.

## Introduced By
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]

## Evidence
- `Recipe.UpdateRecipeAttributeValues`
- `Material.UpdateAttributeValues`
- `Batch.CleanRecipeAttributeValues`

## Edge Cases
- Duplicate values from different attributes are allowed by this rule.
- Two values from the same attribute throw a domain exception during update.
