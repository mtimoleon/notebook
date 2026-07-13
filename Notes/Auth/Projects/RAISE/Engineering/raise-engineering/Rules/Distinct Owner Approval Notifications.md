---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-22
updated: 2026-06-22
product: RAISE
component: Notifications
tags:
  - documentation/raise
  - topic/business-logic
---

# Distinct Owner Approval Notifications

## Current Rule
When an experiment completes with pending result approvals, the system emits at most one `ExperimentResultApprovalRequired` notification per distinct dataset owner per experiment, even if that owner contributed multiple approval-required datasets.

## Introduced By
- [[PR-340 Extend Notifications]]

## Evidence
- `Raise.APIGateway/CoreServices/RegistrationService.cs`
- `Raise.FunctionalTests/NotificationTests.cs`

## Edge Cases
- Owners with only auto-approved self-owned datasets are not notified.
- The runner receives the follow-up unlock notification only after every pending owner approval becomes approved.
