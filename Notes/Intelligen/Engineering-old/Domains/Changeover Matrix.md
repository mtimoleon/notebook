---
type: domain-note
tags:
  - domain/changeover
  - topic/scheduling
---
# Changeover Matrix

## Overview
A changeover matrix defines transition duration between values of the same recipe attribute.

## Changeover Matrix Duration
```mermaid
flowchart TD
    A[Operation.DurationMode = BasedOnChangeoverMatrix] --> B[OperationEntry]
    B --> C[Batch selected RecipeAttributeValues]
    B --> D[DurationChangeoverMatrix]
    D --> E[RecipeAttribute]

    C --> F[Current batch value για το matrix attribute]
    B --> G{Scheduling direction}

    G -->|Forward| H[Find next equipment SKU state]
    G -->|Backward| I[Find previous equipment SKU state]

    H --> J[Matrix lookup from current to next]
    I --> K[Matrix lookup from previous to current]

    J --> L[OperationEntry duration]
    K --> L
    L --> M[Recalculate dynamic tasks]
    M --> N[Update timing / resolve conflicts]
```

## Current Behavior
- A matrix belongs to one `RecipeAttribute`.
- Matrix values represent transition times from one `RecipeAttributeValue` to another.
- `null` from/to values represent transition from or to idle state.
- Duplicate from/to entries in the same matrix are rejected.
- If `IsSymmetrical` is enabled, reverse transition values may be reused.
- Missing matching matrix value means changeover time is zero.
- Idle-state threshold can change how the transition is evaluated.

## Rule
- [[Changeover Matrix Duration]]

## Related PRs
- [[PR-696 Implement SKU in material]]
