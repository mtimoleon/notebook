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

- [ ] IsScheduled -> HasScheduledBatches, will replace export and production member
- [ ] CampaignDto, CampaignTableDto they both have no of batches and schedule status.
- [ ] Campaign.UpdateNoOfBatches finish the update.
- [ ] Campaign.UpdateAmount finish the update, consider allowing no of batches change.
- [ ] Campaign filters rule column Scheduled 
- [ ] Schedulingboard filters rule column Scheduled 

- [ ] Για το IsScheduled που βγαίνει από το ChartService, το πιο καθαρό FE usage που βρήκα είναι στο Planning SPA, στο EOC:
	- PlanningEocChart.jsx
	    ​
	    Χρησιμοποιεί campaign.isScheduled για filtering / visibility logic.
	    ​
	    Ενδεικτικά: γραμμές 131, 140, 145, 2293, 2509, 2516, 2523, 2530.
	- TrackingEocChart.jsx
	    ​
	    Φιλτράρει campaigns και batches με isScheduled.
	    ​
	    Ενδεικτικά: γραμμές 1374, 1377.
	Άρα ναι, το IsScheduled των chart payloads χρησιμοποιείται στο FE, κυρίως στο EOC/Tracking EOC flow.
	Σημαντική διάκριση:
	- Στο Gantt δεν βρήκα FE code που να διαβάζει campaign.isScheduled directly.
	- Εκεί το impact είναι έμμεσο: ο backend στο ChartService κάνει skip όλο το campaign αν !campaign.IsScheduled, άρα το FE απλώς δεν θα το λάβει καθόλου.
	Επίσης υπάρχει και άλλο FE usage του isScheduled, αλλά όχι από ChartService:
	- SchedulingBoard.jsx
	- campaign tabs όπως CampaignAmountGroup.jsx, CampaignIdentificationGroup.jsx, CampaignTimingSequencingGroup.jsx
	Αυτά όμως τραβάνε isScheduled από campaign DTOs / table DTOs, όχι από τα chart DTOs.
- [ ] Το ίδιο IsScheduled mismatch πιθανότατα επηρεάζει και export/workspace DTOs που ακόμη έχουν bool IsScheduled.
- [ ] Το PartiallyScheduled enum υπάρχει, αλλά σήμερα το NoOfScheduledBatches ενημερώνεται μόνο σε 0 ή NoOfBatches, οπότε το partial state φαίνεται latent feature. Αν σκοπεύετε να το χρησιμοποιήσετε, το πρώτο finding γίνεται άμεσο runtime bug.
- [ ] Πιαθανόν ο Αutomapper θέλει map για το CampainScheduleStatus

## Links
