---
type: tech-debt-note
tags:
  - techdebt
  - pr/696
---
# Recipe attribute deletes rely on FK checks

## Found In
- [[PR-696 Implement SKU in material]]

## Problem
Recipe attribute and value deletes rely on DB FK behavior for in-use checks instead of explicit business validation.

## Risk Level
Medium

## Fix Direction
Add explicit domain/application validation before delete operations.
