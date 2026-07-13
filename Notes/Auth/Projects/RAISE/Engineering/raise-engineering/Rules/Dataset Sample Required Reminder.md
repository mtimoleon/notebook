---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-22
updated: 2026-06-22
product: RAISE
component: Datasets
tags:
  - documentation/raise
  - topic/business-logic
---

# Dataset Sample Required Reminder

## Current Rule
When a dataset reaches `Uploaded` or `StreamingInProgress` and its sample is not `Available`, the dataset owner must receive a reminder notification to upload the sample.

## Introduced By
- [[PR-340 Extend Notifications]]

## Evidence
- `Raise.APIGateway/Services/NodeService.cs`
- `Raise.FunctionalTests/NotificationTests.cs`

## Edge Cases
- No reminder is emitted for statuses outside `Uploaded` and `StreamingInProgress`.
- No reminder is emitted when the sample is already `Available`.
