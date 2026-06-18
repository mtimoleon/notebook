---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-10
updated: 2026-06-18
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/technical-debt
---

# Scheduling Entry Point Validation Drift

## Found In
- [[PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review]]

## Problem
Board-oriented scheduling paths call `Campaign.CheckValidationStatus()` before `Campaign.Layout()`, but `ScheduleIndependentCampaign(...)` only checks whether `campaign.Recipe` is non-null. This creates a weaker public scheduling entry point whose validation behavior can drift from the main scheduling contract.

## Risk Level
Medium

## Fix Direction
Decide whether `ScheduleIndependentCampaign(...)` is part of the same public contract as the other scheduling methods. If yes, enforce the same validation gate. If not, rename or narrow the method so its reduced-validation semantics are explicit, then add tests that lock the intended behavior.

## Master Status
- Reviewed against master on 2026-06-18.
- Status: Still open in master
- Evidence: `ScheduleIndependentCampaign(...)` still schedules on the basis of `campaign.Recipe != null` and does not apply the same validation gate used by the main board-oriented scheduling paths.

