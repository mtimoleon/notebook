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
  - topic/technical-debt
---

# Functional Test Service Provider Construction

## Found In
- [[PR-213 Hosted Service Shutdown Hardening]]

## Problem
The functional test factory constructs service-provider state inside test-host configuration, which increases the chance of duplicated or confusing service lifetimes.

## Risk Level
Low

## Fix Direction
Reduce custom provider construction and make test service ownership more explicit around one host/service graph.
