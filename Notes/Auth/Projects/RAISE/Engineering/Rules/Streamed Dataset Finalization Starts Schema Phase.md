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
  - topic/business-logic
---

# Streamed Dataset Finalization Starts Schema Phase

## Current Rule
Finalizing a streamed dataset can only happen from `Draft`, and successful finalization moves the dataset into `SchemaPending` rather than directly into agent initialization.

## Introduced By
- [[PR-343 Streaming Agents and maDMP Workflow]]

## Evidence
- `Raise.APIGateway/Services/DatasetService.cs`
- `RaiseServices.Domain/Aggregates/Dataset/Dataset.cs`
- `Raise.FunctionalTests/DatasetTests.cs`

## Edge Cases
- A non-draft streamed dataset cannot be finalized again through the same path.
- An empty schema keeps the dataset in `SchemaPending` after finalization.
