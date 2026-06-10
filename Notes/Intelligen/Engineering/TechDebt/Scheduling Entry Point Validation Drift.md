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

# Scheduling Entry Point Validation Drift

## Found In
- [[PR-feature-578-Adaptive-recipes-pt.4 Adaptive Recipes Part 4 Review]]

## Problem
Board-oriented scheduling paths call `Campaign.CheckValidationStatus()` before `Campaign.Layout()`, but `ScheduleIndependentCampaign(...)` only checks whether `campaign.Recipe` is non-null. This creates a weaker public scheduling entry point whose validation behavior can drift from the main scheduling contract.

## Risk Level
Medium

## Fix Direction
Decide whether `ScheduleIndependentCampaign(...)` is part of the same public contract as the other scheduling methods. If yes, enforce the same validation gate. If not, rename or narrow the method so its reduced-validation semantics are explicit, then add tests that lock the intended behavior.
