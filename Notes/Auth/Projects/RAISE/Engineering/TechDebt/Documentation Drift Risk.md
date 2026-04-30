---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Documentation
tags:
  - documentation/raise
  - topic/technical-debt
---

# Documentation Drift Risk

## Found In
- [[PR-209 Credit System Foundations]]

## Problem
`Documentation/Credits.md` has become a detailed source of business behavior, which creates risk if code changes later diverge from the written model.

## Risk Level
Medium

## Fix Direction
Treat the credit docs as part of the change contract and require updates whenever pricing, settlement, or access rules change.
