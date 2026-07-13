---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-22
updated: 2026-06-22
product: RAISE
component: Metadata
tags:
  - documentation/raise
  - topic/business-logic
---

# Schema Required Before maDMP Creation

## Current Rule
A streamed dataset can create its maDMP only after it reaches `MaDmpPending` and has at least one validated schema field.

## Introduced By
- [[PR-343 Streaming Agents and maDMP Workflow]]

## Evidence
- `Raise.APIGateway/Services/DatasetService.cs`
- `RaiseServices.Domain/Aggregates/MaDmp/DatasetSchemaValidator.cs`
- `Raise.FunctionalTests/DatasetTests.cs`

## Edge Cases
- Regular datasets cannot create a maDMP.
- A dataset still in `SchemaPending` is rejected even if it already has field candidates in the request flow.
- Creating a second maDMP for the same dataset is rejected.
