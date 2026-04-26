---
type: tech-debt-note
tags:
  - techdebt
  - pr/696
---
# RecipeAttributeValue external references keyed only by value name

## Found In
- [[PR-696 Implement SKU in material]]

## Problem
RecipeAttributeValue external references are keyed only by value name, while uniqueness is `(RecipeAttributeId, Name)`.

## Risk Level
High

## Fix Direction
Use a composite external reference key that includes parent RecipeAttribute identity.
