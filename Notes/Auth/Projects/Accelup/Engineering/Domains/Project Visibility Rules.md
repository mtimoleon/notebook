---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-11
updated: 2026-06-11
product: Accelup
component: Projects
tags:
  - documentation/accelup
  - topic/domain
---

# Project Visibility Rules

## Overview
Deleted-project visibility is primarily enforced at the EF Core model level rather than at individual query call sites.

## Current Behavior
- `APIContext` filters `Project` rows where `IsSoftDeleted` is true.
- `Bid`, `ProjectVisit`, `ProjectInvoice`, and `ProjectUpload` also inherit project visibility through their own query filters.
- Standard project detail, list, upload, and relationship reads stop returning deleted-project data without requiring ad-hoc service filters.
- Bid-rooted permission flows in message and review logic also stop seeing deleted-project bids because `_context.Bids` is already filtered.
- Historical data still exists physically and can be surfaced only by intentionally bypassing default filters.

## Business Meaning
A deleted project should disappear from normal application reads, while still preserving a durable record for controlled internal access.

## Rules
- [[Bid-Rooted Permission Flows Inherit Project Soft-Delete Visibility]]

## Risks
- [[Soft-Delete Visibility Depends on EF Query Filters and Can Be Bypassed]]
- [[No Visible Restore or Undelete Flow for Soft-Deleted Projects]]

## Related PRs
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]
