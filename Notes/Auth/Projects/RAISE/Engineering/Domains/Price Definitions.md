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

# Price Definitions

## Overview
Price definitions describe how a dataset, script, or other billable resource should be charged or accessed at a given point in time.

## Current Behavior
- The latest price definition is authoritative for runtime pricing decisions.
- Supported models include `Free`, `UsageBased`, `PermanentAccess`, and `Lease`.
- Lease pricing requires time-bounded access semantics.
- Repricing from free to paid requires cleanup of stale free access artifacts.

## Rules
- [[Experiment Cost Estimation]]
- [[Price Drift Escrow Cap]]
- [[Free To Paid Access Cleanup]]
- [[Public Usage-Based Access Persistence]]

## Risks
- [[Documentation Drift Risk]]

## Related PRs
- [[PR-209 Credit System Foundations]]
- [[PR-214 Usage-Based Access Request Persistence]]
