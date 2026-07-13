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
  - topic/domain
---

# maDMP

## Overview
The streamed-dataset maDMP is the persisted machine-readable contract that combines dataset identity, stream topic, payload schema, and privacy transformation intent for agent delivery.

## Current Behavior
- maDMP exists only for streamed datasets and is stored one-to-one with the dataset.
- Initial maDMP content is generated from an AIR-style JSON template plus dataset title, description, id, stream topic, payload schema, and anonymization targets.
- Transformations are stored separately and currently validate anonymization rules at the `agent` stage.
- Regeneration can prune transformations that no longer match the saved schema.
- A dataset with schema changes and an existing maDMP must regenerate the maDMP before returning to `AgentInitializationPending`.

## Business Meaning
- maDMP is the durable stream contract between dataset preparation and agent-side consumption.
- It is also where privacy-sensitive fields are marked for anonymization before downstream use.

## Rules
- [[Schema Required Before maDMP Creation]]
- [[maDMP Required Before Agent Initialization]]

## Risks
- [[Grouped maDMP Schema Required Paths May Not Match Nested Fields]]
- [[maDMP Template Is Embedded As A Large Static Source Asset]]

## Related PRs
- [[PR-343 Streaming Agents and maDMP Workflow]]
