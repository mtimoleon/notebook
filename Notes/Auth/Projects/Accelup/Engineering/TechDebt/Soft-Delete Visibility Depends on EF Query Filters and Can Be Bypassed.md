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

# Soft-Delete Visibility Depends on EF Query Filters and Can Be Bypassed

## Found In
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]

## Problem
The hidden-state contract depends on EF query filters. Any use of `IgnoreQueryFilters`, raw SQL, or new project-linked entities without matching filters can re-expose deleted-project data.

## Risk Level
Medium

## Fix Direction
Audit every intentional filter bypass, document the allowed internal read scenarios, and add tests or conventions that force new project-linked entities to declare their visibility behavior.
