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
  - topic/business-logic
---

# Streaming Agent Dataset Link Eligibility

## Current Rule
Only an agent owner or administrator can manage agent dataset links, and the linked dataset must be a streamed dataset owned by the agent owner and currently in `AgentInitializationPending`.

## Introduced By
- [[PR-343 Streaming Agents and maDMP Workflow]]

## Evidence
- `Raise.APIGateway/Services/AgentService.cs`
- `RaiseServices.Domain/Aggregates/StreamingAgent/StreamingAgent.cs`
- `Raise.FunctionalTests/AgentTests.cs`

## Edge Cases
- Linking the same dataset twice is rejected.
- A regular dataset is rejected even when ownership matches.
- `AllowedToStream` can toggle after linking without removing the dataset-agent association.
- A stranger user cannot manage the link even when the dataset belongs to the same researcher organization.
