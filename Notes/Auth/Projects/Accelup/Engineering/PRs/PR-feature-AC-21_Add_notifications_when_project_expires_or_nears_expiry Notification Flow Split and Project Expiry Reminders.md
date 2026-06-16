---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-11
source: PR Analysis
pr:
task: AC-21 notification flow split and project expiry reminders
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-feature-AC-21_Add_notifications_when_project_expires_or_nears_expiry Notification Flow Split and Project Expiry Reminders

## Summary
- Project notification delivery is now split across queue access, aggregate polling, dispatch orchestration, work-item building, and email sending.
- Queued notifications remain persisted and are acknowledged with `IsEmailSent = true` instead of being deleted.
- `ShouldSendEmail` is now the hard gate for whether a queued notification ever becomes email work.
- AC-21 adds scheduled project expiry reminders for monthly near-expiry, near-expiry, and expired cases.

## Domain Impact
- [[Notifications Processing Architecture]]
- [[Project Expiry Reminder Lifecycle]]
- [[Project Status Email Audiences]]

## Business Logic Impact
- `NotificationQueueService.GetPendingEmailNotificationsAsync(...)` returns only matching types where `ShouldSendEmail == true` and `IsEmailSent == false`.
- `NotificationDispatcher.DispatchAsync(...)` groups queued rows by `NotificationType`, builds typed work items, and marks only the covered notification ids as sent.
- Immediate `In_dispute` and `Cancelled_by_Admin` emails now go through the same dispatcher and builder pattern without queue persistence.
- `ProjectExpiryNotificationService` enqueues reminder rows based on three expiry windows with per-type dedupe rules.

## Risks
- The queue has no reservation or claim semantics, so overlapping workers or multiple instances can read the same pending rows before acknowledgement.
- The dispatcher treats no-recipient and noop outcomes as terminal acknowledgement, which is correct for durable no-op cases but removes automatic retry for transient data gaps.
- Recipient discovery uses a raw `MembershipTypeId != 5` rule in multiple queries.

## Follow-up
- Decide whether queued notification dispatch needs lease or claim semantics for multi-instance operation.
- Replace recipient-query magic numbers with named membership semantics.
- Decide whether the unused high-priority worker path should be activated or removed.

## Diagrams
- [[Notifications Processing Architecture]]
- [[Project Expiry Reminder Lifecycle]]

## Tech Debt
- [[Notification Queue Lacks Reservation-Claim Semantics for Multi-Instance Dispatch]]
- [[Recipient Discovery Uses MembershipTypeId Magic Number Instead of Named Rule]]
- [[High-Priority Notification Worker Scaffold Exists but Is Not Active]]

## Raw Analysis
- `C:\Users\michael\developer\accelup\accelup-backend\.local\PR-feature-AC-21_Add_notifications_when_project_expires_or_nears_expiry Engineering Analysis.md`
