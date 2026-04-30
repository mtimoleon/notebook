---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Notifications
tags:
  - documentation/raise
  - topic/technical-debt
---

# Auto-Approved Request Notifications

## Found In
- [[PR-214 Usage-Based Access Request Persistence]]

## Problem
The instant-grant usage-based path now creates request rows through the same notification-producing creation helpers, which may notify owners for flows that do not actually require approval.

## Risk Level
Medium

## Fix Direction
Separate notification intent from request-row creation so auto-approved flows can persist audit state without generating approval-style notifications.
