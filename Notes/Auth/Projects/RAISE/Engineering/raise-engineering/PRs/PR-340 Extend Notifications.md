---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-22
source: PR Analysis
pr: 340
task: RAI-340 Extend Notifications
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-340 Extend Notifications

## Summary
- The notification domain now includes five new `NotificationMessage` values for access-request approvals, dataset sample reminders, and experiment-result approval milestones.
- Dataset and script access approvals now notify the requester only on successful grant.
- Experiment runs can now succeed before results become available, with owner-approval notifications and a later runner unlock notification when the last approval arrives.
- Dataset uploads without an available sample now produce a reminder notification for the dataset owner.

## Domain Impact
- [[Notification Taxonomy]]
- [[Dataset Access Requests]]
- [[Script Access Requests]]
- [[Dataset Sample Upload Reminders]]
- [[Experiment Result Approvals]]
- [[Experiment Result Access Control]]

## Business Logic Impact
- Approving a dataset or script access request creates a requester-facing approval notification and email.
- Dataset upload completion in `Uploaded` or `StreamingInProgress` now checks sample availability and reminds the owner when the sample is still missing.
- Registration completion creates at most one `ExperimentResultApprovalRequired` notification per distinct dataset owner with pending approvals.
- Self-owned approval-required datasets auto-approve at approval-row creation time.
- The experiment runner receives `ExperimentResultApprovalsGranted` only when the last outstanding approval becomes `true`.

## Risks
- [[Notification Deduplication Relies On Application Checks]]
- [[Result Auto-Approval Depends On Hydrated Navigation Properties]]
- [[Approval Email Latency Follows Access-Request Timer Cadence]]

## Follow-up
- Add a database-backed uniqueness guard for notification deduplication paths.
- Move self-approval detection onto stable scalar identifiers or an explicit policy input.
- Validate product UX for the two-step runner success and unlock notification sequence.
- Confirm that access-request timer cadence is acceptable for approval emails.

## Diagrams
- [[Experiment Result Approvals]]
- [[Experiment Result Access Control]]

## Tech Debt
- [[Notification Deduplication Relies On Application Checks]]
- [[Result Auto-Approval Depends On Hydrated Navigation Properties]]
- [[Approval Email Latency Follows Access-Request Timer Cadence]]

## Raw Analysis
- `C:\Users\michael\developer\raise-services\.local\PR-feature-RAI-340_Extend_Notifications Engineering Analysis.md`
