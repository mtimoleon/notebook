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
  - topic/business-logic
---

# Credit Settlement Commission

## Current Rule
Commission reduces the net amount delivered to eligible recipients during settlement, but it is not added to the user's estimated run cost.

## Introduced By
- [[PR-209 Credit System Foundations]]

## Evidence
- `Documentation/Credits.md`

## Edge Cases
- Platform or base-fee allocations are not described as commission-bearing lines.
- Settlement must still stay within the amount held in escrow.
