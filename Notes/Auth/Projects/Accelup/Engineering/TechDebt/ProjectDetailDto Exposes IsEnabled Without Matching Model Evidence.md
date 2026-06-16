---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-11
updated: 2026-06-11
product: Accelup
component: Projects
tags:
  - documentation/accelup
  - topic/technical-debt
---

# ProjectDetailDto Exposes IsEnabled Without Matching Model Evidence

## Found In
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]

## Problem
`ProjectDetailDto` includes `IsEnabled`, but the reviewed final-branch evidence does not show a matching project-model change, which suggests orphaned API surface or mapping drift.

## Risk Level
Medium

## Fix Direction
Trace the DTO mapping end to end, confirm whether `IsEnabled` is still intentional, and remove or document it if the field no longer represents persisted behavior.
