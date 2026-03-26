---
categories:
  - "[[Work]]"
created: 2026-02-13
product: Gantt
component:
tags:
  - documentation/intelligen/gantt
---
## Summary

## Details

## Links
## Documentation

This document describes **how horizontal scrolling is decided** and **how it is applied** in the Gantt component, focusing on these props:

- `scrollLeft` (controlled scroll)
- `scrollToDateTime` (one-shot jump)
- `scrollWithTimeline` + `timelineTime` (auto-follow)

---
### Flow / Inputs (EocApp → Gantt)

- `scrollLeft` (`number | null`): controlled horizontal scroll. If not `null`, Gantt must follow it.
- `scrollWithTimeline` (`bool`): enables auto-follow of `timelineTime` (only when `scrollLeft === null`).
- `scrollToDateTime` (`Date | string | number | null`): one-time jump to a time (center-when-possible + clamp).
- `timelineTime` (`Date | string | null`): current time marker used for auto-follow and (optionally) initial centering.

---

### Priority / Precedence

Inside Gantt, horizontal scroll behavior follows this order:

1. **Controlled mode**: if `scrollLeft !== null` → `scrollLeft` always wins.
2. **One-time jump**: else if `scrollToDateTime` changed and is valid → jump once (center-when-possible + clamp).
3. **Auto-follow**: else if `scrollWithTimeline === true` and `timelineTime` exists → follow via delta updates.
4. **Fallback**: else initial position is `0` (or timeline-centered on first render if `timelineTime` is in range).

---

### Core Scroll Engine

#### `applyHorizontalScroll(targetScrollLeft, metricsParam?)`

- Clamps `targetScrollLeft` to the valid range `[0..maxScrollLeft]`.
- If it will actually change the DOM scroll position, sets `suppressNextHorizontalScrollEventRef = true` so the next `scroll` event is not treated as user intent.
- Writes the clamped value to both:
  - bar chart contents wrapper `scrollLeft`
  - bar chart header wrapper `scrollLeft`
- Updates `effectiveScrollLeftRef`.
- Calls `updateScrollLeft(clampedValue)` via `notifyParentAboutScrollLeftChange(...)`.

#### Why `suppressNextHorizontalScrollEventRef` exists

When we set `element.scrollLeft = ...` programmatically, the browser fires a `scroll` event as if the user scrolled.
Without distinguishing programmatic vs manual scroll:

- We would spam `updateScrollLeft(...)` to the parent.
- We would incorrectly re-anchor auto-follow (as if the user moved the viewport).
- Feedback loops can occur (parent props → we scroll → we notify parent → parent updates again).

`suppressNextHorizontalScrollEventRef` is a one-shot flag: the next `scroll` event is consumed as programmatic.

---

#### 1) Initial / Resize positioning

In `sizeAndPositionBarChartHeaderAndContents(...)`:

- **First render**
  - if `scrollLeft !== null` → use it (clamped)
  - else if `timelineTime` exists and is in range → optionally center on timeline initially
  - else → `0`
- **On resize**
  - attempts to keep the visible “time center” stable so the chart does not jump in time during resizing

---

#### 2) Controlled `scrollLeft` path

- When `scrollLeft !== null`, it is treated as the source of truth.
- All timeline-based behavior (jump + auto-follow) is bypassed while controlled.

---

#### 3) One-time scroll (`scrollToDateTime`)

- Runs only when the request changes (compare in ms).
- Preconditions:
  - `scrollLeft === null`
  - valid `scrollToDateTime` (Date)
  - chart bounds exist (`minimumChartDateRef`, `maximumChartDateRef`)
- Behavior:
  - clamp requested time to chart bounds
  - compute `scrollLeft` for center-when-possible / edge pin
  - clamp `scrollLeft` to scrollbar bounds
  - no-op if `effectiveScrollLeft === target`
  - otherwise `applyHorizontalScroll(target)`
- If `scrollWithTimeline` is enabled, re-anchors auto-follow (previous timeline ms + reset carry).

---

#### 4) Auto-follow (`scrollWithTimeline`)

- Stop / reset if:
  - `scrollLeft !== null` (controlled), or
  - `scrollWithTimeline` is false, or
  - `timelineTime` is null
- When enabled:
  - first tick: only sets the anchor (`autoScrollPreviousTimelineMsRef = timelineTimeMs`), does **not** re-center
  - next ticks:
    - `deltaTimelineMs = timelineTimeMs - previous`
    - convert to pixels via `secondsPerPixel`
    - fractional carry (`autoScrollDeltaCarryPxRef`) accumulates sub-pixel deltas
    - scroll by integer delta using `applyHorizontalScroll(current + deltaPx)`
    - if already pinned fully right and delta is to the right → no-op (stop trying)

---

#### 5) Manual scroll while auto-follow is on

In `handleScrollingInBarChart(...)`:

- Keeps header scroll in sync with contents scroll.
- If the event is programmatic (flag set), it consumes it without treating it as user intent.
- For user scroll while auto-follow enabled:
  - re-anchors auto-follow (set previous timeline ms, reset carry)
  - auto-follow continues from the user’s new position
- For user scroll, notifies the parent via `updateScrollLeft`.

---

#### 6) Refresh persistence (EocApp)

- EocApp saves/loads `scrollLeft` and `scrollWithTimeline`.
- On refresh with `scrollWithTimeline = true`, EocApp forces `scrollLeft = null` in the initial state so Gantt does not enter controlled mode and auto-follow is respected immediately.