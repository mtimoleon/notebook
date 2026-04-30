---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Experiments
tags:
  - documentation/raise
  - topic/technical-debt
---

# Authorization Check Ordering In Receive-Results

## Found In
- [[PR-216 Experiment Result Approval Gate]]

## Problem
The receive-results endpoint currently evaluates pending approval state before its final unauthorized-user branch, which can leak private experiment existence or approval status.

## Risk Level
High

## Fix Direction
Reorder the checks so caller authorization is resolved before exposing approval-specific failures for private results.
