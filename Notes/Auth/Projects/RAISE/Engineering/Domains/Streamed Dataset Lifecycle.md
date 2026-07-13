---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-22
updated: 2026-06-22
product: RAISE
component: Datasets
tags:
  - documentation/raise
  - topic/domain
---

# Streamed Dataset Lifecycle

## Overview
Streamed datasets now move through explicit contract-definition stages before a streaming agent can begin delivering or consuming them.

## Current Behavior
- A streamed dataset can be finalized only from `Draft`.
- Finalization moves the dataset to `SchemaPending`.
- Saving a non-empty schema advances the dataset to `MaDmpPending` when no maDMP exists yet.
- Creating or regenerating a valid maDMP advances the dataset to `AgentInitializationPending`.
- Linking the dataset to a streaming agent moves it to `StreamingInProgress`.
- Editing schema after maDMP creation rolls the dataset back to `SchemaPending` until the maDMP is regenerated.
- `StreamingInProgress` locks further schema and maDMP mutations.

## Rules
- [[Streamed Dataset Finalization Starts Schema Phase]]
- [[Schema Required Before maDMP Creation]]
- [[maDMP Required Before Agent Initialization]]
- [[Streaming Agent Dataset Link Eligibility]]

## Risks
- [[Grouped maDMP Schema Required Paths May Not Match Nested Fields]]

## Related PRs
- [[PR-343 Streaming Agents and maDMP Workflow]]

## Lifecycle Diagram

```mermaid
flowchart LR
    A["Draft streamed dataset"] --> B["Finalize dataset"]
    B --> C["SchemaPending"]
    C --> D["PUT /dataset/{id}/schema"]
    D --> E["MaDmpPending"]
    E --> F["POST /dataset/{id}/madmp"]
    F --> G["AgentInitializationPending"]
    G --> H["POST /agent/{agentId}/datasets/add"]
    H --> I["StreamingInProgress"]
    G --> J["Schema edit after maDMP"]
    J --> C
    C --> K["PUT /dataset/{id}/madmp regenerate"]
    K --> G
```
