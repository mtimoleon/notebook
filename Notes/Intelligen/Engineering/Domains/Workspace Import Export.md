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
  - topic/domain
---

# Workspace Import Export

## Overview
Workspace import/export now serializes recipe attributes and recipe attribute values instead of recipe classifications and recipe types.

## Current Behavior
- Export options contain `recipeAttributes`.
- Recipe exports contain `recipeAttributeValues`.
- Material exports can contain attribute values.
- Equipment exports include attribute-dependent rate information.
- Import resolves recipe attributes and recipe attribute values as external references.

## Risks
- Old exported JSON with `recipeClassifications` and `recipeTypes` is not represented by the new contract.
- Recipe attribute value references can be ambiguous if matching only by value name.

## Related PRs
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]
