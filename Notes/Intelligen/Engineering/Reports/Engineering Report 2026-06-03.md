# Engineering Report 2026-06-03

## Scope
- documentation root: `D:\Notebooks\Notebook\Notes\Intelligen\Engineering`
- period/scope: last 30 days (`2026-05-04` to `2026-06-03`)
- source folders: `PRs/`, `Domains/`, `Rules/`, `TechDebt/`, `Index.md`

## Executive Summary
- Το τελευταίο 30ήμερο δείχνει δύο ισχυρά clusters αλλαγών: `Original baseline / original views` στις `2026-05-19` και `Adaptive recipes / changeovers / import-export` στις `2026-06-03`.
- Το πιο ασταθές σημείο του documentation set είναι η διασταύρωση `Scheduling`, `Import/Export`, και `Production projections`, όπου οι αλλαγές αγγίζουν domain behavior, projections, UI, και migration risk ταυτόχρονα.
- Υπάρχει σαφές pattern “backend supports more than the serving/UI layer fully renders”, ειδικά στα original production views και στο CommonSpa update modal.
- Η τεκμηρίωση είναι αρκετά καλή σε domain/rule coverage, αλλά έχει κενά σε tech-debt follow-up notes για το cluster των original views.

## Most Changed Domains
- `Workspace Import Export`
  - Συνδέεται και με το PR [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]] και με το PR [[PR-task-566-Wrap-original-start-end-into-info-object Original Baseline Snapshot and Production Original Views]].
  - Είναι το μόνο domain note που ενώνει δύο διαφορετικά change waves μέσα στο ίδιο 30ήμερο context: contract change για recipe attributes και object-shaped original baseline payloads.
- `Scheduling Conflict Resolution`
  - Ενημερώθηκε στις `2026-06-03` και συνδέεται με [[Dynamic Scheduling Regression Surface]] και [[Dynamic Task Change Propagation]].
  - Η περιοχή φαίνεται ευαίσθητη, γιατί οι σημειώσεις περιγράφουν validation, dynamic tasks, slot search, cache invalidation, και loop handling στο ίδιο behavior surface.
- `Original Baseline Snapshot` / `Production Original Scheduling Views` / `Timing Info Contexts`
  - Αποτελούν ενιαίο domain cluster που χτίζει το original branch ως first-class read context.
  - Το cluster είναι καθαρό conceptually, αλλά συνοδεύεται από αρκετά follow-ups γύρω από projections, EOC, και rendering.

## Recurring Tech Debt
- Projection/UI divergence
  - [[Update Modal Original Resources Not Rendered]] δείχνει ότι το backend payload υπάρχει αλλά η UI δεν το καταναλώνει σωστά.
  - Το ίδιο pattern εμφανίζεται και στο PR note [[PR-task-566-Wrap-original-start-end-into-info-object Original Baseline Snapshot and Production Original Views]], όπου τα original views υπάρχουν αλλά δεν αποδίδονται πλήρως ανεξάρτητα.
- Scheduling regression surface
  - [[Dynamic Scheduling Regression Surface]] και [[Dynamic Task Change Propagation]] δείχνουν ότι η scheduling λογική αλλάζει σε πολλά coupled σημεία ταυτόχρονα.
  - Το δεύτερο note μάλιστα καταγράφει concrete correctness defect, όχι μόνο γενικό regression risk.
- Contract drift / migration pressure
  - [[Workspace Import Export]] περιγράφει δύο ξεχωριστά contract migrations.
  - [[Recipe Classification Data Migration Risk]] κρατά το migration risk για τα recipe classifications/types, αλλά το note set εξακολουθεί να δείχνει ότι το import/export surface είναι σημείο επαναλαμβανόμενης αστάθειας.

## Risky Areas
- Planning scheduling core
  - Evidence: [[Scheduling Conflict Resolution]], [[Dynamic Scheduling Regression Surface]], [[Dynamic Task Change Propagation]]
  - Ρίσκο: correctness bugs, cache invalidation bugs, conflict loop handling, δύσκολο regression testing.
- Production original views
  - Evidence: [[Production Original Scheduling Views]], [[Production Original Views Are Tracking Anchored]], [[Update Modal Original Resources Not Rendered]]
  - Ρίσκο: partial original-data support, projection/UI mismatch, missing independent rendering for original-only rows.
- Workspace import/export
  - Evidence: [[Workspace Import Export]], [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]]
  - Ρίσκο: external contract breakage, mixed responsibilities in one note, migration ambiguity.

## Business Rule Volatility
- [[One Recipe Attribute Value Per Attribute]]
  - Είναι ο μόνος rule note στο τελευταίο 30ήμερο που τροποποιήθηκε αντί να προστεθεί απλώς.
  - Η αλλαγή του note το επεκτείνει από recipe/material scope σε batch derivation scope, άρα το source of truth μετακινείται από simple validation rule σε propagated runtime invariant.
- Original baseline rules
  - [[First Tracking Sync Captures Immutable Original Snapshot]], [[TimingInfoType Original Is Read Only]], [[Production Original Views Are Tracking Anchored]]
  - Δεν αλλάζουν ακόμα συχνά, αλλά έχουν πολλά edge cases και strong coupling με projection behavior, άρα είναι rules με υψηλή πιθανότητα future churn.
- [[Discrete Materials Cannot Be Stock Mixtures]]
  - Είναι καθαρός και σταθερός rule note.
  - Προς το παρόν δεν φαίνεται volatile, αλλά είναι καλό counter-example: μικρός σαφής κανόνας με περιορισμένο blast radius.

## Missing Documentation
- Το PR note [[PR-task-566-Wrap-original-start-end-into-info-object Original Baseline Snapshot and Production Original Views]] αναφέρει tech debt notes που δεν υπάρχουν στο folder:
  - [[Original Baseline Migration Backfill]]
  - [[Original EOC Outages Depend on Tracking Boundaries]]
  - [[Original Only Chart Rows Need Independent Merge]]
- Το ίδιο PR cluster έχει documented risks, αλλά όχι αντίστοιχη τεκμηρίωση ανά debt item. Αυτό αφήνει orphan follow-up knowledge μέσα στο PR note.
- Δεν υπάρχει ξεχωριστό domain consolidation note για το “original branch in production” ως end-to-end concept across `Planning`, `Production`, and `CommonSpa`. Σήμερα το knowledge είναι σπασμένο σε `Original Baseline Snapshot`, `Timing Info Contexts`, `Production Original Scheduling Views`, και ένα UI debt note.

## Refactor Opportunities
- Διάσπαση του `Workspace Import Export` documentation concept
  - Σήμερα ενώνει recipe-attribute contract migration και original-baseline payload migration.
  - Πρακτικά αξίζει split σε πιο focused notes ή υποενότητες, ώστε το import/export debt να μην γίνεται catch-all bucket.
- Consolidation του “original data pipeline”
  - Δημιουργία πιο καθαρού domain narrative που να ενώνει snapshot capture, timing read contexts, production projections, chart rendering, και update modal behavior.
  - Αυτό θα μειώσει το cognitive overhead όταν ξανανοίξει η περιοχή.
- Hardening της scheduling documentation γύρω από invariants
  - Το cluster `Scheduling Conflict Resolution` + tech debt notes χρειάζεται σαφή invariants list για dynamic updates, cache invalidation, loop skipping, και precedence behavior.
  - Αυτό θα βοηθήσει και test strategy, όχι μόνο documentation.

## Cleanup Suggestions
- Δημιουργία των missing tech debt notes που ήδη αναφέρονται από το PR 566 note, ώστε να μη μένουν broken conceptual references.
- Επανεξέταση overlap ανάμεσα σε `Recipe Attributes` και `SKU Attribute Values`.
  - Τα notes δεν είναι duplicates, αλλά η διάκριση concept vs selected runtime values θέλει να μείνει αυστηρή για να μην μπερδευτεί στο μέλλον.
- Επανεξέταση naming consistency ανάμεσα σε “Original baseline”, “Original views”, “Original context”, και “OriginalInformation”.
  - Η ορολογία είναι σωστή αλλά διασκορπισμένη σε πολλά notes με ελαφρώς διαφορετικό center of gravity.

## Suggested Next Actions
- Δημιουργία των τριών missing tech debt notes που ήδη αναφέρονται από το PR 566 note.
- Διόρθωση του documented bug στο [[Dynamic Task Change Propagation]] πριν μεγαλώσει άλλο το scheduling surface.
- Διάσπαση ή αναδιοργάνωση του [[Workspace Import Export]] note ώστε να ξεχωρίζουν contract changes για recipe attributes από original-baseline export behavior.
- Δημιουργία ενός higher-level domain note για το original-data pipeline από Planning μέχρι Production/UI.
- Προσθήκη explicit test strategy note ή section για scheduling invariants και original-view rendering invariants.