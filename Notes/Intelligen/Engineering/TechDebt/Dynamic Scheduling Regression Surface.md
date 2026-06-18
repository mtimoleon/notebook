---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-26
updated: 2026-06-18
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/technical-debt
---

# Dynamic Scheduling Regression Surface

## Found In
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]
- [[PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review]]

## Problem
Changeover-aware slot search, dynamic task recalculation, campaign-level attribute lookup on equipment neighbors, and cache invalidation alter core scheduling behavior across equipment reassignment, batch shifting, and conflict resolution.

## Risk Level
Medium

## Fix Direction
Keep focused regression examples for dynamic-only procedures, forward/backward slot search, changeover overlap, and higher-precedence campaign cache invalidation.

## Master Status
- Reviewed against master on 2026-06-18.
- Status: Still open in master
- Evidence: The scheduling surface remains broad and sensitive; this review did not find clear evidence that the focused regression coverage described here has been fully locked in.

