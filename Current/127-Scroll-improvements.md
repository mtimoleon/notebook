---
categories:
  - "[[Work]]"
  - "[[Issues]]"
product:
  - Gantt
component:
ticket:
status: current
created: 2026-02-11
tags:
  - intelligen
  - gantt
---
#### Requirements  
##### - scroll with timeline
- `scrollWithTimeline` = true ⇒ το chart “ακολουθεί” το timelineTime κάνοντας auto-scroll **μόνο όταν** το scrollLeft είναι null (δηλ. δεν είναι controlled).
- Δεν κάνει re-center κάθε tick: όταν ενεργοποιείται, ξεκινά να ακολουθεί **από το τρέχον viewport** (anchor) και μετά μετακινείται με βάση το Δ(timelineTime) σε pixels.
- Αν ο χρήστης κάνει manual οριζόντιο scroll ενώ είναι ενεργό, το auto-follow **συνεχίζει** από τη νέα θέση (δηλ. τοποθετεί το anchor στο νέο scrollLeft).
- Αν γίνει scrollToDateTime (π.χ. με timelineTime) και το time είναι μέσα στα min/max (clamped), κάνει jump/center εκεί και μετά, αν scrollWithTimeline είναι true, συνεχίζει να ακολουθεί κανονικά.

#### Flow
- `EocApp` δίνει στο `Gantt`:
  - `scrollLeft` (controlled, αν όχι `null`)
  - `scrollWithTimeline` (auto-follow mode)
  - `scrollToTimeline` (one-time trigger nonce/counter)
  - `timelineTime`
- Στο `Gantt`, ο κανόνας προτεραιότητας είναι:
  - `scrollLeft !== null` -> αυτό κερδίζει πάντα
  - αλλιώς timeline-based logic
  - αν δεν υπάρχει `timelineTime` -> πάει `0`

**Core Scroll Engine**
- `applyHorizontalScroll(target, notifyParent=true)`:
  - κάνει clamp σε valid range
  - αν αλλάζει η θέση, σηκώνει `suppressNextHorizontalScrollEventRef=true`
  - γράφει `scrollLeft` σε contents/header
  - ενημερώνει `effectiveScrollLeftRef`
  - κάνει `updateScrollLeft` μόνο αν όντως άλλαξε και επιτρέπεται notify (`isScrollChanged`)

**1) Initial/Resize Positioning**
- Στο sizing pass (`sizeAndPositionBarChartHeaderAndContents`):
  - first render:
    - αν `scrollLeft` υπάρχει -> αυτό
    - αλλιώς αν υπάρχει `timelineTime` -> center/clamp στο timeline
    - αλλιώς `0`
  - επόμενα renders (resize): κρατάει οπτικό κέντρο χρόνου σταθερό
  - εφαρμόζει με `applyHorizontalScroll(...)`

**2) Controlled `scrollLeft` Path**
- Effect σε `props.scrollLeft`:
  - αν `scrollLeft !== null`, εφαρμόζεται άμεσα (χωρίς parent notify)
  - timeline auto logic παρακάμπτεται

**3) One-time Scroll (`scrollToTimeline`)**
- Effect σε `props.scrollToTimeline`:
  - συγκρίνει με προηγούμενη τιμή (`previousScrollToTimelineRef`)
  - αν άλλαξε και `scrollLeft === null`:
    - υπολογίζει center/clamp από `timelineTime`
    - κάνει one-shot scroll

**4) Auto Follow (`scrollWithTimeline`)**
- Effect σε `timelineTimeMs`, `scrollWithTimeline`, `scrollLeft`:
  - αν `scrollLeft !== null` -> stop auto path
  - αν `timelineTime === null` -> scroll `0`
  - αν auto mode on:
    - στο πρώτο tick απλά “δένει” anchor (δεν recenters)
    - μετά υπολογίζει `deltaTimelineMs`
    - μετατρέπει σε `delta px` με `secondsPerPixel`
    - χρησιμοποιεί carry accumulator (`autoScrollDeltaCarryPxRef`) για sub-pixel κινήσεις
    - εφαρμόζει το ακέραιο delta με `applyHorizontalScroll`

**5) Manual Scroll While Auto On**
- `handleScrollingInBarChart`:
  - συγχρονίζει header/top scroll
  - αν το scroll event είναι programmatic (λόγω internal set), καταναλώνει το suppress flag και δεν το αντιμετωπίζει σαν user event
  - αν είναι user scroll και auto-follow ενεργό:
    - ξαναδένει anchor σε current `timelineTime`
    - μηδενίζει carry
    - άρα το auto συνεχίζει από τη νέα χειροκίνητη θέση
  - για user scroll ενημερώνει parent με `updateScrollLeft`

**6) Refresh Persistence**
- `EocApp` σώζει/φορτώνει `scrollLeft` και `scrollWithTimeline`.
- Σε refresh με `scrollWithTimeline=true` + saved `scrollLeft`:
  - πρώτα κάνει paint εκεί
  - μετά `EocApp` βάζει `scrollLeft=null`
  - άρα auto-follow συνεχίζει από restored θέση, όχι από center.

