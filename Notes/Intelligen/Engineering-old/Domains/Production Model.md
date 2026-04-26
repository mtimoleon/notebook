---
type: domain-note
tags:
  - domain/production-model
  - topic/business-logic
---
# Production Model

## Overview
Production behavior is no longer defined only by the recipe. It is defined by the combination of:

- recipe
- resolved product identity
- selected BOM
- equipment-specific attribute behavior
- transition behavior between recipe attribute values

The model moves from "one recipe schedules operations" to "recipe plus product context schedules operations".

## Domain Overview
```mermaid
flowchart LR
    Workspace --> RecipeAttribute
    RecipeAttribute --> RecipeAttributeValue

    Workspace --> Recipe
    Workspace --> Material
    Workspace --> Facility
    Facility --> Equipment

    Recipe --> RecipeRecipeAttributeValue
    RecipeRecipeAttributeValue --> RecipeAttributeValue

    Material --> MaterialRecipeAttributeValue
    MaterialRecipeAttributeValue --> RecipeAttributeValue

    Equipment --> EquipmentRecipeAttributeValue
    EquipmentRecipeAttributeValue --> RecipeAttributeValue
    Equipment --> RecipeAttribute

    Recipe --> Bom
    Material --> Bom
    Bom --> BomInputStream
    Bom --> BomOutputStream

    Recipe --> AdaptiveInput
    Recipe --> AdaptiveOutput
    Operation --> AdaptiveInput
    Operation --> AdaptiveOutput
    AdaptiveInput --> BomInputStream
    AdaptiveOutput --> BomOutputStream

    Operation --> ChangeoverMatrix
    ChangeoverMatrix --> RecipeAttribute
    ChangeoverMatrix --> ChangeoverMatrixValue
    ChangeoverMatrixValue --> RecipeAttributeValue
```

## SKU State Propagation
```mermaid
flowchart TD
    A[RecipeAttribute] --> B[RecipeAttributeValue]

    B --> C{Πού επιλέγεται το value;}
    C --> D[Recipe selected values]
    C --> E[Material selected values]

    D --> F[Batch.Fill χωρίς BOM]
    E --> G[Batch.Fill με BOM product]

    F --> H[Batch.RecipeAttributeValues]
    G --> H

    H --> I[OperationEntry duration]
    H --> J[Equipment dependent processing rate]
    H --> K[Changeover matrix state lookup]

    J --> L[Effective processing rate]
    K --> M[Effective changeover duration]
    L --> N[Scheduling / conflict resolution]
    M --> N
```

## Product Context Resolution
A batch resolves effective product context from:

1. BOM product material attribute values, when a BOM exists.
2. Recipe default attribute values, when no BOM exists.

## Core Concepts
- `RecipeAttribute`
- `RecipeAttributeValue`
- `Material`
- `Bom`
- `AdaptiveInput`
- `AdaptiveOutput`
- `Campaign`
- `Batch`
- `EquipmentRecipeAttributeValue`
- `ChangeoverMatrix`
- dynamic `OperationEntry` behavior

## Related PRs
- [[PR-696 Implement SKU in material]]
