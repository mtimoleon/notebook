---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-18
source: PR Analysis
pr: N/A
task: EC-122 Add Optional and Required additional fields
tags:
  - documentation/e-consent
  - topic/pr
  - topic/business-logic
  - topic/domain
---

# PR-feature-EC-122_Add_Optional_and_Required_additional_fields Additional Fields and Consent Validation

## Summary
- Introduced `required` semantics for template additional fields.
- Enforced required additional field acceptance before overall consent acceptance.
- Restricted consent triggering to subjects already enrolled in `study.subjectIds`.
- Added audit persistence for required-field state at submission time.
- Added API documentation and localization support around the new behavior.

## Domain Impact
- [[Consent Template Additional Fields]]
- [[Study Enrollment]]

## Business Logic Impact
- Consent acceptance now depends on all required additional fields being accepted when `accept=true`.
- Consent triggering now fails for subjects not already assigned to the study.
- Submitted additional fields are persisted with the template-derived `required` flag for auditability.

## Risks
- Legacy studies without populated `subjectIds` will reject trigger requests.
- Unknown submitted additional field ids are still persisted and default to `required: false`.
- Template replacement path resolution still depends on `studyId` in the body rather than the path `id`.

## Follow-up
- Review older studies for missing `subjectIds` before broad rollout of the stricter trigger rule.
- Add validation to reject submitted additional field ids that are not present in the template.
- Consider aligning template replacement targeting so the URL id is authoritative.

## Diagrams
- [[Consent Template Additional Fields]]
- [[Study Enrollment]]

## Tech Debt
- [[Template Update Target Ambiguity]]
- [[Unknown Additional Field Submission Validation]]

## Raw Analysis
- `C:\Users\michael\developer\e-consent-server\.local\PR-feature-EC-122_Add_Optional_and_Required_additional_fields Engineering Analysis.md`
