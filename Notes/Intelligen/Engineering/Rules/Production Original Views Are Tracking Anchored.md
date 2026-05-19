---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-05-19
updated: 2026-05-19
product: scpCloud
component: Production
tags:
  - documentation/Intelligen
  - topic/business-logic
---

# Production Original Views Are Tracking Anchored

## Current Rule
Production original views are derived by enriching tracking-oriented projections, so original rows do not become independently rendered tasks or resources unless a tracking counterpart exists.

## Introduced By
- [[PR-task-566-Wrap-original-start-end-into-info-object Original Baseline Snapshot and Production Original Views]]

## Evidence
- `Services/Production/Production.Api/Helpers/FilterHelpers.cs`
- `Services/Production/Production.Api/Services/ChartService.cs`
- `Services/Production/Production.Api/GrpcServers/SchedulingBoardServer.cs`

## Edge Cases
- Original-only tasks and resources can be absent from charts.
- Original EOC rows can miss outages when tracking boundaries are not available for the same window.
