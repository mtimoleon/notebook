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

# Approval Email Latency Follows Access-Request Timer Cadence

## Found In
- [[PR-340 Extend Notifications]]

## Problem
Dataset and script access approval emails share the cadence of the access-request timer jobs instead of using the faster high-priority notification pipeline.

## Risk Level
Low

## Fix Direction
Either route approval emails through a dedicated high-priority path or document the expected latency so product behavior matches the timer configuration.
