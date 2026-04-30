---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
source: PR Analysis
pr: 216
task: RAI-334 Fix experiment result approvals to develop
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-216 Experiment Result Approval Gate

## Summary
- Dataset-result approvals now gate private experiment results for all authorized principals, including experiment owners.
- `HasResultAccess` stays `false` until every approval-required dataset has granted approval.
- The result download endpoint now returns an approval error whenever required approvals are still incomplete.

## Domain Impact
- [[Experiment Result Approvals]]
- [[Experiment Result Access Control]]

## Business Logic Impact
- One missing required approval blocks the full private result payload.
- Experiment metadata may remain visible while result access stays disabled.
- The download endpoint now evaluates approval state before its final unauthorized-user branch.

## Risks
- [[Authorization Check Ordering In Receive-Results]]
- [[Approval Policy Test Gaps]]
- [[Duplicated Approval Logic]]

## Follow-up
- Add tests for unauthorized callers, dataset-owner callers, and public-result cases.
- Revisit error ordering in the receive-results endpoint to avoid existence leakage.
- Consider centralizing approval-access computation.

## Diagrams
- [[Experiment Result Approvals]]
- [[Experiment Result Access Control]]

## Tech Debt
- [[Authorization Check Ordering In Receive-Results]]
- [[Approval Policy Test Gaps]]
- [[Duplicated Approval Logic]]

## Raw Analysis
- `C:\Users\michael\developer\raise-services\artifacts\PR-216 Engineering Analysis.md`
