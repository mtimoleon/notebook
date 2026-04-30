---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Experiments
tags:
  - documentation/raise
  - topic/domain
---

# Experiment Result Approvals

## Overview
Experiment result approvals allow dataset owners to control access to private experiment results when their datasets require result approval.

## Current Behavior
- Every approval-required dataset in an experiment must approve before the private result becomes accessible.
- The gate applies uniformly to experiment owners, dataset owners, and project members.
- Public results still bypass the approval gate.

## Rules
- [[All Required Dataset Approvals Must Pass]]
- [[HasResultAccess Contract]]

## Risks
- [[Authorization Check Ordering In Receive-Results]]
- [[Approval Policy Test Gaps]]
- [[Duplicated Approval Logic]]

## Related PRs
- [[PR-216 Experiment Result Approval Gate]]
