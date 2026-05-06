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

# Hierarchical Row Model

## Overview
Rows are hierarchical and visibility is projection-based. Child rows stay in the data model and are only included in the rendered list when expansion state allows it.

## Current Behavior
- `flattenVisibleRows(...)` walks the row tree and returns visible rows with indentation level metadata.
- Expansion is controlled by `rowStatus[rowId].isExpanded`.
- `GridContents` uses the computed `level` to indent first-column content.
- Row height is shared between the grid and the bar chart so the split-pane stays aligned.
- `getMaxVisibleRows(...)` is used to size the viewport for the fully expanded case.

## Business Meaning
- The model supports drill-down planning without mutating or flattening the underlying data.
- Structural hierarchy and schedule rendering stay aligned because both sides consume the same visible-row projection.

## Rules
- [[Row expansion visibility rule]]

## Risks
- [[Monolithic Gantt Orchestrator]]

## Related PRs
- [[PR-fluidence-gantt Module Architecture and Rules]]
