---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Credits
tags:
  - documentation/raise
  - topic/domain
---

# Credit Escrow Lifecycle

## Overview
Escrow is the temporary holding state for credits before they are either committed to settlement or released back to the payer.

## Current Behavior
- Experiment execution can hold credits before runtime and settle them after the final status is known.
- Owner-approved paid access can also hold funds until a request is granted or released.
- If the experiment does not end as `Registered`, the held value is released instead of committed.
- Settlement must not exceed the amount actually held in escrow.

## Rules
- [[Experiment Cost Estimation]]
- [[Credit Settlement Commission]]
- [[Escrow Release On Failed Experiment]]
- [[Price Drift Escrow Cap]]

## Risks
- [[Documentation Drift Risk]]

## Related PRs
- [[PR-209 Credit System Foundations]]
