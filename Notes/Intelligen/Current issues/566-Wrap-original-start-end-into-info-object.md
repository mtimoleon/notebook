---
categories:
  - "[[Work]]"
created: 2026-05-08
product: scpCloud
component:
status: open
tags:
  - issues/intelligen
---
## Context
 - Original start upgrade [video](file:///D:/develop-tasks/566-Wrap-original-start-end-into-info-object/Original-start-end-Recording%202026-04-21%20125124.mp4)
 - Other requirement [video](file:///D:/develop-tasks/566-Wrap-original-start-end-into-info-object/Recording%202026-05-08%20115458-566-Wrap-original-information.mp4)

## Notes

Sample code:
![[566-Wrap-original-start-end-into-info-object-1778838117210.png|930x638]]
- [x] Improve eocDataType that comes to server request, now it should have 2 booleans for planning and original? or an array.
- [x] Makis to remove filter option for original from both views eoc data and operation entries.
- [x] 4 pragmata, 
      1. lookup anti resolve, ✔️
      2. tracking eoc data panta sto view, ✔️
      3. remove original start/end filter ✔️
      4. na valo kai ta planning start-end sto view ton operations ✔️
- [x] ~~Production Na zitisoyme to query na kanei join sta procedure entries/operation entries kai operation entries xyma kai pano sto apotelesma ayto na efarmozetai to filtro~~ θα εφαρμόσουμε άλλη λογική τελικά
- [x] ![[566-Wrap-original-start-end-into-info-object-1778567579027.png|930x657]]
- [x] SchedulingBoardServer line 766 check code changes for projection (there are linq expressions to get aux equipment and staff that ef cannot translate)
- [x] Na sviso kai ton legacy kodika, ![[Intelligen-Backlog-1778163654711.png|930x402]]
- [x] ![[Intelligen-Backlog-1778162478762.png|930x421]]
- [x] omadopoiisi xoriki ton tracking/original sto OperationEntry.cs 
- [x] ![[Intelligen-Backlog-1778161376769.png|930x284]]
- [x] Na mpei se oli ti diadromi Campaign, Batch, Procedure ![[Intelligen-Backlog-1778161038229.png|930x518]]
- [x] To add original start and sync start in eoc chart (none, planning, original) in production app
- [x] ​Να συμμαζέψουμε στο operation entry το original info (original start/end, original staff, original equipment) ετσι όταν γίνεται update να έχω πλήρως την αρχική πληροφορία
- [x] Στο scheduling service TimingInfoType να βάλουμε και type original και μετά να γίνει το plumping στον κώδικα.
    Also these methods need extension with original (now they have tracking)
    ![[Intelligen-Backlog-1776765003740.png|930x430]]​

## Links
