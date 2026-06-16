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

# Recipient Discovery Uses MembershipTypeId Magic Number Instead of Named Rule

## Found In
- [[PR-feature-AC-21_Add_notifications_when_project_expires_or_nears_expiry Notification Flow Split and Project Expiry Reminders]]

## Problem
Recipient discovery queries repeatedly depend on `MembershipTypeId != 5`, which hides the business meaning of the exclusion rule and makes future maintenance harder.

## Risk Level
Medium

## Fix Direction
Replace the raw membership id check with a named enum, constant, or predicate that makes the excluded membership category explicit everywhere it is used.
