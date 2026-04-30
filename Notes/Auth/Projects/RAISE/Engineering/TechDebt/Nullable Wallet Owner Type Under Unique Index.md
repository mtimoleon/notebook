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
  - topic/technical-debt
---

# Nullable Wallet Owner Type Under Unique Index

## Found In
- [[PR-209 Credit System Foundations]]

## Problem
The wallet uniqueness invariant depends on `(OwnerType, OwnerId)`, but a nullable `OwnerType` weakens the database-level guarantee on MySQL.

## Risk Level
Medium

## Fix Direction
Tighten the persistence contract so wallet owner type cannot be null, or add stronger application validation before insert.
