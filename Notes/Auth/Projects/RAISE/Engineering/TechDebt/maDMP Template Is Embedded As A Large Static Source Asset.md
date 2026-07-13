---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-22
updated: 2026-06-22
product: RAISE
component: Metadata
tags:
  - documentation/raise
  - topic/technical-debt
---

# maDMP Template Is Embedded As A Large Static Source Asset

## Found In
- [[PR-343 Streaming Agents and maDMP Workflow]]

## Problem
The AIR JSON template for maDMP generation lives as a large compiled source artifact in `StreamingAgentMaDmpDefaults.cs`, which makes review, targeted updates, and template versioning harder than they need to be.

## Risk Level
Medium

## Fix Direction
Move the template into a versioned resource or external JSON asset with validation tests so template updates can be reviewed and evolved independently from unrelated code changes.
