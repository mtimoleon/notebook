---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: API Gateway
tags:
  - documentation/raise
  - topic/technical-debt
---

# Hosted Service Stop-Dispose Ordering

## Found In
- [[PR-213 Hosted Service Shutdown Hardening]]

## Problem
Several hosted services carry similar manual shutdown guards, which suggests lifecycle ordering is still fragile and duplicated across implementations.

## Risk Level
Medium

## Fix Direction
Standardize service shutdown behavior through a shared helper or by converging on a more consistent background-service pattern.
