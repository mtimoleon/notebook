---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-26
updated: 2026-04-26
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/technical-debt
---

# Dynamic Scheduling Regression Surface

## Found In
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]

## Problem
Changeover-aware slot search, dynamic task recalculation, and cache invalidation alter core scheduling behavior across equipment reassignment, batch shifting, and conflict resolution.

## Risk Level
Medium

## Fix Direction
Keep focused regression examples for dynamic-only procedures, forward/backward slot search, changeover overlap, and higher-precedence campaign cache invalidation.
