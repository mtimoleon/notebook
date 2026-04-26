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
  - topic/technical-debt
---

# Ambiguous Recipe Attribute Value Import References

## Found In
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]

## Problem
Import/export reference resolution for recipe attribute values appears to rely on value name. The same value name can exist under different recipe attributes.

## Risk Level
High

## Fix Direction
Resolve recipe attribute values by attribute path plus value name, or export a stable composite reference that includes the parent recipe attribute.
