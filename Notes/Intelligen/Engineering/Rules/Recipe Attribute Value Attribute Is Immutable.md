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

# Recipe Attribute Value Attribute Is Immutable

## Current Rule
A recipe attribute value must not be moved to another recipe attribute. It should be deleted and recreated under the target attribute instead.

## Introduced By
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]

## Evidence
- `RecipeAttributeValue.RecipeAttributeId`
- Domain comment in `RecipeAttributeValue`

## Edge Cases
- Existing selections on recipes, materials, batches, equipment rates, and changeover matrices depend on the value's original attribute.
