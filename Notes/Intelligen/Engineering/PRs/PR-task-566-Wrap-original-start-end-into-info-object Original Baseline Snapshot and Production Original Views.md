---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-05-19
source: PR Analysis
pr: task/566-Wrap-original-start-end-into-info-object
task: Wrap original start/end into info object and propagate original baseline through planning, production sync, filtering, and EOC views
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-task-566-Wrap-original-start-end-into-info-object Original Baseline Snapshot and Production Original Views

## Summary
- Replaces flattened original timing fields with an immutable `OriginalInformation` snapshot on `OperationEntry`.
- Promotes `TimingInfoType.Original` to a first-class read context for timing and resource lookups.
- Propagates original baseline data through procedure, batch, campaign, sync, production publish payloads, filters, and EOC views.
- Extends production projections with `BatchContentsOriginal` and `EocResourceDataOriginal` so original data can be served beside planning and tracking.
- Leaves follow-up work around migration backfill, original-only EOC outages, tracking-anchored chart merge, and the FE update modal.

## Domain Impact
- [[Original Baseline Snapshot]]
- [[Timing Info Contexts]]
- [[Production Original Scheduling Views]]
- [[Workspace Import Export]]

## Business Logic Impact
- [[First Tracking Sync Captures Immutable Original Snapshot]]
- [[TimingInfoType Original Is Read Only]]
- [[Production Original Views Are Tracking Anchored]]

## Risks
- Legacy original baseline data is dropped by the migration unless backfilled before schema removal.
- Original EOC outages still depend on tracking boundaries instead of original boundaries.
- Chart rendering still hides original-only tasks and resources when no tracking counterpart exists.
- At review time, the update modal backend exposed original resources, but the UI still rendered planning values in the original slots. This gap was later resolved on master.

## Follow-up
- Add SQL backfill for legacy `OriginalStart` and `OriginalDuration` before migration rollout.
- Expand production regression coverage for `eocDataType=original` and original-only resources.
- Rework chart merge so original rows can render without a tracking anchor.
- Completed later on master: the CommonSpa update modal now renders original auxiliary equipment and staff through the original-resource UI path.

## Diagrams
- [[Original Baseline Snapshot]]
- [[Production Original Scheduling Views]]

## Tech Debt
- [[Original Baseline Migration Backfill]]
- [[Original EOC Outages Depend on Tracking Boundaries]]
- [[Original Only Chart Rows Need Independent Merge]]
- The CommonSpa original-resource rendering gap identified during this review was later resolved on master.

## Raw Analysis
- `.local/PR-task-566-Wrap-original-start-end-into-info-object Engineering Analysis.md`
