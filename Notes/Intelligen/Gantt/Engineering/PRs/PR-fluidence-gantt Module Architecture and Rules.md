---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-05-06
source: PR Analysis
pr: fluidence-gantt
task: Full engineering analysis of src/fluidence-gantt
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-fluidence-gantt Module Architecture and Rules

## Summary
- Documented the `src/fluidence-gantt` module as a reusable split-pane Gantt renderer with a left grid and a right time-based bar chart.
- Captured the durable public contract for rows, bars, arrows, controlled widths, row expansion state, and horizontal scroll state.
- Recorded the key runtime rules around time-scale selection, drag/drop eligibility, bar click resolution, tooltip visibility, and layered rendering.

## Domain Impact
- [[Fluidence Gantt Architecture]]
- [[Fluidence Gantt Input Contracts]]
- [[Timeline Rendering]]
- [[Hierarchical Row Model]]

## Business Logic Impact
- Visible rows are a state projection driven by `rowStatus[rowId].isExpanded`.
- Effective time scale can be selected automatically from duration, zoom, and viewport width when `lockTimeScale` is disabled.
- Only primary-layer draggable bars can start drag interactions, and cross-row drops are controlled by `droppableRowIds`.
- Bar click and right-click resolve all bars in the same layer that cover the clicked time, not only the visual bar node under the pointer.
- Tooltips are shown only for normal bars with `caption`, with clipping-aware anchor placement when bars overlap.

## Risks
- [[Monolithic Gantt Orchestrator]]
- [[Public API Drift In Gantt Component]]
- [[Mouse-First Interaction Model]]

## Follow-up
- Add explicit documentation for the supported row, bar, and arrow schemas near the component entrypoint.
- Consider extracting layout measurement, drag/drop, and resize behavior into dedicated hooks.
- Decide whether `license` remains part of the public API or should be removed from consumers.
- Validate touch and pointer-device behavior explicitly.

## Diagrams
- [[Fluidence Gantt Architecture]]
- [[Timeline Rendering]]

## Tech Debt
- [[Monolithic Gantt Orchestrator]]
- [[Public API Drift In Gantt Component]]
- [[Mouse-First Interaction Model]]

## Raw Analysis
- `C:\Users\michael\developer\FluidenceGantt\.local\PR-fluidence-gantt Engineering Analysis.md`
