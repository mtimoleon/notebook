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

# Public API Drift In Gantt Component

## Found In
- [[PR-fluidence-gantt Module Architecture and Rules]]

## Problem
Current consumers pass a `license` prop, but the renderer does not use `props.license`. This suggests either a stale public contract or an incomplete integration boundary.

## Risk Level
Medium

## Fix Direction
Decide whether `license` is still part of the supported API. If not, remove it from consumers and documentation. If yes, restore explicit handling and document the behavior.
