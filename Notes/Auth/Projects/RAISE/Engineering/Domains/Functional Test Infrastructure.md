---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Functional Tests
tags:
  - documentation/raise
  - topic/domain
---

# Functional Test Infrastructure

## Overview
The functional test harness owns the web application factory, HTTP client, and scoped test services used by end-to-end API tests.

## Current Behavior
- `SutFixture` explicitly owns and disposes the factory and HTTP client.
- The test factory now disposes its `ServiceScope`.
- Credit-related test overrides are applied with `PostConfigure`.

## Rules
- None currently documented as durable business rules.

## Risks
- [[Functional Test Service Provider Construction]]

## Related PRs
- [[PR-213 Hosted Service Shutdown Hardening]]
