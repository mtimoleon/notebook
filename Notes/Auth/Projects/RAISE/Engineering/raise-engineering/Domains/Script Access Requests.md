---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-06-22
product: RAISE
component: Script Access
tags:
  - documentation/raise
  - topic/domain
---

# Script Access Requests

## Overview
Script access requests track script-specific access attempts, approvals, and pricing context for public or owner-approved script flows.

## Current Behavior
- Public usage-based script access now persists an approved request row.
- Request rows can carry pricing metadata without a corresponding access grant.
- Cancellation behavior now hard-deletes pending rows after escrow release.
- Owner-approved requests now emit a requester-facing approval notification only when `AccessGranted = true`.

## Rules
- [[Public Usage-Based Access Persistence]]
- [[Access Request Cancellation Semantics]]
- [[Access Request Idempotency]]
- [[Access Request Approval Notifications]]

## Risks
- [[Soft-Cancel Model Bypassed By Services]]
- [[Auto-Approved Request Notifications]]
- [[Approval Email Latency Follows Access-Request Timer Cadence]]

## Related PRs
- [[PR-214 Usage-Based Access Request Persistence]]
- [[PR-340 Extend Notifications]]
