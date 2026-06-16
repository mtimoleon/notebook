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
  - topic/business-logic
---

# Project Expiry Reminder Windows and Dedupe Rules

## Current Rule
Project expiry reminders are enqueued in three windows with per-type dedupe constraints: monthly near-expiry for 11 to 30 days ahead, near-expiry for 0 to 10 days ahead, and expired for dates before today.

## Introduced By
- [[PR-feature-AC-21_Add_notifications_when_project_expires_or_nears_expiry Notification Flow Split and Project Expiry Reminders]]

## Evidence
- `Enoll/Services/ProjectExpiryNotificationService.cs`
- `Enoll/Model/Entities/Notification.cs`

## Edge Cases
- Monthly reminders are suppressed when a matching notification exists in the prior 30 days.
- Near-expiry reminders are suppressed when a matching notification exists in the prior 10 days.
- Expired reminders are suppressed if any `ProjectExpired` row already exists for the project.
