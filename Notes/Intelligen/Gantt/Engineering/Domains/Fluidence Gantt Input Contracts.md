---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-05-06
updated: 2026-05-06
product:
component: fluidence-gantt
tags:
  - documentation/fluidence-gantt
  - topic/domain
---

# Fluidence Gantt Input Contracts

## Overview
The module relies on an implicit runtime schema rather than explicit TypeScript types or validators. The host application is expected to provide rows, bars, arrows, and controlled UI state in a shape that the renderer can use directly.

## Current Behavior
- `data` is expected to be an array of rows.
- Each row is expected to provide at least `id`, `gridValues`, `bars`, and optionally `childRows`.
- `bars` can be a flat array for a single layer or an array of arrays for multiple layers.
- Each bar can carry fields such as `id`, `startDate`, `endDate`, `text`, `caption`, `type`, `groupId`, `isDraggable`, `droppableRowIds`, `completionPercentage`, and `barStyle`.
- `arrows` are expected to use `sourceBarId`, `destinationBarId`, `sourceEdge`, and `destinationEdge`.
- The host can also control `widths`, `rowStatus`, `scrollLeft`, `zoom`, `timeScale`, `lockTimeScale`, timeline options, and drag/click callbacks.

## Business Meaning
- This contract allows the same renderer to support simple Gantt views and richer planning views with multiple bar layers, dependencies, and row hierarchies.
- Because the contract is implicit, host applications carry responsibility for input quality and identifier uniqueness.

## Rules
- [[Drag eligibility and droppable row rule]]
- [[Bar click resolution rule]]
- [[Tooltip visibility rule]]

## Risks
- [[Public API Drift In Gantt Component]]

## Related PRs
- [[PR-fluidence-gantt Module Architecture and Rules]]
