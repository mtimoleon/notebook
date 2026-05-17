---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Pricing
tags:
  - documentation/raise
  - topic/domain
---

# Usage-Based Pricing

## Overview
Usage-based pricing charges per experiment run unless the cost is waived by ownership or an active access grant.

## Current Behavior
- Public usage-based access can be auto-approved and persisted as an access-request row.
- Existing approved rows are reused instead of creating duplicates for the same requester/resource.
- Usage-based price definitions can coexist with grant-based waivers from permanent or leased access.

## Rules
- [[Experiment Cost Estimation]]
- [[Public Usage-Based Access Persistence]]
- [[Access Request Cancellation Semantics]]

## Risks
- [[Auto-Approved Request Notifications]]
- [[Soft-Cancel Model Bypassed By Services]]

## Related PRs
- [[PR-209 Credit System Foundations]]
- [[PR-214 Usage-Based Access Request Persistence]]
