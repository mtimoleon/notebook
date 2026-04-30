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

# Duplicated Approval Logic

## Found In
- [[PR-216 Experiment Result Approval Gate]]

## Problem
Approval and result-access decisions are now computed in both `ExperimentService` and `ExternalRequestService`, which increases drift risk.

## Risk Level
Low

## Fix Direction
Move approval-access evaluation into one reusable policy/helper so both endpoints use the same logic.
