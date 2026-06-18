## Scope
- Documentation root: `D:\Notebooks\Notebook\Notes\Intelligen\Engineering`
- Περίοδος/scope: όλα τα notes
- Πηγές: `PRs/`, `Domains/`, `Rules/`, `TechDebt/`, `Index.md`

## Executive Summary
- Το documentation αυτή τη στιγμή αποτυπώνει μια συγκεντρωμένη αλλαγή στο Planning domain που εισήχθη από το [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]].
- Ο μεγαλύτερος planning κίνδυνος είναι ότι τα recipe attributes πλέον συνδέουν recipe selection, material/SKU context, BOM/adaptive streams, equipment rates, changeover durations και scheduling conflict resolution.
- Τα debt items με την υψηλότερη προτεραιότητα ήταν το [[Recipe Classification Data Migration Risk]] και η τότε ανοιχτή ασάφεια στα import references των recipe attribute values, και τα δύο σημειωμένα ως High risk.
- Το [[Dynamic Scheduling Regression Surface]] είναι Medium risk, αλλά ακουμπά core scheduling συμπεριφορά: slot search, dynamic task recalculation, equipment reassignment, batch shifting, conflict resolution και schedule utilization cache invalidation.
- Δεν υπάρχει ακόμη αρκετό ιστορικό documentation για να αποδειχθούν επαναλαμβανόμενα trends στο χρόνο. Τα περισσότερα συμπεράσματα είναι structural risks από ένα μεγάλο PR analysis snapshot.

## Most Changed Domains
- Το [[Recipe Attributes]] είναι το κεντρικό domain. Αντικαθιστά τα recipe classifications/types και συνδέεται με recipes, materials, batches, equipment rates και changeover matrices.
- Το [[Scheduling Conflict Resolution]] έχει ευρεία αλλαγή συμπεριφοράς, επειδή το scheduling πλέον λαμβάνει υπόψη dynamic tasks, changeover matrix durations, BOM-derived batch attributes, overlap checks και cache invalidation.
- Το [[Workspace Import Export]] αλλάζει εξωτερικά contracts από recipe classifications/types σε recipe attributes/values και κουβαλά τον μεγαλύτερο ambiguity risk γύρω από name-only value references.
- Το [[Adaptive Recipes and BOMs]] συνδέει BOM-specific streams με batch filling και operation entry stream creation.
- Τα [[Changeover Matrices]] και [[Equipment Processing Rates]] εξαρτώνται από batch recipe attribute values και μπορούν να αλλάξουν operation duration.

## Recurring Tech Debt
- Η migration safety εμφανίζεται επανειλημμένα ως ανησυχία. Το [[Recipe Classification Data Migration Risk]] λέει ότι τα `RecipeClassifications`, `RecipeTypes` και `Recipes_RecipeTypes` διαγράφονται χωρίς εμφανές data migration path.
- Το reference ambiguity εμφανιζόταν τόσο στο import/export guidance όσο και στο [[Workspace Import Export]]. Recipe attribute values μπορούσαν να έχουν ίδιο value name κάτω από διαφορετικά attributes, άρα value-name-only resolution δεν ήταν ασφαλές.
- Το scheduling regression risk εμφανίζεται στα [[Dynamic Scheduling Regression Surface]], [[Scheduling Conflict Resolution]] και [[Changeover Matrices]]. Η dynamic duration συμπεριφορά εξαρτάται από neighboring tasks, batch attributes, equipment assignment και cache invalidation.

## Risky Areas
- Το data migration από recipe classifications/types σε recipe attributes/values είναι η πιο καθαρή high-risk περιοχή. Υπάρχον production data μπορεί να χαθεί ή να απαιτήσει undocumented manual recovery.
- Το import/export compatibility είναι risky επειδή παλιά exported JSON με `recipeClassifications` και `recipeTypes` δεν εκπροσωπούνται στο νέο contract, ενώ τα recipe attribute value references μπορεί να είναι ambiguous.
- Το scheduling είναι risky επειδή το changeover-aware search μπορεί να απορρίψει ή να μετακινήσει candidate slots βάσει start/end overlap με lower-precedence neighboring tasks.
- Το dynamic duration calculation είναι risky επειδή τα [[Equipment Attribute Dependent Rate]] και [[Missing Changeover Matrix Value Means Zero Duration]] εξαρτώνται από selected batch attribute values.
- Το BOM reassociation έχει data-loss-like συμπεριφορά στο [[Adaptive Recipes and BOMs]]: όταν ένα BOM συνδεθεί με άλλο recipe, καθαρίζονται τα υπάρχοντα BOM streams.

## Business Rule Volatility
- Κανένας rule δεν έχει documented repeated changes στο χρόνο. Όλοι οι τρέχοντες rules εισάγονται από το [[PR-task-430-Implement-SKU-in-material Adaptive Recipes and Recipe Attributes]].
- Το [[Campaign BOM Must Match Recipe]] έχει σημαντικές layout επιπτώσεις, επειδή campaigns με missing recipes είναι invalid πριν το layout, ενώ campaigns χωρίς BOM μπορούν ακόμη να χρησιμοποιούν recipe-level attribute values.
- Το [[One Recipe Attribute Value Per Attribute]] είναι σημαντικό επειδή duplicate values από διαφορετικά attributes επιτρέπονται, αλλά δύο values από το ίδιο attribute προκαλούν domain exception.
- Το [[Recipe Attribute Value Attribute Is Immutable]] προστατεύει dependent selections σε recipes, materials, batches, equipment rates και changeover matrices.
- Το [[Missing Changeover Matrix Value Means Zero Duration]] είναι sharp default: όταν λείπει transition data, δεν μπλοκάρει scheduling ούτε προειδοποιεί από μόνο του. Παράγει zero duration.
- Το [[Equipment Attribute Dependent Rate]] έχει fallback στο base equipment processing rate όταν δεν υπάρχει matching per-value override.

## Missing Documentation
- Δεν υπάρχει documented production migration plan για υπάρχον recipe classification/type data, παρότι το [[Recipe Classification Data Migration Risk]] είναι High risk.
- Δεν υπάρχει documented backward-compatible import strategy για παλιά exports που περιέχουν `recipeClassifications` και `recipeTypes`.
- Δεν υπάρχουν concrete regression examples για τα σενάρια που κατονομάζει το [[Dynamic Scheduling Regression Surface]]: dynamic-only procedures, forward/backward slot search, changeover overlap και higher-precedence campaign cache invalidation.
- Δεν υπάρχει consolidated import reference contract που να περιγράφει αν τα recipe attribute values γίνονται resolve με value name, attribute path plus value name ή stable composite reference.
- Τα docs δεν δείχνουν decision record για το γιατί missing changeover matrix values γίνονται zero duration αντί για validation failure, warning ή explicit default configuration.

## Refactor Opportunities
- Δημιουργία stable recipe attribute value reference model για import/export που περιλαμβάνει το parent recipe attribute. Αυτό αργότερα υλοποιήθηκε στο master μέσω parent-qualified references.
- Προσθήκη migration ή documented manual migration path πριν εφαρμοστεί η αφαίρεση recipe classification/type σε environments με υπάρχον data, όπως προτείνει το [[Recipe Classification Data Migration Risk]].
- Απομόνωση focused scheduling regression fixtures για dynamic-only procedures, slot search direction, changeover overlap και cache invalidation, σύμφωνα με το [[Dynamic Scheduling Regression Surface]].
- Ενοποίηση των recipe attribute value selection rules σε ένα reference note που συνδέει [[Recipe Attributes]], [[SKU Attribute Values]], [[One Recipe Attribute Value Per Attribute]] και [[Recipe Attribute Value Attribute Is Immutable]].
- Προσθήκη explicit examples για fallback behavior στα [[Equipment Attribute Dependent Rate]] και [[Missing Changeover Matrix Value Means Zero Duration]], ώστε το zero-duration και base-rate behavior να είναι intentional και testable.

## Cleanup Suggestions
- Να ξεκαθαριστεί η ονοματολογική σχέση μεταξύ [[SKU Attribute Values]] και recipe attribute values. Το note περιγράφει selected recipe attribute values σε SKU/material/batch contexts, όχι ξεχωριστό entity type.
- Δεν βρέθηκαν duplicate notes στο τρέχον index, αλλά αρκετά domains δείχνουν στο ίδιο PR. Μελλοντικά reports θα είναι πιο χρήσιμα αν προστεθούν follow-up PRs στα related domain notes.
- Διατήρηση σαφούς import-reference guidance δίπλα στο [[Workspace Import Export]] αν το contract αλλάξει ξανά, επειδή το identifier model επηρεάζει άμεσα το import resolution.
- Προσθήκη links από το [[Scheduling Conflict Resolution]] στο [[Dynamic Scheduling Regression Surface]] σε μελλοντικό expanded test documentation.

## Suggested Next Actions
- Να δοθεί προτεραιότητα σε production-safe migration decision για recipe classifications/types.
- Να οριστεί και να τεκμηριωθεί το import/export identity contract για recipe attribute values.
- Να προστεθούν regression examples για τα dynamic scheduling scenarios που αναφέρει το [[Dynamic Scheduling Regression Surface]].
- Να τεκμηριωθεί compatibility behavior για παλιά workspace exports.
- Να προστεθούν examples ή tests γύρω από zero-duration missing changeover values και equipment base-rate fallback.
