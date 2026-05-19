---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-05-19
updated: 2026-05-19
product: scpCloud
component: CommonSpa
tags:
  - documentation/Intelligen
  - topic/technical-debt
---

# Update Modal Original Resources Not Rendered

## Found In
- [[PR-task-566-Wrap-original-start-end-into-info-object Original Baseline Snapshot and Production Original Views]]

## Problem
The backend contract now exposes original auxiliary equipment and staff, but the CommonSpa update modal still populates the original slots from planning props and keeps original-resource UI paths disabled.

## Risk Level
Medium

## Fix Direction
Enable the original-resource UI path and bind it to the backend-provided original aux/staff fields instead of reusing planning values.
