WARN missing: SKU remove risks ---
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

# SKU Attribute Values

## Overview
SKU attribute values are recipe attribute values selected on materials, recipes, and batches. They determine which product context a batch carries during scheduling and execution.

## Current Behavior
- A batch filled without BOM receives values from the recipe.
- A batch filled with BOM receives values from the BOM product material.
- Batch values are used by equipment-dependent processing rate calculations.
- Batch values are used when resolving changeover matrix transitions.
- Workspace import/export now qualifies selected values with the parent recipe attribute name, so identical value names under different attributes no longer collide in the current contract.

## Business Meaning
The selected material or SKU can change equipment rates, adaptive streams, and changeover duration without duplicating entire recipes.

## Rules
- [[One Recipe Attribute Value Per Attribute]]
- [[Equipment Attribute Dependent Rate]]

## Risks

## Related PRs
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]
