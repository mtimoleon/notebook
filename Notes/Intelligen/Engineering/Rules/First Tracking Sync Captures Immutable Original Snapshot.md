---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-05-19
updated: 2026-05-19
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/business-logic
---

# First Tracking Sync Captures Immutable Original Snapshot

## Current Rule
On the first tracking sync, the system captures the current planning timing and resource assignment into `OriginalInformation`, and later tracking changes reuse that snapshot instead of rewriting it.

## Introduced By
- [[PR-task-566-Wrap-original-start-end-into-info-object Original Baseline Snapshot and Production Original Views]]

## Evidence
- `OperationEntry.SyncTrackingUpdate()`
- `OperationEntryOriginalInformation`
- `OperationEntry.ResetTrackingStatus()`

## Edge Cases
- Before the first tracking sync, original getters fall back to current planning values.
- Resetting tracking clears the snapshot, so a later sync can establish a new baseline.
