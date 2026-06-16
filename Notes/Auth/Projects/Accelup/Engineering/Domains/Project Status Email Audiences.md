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
  - topic/domain
---

# Project Status Email Audiences

## Overview
Project status changes now share a common audience-building model, but the dispatch path differs between immediate statuses and queued statuses.

## Current Behavior
- `In_dispute` emails go immediately to project owners, winning bid organization users, and the configured contact address.
- `Cancelled_by_Admin` emails go immediately to bidding organization users, winning bid organization users, and project owners.
- Other status changes enqueue notifications and later resolve audiences through the builder using the project status and bid state.
- Audience selection depends on whether the target status should notify bidding organizations, winning organizations, or both.

## Business Meaning
Status email behavior is driven by audience intent and urgency, not only by where the email is triggered.

## Rules
- [[Immediate Dispute and Admin-Cancelled Project Emails Use Dispatcher Plus Builder]]

## Risks
- [[Recipient Discovery Uses MembershipTypeId Magic Number Instead of Named Rule]]

## Related PRs
- [[PR-feature-AC-21_Add_notifications_when_project_expires_or_nears_expiry Notification Flow Split and Project Expiry Reminders]]
