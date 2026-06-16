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

# No Visible Restore or Undelete Flow for Soft-Deleted Projects

## Found In
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]

## Problem
The branch introduces durable soft delete but does not expose a visible user-facing or admin-facing restore path, so deletion is effectively terminal in normal flows.

## Risk Level
Medium

## Fix Direction
Decide whether deletion is intentionally terminal. If not, define an explicit restore workflow, authorization rule, and audit trail for undelete operations.
