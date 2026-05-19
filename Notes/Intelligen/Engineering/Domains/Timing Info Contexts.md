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
  - topic/domain
---

# Timing Info Contexts

## Overview
Timing and resource lookups now support an explicit original context beside planning and tracking.

## Current Behavior
- `GetStart`, `GetDuration`, `GetEnd`, `GetAuxEquipment`, and `GetStaff` accept `TimingInfoType.Original`.
- The original context resolves from `OriginalInformation` when present and otherwise falls back to planning values.
- Scheduling, EOC calculation, sync payload building, and production projections can request original values through the same read API shape.
- Original context is read-only baseline data, not a third mutable scheduling mode.
- Comments, attention codes, completion status, and confirmed time do not gain independent original-state mutations.

## Rules
- [[TimingInfoType Original Is Read Only]]

## Risks
- [[Original EOC Outages Depend on Tracking Boundaries]]
- [[Original Only Chart Rows Need Independent Merge]]

## Related PRs
- [[PR-task-566-Wrap-original-start-end-into-info-object Original Baseline Snapshot and Production Original Views]]
