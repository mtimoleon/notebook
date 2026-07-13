---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-18
updated: 2026-06-18
product: e-Consent
component: Studies
tags:
  - documentation/e-consent
  - topic/technical-debt
---

# Legacy Study SubjectIds Backfill

## Found In
- [[PR-feature-EC-122_Add_Optional_and_Required_additional_fields Additional Fields and Consent Validation]]

## Problem
The stricter trigger eligibility rule now depends on `study.subjectIds` being populated. Older studies with empty or missing membership lists will reject consent trigger requests even when the intended subject records exist elsewhere.

## Risk Level
Medium

## Fix Direction
Audit older study documents for missing enrollment lists, backfill `subjectIds` where ownership is known, and add migration or repair tooling before broad rollout.
