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

# Grouped maDMP Schema Required Paths May Not Match Nested Fields

## Found In
- [[PR-343 Streaming Agents and maDMP Workflow]]

## Problem
`MaDmpSchemaCompiler.BuildPayloadSchema` adds raw field names to the root `required` list even when a field is emitted under nested group objects, which can produce a JSON schema whose required paths do not match the generated nested structure.

## Risk Level
High

## Fix Direction
Generate `required` arrays at the same nesting level as the emitted properties, or simplify the payload schema shape so required paths and object layout use a single consistent strategy.
