---
type: rule-note
tags:
  - rule/campaign
  - domain/bom
---
# Campaign BOM Recipe Match

## Current Rule
A campaign can use a selected BOM only when the BOM belongs to the same recipe as the campaign.

## Introduced By
- [[PR-696 Implement SKU in material]]

## Evidence
- `Campaign.UpdateBom(...)`
- `CampaignError.BomRecipeMustMatchCampaignRecipe`

## Edge Cases
- Campaign recipe changes after BOM selection.
- BOM association changes while campaign is already scheduled.
