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
  - topic/domain
---

# Notification Taxonomy

## Overview
The notification taxonomy defines which business events produce stored notifications, who receives them, and which delivery pipeline dispatches the email side effects.

## Current Behavior
- `DatasetAccessRequestApproved` is emitted when a dataset owner grants access to a requester.
- `ScriptAccessRequestApproved` is emitted when a script owner grants access to a requester.
- `DatasetSampleUploadRequired` is emitted when a dataset upload reaches `Uploaded` or `StreamingInProgress` without an available sample.
- `ExperimentResultApprovalRequired` is emitted once per distinct dataset owner with pending approvals after experiment completion.
- `ExperimentResultApprovalsGranted` is emitted when the final outstanding result approval becomes approved.
- Access-request approval notifications flow through the dataset/script request mailer timers, while experiment and dataset-sample notifications use the high-priority mailer pipeline.

## Rules
- [[Access Request Approval Notifications]]
- [[Dataset Sample Required Reminder]]
- [[Distinct Owner Approval Notifications]]

## Risks
- [[Notification Deduplication Relies On Application Checks]]
- [[Approval Email Latency Follows Access-Request Timer Cadence]]

## Related PRs
- [[PR-340 Extend Notifications]]
