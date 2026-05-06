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

# Time scale auto-selection rule

## Current Rule
When `lockTimeScale` is disabled, the component selects an effective time scale automatically from chart duration, effective zoom, and available screen width. The available scales are `HourTenmin`, `DayHour`, `WeekDay`, `MonthWeek`, and `YearMonth`.

## Introduced By
- [[PR-fluidence-gantt Module Architecture and Rules]]

## Evidence
- `src/fluidence-gantt/utilities/timeScaleUtilities.js`
- `getEffectiveZoom(...)`
- `calculateAutomaticTimeScaleConfig(...)`
- `getEffectiveTimeScaleConfig(...)`

## Edge Cases
- Invalid or non-finite chart start or end values fall back to `WeekDay`.
- The thresholds are hardcoded and can change perceived behavior abruptly near boundaries.
