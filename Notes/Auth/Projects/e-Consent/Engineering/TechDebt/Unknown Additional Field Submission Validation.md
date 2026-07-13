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
  - topic/technical-debt
---

# Unknown Additional Field Submission Validation

## Found In
- [[PR-feature-EC-122_Add_Optional_and_Required_additional_fields Additional Fields and Consent Validation]]

## Problem
The submit flow validates missing required fields, but it does not reject additional field ids that are absent from the template. Unknown entries are preserved and stored with `required: false`.

## Risk Level
Medium

## Fix Direction
Validate submitted additional field ids against the template definition before persistence and reject payloads containing unknown ids.
