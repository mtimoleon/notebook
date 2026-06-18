---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-03
updated: 2026-06-18
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/technical-debt
---

# Auxiliary Equipment Move Contract Is Single-Selection Shaped

## Found In
- [[PR-feature-568-implement-multiple-aux-equip-assignment Multiple Auxiliary Equipment Assignment]]

## Problem
The EOC auxiliary-equipment move flow still uses a single destination equipment id, which becomes ambiguous once one operation entry can hold multiple auxiliary equipment assignments.

## Risk Level
High

## Fix Direction
Extend the move contract with explicit source and destination resource identifiers and align auxiliary-equipment move semantics with the multi-resource interaction model.

## Master Status
- Reviewed against master on 2026-06-18.
- Status: Still open in master
- Evidence: The move flow still uses `OldAuxEquipmentId` and `NewAuxEquipmentId`, so the contract remains single-replacement shaped rather than multi-resource explicit.

