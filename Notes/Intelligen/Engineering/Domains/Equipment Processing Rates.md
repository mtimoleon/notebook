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

# Equipment Processing Rates

## Overview
Equipment processing rates can now depend on recipe attribute values carried by a batch.

## Current Behavior
- Equipment can reference a recipe attribute.
- Equipment can store per-value processing rate overrides.
- During operation duration calculation, the batch attribute value matching the equipment recipe attribute is used to select the rate.
- If no matching override is found, the equipment base processing rate is used.

## Rules
- [[Equipment Attribute Dependent Rate]]

## Related PRs
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]
