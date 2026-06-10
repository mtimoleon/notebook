---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-03
updated: 2026-06-10
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/technical-debt
---

# Dynamic Task Change Propagation

## Found In
- [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]
- [[PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review]]

## Problem
`Campaign.UpdateDynamicTasks()` overwrites the `campaignChanged` flag for each batch instead of accumulating it. If an earlier batch changes and the final batch does not, the campaign can incorrectly report that nothing changed, which can hide real dynamic-task updates from `SchedulingBoard.UpdateDynamicTasks()`.

## Risk Level
High

## Fix Direction
Aggregate batch changes with OR semantics, then add a regression test covering a multi-batch campaign where only a non-final batch changes. Verify that scheduling-board-level highest-precedence change detection still works after the fix.
