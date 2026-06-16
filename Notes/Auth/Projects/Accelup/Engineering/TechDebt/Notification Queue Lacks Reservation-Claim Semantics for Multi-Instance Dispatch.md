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

# Notification Queue Lacks Reservation-Claim Semantics for Multi-Instance Dispatch

## Found In
- [[PR-feature-AC-21_Add_notifications_when_project_expires_or_nears_expiry Notification Flow Split and Project Expiry Reminders]]

## Problem
Pending notifications are read with `AsNoTracking()` and acknowledged only after dispatch, but there is no lease, claim, or reservation field to prevent concurrent workers from reading the same rows before `IsEmailSent` is updated.

## Risk Level
High

## Fix Direction
Introduce claim semantics such as a processing state, lease timestamp, or transactional fetch-and-mark pattern so multiple instances cannot send the same email work twice.
