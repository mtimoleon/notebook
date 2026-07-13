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

# Required Additional Consent Before Acceptance

## Current Rule
Overall consent acceptance is allowed only when every template additional field marked `required=true` is submitted with `accept=true`.

## Introduced By
- [[PR-feature-EC-122_Add_Optional_and_Required_additional_fields Additional Fields and Consent Validation]]

## Evidence
- `src/shared/models/additionalField.entity.ts`
- `src/consents/consents.service.ts` (`submitConsent`)
- `src/consents/dto/consent-submit.dto.ts`
- `src/views/consent-preview.hbs`

## Edge Cases
- Required fields block only the `accept=true` path.
- A full rejection (`accept=false`) is still allowed even when required fields are unchecked.
- If there are no required fields, the rule has no gating effect.
