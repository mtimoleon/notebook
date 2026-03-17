---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-03-06
product:
component:
status: backlog
tags:
  - issues/intelligen
  - documentation/intelligen
---
## Context
Find a way to protect copy functions and import export from breaking after domain changes.

Στον κώδικα έχουμε κάποια extentions όπως το clone και copyFrom αλλά και το importExport service. Επίσης σε κάποια domain aggregates έχουμε υλοποιημένο copyFrom αλλά και όπως τώρα το copy operation to another procedure. To πρόβλημα που έχουμε είναι ότι αν αλλάξει το domain πχ προστεθούν νέα aggregates ή νέες συνδέσεις μεταξύ τους όπως γίνεται με τις λίστες τους όλα τα σημεία που κάνουν δουλειές copy μπορούν να σπάσουν χωρίς να το καταλάβουμε. Ιδανικά θέλουμε να φτιάξουμε κάτι που θα μπορεί να βλέπει τις αλλαγές on demand και να μας δείχνει ποιο σημείο μπορεί να σπάσει ή να τρέχει τα ισοδύναμα copy commands και να δείχνει ποια έχουν πρόβλημα. Κάτι σαν τεστ δηλαδή. ένα παρόμοιο τεστ έχουμε για το automapper profile toy import export. Μπορείς να προτείνεις μια λύση χωρίς να γίνει implement ακόμη απλά να το συζητήσουμε;

## Notes
​
Ναι. Με βάση αυτό που ήδη υπάρχει, το πρόβλημα είναι πραγματικό και σήμερα είναι διάσπαρτο σε πολλά διαφορετικά mechanisms:
- generic reflection copy στο CloneExtension.cs και CloneExtension.cs
- χειροκίνητο rewiring σε aggregate copy methods όπως SchedulingBoard.cs, Recipe.cs, Procedure.cs
- import/export mapping στο [ImportExportService.cs](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-26.304.20706-win32-x64/webview/)
- και το υπάρχον AutoMapper validation test στο [ImportExportMappingTests.cs](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-26.304.20706-win32-x64/webview/), που ελέγχει config validity αλλά όχι semantic completeness
Η λύση που θα πρότεινα δεν είναι “ένα ακόμα test ανά aggregate”, αλλά ένα μικρό framework από copy contract tests.
1. Copy scenario registry
    ​
    Για κάθε operation που θεωρείται copy path, δηλώνεις ένα scenario:
    - Recipe.CreateCopy
    - SchedulingBoard.CreateCopy
    - Facility.CreateCopy
    - Procedure.CreateOperationFromAnother
    - Batch.CopyFrom
    - Workspace export/import roundtrip
Κάθε scenario λέει:
- ποιο object graph χτίζω
- ποια εντολή copy εκτελώ
- τι πρέπει να γίνει deep copy
- τι πρέπει να μείνει external reference
- τι πρέπει να γίνει rebind στον νέο owner
- τι επιτρέπεται να αγνοηθεί ρητά
1. Rich graph builders
    ​
    Χρειάζεστε builders/test fixtures που δημιουργούν “γεμάτα” aggregates, όχι minimal.
    ​
    Αν το fixture δεν βάζει lists, many-to-many, reference links, scheduling links, nested children, τότε δεν θα πιάνει τα σπασίματα που σας νοιάζουν.
2. Graph comparison engine
    ​
    Ο comparator δεν πρέπει να ελέγχει μόνο not same reference.
    ​
    Πρέπει να ξέρει κανόνες όπως:
    - child collections πρέπει να έχουν ίδιο count/orderowner back-references πρέπει να δείχνουν στο νέο aggregate
    - internal references πρέπει να remap-άρονται από old node σε new node
    - external references πρέπει να μένουν shared
    - νέα property/collection που δεν έχει classification να ρίχνει fail
Εδώ είναι το κρίσιμο σημείο: αν αύριο προστεθεί νέα λίστα ή νέο aggregate relation, το test να αποτύχει επειδή είναι “unclassified”, όχι επειδή κάποιος θυμήθηκε να γράψει assertion.
4. Drift detection
    ​
    Θα έβαζα discovery test που σκανάρει:
    - όλα τα aggregate types
    - όλα τα private List<> fields / navigation collections
    - όλα τα methods με ονόματα CreateCopy, CopyFrom, Clone, ή γνωστά copy commands
Και να αποτυγχάνει αν:
- βρεθεί νέο copy entry point χωρίς scenario
- βρεθεί νέο child/reference member σε covered aggregate χωρίς declared behavior
5. Import/export: roundtrip contract, όχι μόνο AutoMapper config test
    ​
    Το υπάρχον test είναι χρήσιμο αλλά περιορισμένο.
    ​
    Θέλετε και semantic roundtrip test:
    - φτιάχνεις πλούσιο workspace
    - export
    - import σε clean target
    - συγκρίνεις το graph με contract rules
Αυτό θα πιάνει περιπτώσεις όπου το mapping είναι “valid” αλλά ξέχασες να περάσεις νέα nested οντότητα ή σύνδεση.
Η βασική αρχιτεκτονική απόφαση είναι αν οι κανόνες copy θα δηλώνονται:
- μέσα στο domain με attributes/metadata
- ή μόνο στα tests με fluent contract DSL
Εγώ θα ξεκινούσα test-side, για να μη μολυνθεί το domain. Μόνο όπου ήδη υπάρχει metadata όπως OwnerReference / OwnerReferenceId, θα το αξιοποιούσα.

Kαθαρό design-only βήμα:
- να χαρτογραφήσουμε τα copy entry points που θα καλύψουμε πρώτα
- να ορίσουμε το contract model των tests
- να αποφασίσουμε αν ξεκινάμε από Recipe, SchedulingBoard, Procedure copy to another procedure, και Import/Export roundtrip

Η πρόταση που βλέπω να ταιριάζει στο repo σας είναι αυτή:
**Δομή**
​
Στο Planning.UnitTests να μπει ένα νέο test area, π.χ. Domain/CopyContracts/, με 4 βασικά κομμάτια:
- CopyScenario: περιγράφει ένα copy path.
- CopyScenarioRegistry: κεντρική λίστα όλων των scenarios που πρέπει να καλύπτονται.
- GraphAssertions ή CopyContractVerifier: ο engine που ελέγχει source/target graph.
- Builders: rich fixtures για να χτίζουν aggregates με όσο το δυνατόν περισσότερες σχέσεις.
Κάθε scenario θα δίνει:
- Name
- BuildSource()
- ExecuteCopy(source)
- Rules
Οι Rules θα λένε:
- ποια children πρέπει να είναι deep-copied
- ποια refs πρέπει να μείνουν shared
- ποια owner refs πρέπει να δείχνουν στον νέο parent
- ποια internal links πρέπει να γίνουν remap
- ποια members εξαιρούνται ρητά

**Τι θα ελέγχουν**
​Δεν θα γράφαμε πολλά ad-hoc asserts τύπου “count = 1”.
​
Θα θέλαμε generic checks όπως:
- όλα τα declared child collections αντιγράφτηκαν
- τα items είναι νέα instances όπου περιμένουμε deep copy
- οι back references δείχνουν στο νέο aggregate
- οι internal links δεν δείχνουν ακόμα στο source graph
- αν προστεθεί νέο navigation/list/property σε covered aggregate και δεν έχει rule, το test να αποτυγχάνει
Αυτό είναι το πιο σημαντικό: fail on unknown member, όχι μόνο fail on known regression.

**Πρώτο scope**
​Θα ξεκινούσα με 3 scenarios μόνο:
- Recipe.CreateCopy
- SchedulingBoard.CreateCopy
- Batch.Clone/CopyFrom
Αυτά ήδη καλύπτουν:
- nested aggregates
- internal reference rewiring
- many-to-many / owner references
- restore semantics με CopyFrom
Μετά θα έμπαινε:
- Import/Export roundtrip contract
- αργότερα Procedure.CreateOperationFromAnother από το άλλο branch

**Discovery test**
Θα έβαζα και ένα δεύτερο test που δεν κάνει copy, μόνο “coverage enforcement”:
- βρίσκει methods τύπου CreateCopy, CopyFrom, Clone
- ελέγχει ότι για κάθε supported aggregate υπάρχει registered scenario
- βρίσκει private List<> fields / navigation members στα covered aggregates
- αποτυγχάνει αν εμφανιστεί νέο member χωρίς classification
Έτσι θα πιάνει ακριβώς το πρόβλημα που περιέγραψες: αλλαγή στο domain που μπορεί να σπάσει copy path χωρίς να το πάρεις χαμπάρι.
Αν θέλεις, στο επόμενο βήμα μπορώ να σου γράψω ένα πολύ συγκεκριμένο “mini design spec”:
- ποια classes/interfaces να υπάρχουν
- τι signatures να έχουν
- τι rules θα έχει το πρώτο RecipeCreateCopyScenario
- και ποια tests θα μπουν πρώτα ώστε να ξεκινήσει μικρά αλλά σωστά.


Η σωστή πρώτη έκδοση είναι αυτή: test-only infrastructure στο `Planning.UnitTests`, με ένα μικρό contract framework που καλύπτει τα copy paths και αποτυγχάνει όταν εμφανιστεί νέο member ή νέο copy entry point χωρίς classification. Θα ξεκινούσα από τα υπάρχοντα mechanisms στα [CloneExtension.cs](c:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Helpers/CloneExtension.cs#L25), [SchedulingBoard.cs](c:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/SchedulingBoardAggregate/SchedulingBoard.cs#L344), [Recipe.cs](c:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/RecipeAggregate/Recipe.cs#L285) και μετά θα πρόσθετα import/export roundtrip δίπλα στο υπάρχον mapping validation του [ImportExportMappingTests.cs](c:/Users/michael/developer/scpCloud/Services/Planning/Planning.UnitTests/Domain/ImportExportMappingTests.cs#L15).
Το mini design spec:
- Νέο test area: `Services/Planning/Planning.UnitTests/Domain/CopyContracts/`
- Core types:
  - `CopyScenario` για `BuildSource()`, `ExecuteCopy()`, `DescribeContract()`
  - `CopyContract` με rules για `DeepCopy`, `SharedReference`, `OwnerRebind`, `InternalReferenceRemap`, `IgnoredMember`
  - `CopyContractVerifier` που κάνει generic traversal/comparison
  - `CopyScenarioRegistry` με όλα τα supported copy paths
  - `CopyCoverageTests` που σκανάρει reflection-based τα covered aggregates και αποτυγχάνει σε unclassified members ή unregistered copy methods
  - `Builders` ή `Mother` fixtures για rich graphs
- Πρώτα scenarios:
  - `Recipe.CreateCopy`
  - `SchedulingBoard.CreateCopy`
  - `Batch.Clone` και `Batch.CopyFrom`
- Δεύτερη φάση:
  - `ImportExportRoundtripScenario`
  - αργότερα `Procedure.CreateOperationFromAnother` από το άλλο branch
- Βασική αρχή: unknown structural drift => test failure, όχι σιωπηρή παράβλεψη

Παρακάτω είναι ενοποιημένο το prompt (specs and plan) που πρέπει να δοθεί στο codex:

```
Υλοποίησε το παρακάτω ακριβώς. Μην αλλάξεις production/domain code, μόνο tests και test helpers.
Θέλω να υλοποιήσεις test-only infrastructure για copy contract/regression testing στο Planning solution, χωρίς καμία αλλαγή στο domain production code.
Context
- Υπάρχουν πολλά copy mechanisms:
  - generic Clone/CopyFrom extension methods
  - aggregate-specific CreateCopy methods
  - import/export mapping and roundtrip
- Το ρίσκο είναι ότι όταν προστεθούν νέα aggregates, νέες nested λίστες ή νέες συνδέσεις μεταξύ οντοτήτων, κάποια copy path μπορεί να σπάσει χωρίς να το καταλάβουμε.
- Θέλουμε tests που να εντοπίζουν structural drift και missing rewiring logic.
Relevant existing code
- Services/Planning/Planning.Domain/Helpers/CloneExtension.cs
- Services/Planning/Planning.Domain/Aggregates/RecipeAggregate/Recipe.cs
- Services/Planning/Planning.Domain/Aggregates/SchedulingBoardAggregate/SchedulingBoard.cs
- Services/Planning/Planning.UnitTests/Domain/ImportExportMappingTests.cs
- Services/Planning/Planning.Api/Services/ImportExportService.cs
Goal
Να προστεθεί νέο test framework στο Planning.UnitTests που:
1. Περιγράφει copy scenarios declaratively.
2. Εκτελεί generic verification του source/target graph.
3. Αποτυγχάνει όταν προστεθεί νέο relevant member ή νέο copy entry point χωρίς explicit coverage/classification.
4. Δεν αλλάζει καθόλου production/domain code.
Implementation constraints
- Μόνο tests και test helpers.
- Μην πειράξεις domain production classes.
- Προτίμησε μικρό, καθαρό design που να επεκτείνεται.
- Χρησιμοποίησε apply_patch για edits.
- Κράτησε ASCII.
- Αν δεις existing unrelated changes, μην τις πειράξεις.
Proposed structure
- New folder: Services/Planning/Planning.UnitTests/Domain/CopyContracts/
- Add:
  - CopyScenario base abstraction
  - CopyContract rule model
  - CopyContractVerifier
  - CopyScenarioRegistry
  - CopyCoverageTests
  - Rich builders/fixtures for representative graphs
Required first scenarios
- Recipe.CreateCopy
- SchedulingBoard.CreateCopy
- Batch.Clone and/or Batch.CopyFrom
Contract behavior to support
- Deep-copied child collections
- Shared external references
- Owner/back-reference rebinding to new parent
- Internal reference remapping from old graph to new graph
- Explicit ignored members
- Failure on unclassified relevant members
Coverage enforcement
- Add reflection-based tests that:
  - find covered aggregate types and their private List<> / IReadOnlyList<>-backed members
  - fail if a new relevant member appears without being declared in the scenario contract
  - optionally detect copy-like methods (CreateCopy / CopyFrom / Clone) and fail if a supported target type has no registered scenario
Validation
- Add unit tests for the verifier itself where useful
- Ensure the new tests are deterministic and readable
- Run the relevant test project(s) after implementation and report results
Deliverables
- Implement the infrastructure
- Implement the first scenarios
- Add/adjust tests
- Summarize design decisions, tradeoffs, and any remaining gaps
Και ακολούθησε αυτό το plan:
##### Plan
Build a small test-only copy-contract framework in `Planning.UnitTests` so copy paths are verified generically instead of with scattered ad-hoc assertions. The first pass should cover the highest-risk existing copy mechanisms, then add reflection-based drift detection so new members or copy entry points cannot slip in unnoticed.
###### Scope
- In:
- Add copy-contract test infrastructure under `Services/Planning/Planning.UnitTests/Domain/CopyContracts/`
- Cover `Recipe.CreateCopy`, `SchedulingBoard.CreateCopy`, and `Batch.Clone` / `Batch.CopyFrom`
- Add generic graph verification and coverage-enforcement tests
- Run the relevant Planning unit tests and report results
- Out:
- Any production/domain code changes
- Any implementation of `Procedure.CreateOperationFromAnother` on this branch
- Broad functional test refactors outside the new copy-contract area
###### Action items
[ ] Inspect the current `Clone`, `CopyFrom`, and aggregate `CreateCopy` paths to list the graph behaviors each scenario must validate.
[ ] Add a minimal `CopyScenario` and `CopyContract` model in `Services/Planning/Planning.UnitTests/Domain/CopyContracts/` to declare source builder, copy executor, and member rules.
[ ] Add a `CopyContractVerifier` that traverses source and copied graphs and checks deep-copy members, shared references, owner rebinds, internal remaps, and explicit ignores.
[ ] Add rich test builders/fixtures that create representative `Recipe`, `SchedulingBoard`, and `Batch` graphs with nested lists and internal links.
[ ] Implement scenario tests for `Recipe.CreateCopy`, `SchedulingBoard.CreateCopy`, and `Batch.Clone` / `Batch.CopyFrom` using the new verifier instead of one-off assertions.
[ ] Add reflection-based coverage tests that fail when a covered aggregate gains a new relevant collection/reference member without contract classification.
[ ] Add reflection-based registry tests that fail when known copy-style methods on covered types are missing a registered scenario.
[ ] Add small verifier self-tests for tricky behaviors such as owner rebinding, internal reference remapping, and ignored-member handling.
[ ] Run the relevant Planning unit test project, fix failures, and confirm the new tests are deterministic and readable.
[ ] Document the final test structure and residual gaps, including that import/export roundtrip and procedure-to-procedure copy are next scenarios to add.
###### Open questions
- Should the first registry version detect copy methods only on explicitly covered aggregate types, or globally across the Planning domain assembly?
- Do we want `Batch.Clone` and `Batch.CopyFrom` as separate scenarios from day one, or one scenario each with shared builder logic?
- Should import/export roundtrip be added immediately after this work or left as a follow-up once the verifier shape stabilizes?
```


---

Υλοποίησα πλήρως test-only copy-contract infrastructure στο `Planning.UnitTests`, χωρίς αλλαγή σε production/domain code.
**Νέα δομή**
- [CopyScenario.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyScenario.cs)
- [CopyContract.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyContract.cs)
- [CopyMemberBehavior.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyMemberBehavior.cs)
- [CopyMemberRule.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyMemberRule.cs)
- [CopyContractVerifier.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyContractVerifier.cs)
- [CopyReflectionCoverage.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyReflectionCoverage.cs)
- [CopyScenarioRegistry.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyScenarioRegistry.cs)
- [CopyGraphFixtures.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyGraphFixtures.cs)
- [CopyContractTests.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyContractTests.cs)
- [CopyCoverageTests.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyCoverageTests.cs)
- [CopyContractVerifierTests.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyContractVerifierTests.cs)
**Τι καλύπτει**
- Declarative scenarios + contracts για:
  - `Recipe.CreateCopy`
  - `SchedulingBoard.CreateCopy`
  - `Batch.Clone` (extension)
  - `Batch.CopyFrom` (extension)
- Generic verification για:
  - deep-copied collections
  - deep-copied references
  - shared external references
  - owner/back-reference rebinding
  - internal reference remap
  - explicit ignored members
- Reflection-based coverage tests για:
  - unclassified relevant list-backed members σε covered types
  - invalid/non-existing contract members
  - missing registered scenarios για copy-like entry points
**Validation**
- Έτρεξα:
  - `dotnet test Services/Planning/Planning.UnitTests/Planning.UnitTests.csproj --filter "FullyQualifiedName~CopyContracts"`
  - `dotnet test Services/Planning/Planning.UnitTests/Planning.UnitTests.csproj`
- Αποτέλεσμα: `Passed: 221, Failed: 0`.
**Design tradeoffs / gaps**
- Εξαιρέθηκε το `DomainEvents` από list-backed coverage (δεν είναι copy-contract concern).
- Κάποια known-members μπήκαν `Ignored` όπου δεν ανήκουν στον τρέχοντα contract στόχο.
- Επόμενα φυσικά scenarios για επέκταση: import/export roundtrip και procedure-to-procedure copy path.

---

**Πώς δουλεύει**
Το framework χωρίζει το πρόβλημα σε 4 επίπεδα: scenario, contract, verifier, coverage tests.
```text
┌───────────────────────┐
│   Test Runner         │
│ CopyContractTests     │
└──────────┬────────────┘
           │ παίρνει όλα τα scenarios
           v
┌───────────────────────┐
│ CopyScenarioRegistry  │
│ - Recipe.CreateCopy   │
│ - SchedulingBoard...  │
│ - Batch.Clone         │
│ - Batch.CopyFrom      │
└──────────┬────────────┘
           │ κάθε scenario δίνει:
           │ 1) source graph
           │ 2) copy execution
           │ 3) contract
           v
┌───────────────────────┐
│ CopyScenario          │
│ CreateExecution()     │
│ Contract              │
│ EntryPointId          │
└──────────┬────────────┘
           │
           v
┌───────────────────────┐
│ CopyContractVerifier  │
│                       │
│ 1. Εκτελεί το copy    │
│ 2. Φτιάχνει map       │
│    source -> target   │
│ 3. Ελέγχει rules      │
└──────────┬────────────┘
           │
           v
┌──────────────────────────────────────────┐
│ CopyContract                             │
│ rules ανά member:                        │
│ - DeepCopyCollection                     │
│ - DeepCopyReference                      │
│ - SharedReference                        │
│ - OwnerRebound                           │
│ - InternalReferenceRemap                 │
│ - Ignored                                │
└──────────────────────────────────────────┘
```
**Τι ελέγχει ο verifier**
Σε κάθε scenario κάνει περίπου αυτό:
```text
source graph
   │
   ├─ execute copy ─────────────► target graph
   │
   └─ walk contract-deep members
         │
         ├─ αντιστοιχίζει source node -> copied node
         ├─ επιβεβαιώνει ότι collections είναι νέα instances
         ├─ επιβεβαιώνει ότι children είναι νέα instances
         ├─ επιβεβαιώνει owner rebinding
         ├─ επιβεβαιώνει internal remapping
         └─ επιβεβαιώνει shared refs όπου πρέπει
```
Παράδειγμα για `Recipe.CreateCopy`:
```text
Recipe(old)
 ├─ Branches ---------------------- deep copy --------------------► Branches(new)
 │    └─ Branch.Recipe ----------- owner rebound ----------------► new Recipe
 │
 └─ Procedures/Operations
      ├─ Operation.InputStreams --- deep copy -------------------► new streams
      │    └─ stream.Operation ---- owner rebound --------------► new operation
      │
      ├─ Operation.SchedulingLinkOperation
      │                         --- internal remap -------------> mapped new operation
      │
      └─ Operation.AuxEquipmentPool / Staff / Materials
                                --- shared refs ---------------> same external objects
```
**Πώς πιάνει structural drift**
Υπάρχει δεύτερο στρώμα tests, τα [CopyCoverageTests.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyCoverageTests.cs):
```text
covered domain type
   │
   ├─ reflection: βρες relevant list-backed members
   │
   ├─ υπάρχουν όλοι στο contract;
   │      └─ αν όχι -> FAIL
   │
   └─ reflection: βρες copy-like entry points
          └─ υπάρχει scenario στο registry;
                 └─ αν όχι -> FAIL
```
Αυτό σημαίνει:
- αν προστεθεί νέο `List<>`/`IReadOnlyList<>` member σε covered aggregate και δεν ταξινομηθεί, σπάει test
- αν προστεθεί νέο copy entry point σε supported type και δεν δηλωθεί scenario, σπάει test
**Πού να κοιτάξεις**
Η πιο καθαρή ροή είναι:
1. [CopyScenarioRegistry.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyScenarioRegistry.cs)
2. [CopyContractVerifier.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyContractVerifier.cs)
3. [CopyCoverageTests.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyCoverageTests.cs)
4. [CopyGraphFixtures.cs](C:\Users\michael\developer\scpCloud\Services\Planning\Planning.UnitTests\Domain\CopyContracts\CopyGraphFixtures.cs)

Αν θέλεις, μπορώ να σου φτιάξω και δεύτερο διάγραμμα, πιο συγκεκριμένο, μόνο για `Recipe.CreateCopy` ή μόνο για `SchedulingBoard.CreateCopy`.

Το πιο χρήσιμο διάγραμμα είναι ένα end-to-end για `Recipe.CreateCopy`, γιατί εκεί φαίνονται και τα 3 βασικά πράγματα που ελέγχει το framework: deep copy, owner rebinding, internal remap.
**Διάγραμμα**
```text
SOURCE RECIPE GRAPH
==================
Recipe(old)
├─ RecipeTypes ---------------------------> RecipeType(external)
├─ Branches
│  └─ Branch(old)
│     ├─ Recipe --------------------------> Recipe(old)
│     └─ Sections
│        └─ Section(old)
│           ├─ Branch --------------------> Branch(old)
│           └─ Procedures
│              ├─ Procedure A(old)
│              │  ├─ Section -------------> Section(old)
│              │  ├─ MainEquipmentPool ---> Equipment(external)
│              │  └─ Operations
│              │     ├─ Op1(old)
│              │     │  ├─ Procedure -----> Procedure A(old)
│              │     │  ├─ InputStreams --> Material(external)
│              │     │  └─ OutputStreams -> Material(external)
│              │     └─ Op2(old)
│              │        ├─ Procedure -----> Procedure A(old)
│              │        ├─ SchedulingLink -> Op1(old)
│              │        └─ DurationRef ----> Op1(old)
│              └─ Procedure B(old)
│                 ├─ MainEquipmentCompatibilityProcedure -> Procedure A(old)
│                 └─ Operations
│                    └─ Op3(old)
│                       ├─ SchedulingLink -------------> Op2(old)
│                       └─ AdditionalSchedulingLinks --> Op1(old)
COPY OPERATION
==============
Recipe.CreateCopy(...)
    │
    ├─ 1. Clone() φτιάχνει νέο object graph
    │      - νέα Recipe / Branch / Section / Procedure / Operation instances
    │      - νέα lists
    │      - shared refs προς external objects
    │
    ├─ 2. Rebind owners
    │      - Branch.Recipe = new Recipe
    │      - Section.Branch = new Branch
    │      - Procedure.Section = new Section
    │      - Operation.Procedure = new Procedure
    │      - Stream.Operation = new Operation
    │
    └─ 3. Remap internal links
           old Op1 -> new Op1
           old Op2 -> new Op2
           old Op3 -> new Op3
           μετά:
           new Op2.SchedulingLink = new Op1
           new Op2.DurationRef    = new Op1
           new Op3.SchedulingLink = new Op2
           new Op3.AdditionalLink = new Op1
           new ProcedureB.MainEquipmentCompatibilityProcedure = new ProcedureA
TARGET RECIPE GRAPH
===================
Recipe(new)
├─ RecipeTypes ---------------------------> SAME RecipeType(external)
├─ Branches
│  └─ Branch(new)
│     ├─ Recipe --------------------------> Recipe(new)
│     └─ Sections
│        └─ Section(new)
│           ├─ Branch --------------------> Branch(new)
│           └─ Procedures
│              ├─ Procedure A(new)
│              │  ├─ Section -------------> Section(new)
│              │  ├─ MainEquipmentPool ---> SAME Equipment(external)
│              │  └─ Operations
│              │     ├─ Op1(new)
│              │     └─ Op2(new)
│              │        ├─ SchedulingLink -> Op1(new)
│              │        └─ DurationRef ----> Op1(new)
│              └─ Procedure B(new)
│                 ├─ MainEquipmentCompatibilityProcedure -> Procedure A(new)
│                 └─ Op3(new)
│                    ├─ SchedulingLink -------------> Op2(new)
│                    └─ AdditionalSchedulingLinks --> Op1(new)
```
**Τι ελέγχουν τα tests πάνω σε αυτό**
```text
DeepCopyCollection
- `Branches`, `Sections`, `Procedures`, `Operations`, `Streams` είναι νέες συλλογές
- τα items μέσα τους είναι νέα instances
SharedReference
- `RecipeType`, `Equipment`, `Material`, `Staff`, `Labor` μένουν οι ίδιες external αναφορές
OwnerRebound
- κάθε child δείχνει στον νέο parent, όχι στον παλιό
InternalReferenceRemap
- ό,τι έδειχνε σε node μέσα στο old graph πρέπει να δείχνει στο αντίστοιχο node του new graph
```
**Πώς το framework το μοντελοποιεί**
```text
Scenario
  -> "Recipe.CreateCopy"
Contract
  -> για κάθε relevant member δηλώνει:
     DeepCopyCollection / SharedReference / OwnerRebound / InternalReferenceRemap / Ignored
Verifier
  -> τρέχει το copy
  -> χτίζει map old-node -> new-node
  -> εφαρμόζει τους κανόνες του contract
Coverage tests
  -> αν μπει νέο relevant member και δεν δηλωθεί στο contract: FAIL
  -> αν μπει νέο copy entry point και δεν μπει scenario: FAIL
```
Αν θέλεις, μπορώ να κάνω και ένα δεύτερο ακόμα πιο πρακτικό διάγραμμα μόνο για το `Batch.Clone` vs `Batch.CopyFrom`, γιατί εκεί φαίνεται πολύ καθαρά η διαφορά ανάμεσα σε “φτιάχνω νέο graph” και “ενημερώνω υπάρχον graph”.

Το `Batch.Clone` και το `Batch.CopyFrom` είναι το καλύτερο ζευγάρι για να δεις τη διαφορά ανάμεσα σε copy-new-object και restore-into-existing-object.
**Διάγραμμα**
```text
A. Batch.Clone
==============
SOURCE
Batch(old)
├─ ProcedureEntries
│  ├─ ProcEntry1(old)
│  │  ├─ Batch --------------------------> Batch(old)
│  │  ├─ MainEquipmentPool -------------> Equipment(external)
│  │  └─ OperationEntries
│  │     ├─ OpEntry1(old)
│  │     │  ├─ ProcedureEntry ----------> ProcEntry1(old)
│  │     │  ├─ AuxEquipmentPool --------> Equipment(external)
│  │     │  ├─ StaffPool ---------------> Staff(external)
│  │     │  ├─ LaborResources ----------> Labor(external)
│  │     │  └─ Streams -----------------> Material(external)
│  │     └─ OpEntry2(old)
│  └─ ProcEntry2(old)
└─ Campaign -----------------------------> Campaign(external)
CLONE()
  │
  └─ δημιουργεί ΝΕΟ graph
RESULT
Batch(clone)
├─ ProcedureEntries                  new list
│  ├─ ProcEntry1(clone)              new object
│  │  ├─ Batch --------------------> Batch(clone)
│  │  └─ OperationEntries           new list
│  │     ├─ OpEntry1(clone)         new object
│  │     │  ├─ ProcedureEntry -----> ProcEntry1(clone)
│  │     │  ├─ Equipment refs -----> SAME external Equipment
│  │     │  ├─ Staff refs ---------> SAME external Staff
│  │     │  ├─ Labor refs ---------> SAME external Labor
│  │     │  └─ Material refs ------> SAME external Material
│  │     └─ OpEntry2(clone)
│  └─ ProcEntry2(clone)
└─ Campaign ------------------------> SAME external Campaign
```
Το νόημα εδώ είναι:
- αλλάζουν τα containers και τα owned παιδιά
- δεν αλλάζουν τα external refs
- το αποτέλεσμα είναι καινούριο `Batch`

---
```text
B. Batch.CopyFrom
=================
Έχουμε 2 graphs:
BACKUP GRAPH
Batch(backup)
├─ ProcedureEntries
│  ├─ ProcEntry1(backup)
│  │  └─ OpEntry1(backup)
│  └─ ProcEntry2(backup)
LIVE GRAPH
Batch(live)
├─ ProcedureEntries
│  ├─ ProcEntry1(live)
│  │  └─ OpEntry1(live)
│  └─ ProcEntry2(live)
Το live graph έχει αλλοιωθεί:
- άλλο MainEquipment
- άλλο AuxEquipment
- άλλο Staff
- άλλο Duration / Start
- άλλο batch metadata
COPYFROM(backup -> live)
  │
  ├─ ΔΕΝ αντικαθιστά το root object
  │     Batch(live) μένει το ίδιο object
  │
  ├─ ΔΕΝ αντικαθιστά τα existing children by position
  │     ProcEntry1(live) μένει το ίδιο object
  │     OpEntry1(live) μένει το ίδιο object
  │
  └─ ξαναγράφει values από το backup πάνω στο live graph
RESULT
Batch(live after restore)
├─ same Batch instance as πριν
├─ same ProcEntry/OpEntry instances as πριν
└─ αλλά values ίσα με του backup
```
**Η βασική διαφορά**
```text
Clone
- φτιάχνει νέο graph
- old object != new object
- old child != new child
CopyFrom
- κρατάει το υπάρχον graph
- input object == ίδιο object μετά
- child objects == ίδια objects μετά
- μόνο τα values / owned contents επανέρχονται
```
**Πώς το βλέπει το framework**
Για `Batch.Clone` το contract λέει ουσιαστικά:
- `ProcedureEntries`, `OperationEntries`, `Streams`, `LaborResources` -> deep copy
- owner refs -> rebound στο νέο graph
- external refs (`Campaign`, `Procedure`, `Equipment`, `Staff`, `Labor`, `Material`) -> shared
Για `Batch.CopyFrom` το framework το μοντελοποιεί έτσι:
- `sourceRoot` = backup graph
- `targetRoot` = το ήδη υπάρχον live batch μετά το `CopyFrom`
- ο verifier δεν ενδιαφέρεται ότι το target υπήρχε πριν
- ενδιαφέρεται ότι μετά το `CopyFrom` η δομή και οι κανόνες του contract ισχύουν
Άρα το test κοιτάει το τελικό post-`CopyFrom` state σαν “copy result”, όχι σαν “brand new object”.
**Μικρό mental model**
```text
Clone     = "create another batch like this one"
CopyFrom  = "restore this batch from snapshot"
```
Αν θέλεις, μπορώ να σου φτιάξω και τρίτο διάγραμμα για `SchedulingBoard.CreateCopy`, που είναι το πιο σύνθετο επειδή έχει και `Campaign -> Batch -> ProcedureEntry -> OperationEntry` και post-changeover rewiring.
## Links
