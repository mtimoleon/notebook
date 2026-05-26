## Scope
- Documentation root: `D:\Notebooks\Notebook\Notes\Intelligen\Engineering`
- Period/scope: last 30 days
- Source folders: `PRs/`, `Domains/`, `Rules/`, `TechDebt/`, `Index.md`

## Executive Summary
- Η τεκμηρίωση χωρίζεται σε δύο καθαρά clusters αλλαγών: το cluster `PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes` γύρω από recipe attributes/BOMs/dynamic scheduling και το cluster `PR-task-566-Wrap-original-start-end-into-info-object Original Baseline Snapshot and Production Original Views` γύρω από original baseline και production projections.
- Το Planning παραμένει το πιο ευαίσθητο σημείο του συστήματος: συνδυάζει migration risk (`Recipe Classification Data Migration Risk`), import ambiguity (`Ambiguous Recipe Attribute Value Import References`) και scheduling regression surface (`Dynamic Scheduling Regression Surface`).
- Το νέο original-baseline flow έχει ήδη καλή κάλυψη σε PR, Domain και Rule notes, αλλά η τεκμηρίωσή του είναι ασυνεπής επειδή τρία referenced TechDebt notes λείπουν από το vault.
- Υπάρχει άμεσο θέμα καθαριότητας τεκμηρίωσης: τα `Workspace Import Export.md` και `Workspace Import Export 1.md` επικαλύπτονται με ίδιο τίτλο note και διαφορετικό περιεχόμενο.

## Most Changed Domains
- `Workspace Import Export`: εμφανίζεται και στα δύο PR notes. Αυτό είναι το μόνο domain με σαφή ιστορική επέκταση και ταυτόχρονα naming drift.
- `Recipe Attributes`, `Adaptive Recipes and BOMs`, `Changeover Matrices`, `Scheduling Conflict Resolution`: αποτελούν τον πυρήνα του cluster του PR 430 και συνδέονται άμεσα με τους κανόνες `One Recipe Attribute Value Per Attribute`, `Campaign BOM Must Match Recipe`, `Missing Changeover Matrix Value Means Zero Duration`.
- `Original Baseline Snapshot`, `Timing Info Contexts`, `Production Original Scheduling Views`: αποτελούν το νέο cross-boundary cluster του PR 566 και δείχνουν ότι η έννοια του original state πλέον διαπερνά Planning και Production.

## Recurring Tech Debt
- Επαναλαμβανόμενο migration risk: το `Recipe Classification Data Migration Risk` δείχνει απώλεια legacy data στο cluster των recipe attributes, ενώ το PR 566 note αναφέρει αντίστοιχο κίνδυνο απώλειας original baseline data, αλλά το αντίστοιχο TechDebt note δεν υπάρχει στο vault.
- Επαναλαμβανόμενο import/export fragility: το `Ambiguous Recipe Attribute Value Import References` και το domain `Workspace Import Export` δείχνουν ότι τα contract changes συσσωρεύουν ασάφεια σε identifiers και backward compatibility.
- Επαναλαμβανόμενο scheduling/projection fragility: το `Dynamic Scheduling Regression Surface` δείχνει υψηλή επιφάνεια regressions στο Planning, ενώ το `Production Original Views Are Tracking Anchored` περιγράφει αντίστοιχη ευθραυστότητα στην Production προβολή original δεδομένων.
- Επαναλαμβανόμενο FE/BE drift: το `Update Modal Original Resources Not Rendered` δείχνει ότι backend contract και UI συμπεριφορά έχουν ήδη αποκλίνει στο cluster του PR 566.

## Risky Areas
- Planning migrations: `Recipe Classification Data Migration Risk` και οι κίνδυνοι του PR 566 γύρω από original baseline δείχνουν ότι schema evolution γίνεται χωρίς σταθερά documented backfill patterns.
- Scheduling logic: τα `Scheduling Conflict Resolution`, `Changeover Matrices` και `Dynamic Scheduling Regression Surface` δείχνουν περιοχή με πολλούς αλληλεξαρτώμενους κανόνες και υψηλή πιθανότητα regression.
- Cross-boundary Planning -> Production flow: τα `Original Baseline Snapshot` και `Production Original Scheduling Views` δείχνουν ότι η ίδια έννοια μετασχηματίζεται σε πολλά στάδια, άρα ownership και validation boundaries δεν είναι ακόμη πλήρως σταθερά.
- UI consistency στο CommonSpa: το `Update Modal Original Resources Not Rendered` δείχνει ότι η τεκμηρίωση καταγράφει backend support χωρίς αντίστοιχη UI ετοιμότητα.

## Business Rule Volatility
- Δεν προκύπτει συχνή ιστορική τροποποίηση των ίδιων rule notes μέσα στο διαθέσιμο 30ήμερο corpus. Η τεκμηρίωση δείχνει περισσότερο νέες rule introductions παρά επαναλαμβανόμενες αναθεωρήσεις.
- Οι πιο ευαίσθητοι κανόνες είναι οι `First Tracking Sync Captures Immutable Original Snapshot`, `TimingInfoType Original Is Read Only` και `Production Original Views Are Tracking Anchored`, επειδή ορίζουν semantics που διαπερνούν Planning, sync και Production.
- Από το cluster του PR 430, οι κανόνες `Missing Changeover Matrix Value Means Zero Duration` και `Equipment Attribute Dependent Rate` έχουν edge cases που επηρεάζουν directly scheduling outcomes και duration calculations.

## Missing Documentation
- Το PR 566 note συνδέει τα `Original Baseline Migration Backfill`, `Original EOC Outages Depend on Tracking Boundaries` και `Original Only Chart Rows Need Independent Merge`, αλλά αυτά τα TechDebt notes δεν υπάρχουν στον φάκελο `TechDebt/`.
- Το `Index.md` δεν περιλαμβάνει τα παραπάνω missing TechDebt notes, άρα το index δεν αντανακλά πλήρως τους καταγεγραμμένους κινδύνους του PR 566.
- Το `Workspace Import Export 1.md` υποδηλώνει αποτυχημένη ενημέρωση υπάρχοντος note και έλλειψη ενοποιημένου source of truth για το import/export domain.
- Δεν υπάρχει consolidated note που να περιγράφει end-to-end ownership για το original baseline από Planning snapshot μέχρι Production table/EOC/chart consumers. Η γνώση είναι μοιρασμένη στα `Original Baseline Snapshot`, `Timing Info Contexts` και `Production Original Scheduling Views`.

## Refactor Opportunities
- Καθιέρωση ενιαίου migration playbook για schema changes που αλλάζουν persisted semantics. Τα `Recipe Classification Data Migration Risk` και οι κίνδυνοι του PR 566 δείχνουν ότι αυτό είναι επαναλαμβανόμενο κενό.
- Ενοποίηση του import/export domain note: συγχώνευση των `Workspace Import Export.md` και `Workspace Import Export 1.md` σε ένα note με καθαρό update history.
- Διαχωρισμός του production original-view flow σε σαφή invariants: τι επιτρέπεται να fallback σε planning, τι απαιτεί tracking anchor και τι οφείλει να υπάρχει ως ανεξάρτητη original προβολή.
- Στόχευση regression packs ανά domain cluster αντί για οριζόντιες generic δοκιμές: ένα pack για recipe-attribute scheduling, ένα δεύτερο για original baseline propagation.

## Cleanup Suggestions
- Συγχώνευση ή διαγραφή του duplicate `Workspace Import Export 1.md`.
- Έλεγχος όλων των links από το PR 566 cluster προς missing TechDebt notes και δημιουργία ή αφαίρεση broken references.
- Επαλήθευση ότι το `Index.md` περιλαμβάνει όλα τα ενεργά notes και μόνο αυτά.
- Ενοποίηση naming για domains που περιγράφουν cross-boundary behavior, ώστε να ξεχωρίζει καθαρά το Planning concept (`Original Baseline Snapshot`) από το Production projection concept (`Production Original Scheduling Views`).

## Suggested Next Actions
- Δημιουργία των τριών missing TechDebt notes που ήδη referenced από το PR 566 cluster και ενημέρωση του `Index.md`.
- Συγχώνευση των `Workspace Import Export.md` και `Workspace Import Export 1.md` σε ένα note.
- Καταγραφή explicit migration strategy note ή checklist για future schema-changing PRs, με αφετηρία τα migration risks των PR 430 και PR 566.
- Προσθήκη ενός compact end-to-end domain note για το original baseline lifecycle, ώστε να υπάρχει ένα ενιαίο σημείο αναφοράς για Planning, sync και Production behavior.
