---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-22
updated: 2026-06-22
product: RAISE
component: Notifications
tags:
  - documentation/raise
  - topic/technical-debt
---

# Notification Deduplication Relies On Application Checks

## Found In
- [[PR-340 Extend Notifications]]

## Problem
Notification deduplication is implemented through application-level `AnyAsync(...)` checks before insert, with no visible database uniqueness constraint in the analyzed change set.

## Risk Level
Medium

## Fix Direction
Add database-backed uniqueness for the relevant notification scopes or replace the check-then-insert flow with a transactional upsert pattern.
