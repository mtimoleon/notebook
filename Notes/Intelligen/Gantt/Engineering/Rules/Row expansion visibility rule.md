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
  - topic/business-logic
---

# Row expansion visibility rule

## Current Rule
Visible rows are derived from the hierarchical row tree using `rowStatus[rowId].isExpanded`. A row is always included in the visible list, and its children are included only when that row is expanded.

## Introduced By
- [[PR-fluidence-gantt Module Architecture and Rules]]

## Evidence
- `src/fluidence-gantt/utilities/rowUtilities.js`
- `flattenVisibleRows(...)`
- `src/fluidence-gantt/components/Gantt.jsx`
- `src/fluidence-gantt/components/Grid/GridContents.jsx`

## Edge Cases
- Child rows remain in the underlying data even when collapsed.
- Indentation level is computed from traversal depth, not from any stored row property.
