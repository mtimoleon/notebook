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

# ShouldSendEmail Gates Queued Email Dispatch

## Current Rule
A queued notification participates in email dispatch only when its type is requested, `ShouldSendEmail` is true, and `IsEmailSent` is false.

## Introduced By
- [[PR-feature-AC-21_Add_notifications_when_project_expires_or_nears_expiry Notification Flow Split and Project Expiry Reminders]]

## Evidence
- `Enoll/Services/NotificationQueueService.cs::GetPendingEmailNotificationsAsync`
- `Enoll/Model/Entities/Notification.cs`

## Edge Cases
- Rows with `ShouldSendEmail = false` remain persisted for history but never become pending email work.
- A row that is already marked sent is permanently excluded from default dispatch reads.
