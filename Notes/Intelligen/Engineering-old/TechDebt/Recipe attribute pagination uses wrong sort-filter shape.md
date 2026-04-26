---
type: tech-debt-note
tags:
  - techdebt
  - pr/696
---
# Recipe attribute pagination uses wrong sort-filter shape

## Found In
- [[PR-696 Implement SKU in material]]

## Problem
The new recipe-attribute list pagination appears to pass the wrong sort/filter state shape to `retrieveEntities`.

## Risk Level
Medium

## Fix Direction
Fix request shape mapping and add list endpoint tests for sort/filter behavior.
