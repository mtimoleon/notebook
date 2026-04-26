---
type: rule-note
tags:
  - rule/changeover
  - domain/scheduling
---
# Changeover Matrix Duration

## Current Rule
An operation with duration mode `BasedOnChangeoverMatrix` derives its duration from the transition between recipe attribute values around the operation's equipment state.

The relevant transition may be previous-to-current or current-to-next depending on scheduling direction.

## Introduced By
- [[PR-696 Implement SKU in material]]

## Evidence
- `OperationDurationMode.BasedOnChangeoverMatrix`
- `Operation.DurationChangeoverMatrix`
- `OperationEntry.DurationChangeoverMatrix`
- `Campaign.GetCampaignAttributeValueForEquipment(...)`

## Edge Cases
- No previous/next equipment state exists.
- Matrix does not contain a matching value.
- Symmetrical matrix fallback applies.
- Equipment is considered idle due to idle threshold.
