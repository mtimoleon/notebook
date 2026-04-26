---
type: rule-note
tags:
  - rule/recipe-attributes
---
# Recipe Attribute Value Uniqueness

## Current Rule
A recipe, material or batch cannot select more than one `RecipeAttributeValue` for the same parent `RecipeAttribute`.

A `RecipeAttributeValue` belongs to exactly one `RecipeAttribute`.

## Introduced By
- [[PR-696 Implement SKU in material]]

## Evidence
- Recipe values are unique by parent attribute.
- Material values are unique by parent attribute.
- Persistence uniqueness for values is `(RecipeAttributeId, Name)`.

## Edge Cases
- Two different attributes have values with the same name.
- External references use only value name instead of composite identity.
