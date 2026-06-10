---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-03
source: PR Analysis
pr: feature/568-implement-multiple-aux-equip-assignment
task: Implement multiple auxiliary equipment assignment with required-count semantics and conflict resolution updates
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-feature-568-implement-multiple-aux-equip-assignment Multiple Auxiliary Equipment Assignment

## Summary
- Replaces the legacy `UseAllCompatibleAuxEquipment` flag with required-count semantics for auxiliary equipment selection.
- Propagates auxiliary selection mode and required-count metadata through operation configuration, operation entries, scheduling, and board/EOC contracts.
- Extends campaign scheduling so one operation entry can hold multiple auxiliary equipment assignments under `All` or `SpecificNumber` selection modes.
- Updates conflict resolution so auxiliary overuse and main/aux incompatibility can replace only the conflicting auxiliary resource instead of resetting the full selection.
- Leaves follow-up work around compatibility-aware validation, DTO completeness, and the still single-selection-shaped move contract.

## Domain Impact
- [[Auxiliary Equipment Assignment]]
- [[Scheduling Conflict Resolution]]

## Business Logic Impact
- [[Required Auxiliary Equipment Count Must Remain Satisfiable]]
- [[Auxiliary Equipment Move Must Identify Source and Destination]]

## Risks
- Validation still checks the total auxiliary pool instead of the main-compatible subset that actually has to satisfy the requested count.
- Round-robin assignment can recycle the same compatible auxiliary equipment when the requested count exceeds the compatible subset.
- Some DTO and mapping paths still omit full required-count metadata.
- Auxiliary-equipment move requests still carry a single destination identifier even when multiple auxiliary selections exist.

## Follow-up
- Add validation and regression coverage for `SpecificNumber` requests that become unsatisfied after main-equipment compatibility filtering.
- Normalize board, panel, and EOC DTOs so required-count metadata is returned consistently.
- Align auxiliary-equipment move requests with the source-and-destination semantics already expected by multi-resource interactions.
- Keep focused scheduling tests around auxiliary replacement during conflict resolution.

## Diagrams
- [[Auxiliary Equipment Assignment]]
- [[Scheduling Conflict Resolution]]

## Tech Debt
- [[Auxiliary Equipment DTO Required-Count Gaps]]
- [[Auxiliary Equipment Move Contract Is Single-Selection Shaped]]

## Raw Analysis
- `.local/PR-feature-568-implement-multiple-aux-equip-assignment Engineering Analysis.md`
