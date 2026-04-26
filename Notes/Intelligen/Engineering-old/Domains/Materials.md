---
type: domain-note
tags:
  - domain/materials
---
# Materials

## Overview
`Material` can now carry recipe attribute values. This allows a material to represent a concrete product identity, such as SKU, color, grade or pack size.

## Current Behavior
- `Material.RecipeAttributeValues` stores selected product attribute values.
- A material cannot have multiple values for the same parent recipe attribute.
- When a batch is created from a BOM, it can inherit product context from the BOM product material.

## Key Rule
- [[Batch Product Context Resolution]]

## Risks
- [[Material attribute values import-export round-trip incomplete]]

## Related PRs
- [[PR-696 Implement SKU in material]]
