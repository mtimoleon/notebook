---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-03
updated: 2026-06-18
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/technical-debt
---

# Auxiliary Equipment DTO Required-Count Gaps

## Found In
- [[PR-feature-568-implement-multiple-aux-equip-assignment Multiple Auxiliary Equipment Assignment]]

## Problem
Some DTO and mapping paths still carry boolean-era assumptions, so required-count auxiliary-equipment metadata is not returned consistently to all consumers.

## Risk Level
Medium

## Fix Direction
Normalize AutoMapper, gRPC, and API DTOs around required-count fields and add contract tests for board, panel, and EOC payloads.

## Master Status
- Reviewed against master on 2026-06-18.
- Status: Likely resolved in master
- Evidence: Required-count auxiliary-equipment fields are present in current API/UI/test paths, but this review did not re-run every downstream consumer end-to-end.

