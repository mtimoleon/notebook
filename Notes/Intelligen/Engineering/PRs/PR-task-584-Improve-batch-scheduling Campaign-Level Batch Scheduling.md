---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-18
source: PR Analysis
pr: task/584-Improve-batch-scheduling
task: Improve batch scheduling with campaign-level BOM and recipe attribute override resolution
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-task-584-Improve-batch-scheduling Campaign-Level Batch Scheduling

## Summary
- Μεταφέρει το scheduling context από batch-level state σε campaign-level state για BOM selection και recipe attribute overrides.
- Εισάγει `SchedulingType` με `RecipeBased` και `MaterialBased` campaign modes.
- Κάνει το cycle time / batch time calculation campaign-aware και BOM-aware αντί για ενιαίο recipe-only path.
- Μετακινεί το import/export shape ώστε τα scheduling overrides να serialized/deserialized στο επίπεδο campaign.
- Αφαιρεί batch-local persistence για `Bom` και recipe attribute override values.

## Domain Impact
- [[Adaptive Recipes and BOMs]]
- [[Recipe Attributes]]
- [[Scheduling Conflict Resolution]]
- [[Workspace Import Export]]

## Business Logic Impact
- [[Campaign BOM Must Match Recipe]]
- [[One Recipe Attribute Value Per Attribute]]

## Risks
- Το persistence model για campaign recipe attribute values έχει πλέον δύο campaign-related σήματα και αυξάνει τη γνωστική πολυπλοκότητα του mapping.
- Το scheduling path εξαρτάται περισσότερο από valid adaptive BOM stream mappings και από το σωστό `SchedulingType`.
- Το import/export contract αλλάζει για scheduling-board payloads που προηγουμένως περίμεναν batch-level BOM ή batch-level recipe attribute override fields.

## Follow-up
- Πρόσθεσε regression coverage για `RecipeBased` vs `MaterialBased` layout flows με invalid ή partial BOM mappings.
- Κλείδωσε με tests το precedence rule των effective recipe attribute values όταν συνυπάρχουν defaults και overrides.
- Αξιολόγησε αν το persistence model των campaign override values πρέπει να κρατήσει και join table και direct nullable campaign foreign key.

## Diagrams
- [[Adaptive Recipes and BOMs]]
- [[Recipe Attributes]]
- [[Scheduling Conflict Resolution]]

## Tech Debt
- [[Campaign Override Persistence Has Dual Mapping Signals]]

## Raw Analysis
- `.local/PR-task-584-Improve-batch-scheduling Engineering Analysis.md`
