---
type: tech-debt-note
tags:
  - techdebt
  - pr/696
---
# Equipment attribute rates import-export wiring incomplete

## Found In
- [[PR-696 Implement SKU in material]]

## Problem
Equipment recipe-attribute-dependent rates exist in domain/DTO state, but facility/workspace import-export wiring appears incomplete.

## Risk Level
Medium

## Fix Direction
Add round-trip tests for equipment attribute rates and complete import/export mapping.
