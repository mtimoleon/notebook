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

# Notifications and Emails Should Not Resolve Deleted Projects

## Current Rule
Notification and email projection paths should not hydrate project payloads for projects that have been soft deleted.

## Introduced By
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]

## Evidence
- `Enoll/Services/EmailService.cs`
- `Enoll/Services/NotificationService.cs`

## Edge Cases
- Existing notifications can lose project payload enrichment after the target project is soft deleted.
