---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-10
updated: 2026-06-10
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/technical-debt
---

# Equipment Incompatibility Is Not Enforced

## Found In
- [[PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review]]

## Problem
`EquipmentRecipeAttributeValue` stores `IsIncompatible` per recipe attribute value, but the scheduling duration path still calls `Equipment.GetEquipmentProcessingRate(...)` and uses the returned rate without checking that flag. As a result, an equipment/value pair can be explicitly marked incompatible and still remain schedulable.

## Risk Level
High

## Fix Direction
Enforce incompatibility in a scheduling-critical path. The safest options are to filter incompatible equipment out of compatibility/default-assignment selection or to fail fast when a rate is requested for an incompatible value. Add regression coverage that proves an incompatible equipment/value pair cannot be scheduled.
