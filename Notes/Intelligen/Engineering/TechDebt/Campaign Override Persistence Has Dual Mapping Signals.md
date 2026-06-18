---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-18
updated: 2026-06-18
product: scpCloud
component: Planning
tags:
  - documentation/Intelligen
  - topic/technical-debt
---

# Campaign Override Persistence Has Dual Mapping Signals

## Found In
- [[PR-task-584-Improve-batch-scheduling Campaign-Level Batch Scheduling]]

## Problem
Το model και το migration εισάγουν campaign-related recipe attribute persistence και μέσω του join table `Campaign_RecipeAttributeValues` και μέσω του nullable `RecipeAttributeValues.CampaignId`. Αυτή η διπλή αναπαράσταση δυσκολεύει να καταλάβεις ποιο path είναι authoritative για campaign overrides και αυξάνει την πολυπλοκότητα του EF mapping, του import/export και της μελλοντικής συντήρησης.

## Risk Level
Medium

## Fix Direction
Διάλεξε ένα ξεκάθαρο ownership model για campaign override values. Αν τα overrides είναι join-owned selection state, αφαίρεσε το direct nullable campaign foreign key. Αν είναι direct campaign-owned values, αφαίρεσε το parallel join abstraction. Κλείδωσε το τελικό contract με migration tests και import/export coverage.
