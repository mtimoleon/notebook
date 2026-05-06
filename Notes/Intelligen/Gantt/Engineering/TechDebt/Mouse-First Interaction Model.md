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
  - topic/technical-debt
---

# Mouse-First Interaction Model

## Found In
- [[PR-fluidence-gantt Module Architecture and Rules]]

## Problem
The drag and resize lifecycle is centered on `mousemove` and `mouseup` listeners on `window`. There are touch-aware coordinate helpers, but the main interaction path is still mouse-first rather than pointer-first.

## Risk Level
Medium

## Fix Direction
Move the drag and resize model toward pointer events and validate behavior explicitly on touch devices and mixed-input environments.
