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

# Monolithic Gantt Orchestrator

## Found In
- [[PR-fluidence-gantt Module Architecture and Rules]]

## Problem
`components/Gantt.jsx` holds too many responsibilities in one file: layout measurement, resize flows, synchronized scrolling, drag/drop state, tooltip state, timeline overlays, time-scale selection, and the main render tree.

## Risk Level
Medium

## Fix Direction
Extract coherent behaviors into dedicated hooks or controller modules, starting with layout measurement, grid resizing, and drag/drop orchestration.
