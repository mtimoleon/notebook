---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-11
updated: 2026-06-11
product: Accelup
component: Notifications
tags:
  - documentation/accelup
  - topic/technical-debt
---

# High-Priority Notification Worker Scaffold Exists but Is Not Active

## Found In
- [[PR-feature-AC-21_Add_notifications_when_project_expires_or_nears_expiry Notification Flow Split and Project Expiry Reminders]]

## Problem
`NotificationsAggregateService` still defines high-priority timers, task plumbing, and a send path, but the high-priority task is commented out and the configured high-priority notification type list is empty.

## Risk Level
Low

## Fix Direction
Either activate the high-priority path with real notification types and lifecycle coverage or remove the unused scaffold so the polling model stays easier to reason about.
