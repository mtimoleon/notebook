---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-03
updated: 2026-06-03
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
