---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-22
updated: 2026-06-22
product: RAISE
component: Access Requests
tags:
  - documentation/raise
  - topic/business-logic
---

# Access Request Approval Notifications

## Current Rule
When a dataset or script access request is granted, the requester receives an approval notification and approval email. The rejection path does not emit an equivalent approval notification.

## Introduced By
- [[PR-340 Extend Notifications]]

## Evidence
- `Raise.APIGateway/Services/DatasetService.cs`
- `Raise.APIGateway/Services/ScriptService.cs`
- `Raise.APIGateway/CoreServices/NotificationMailerService.cs`

## Edge Cases
- Dataset and script approvals use their existing access-request mailer timers rather than the high-priority notification pipeline.
- The rule is tied to successful grant state and does not mirror the rejection branch.
