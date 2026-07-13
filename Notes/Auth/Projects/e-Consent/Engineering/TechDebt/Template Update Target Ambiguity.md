---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-18
updated: 2026-06-18
product: e-Consent
component: Templates
tags:
  - documentation/e-consent
  - topic/technical-debt
---

# Template Update Target Ambiguity

## Found In
- [[PR-feature-EC-122_Add_Optional_and_Required_additional_fields Additional Fields and Consent Validation]]

## Problem
The template replacement route exposes a path `id`, but the update flow still resolves the effective template through `studyId` in the request body. The URL identifier is therefore not the authoritative update target.

## Risk Level
Medium

## Fix Direction
Align the controller contract so the authoritative template target is derived from one source only, ideally the path identifier, and reject mismatched body/path combinations.
