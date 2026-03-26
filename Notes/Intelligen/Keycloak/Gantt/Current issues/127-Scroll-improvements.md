---
categories:
  - "[[Work]]"
created: 2026-02-11
product: Gantt
component:
status: open
tags:
  - issues/intelligen
---

## Requirements

### 1) `scrollToDateTime` (one-shot scroll)

- Το `scrollToDateTime` είναι prop “one-shot scroll” που δέχεται `Date | date string | number (ms) | null`.
- Ενεργοποιείται **μόνο όταν αλλάξει** η τιμή (σύγκριση με `getTime()`).
- Αν η τιμή δεν μετατρέπεται σε valid `Date`, αγνοείται (δεν κάνει scroll).
- Το requested time γίνεται **clamp** στα όρια του chart (`minimumChartDate` → `maximumChartDate`) πριν βγει το target `scrollLeft`.
- Ο στόχος είναι **κεντράρισμα όταν είναι δυνατό**, αλλιώς pin στο κοντινότερο edge (`0` ή `maxScrollLeft`).
- Το τελικό `scrollLeft` είναι πάντα clamp στο range του scrollbar (`0..maxScrollLeft`) με βάση `gridWidthPx` και `viewportWidthPx`.
- Λαμβάνει υπόψη το `effectiveScrollLeft`: αν είναι ήδη στο target, κάνει no-op.
- Κάνει programmatic scroll και ενημερώνει τον parent με `updateScrollLeft`.
- Αν `scrollWithTimeline` είναι enabled, μετά το jump γίνεται re-anchor ώστε το auto-follow να συνεχίσει από τη νέα θέση (reset carry + set previous timeline ms).

### 2) `scrollWithTimeline` (auto-follow)

- `scrollWithTimeline = true` ⇒ το chart “ακολουθεί” το `timelineTime` **μόνο όταν** `scrollLeft === null` (δηλ. δεν είναι controlled).
- Δεν κάνει re-center σε κάθε tick: όταν ενεργοποιείται, ξεκινά να ακολουθεί **από την τρέχουσα θέση viewport** (anchor) και έπειτα μετακινείται με βάση το `Δ(timelineTime)` σε pixels.
- Αν ο χρήστης κάνει manual οριζόντιο scroll ενώ είναι ενεργό, το auto-follow **συνεχίζει** από τη νέα θέση (re-anchor στο νέο `scrollLeft`).
- Edge case (δεξί όριο): όταν είναι ήδη **τέρμα δεξιά** και το timeline προχωράει δεξιά, το auto-follow **σταματά να προσπαθεί** να scrollάρει (no-op) μέχρι να υπάρξει διαθέσιμο range.

### 3) Timeline indicator visibility

-  Το timeline indicator εμφανίζεται μόνο αν:
  - `showTimeline === true`, και
  - `timelineTime` είναι **εντός** του chart range (`minimumChartDate..maximumChartDate`), και
  - η υπολογισμένη θέση είναι εντός του ορατού grid width (`timelineStart + 5 < gridWidth`).
- Αν `timelineTime` είναι εκτός range (π.χ. πριν το `chartStart`), το indicator είναι `display: none`.

---

Relative documentation [[Scrolling flow]]
