---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-18
updated: 2026-06-18
product: e-Consent
component: Consents
tags:
  - documentation/e-consent
  - topic/business-logic
---

# Consent Trigger Eligibility

## Current Rule
A subject may be targeted by a consent trigger only if that subject id is already present in the target study's `subjectIds` list.

## Introduced By
- [[PR-feature-EC-122_Add_Optional_and_Required_additional_fields Additional Fields and Consent Validation]]

## Evidence
- `src/consents/consents.controller.ts` (`trigger`)
- `src/projects/schemas/study.entity.ts`
- `src/consents/consents.controller.spec.ts`

## Edge Cases
- If even one requested subject id is missing from `study.subjectIds`, the request fails as a whole.
- A strict subset of enrolled subjects is valid.
- Empty or undefined `study.subjectIds` makes all trigger requests invalid.
