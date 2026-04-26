---
type: domain-note
tags:
  - domain/bom
  - topic/adaptive-recipe
---
# BOM

## Overview
BOM is the runtime product choice for a campaign. It connects the generic recipe process to a concrete product material and concrete input/output streams.

## Adaptive Recipe and BOM Flow
```mermaid
flowchart TD
    A[Recipe] --> B[Operation]
    A --> C[AdaptiveInput]
    A --> D[AdaptiveOutput]
    B --> C
    B --> D

    E[Material product] --> F[BOM]
    A --> F
    F --> G[BomInputStream]
    F --> H[BomOutputStream]

    C --> G
    D --> H

    I[Campaign] --> F
    I --> J[Batch]
    J --> K[OperationEntry]

    G --> L[Input OperationEntryStream]
    H --> M[Output OperationEntryStream]
    K --> L
    K --> M
```

## Current Behavior
- A BOM belongs to a product material.
- A BOM may be associated with a recipe.
- BOM input/output streams can be linked to adaptive input/output definitions.
- If the associated recipe changes, existing stream links are cleared because previous links may no longer be valid.
- Adaptive links must point to the same recipe as the BOM.

## Business Meaning
- Recipe defines process logic.
- BOM defines concrete material realization.
- Campaign selects the BOM to run the recipe for a specific product.

## Rules
- [[Campaign BOM Recipe Match]]
- [[Batch Product Context Resolution]]

## Related PRs
- [[PR-696 Implement SKU in material]]
