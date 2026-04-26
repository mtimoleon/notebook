---
type: domain-note
tags:
  - domain/recipes
---
# Recipes

## Overview
Recipes no longer use recipe classifications/types as the main product classification mechanism. The model now uses recipe attributes and recipe attribute values.

## Current Behavior
- A recipe can define default selected `RecipeAttributeValue` entries.
- A recipe cannot select more than one value for the same parent `RecipeAttribute`.
- Recipe defaults are used as batch product context when there is no BOM-driven product material.
- Recipes can define adaptive inputs and outputs at operation level.

## Removed Concepts
- `RecipeClassification`
- `RecipeType`
- `RecipeRecipeType`
- `Recipe.RecipeTypes`

## New Concepts
- `RecipeAttribute`
- `RecipeAttributeValue`
- `RecipeRecipeAttributeValue`
- `Recipe.AdaptiveInputs`
- `Recipe.AdaptiveOutputs`

## Rules
- [[Recipe Attribute Value Uniqueness]]
- [[Batch Product Context Resolution]]

## Related PRs
- [[PR-696 Implement SKU in material]]
