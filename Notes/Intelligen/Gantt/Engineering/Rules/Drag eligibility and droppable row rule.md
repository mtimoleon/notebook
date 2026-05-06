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

# Drag eligibility and droppable row rule

## Current Rule
Only primary-layer bars that are marked draggable can start a drag interaction. If a bar has a `groupId`, all matching visible entries in that group are dragged together. Cross-row dropping is supported only for single-bar drags and is limited by `droppableRowIds`.

## Introduced By
- [[PR-fluidence-gantt Module Architecture and Rules]]

## Evidence
- `src/fluidence-gantt/components/Gantt.jsx`
- `onBarChartMouseDown(...)`
- `src/fluidence-gantt/utilities/barInteractionUtilities.js`
- `pickDragTargetAtPoint(...)`
- `getDroppableRows(...)`
- `buildDragPreviewEntries(...)`

## Edge Cases
- Group drags effectively keep the original row as the only droppable row.
- `droppableRowIds` supports either `"*"` or an explicit list of row ids.
- A drag can move in time without changing rows when row eligibility does not allow reassignment.
