---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-22
updated: 2026-06-22
product: RAISE
component: Experiments
tags:
  - documentation/raise
  - topic/technical-debt
---

# Result Auto-Approval Depends On Hydrated Navigation Properties

## Found In
- [[PR-340 Extend Notifications]]

## Problem
The self-owned auto-approval rule now depends on `experiment.User` and `dataset.User` being hydrated when `ExperimentResultDatasetApproval` is constructed, rather than comparing stable scalar identifiers.

## Risk Level
Medium

## Fix Direction
Move owner comparison onto scalar ids or pass an explicit self-approval decision into the aggregate constructor so the rule does not depend on navigation loading state.
