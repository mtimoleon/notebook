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

# Notifications Are Marked Sent Instead of Deleted

## Current Rule
Queued notification rows are acknowledged by setting `IsEmailSent = true` after dispatch coverage instead of being deleted after sending.

## Introduced By
- [[PR-feature-AC-21_Add_notifications_when_project_expires_or_nears_expiry Notification Flow Split and Project Expiry Reminders]]

## Evidence
- `Enoll/Services/NotificationDispatcher.cs::DispatchAsync`
- `Enoll/Services/NotificationQueueService.cs::MarkEmailSentAsync`
- `Enoll/Documentation/EmailsAndNotifications.md`

## Edge Cases
- `NotificationNoopEmailWorkItem` still leads to deterministic acknowledgement.
- Historical rows stay in the table even when no email was emitted because the business outcome was a no-op.
