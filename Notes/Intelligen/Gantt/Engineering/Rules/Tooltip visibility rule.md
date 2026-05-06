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

# Tooltip visibility rule

## Current Rule
Tooltips are shown only for normal bars that provide a `caption`. When bars overlap in the same row and layer, the tooltip logic tries to resolve a visible segment of the chosen bar and anchor the tooltip to that visible segment.

## Introduced By
- [[PR-fluidence-gantt Module Architecture and Rules]]

## Evidence
- `src/fluidence-gantt/components/Gantt.jsx`
- `onBarPointerEnter(...)`
- `onBarPointerMove(...)`
- `src/fluidence-gantt/utilities/barInteractionUtilities.js`
- `pickBarTooltipInfoAtPoint(...)`
- `src/fluidence-gantt/components/Tooltip.jsx`

## Edge Cases
- Overlay and backdrop bars do not participate in the same tooltip rule.
- Tooltip placement can be suppressed when there is not enough visible clipped space.
