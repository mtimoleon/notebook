---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-06-22
product: RAISE
component: Dataset Access
tags:
  - documentation/raise
  - topic/domain
---

# Dataset Access Requests

## Overview
Dataset access requests track dataset-specific access attempts, approvals, pricing context, and optional escrow/grant bindings.

## Current Behavior
- A request row can now represent instant approved public usage-based access.
- Approved request rows may exist without a separate `AccessGrant` when the pricing model is pay-per-use.
- Cancelling a pending request releases escrow and deletes the row instead of soft-cancelling it.
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
