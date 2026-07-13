---
categories:
  - "[[Work]]"
created: 2026-06-09
product: scpCloud
component:
status: open
tags:
  - issues/intelligen
---
## Context

Replace Campaign IsScheduled with HasScheduledBatches

## Notes

- [x] CampaignDto, CampaignTableDto they both have no of batches and schedule status.
- [x] Campaign.UpdateNoOfBatches finish the update.
- [x] Campaign.UpdateAmount finish the update, consider allowing no of batches change.
- [x] Campaign filters rule column Scheduled 
- [x] Schedulingboard filters rule column Scheduled 
- [x] Για το IsScheduled που βγαίνει από το ChartService, το πιο καθαρό FE usage που βρήκα είναι στο Planning SPA, στο EOC:
	- PlanningEocChart.jsx	    ​
	    Χρησιμοποιεί campaign.isScheduled για filtering / visibility logic.
	- TrackingEocChart.jsx
	    Φιλτράρει campaigns και batches με isScheduled.	
- [x] Το ίδιο IsScheduled mismatch πιθανότατα επηρεάζει και export/workspace DTOs που ακόμη έχουν bool IsScheduled.
       Να γίνει replace με τα 2 NoOfBatches και NoOfScheduledBatches

- [x] RecreateBatches
	should contain the scale factor update, but still remain in UpdateAmount
	![[582-Scheduled-Campaign-Batches-update-1782290246375.png|940x423]]
	batch ScaleFactor move it to Campaign, opote μετά δεν έχει νόημα το παραπάνω loop , μπορεί να φύγει.
	Αρα όπου έχω Batch.ScaleFactor να γίνει replace with batch.Campaign.GetScaleFactor() γιατί κανει κι άλλα πράγματα.

- [x] Update UI
	![[582-Scheduled-Campaign-Batches-update-1782290876278.png|374]]![[582-Scheduled-Campaign-Batches-update-1782290896104.png|376]]
- [ ] Change order
![[582-Scheduled-Campaign-Batches-update-1782740856747.png|623x426]]

- [ ] Add schedule menu
