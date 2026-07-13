---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-22
updated: 2026-06-22
product: RAISE
component: Streaming
tags:
  - documentation/raise
  - topic/technical-debt
---

# Streaming Agent Authentication Scales Linearly With Agent Count

## Found In
- [[PR-343 Streaming Agents and maDMP Workflow]]

## Problem
`AgentAuthenticationHandler` loads every enabled agent and performs bcrypt verification until one hash matches the presented API key, so each authenticated request gets slower as agent count grows.

## Risk Level
High

## Fix Direction
Introduce a stable key identifier or lookup prefix so authentication can fetch one candidate row before bcrypt verification, or move credentials into a shape that supports indexed lookup plus single-row verification.
