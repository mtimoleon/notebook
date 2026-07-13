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
  - topic/domain
---

# Streaming Agent

## Overview
A Streaming Agent is a machine-facing identity owned by a user and used to consume streamed dataset metadata and delivery configuration without reusing a human JWT session.

## Current Behavior
- Agents are created per user with a generated API key and a persisted bcrypt `SecretHash`.
- Agent requests authenticate through a dedicated bearer scheme and expose the owning agent through `GET /agent/self`.
- Owners and administrators can inspect agents, regenerate keys, link datasets, and toggle `AllowedToStream` on existing links.
- Each link stores whether streaming is currently allowed for that dataset-agent pair.
- Linking a dataset to an agent transitions the dataset into active streaming state.

## Business Meaning
- The model separates machine access from human portal access.
- It makes the stream consumer contract explicit at the agent boundary, including topic name, maDMP, and per-dataset allow/deny control.

## Rules
- [[Streaming Agent Dataset Link Eligibility]]
- [[maDMP Required Before Agent Initialization]]

## Risks
- [[Streaming Agent Authentication Scales Linearly With Agent Count]]

## Related PRs
- [[PR-343 Streaming Agents and maDMP Workflow]]
