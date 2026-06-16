---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-11
source: PR Analysis
pr:
task: AC-19 hide/delete project with soft delete semantics
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project

## Summary
- Project deletion is implemented as soft delete through `Project.IsSoftDeleted`.
- `APIContext` enforces the hidden state through global query filters on `Project`, `Bid`, `ProjectVisit`, `ProjectInvoice`, and `ProjectUpload`.
- The delete path allows both the project owner and an admin, and the controller exposure matches that rule.
- Bid-rooted permission flows inherit the hidden state automatically because deleted-project bids are filtered out by default.

## Domain Impact
- [[Project Soft Delete Lifecycle]]
- [[Project Visibility Rules]]
- [[Project Deletion Permissions]]

## Business Logic Impact
- `DeleteProjectAsync` authorizes the operation for the project owner or an admin.
- Deleting a project calls `project.UpdateSoftDeleted(true)` and persists the row instead of removing it.
- Standard reads for projects, bids, visits, invoices, and uploads stop returning deleted-project data through EF query filters.
- Message and review permission checks lose access to deleted-project bids because `_context.Bids` inherits the project visibility filter.

## Risks
- Soft-delete visibility depends on EF query filters and can be bypassed intentionally with `IgnoreQueryFilters`, raw SQL, or new project-linked entities that do not get a matching filter.
- The current branch does not expose a visible restore or undelete flow.
- Historical relations remain persisted, which is useful for audit scenarios but requires care in reporting and back-office reads that bypass default filters.

## Follow-up
- Decide whether soft delete is terminal or whether a recover workflow is required.
- Audit any `IgnoreQueryFilters`, raw SQL, or back-office/reporting paths that intentionally bypass default reads.
- Add regression coverage that proves deleted-project visibility is consistently inherited across bid-rooted permission checks.

## Diagrams
- [[Project Soft Delete Lifecycle]]

## Tech Debt
- [[Soft-Delete Visibility Depends on EF Query Filters and Can Be Bypassed]]
- [[No Visible Restore or Undelete Flow for Soft-Deleted Projects]]

## Raw Analysis
- `C:\Users\michael\developer\accelup\accelup-backend\.local\PR-feature-AC-19_Add_hide_or_delete_project Engineering Analysis.md`
