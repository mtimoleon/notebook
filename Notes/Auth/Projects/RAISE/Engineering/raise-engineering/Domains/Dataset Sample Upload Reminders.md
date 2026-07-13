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
  - topic/domain
---

# Dataset Sample Upload Reminders

## Overview
Dataset sample upload reminders ensure that dataset owners are prompted to provide a sample after the main dataset upload completes when the sample is still unavailable.

## Current Behavior
- A reminder is created when a dataset reaches `Uploaded` without a sample in `Available`.
- The same reminder also applies to the streamed upload path when the dataset reaches `StreamingInProgress`.
- No reminder is created for intermediate or unrelated statuses.
- No reminder is created when the sample is already available at the time the status changes.

## Rules
- [[Dataset Sample Required Reminder]]

## Risks
- None currently documented.

## Related PRs
- [[PR-340 Extend Notifications]]
