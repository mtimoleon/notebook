---
type: tech-debt-note
tags:
  - techdebt
  - pr/696
---
# Material attribute values import-export round-trip incomplete

## Found In
- [[PR-696 Implement SKU in material]]

## Problem
Material attribute values were added to DTOs and domain state, but workspace/material import-export does not appear to fully round-trip them.

## Risk Level
High

## Fix Direction
Add import/export tests covering material attribute values and fix missing mapping paths.
