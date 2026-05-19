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

# TimingInfoType Original Is Read Only

## Current Rule
`TimingInfoType.Original` is a read context for timing and resource accessors, not a third mutable scheduling mode.

## Introduced By
- [[PR-task-566-Wrap-original-start-end-into-info-object Original Baseline Snapshot and Production Original Views]]

## Evidence
- `OperationEntry.GetStart(TimingInfoType type)`
- `OperationEntry.GetDuration(TimingInfoType type)`
- `OperationEntry.GetEnd(TimingInfoType type)`
- `OperationEntry.GetAuxEquipment(TimingInfoType type)`
- `OperationEntry.GetStaff(TimingInfoType type)`

## Edge Cases
- When no original snapshot exists, the original context returns planning values.
- Comments, attention codes, completion status, and confirmed time are still governed by planning/tracking behavior rather than a separate original branch.
