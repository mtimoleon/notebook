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

# Consent Audit Payload

## Current Rule
When a consent is stored, each submitted additional field is persisted together with the template-derived `required` flag that was in effect at signing time.

## Introduced By
- [[PR-feature-EC-122_Add_Optional_and_Required_additional_fields Additional Fields and Consent Validation]]

## Evidence
- `src/consents/consents.service.ts` (`submitConsent`)
- `src/consents/schemas/consent.schema.ts`
- `src/shared/models/additionalField.entity.ts`

## Edge Cases
- Submitted additional field ids not found in the template are still persisted.
- Such unknown fields currently end up with `required: false` in stored data.
