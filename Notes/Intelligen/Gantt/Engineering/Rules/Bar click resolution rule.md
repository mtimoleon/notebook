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

# Bar click resolution rule

## Current Rule
A bar click or right-click resolves the clicked time first and then returns all bars from the same bar layer that cover that time. The callback does not return only the single DOM bar that received the event.

## Introduced By
- [[PR-fluidence-gantt Module Architecture and Rules]]

## Evidence
- `src/fluidence-gantt/components/Gantt.jsx`
- `onBarClick(...)`
- `onBarRightClick(...)`
- `src/fluidence-gantt/utilities/barUtilities.js`
- `getBarsAtDate(...)`

## Edge Cases
- Click behavior is attached only to primary-layer entries.
- Overlapping bars in the same layer can all be returned for the resolved click time.
