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

# Immediate Dispute and Admin-Cancelled Project Emails Use Dispatcher Plus Builder

## Current Rule
`In_dispute` and `Cancelled_by_Admin` project emails are sent immediately, but payload composition and recipient discovery still go through the dispatcher and work-item builder instead of living in the controller.

## Introduced By
- [[PR-feature-AC-21_Add_notifications_when_project_expires_or_nears_expiry Notification Flow Split and Project Expiry Reminders]]

## Evidence
- `Enoll/Controllers/ProjectsController.cs`
- `Enoll/Services/NotificationDispatcher.cs::DispatchProjectDisputeEmailsAsync`
- `Enoll/Services/NotificationDispatcher.cs::DispatchProjectCancelledByAdminEmailsAsync`
- `Enoll/Services/NotificationEmailWorkItemBuilder.cs`

## Edge Cases
- Immediate flows do not create queue rows, so they do not inherit queued retry behavior.
- Audiences with no recipients are skipped rather than retried through background processing.
