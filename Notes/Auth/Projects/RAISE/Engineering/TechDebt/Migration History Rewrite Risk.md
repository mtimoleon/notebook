---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Migrations
tags:
  - documentation/raise
  - topic/technical-debt
---

# Migration History Rewrite Risk

## Found In
- [[PR-209 Credit System Foundations]]

## Problem
The credit migration was renamed/resquashed and a separate migration was removed, which can desynchronize EF migration history for environments that already applied the earlier ids.

## Risk Level
High

## Fix Direction
Document a supported upgrade path for already-migrated environments and validate migration-history repair steps before rollout.
