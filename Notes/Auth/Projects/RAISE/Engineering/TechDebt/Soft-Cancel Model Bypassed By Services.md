---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Access
tags:
  - documentation/raise
  - topic/technical-debt
---

# Soft-Cancel Model Bypassed By Services

## Found In
- [[PR-214 Usage-Based Access Request Persistence]]

## Problem
The domain access-request aggregates still expose cancellation metadata and `CancelRequest(...)`, but the service layer now deletes rows instead of using that model.

## Risk Level
Medium

## Fix Direction
Choose one durable cancellation strategy and align the domain model, service layer, and reporting assumptions around it.
