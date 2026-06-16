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

# Route Authorization and Deletion Rule Are Misaligned

## Found In
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]

## Problem
The delete route admits `Admin` callers, but the service rejects non-owner admins, creating an avoidable contract mismatch between API exposure and business behavior.

## Risk Level
Medium

## Fix Direction
Either narrow the controller authorization to owners-only capable roles or explicitly support an admin override and test that behavior at both controller and service levels.
