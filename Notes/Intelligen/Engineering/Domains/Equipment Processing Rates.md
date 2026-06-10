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

# Equipment Processing Rates

## Overview
Equipment processing rates can now depend on recipe attribute values carried by a batch.

## Current Behavior
- Equipment can reference a recipe attribute.
- Equipment can store per-value processing rate overrides.
- Equipment can also store per-value incompatibility flags alongside those overrides.
- During operation duration calculation, the batch attribute value matching the equipment recipe attribute is used to select the rate.
- If no matching override is found, the equipment base processing rate is used.
- The current rate lookup path uses the matching override rate when present, but does not itself block scheduling for `IsIncompatible` entries.

## Rules
- [[Equipment Attribute Dependent Rate]]

## Risks
- [[Equipment Incompatibility Is Not Enforced]]

## Related PRs
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]
- [[PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review]]
