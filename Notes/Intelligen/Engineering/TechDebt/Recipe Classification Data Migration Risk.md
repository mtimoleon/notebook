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

# Recipe Classification Data Migration Risk

## Found In
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]

## Problem
The migration drops `RecipeClassifications`, `RecipeTypes`, and `Recipes_RecipeTypes` without an evident data migration into recipe attributes and recipe attribute values.

## Risk Level
High

## Fix Direction
Add a data migration or documented manual migration path before applying this migration to environments with existing recipe classification/type data.
