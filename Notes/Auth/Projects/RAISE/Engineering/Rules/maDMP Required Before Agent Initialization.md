---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-22
updated: 2026-06-22
product: RAISE
component: Streaming
tags:
  - documentation/raise
  - topic/business-logic
---

# maDMP Required Before Agent Initialization

## Current Rule
A streamed dataset must have both a saved schema and a saved maDMP before it is considered ready for `AgentInitializationPending` and eventual agent linking.

## Introduced By
- [[PR-343 Streaming Agents and maDMP Workflow]]

## Evidence
- `Raise.APIGateway/Services/DatasetService.cs`
- `RaiseServices.Domain/Aggregates/Dataset/Dataset.cs`
- `Raise.FunctionalTests/DatasetTests.cs`

## Edge Cases
- Editing schema after maDMP creation returns the dataset to `SchemaPending` until maDMP regeneration.
- Regeneration from `MaDmpPending` can move the dataset back to `AgentInitializationPending`.
- `StreamingInProgress` blocks later maDMP changes.
