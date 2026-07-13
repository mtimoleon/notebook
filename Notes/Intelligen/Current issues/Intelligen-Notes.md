---
categories:
  - "[[Work]]"
created: 2026-02-26
product:
component: Docker
tags:
  - documentation/intelligen
---
- [ ] Zlate
1. To track inventory θα φύγει απο το others kai tha paei mesa sto inventory limits me  rename se EnforceInventoryConstraints
2. An capacity einai 0 na mi ginetai save apo inventory limits
3. external transfer mode na mi kanei save an capacity einai 0 kai continues
4. capacity info apagoreyetai save me 0 an inventory limits enforceinventoryConstraints = checked kai external trasnfer mode exei capacity
![[Intelligen-Notes-1783933015143.png|940x493]]


- [ ] NEO 601
![[Intelligen-Notes-1783932714270.png|940x395]]
Na mpei sto BOM sidepanel assign recipe na mpei kai to factor (double  RecipeAmountFactor me initial value des pio kato ). Ta amounts toy input kai out streams toy bom tha polaplasiastoyn me to factor.
An den exei recipe mprosta disabled
Gia to inital value to default value tha einai 0 opote thelei validation gia to recipe.


- [ ] Otan ayjano ta batches enos campaign kai bazei nea prepei to ordering na pairnei timi meta to teleytaio oxi proto.
![[Intelligen-Notes-1783689636440.png|940x496]]



Na mpei sto unscheduleCampaignsFromTo o diaxorismos me to method

- [x] NoAction na g;inei pantoy ClientNoAction
VisibilityOrdering na ginei cascade

- [x] Na diavaso ti diafora NoAction, ClientNoAction

Exo IManyToMany poy exei mesa toy IManyToMany?

DbSet Type, expression 

![[Intelligen-Notes-1783667209181.png|940x551]]

```
        

    const retrieveRecipe = async (recipe, dragPathObject, showBranches, showSections) => {
        let showBranchesLocal = false;
        let showSectionsLocal = false;
        let forceShowSectionsLocal = false;
​
        submitBatchTimeAndValidationStatusRequests();
​
        let recipeContentResponse = await recipeService.getRecipeContentById(recipeId);
​
        let transformedEntityList = [];
        let transformedEntityDictionary = {};
        let retrievedRecipe = null;
​
        // Transform data from the server.
        if (recipeContentResponse.success && recipeContentResponse.successfulResult !== null) {
            retrievedRecipe = recipeContentResponse.successfulResult;
		...
	}​
	
	   
    
    
    
    const submitBatchTimeAndValidationStatusRequests = async () => {
        const [timesResponse, validityResponse] = await Promise.all([
            recipeService.getBatchTimeAndCycleTime(recipeId),
            recipeService.getValidationStatus(recipeId)
        ]);
​
        let batchTime = null;
        let cycleTime = null;
        let validationStatus = null;
​
        // Transform data from the server.
        if (timesResponse && timesResponse.successfulResult !== null) {
​
            batchTime = timesResponse.successfulResult.batchTime;
            cycleTime = timesResponse.successfulResult.cycleTime;
        }
​
        //Transform data from the server.
        if (validityResponse.success && validityResponse.successfulResult !== null)
            validationStatus = validityResponse.successfulResult;
​
        setState(prevState => ({
            ...prevState,
            validationStatus: validationStatus,
            batchTime: batchTime,
            cycleTime: cycleTime
        }))
    }
    
    
                        <div
                        style={{ display: "flex", alignItems: "baseline", gap: "10px" }}
                    >
                        <label className="simple-label">Status</label>
​
                        {state.validationStatus !== null
                            ? state.validationStatus.isValid === true
                                ? <span style={{ color: "#05C706", fontWeight: "bold" }}>
                                    Valid
                                </span>
                                : <span>
                                    <button
                                        type="button"
                                        className={"link " + ((state.activeEntity.type === "validity" && state.activeEntity.id === state.recipe.entity.id) ? "active" : "") + (isEnabledPropertyFunctions.recipeStatusLink() ? "" : " disabled")}
                                        style={{ color: "#E02020", fontWeight: "bold" }}
​
                                        onClick={(event) => {
                                            if ((state.activeEntity.type === "validity" && state.activeEntity.id === state.recipe.entity.id) || !isEnabledPropertyFunctions.recipeStatusLink())
                                                return;
​
                                            handleEntityClick(event, state.recipe, state.recipe.entity.id, "validity");
                                        }}
                                    >
                                        Invalid ({state.validationStatus.validityError.length} {state.validationStatus.validityError.length === 1 ? "error" : "errors"})
                                    </button>
                                </span>
                            : <span></span>
                        }
                    </div>
                    
     
     
                 <RecipeValidityInformationSidePanel
                recipeId={state.activeEntity.type === "validity" ? state.activeEntity.id : null}
                validityError={state.activeEntity.type === "validity" ? state.validationStatus.validityError : []}
​
                onCloseClick={handleSidePanelCloseClick}
            />
​
​
```



# Review Notes για Findings 
​
## Πλαίσιο
Το note αυτό συγκεντρώνει με πλήρη εξήγηση τα τρία βασικά σημεία που προέκυψαν από το review του branch:
​
- branch υπό review: `feature/578-Adaptive-recipes-pt.4`
- base branch: `master`
- merge base: `82ea4e39fbcce72917c692a0f878b05e65d7d5aa`
​
Ο στόχος του note δεν είναι απλώς να πει "υπάρχει bug", αλλά να εξηγήσει:
​
- ποια ακριβώς είναι η ροή του κώδικα
- γιατί η συμπεριφορά που βλέπουμε είναι προβληματική
- πότε το κάθε finding είναι ισχυρό και πότε είναι πιο αδύναμο
- ποια είναι η πρακτική επίπτωση στο scheduling
​

---
​
## Finding 1
​
### Σύντομη διατύπωση
Το branch εισάγει per-equipment recipe-attribute-value configuration με δύο διαφορετικές έννοιες:
​
- ειδικό `ProcessingRate`
- flag `IsIncompatible`
​
Όμως το scheduling χρησιμοποιεί το πρώτο και αγνοεί το δεύτερο. Άρα ένα equipment/value pair που έχει δηλωθεί ως incompatible παραμένει πρακτικά schedulable.
​
### Πού φαίνεται στον κώδικα
Το νέο entity που κρατάει τα per-value στοιχεία του equipment είναι εδώ:
​
- [EquipmentRecipeAttributeValue.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/EquipmentAggregate/EquipmentRecipeAttributeValue.cs)
​
Κρίσιμο πεδίο:
​
```csharp
public bool IsIncompatible { get; private set; }
```
​
Η ανάκτηση του processing rate γίνεται εδώ:
​
- [Equipment.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/EquipmentAggregate/Equipment.cs:323)
​
```csharp
public FlowAmount GetEquipmentProcessingRate(RecipeAttributeValue recipeAttributeValue)
{
    if (recipeAttributeValue != null)
    {
        EquipmentRecipeAttributeValue equipmentRecipeAttributeValue =
            _recipeAttributeValues.FirstOrDefault(rav => rav.RecipeAttributeValue == recipeAttributeValue);
​
        if (equipmentRecipeAttributeValue != null)
            return equipmentRecipeAttributeValue.ProcessingRate;
    }
​
    return ProcessingRate;
}
```
​
Και το rate αυτό χρησιμοποιείται απευθείας στον υπολογισμό duration εδώ:
​
- [OperationEntry.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntry.cs:921)
​
```csharp
durationInRefUnit += ScaledAmountInReferenceUnit / equipment.GetEquipmentProcessingRate(attributeValue).ReferenceUnitValue;
```
​
### Γιατί είναι bug
Το feature μοιάζει να θέλει να υποστηρίξει δύο ξεχωριστούς κανόνες:
​
1. "Για αυτό το attribute value, το equipment τρέχει με διαφορετική ταχύτητα."
2. "Για αυτό το attribute value, το equipment δεν πρέπει να χρησιμοποιείται καθόλου."
​
Στο σημερινό code path εφαρμόζεται μόνο ο πρώτος κανόνας.
​
Η ροή είναι:
​
3. Βρίσκεται το `RecipeAttributeValue` του batch.
4. Ζητείται από το equipment το rate για αυτό το value.
5. Αν υπάρχει override, επιστρέφεται κανονικά.
6. Ο υπολογισμός διάρκειας συνεχίζει.
​
Πουθενά σε αυτό το flow δεν ελέγχεται το `IsIncompatible`.
​
### Παράδειγμα
Έστω:
​
- Recipe Attribute: `Packing Size`
- Values: `200g`, `500g`
- Equipment: `Filler A`
- Batch: έχει `Packing Size = 200g`
​
Ο χρήστης δηλώνει:
​
- `Filler A` + `200g`
  - `ProcessingRate = 300 kg/h`
  - `IsIncompatible = true`
​
Η φυσική ανάγνωση του κανόνα είναι:
​
- το `Filler A` δεν πρέπει να θεωρείται επιτρεπτό για batch με `200g`
​
Αυτό που κάνει τώρα το σύστημα είναι:
​
1. βρίσκει το `200g`
2. καλεί `GetEquipmentProcessingRate(200g)`
3. παίρνει `300 kg/h`
4. συνεχίζει κανονικά το scheduling
​
Άρα το incompatible pair δεν απορρίπτεται. Απλώς διαβάζεται και χρησιμοποιείται το rate του.
​
### Γιατί έχει σημασία
Αυτό είναι καθαρό issue ορθότητας του domain:
​
- ο χρήστης δηλώνει incompatibility
- το σύστημα το αποθηκεύει
- το scheduling το αγνοεί
​
Άρα το UI/API υπόσχεται rule που το domain behavior δεν εφαρμόζει.
​
### Πιθανές κατευθύνσεις για fix
Το fix μπορεί να μπει σε διαφορετικό σημείο, αρκεί να εφαρμοστεί σε scheduling-critical path:
​
1. να αποκλείεται το equipment από τα compatible candidates
2. να απορρίπτεται στο default assignment
3. να απορρίπτεται στο scheduling/duration path
4. να πετάει explicit error όταν ζητηθεί rate για incompatible pair
​
Το κρίσιμο δεν είναι ποιο ακριβώς σημείο θα διαλεγεί. Το κρίσιμο είναι ότι σήμερα το `IsIncompatible` δεν έχει πραγματικό behavioral effect.
​

---
​
## Finding 2
​
### Σύντομη διατύπωση
Το branch αφαίρεσε το παλιό validation που προστάτευε τη σωστή σειρά procedures όταν υπάρχει `MainEquipmentCompatibilityProcedureEntry`, αλλά δεν άλλαξε τον αλγόριθμο default equipment assignment που εξακολουθεί να βασίζεται στο order.
​
Άρα μπορεί πλέον να περάσει configuration που παλιότερα κοβόταν, και μετά το default assignment να καταλήξει σε invalid equipment pairing.
​
### Τι αφαιρέθηκε
Στο `Campaign.Layout()` δεν υπάρχει πια το παλιό validation που προστάτευε αυτό το scenario:
​
- [Campaign.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/CampaignAggregate/Campaign.cs:441)
​
Στο προηγούμενο flow υπήρχε λογικά αυτό:
​
```csharp
if (IsProcedurePrecedenceViolated())
    throw new PlanningDomainException(CampaignError.ProcedureMustPrecedeMaster);
```
​
Η ουσία αυτού του validation ήταν:
​
- αν ένα procedure εξαρτάται από main equipment άλλου procedure
- τότε πρέπει η σειρά να είναι τέτοια ώστε το "master" procedure να είναι ήδη γνωστό όταν γίνεται assign το dependent
​
### Τι παραμένει ίδιο
Ο default assignment αλγόριθμος παραμένει σειριακός:
​
- [Batch.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/BatchAggregate/Batch.cs:275)
​
```csharp
public void AssignDefaultEquipment()
{
    for (int i = 0; i < ProcedureEntries.Count; i++)
    {
        ProcedureEntries[i].UpdateMainEquipment(
            ProcedureEntries[i].GetCompatibleMainEquipment()[0]
        );
    }
}
```
​
Και το compatibility filter ενεργοποιείται μόνο αν το referenced procedure έχει ήδη επιλεγμένο main equipment:
​
- [ProcedureEntry.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/ProcedureEntryAggregate/ProcedureEntry.cs:265)
​
```csharp
if (EnforceMainEquipmentCompatibility && MainEquipmentCompatibilityProcedureEntry.MainEquipment != null)
{
    var referenceEquipment = MainEquipmentCompatibilityProcedureEntry.MainEquipment;
    equipmentList = equipmentList.Where(e => referenceEquipment.IsCompatibleWith(e));
}
```
​
Άρα αν το referenced procedure δεν έχει ακόμα `MainEquipment`, το φίλτρο δεν τρέχει καθόλου.
​
### Παράδειγμα
Έστω δύο procedures:
​
- `Blend`
- `Fill`
​
και ας πούμε ότι:
​
- το `Blend` πρέπει να είναι compatible με το equipment του `Fill`
- αλλά στη σειρά των procedures το `Blend` έρχεται πρώτο
​
Equipment pools:
​
- `Blend`: `Mixer A`, `Mixer B`
- `Fill`: `Filler X`
​
Compatibility:
​
- το `Filler X` είναι compatible μόνο με `Mixer B`
- δεν είναι compatible με `Mixer A`
​
Τι γίνεται τώρα:
​
1. Το `AssignDefaultEquipment()` επεξεργάζεται πρώτο το `Blend`.
2. Το `Blend.GetCompatibleMainEquipment()` κοιτάζει αν το `Fill` έχει ήδη `MainEquipment`.
3. Δεν έχει ακόμα, γιατί δεν έχει γίνει assign.
4. Το compatibility φίλτρο παραλείπεται.
5. Το `Blend` μπορεί να πάρει το πρώτο available equipment, π.χ. `Mixer A`.
6. Μετά το `Fill` παίρνει `Filler X`.
7. Το τελικό pairing είναι incompatible.
​
Με το παλιό validation αυτό το setup κοβόταν νωρίτερα.
​
### Γιατί είναι regression αυτού του branch
Δεν είναι αφηρημένη παρατήρηση πάνω σε παλιό code.
​
Το branch έκανε δύο πράγματα μαζί:
​
1. αφαίρεσε ένα protection rule
2. άφησε ίδιο τον assignment αλγόριθμο που εξακολουθεί να χρειάζεται αυτή την προστασία
​
Άρα έχουμε καθαρή regression εισαγόμενη από αυτή την αλλαγή.
​
### Γιατί έχει σημασία
Το αποτέλεσμα είναι ότι το σύστημα μπορεί:
​
- να μην απορρίπτει invalid procedure configuration
- να παράγει default assignments που εξαρτώνται από τη σειρά
- να δίνει scheduling αποτέλεσμα που παραβιάζει declared compatibility rules
​
### Πιθανά fixes
​
1. επαναφορά του validation
2. redesign του assignment ώστε να λύνει πρώτα τα referenced procedures
3. δεύτερο pass που ξαναφιλτράρει όταν έχουν πλέον γίνει known τα master assignments
​
Αν ζητείται η ελάχιστη ασφαλής διόρθωση, η επαναφορά του validation είναι το πιο άμεσο fix.
​

---
​
## Finding 3
​
### Σύντομη διατύπωση
Το `ScheduleIndependentCampaign()` φαίνεται να εκτελεί scheduling με πιο αδύναμο validation path από άλλα campaign scheduling flows. Αυτό σημαίνει ότι ένα campaign μπορεί να περάσει από scheduling entry point χωρίς να έχει ελεγχθεί το ίδιο σύνολο domain validations που ελέγχεται αλλού.
​
Το σημαντικό caveat είναι ότι στο σημερινό repo δεν βρήκα ξεκάθαρο production call site που να χρησιμοποιεί αυτό το entry point. Άρα το `3` είναι ισχυρό ως inconsistency του domain/API surface, αλλά πιο αδύναμο ως αποδεδειγμένο production bug.
​
### Ποια ήταν η αρχική ανησυχία
Στο branch έχει προστεθεί campaign-level validation που ουσιαστικά απαιτεί η συνταγή του campaign να ταιριάζει με τη συνταγή του BOM:
​
- [Campaign.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/CampaignAggregate/Campaign.cs:1074)
​
Η ύπαρξη αυτού του validation σημαίνει ότι το domain πλέον θεωρεί αυτόν τον έλεγχο απαραίτητο για να είναι το campaign valid πριν γίνει scheduling.
​
Το πρόβλημα που εντοπίστηκε ήταν ότι το `ScheduleIndependentCampaign()` δεν φαίνεται να περνάει από το ίδιο validation flow που περνούν άλλες scheduling ροές.
​
### Πού φαίνεται αυτό στον κώδικα
Το public entry point υπάρχει εδώ:
​
- [ISchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ISchedulingService.cs:16)
​
και η υλοποίηση εδώ:
​
- [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs:166)
​
Η βασική παρατήρηση ήταν ότι στη ροή του `ScheduleIndependentCampaign()` δεν φαίνεται να προηγείται `Campaign.CheckValidationStatus()` με τον ίδιο τρόπο που γίνεται σε άλλα flows όπου το campaign "στήνεται", "γίνεται layout" ή "προετοιμάζεται" πριν το scheduling.
​
Με απλά λόγια:
​
- υπάρχει νέο validation rule στο campaign
- αλλά υπάρχει scheduling entry point που μοιάζει να το παρακάμπτει
​
### Γιατί αυτό είναι πρόβλημα σε επίπεδο design
Ακόμα και αν αγνοήσουμε για λίγο το αν καλείται ή όχι από production code, υπάρχει μια καθαρή ασυνέπεια στο domain surface:
​
1. Το domain δηλώνει ότι κάποια campaigns είναι invalid.
2. Κάποια scheduling flows σέβονται αυτό το invalid state.
3. Τουλάχιστον ένα public scheduling flow φαίνεται να είναι πιο permissive.
​
Αυτό είναι προβληματικό γιατί αφήνει το contract του service ασαφές.
​
Ένας developer που κοιτάζει το `ISchedulingService` εύλογα θα υποθέσει ότι:
​
- όλα τα scheduling methods εφαρμόζουν το ίδιο baseline validation
​
Αν όμως ένα method είναι λιγότερο αυστηρό, τότε:
​
- ή το contract είναι λάθος
- ή λείπει validation
- ή το method είναι intended μόνο για εσωτερική/ειδική χρήση αλλά αυτό δεν είναι ξεκάθαρο από το API
​
### Παράδειγμα για να γίνει πιο συγκεκριμένο
Έστω campaign `C1` με:
​
- `Campaign.Recipe = Recipe A`
- `Bom.Recipe = Recipe B`
​
και ας θεωρήσουμε ότι το νέο domain rule λέει ότι αυτό είναι invalid setup.
​
Τότε υπάρχουν δύο πιθανά scheduling paths:
​
1. Path A:
   - γίνεται πρώτα το validation/lifecycle του campaign
   - το invalid state εντοπίζεται
   - το scheduling απορρίπτεται
​
2. Path B:
   - καλείται `ScheduleIndependentCampaign()`
   - το validation δεν εφαρμόζεται στο ίδιο επίπεδο
   - το scheduling συνεχίζει
​
Αν ισχύει αυτό, τότε το ίδιο invalid campaign:
​
- σε ένα path απορρίπτεται
- σε άλλο path προχωράει
​
Αυτό είναι ασυνέπεια συμπεριφοράς ανεξάρτητα από το αν σήμερα το path B εκτίθεται σε τελικό χρήστη.
​
### Τι έλεγξα για τη χρήση του
Έψαξα τα call sites του `ScheduleIndependentCampaign()`.
​
Το αποτέλεσμα ήταν:
​
- βρέθηκε στο public interface `ISchedulingService`
- βρέθηκε στην υλοποίηση του service
- βρέθηκε σε tests
​
Δεν βρήκα καθαρό production caller όπως:
​
- command handler
- gRPC endpoint
- application service flow
- background job orchestration
​
που να το καλεί άμεσα στο σημερινό codebase.
​
Αυτό είναι πολύ σημαντικό, γιατί αλλάζει το πόσο "βαρύ" είναι το finding.
​
### Τι σημαίνει αυτό για τη βαρύτητα του finding
Το `3` δεν είναι στο ίδιο confidence level με τα `1` και `2`.
​
Για τα `1` και `2` μπορούμε να πούμε:
​
- υπάρχει σαφές code path
- υπάρχει σαφής behavioral επίπτωση
- το branch εισάγει ή αφήνει ενεργό το bug σε ρεαλιστική ροή
​
Για το `3` μπορούμε να πούμε με σιγουριά μόνο ότι:
​
- υπάρχει public scheduling entry point με διαφορετικό validation behavior
​
Αλλά δεν μπορούμε να πούμε με την ίδια σιγουριά ότι:
​
- αυτό το path είναι σήμερα production-reachable από UI/API flow
​
### Άρα είναι bug ή όχι;
Η σωστή απάντηση είναι:
​
- ως domain/API inconsistency: ναι, είναι πραγματική και αξίζει παρατήρηση
- ως high-confidence production regression: όχι με τα σημερινά στοιχεία, δεν είναι τόσο ισχυρό
​
Αν το `ScheduleIndependentCampaign()` είναι όντως intended μόνο για εσωτερική χρήση, tests ή ειδικά controlled scenarios, τότε είναι πιθανό το χαλαρότερο validation να είναι αποδεκτό ή έστω λιγότερο επικίνδυνο.
​
Αν όμως στο μέλλον χρησιμοποιηθεί από πραγματικό application flow, τότε η ασυνέπεια αυτή μπορεί εύκολα να μετατραπεί σε κανονικό production bug.
​
### Πρακτικό συμπέρασμα
Το σωστό framing για το `3` είναι το εξής:
​
- δεν είναι τόσο ισχυρό finding όσο τα `1` και `2`
- δεν το πετάμε τελείως, γιατί δείχνει ασυνέπεια στο domain contract
- αν το review θέλει μόνο αποδεδειγμένα production-impact issues, το `3` μάλλον πρέπει να υποβαθμιστεί ή να μείνει εκτός
- αν το review θέλει και API/domain consistency risks, τότε το `3` αξίζει να μείνει ως χαμηλότερης βαρύτητας παρατήρηση
​
### Τι θα το έκανε ισχυρότερο
Το finding θα γινόταν πολύ πιο ισχυρό αν βρίσκαμε έστω ένα από τα παρακάτω:
​
1. production handler που καλεί `ScheduleIndependentCampaign()`
2. UI/API flow που καταλήγει εκεί
3. test που δείχνει ότι invalid campaign περνάει από εκεί ενώ απορρίπτεται αλλού
4. explicit comment ή contract που λέει ότι το method πρέπει να εφαρμόζει ίδιο validation με τα υπόλοιπα scheduling flows
​
Χωρίς αυτά, το `3` πρέπει να παρουσιάζεται με προσοχή και όχι στο ίδιο severity με τα άλλα δύο.
​

---
​
## Τελικό συμπέρασμα
​
### Για το 1
Ισχυρό behavioral bug. Το branch αποθηκεύει incompatibility rule αλλά το scheduling δεν το εφαρμόζει.
​
### Για το 2
Ισχυρό behavioral bug. Αφαιρέθηκε validation που ο σημερινός assignment αλγόριθμος εξακολουθεί να χρειάζεται.
​
### Για το 3
Πλήρως έγκυρη παρατήρηση ως inconsistency του public scheduling surface, αλλά όχι εξίσου ισχυρό production-impact finding χωρίς επιπλέον απόδειξη ότι το `ScheduleIndependentCampaign()` χρησιμοποιείται από πραγματική εφαρμοστική ροή.
​


```
docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "password" -Q "BACKUP DATABASE [database-name] TO DISK='/var/opt/mssql/backup/keycloak.bak'"
```


Discussion
[BOM-material changes in regard of Storage units, concurrency problems](file:///D:/develop-tasks/Recordings/Recording%202026-05-13%20113639-Storage-uints-BOM-materials-chenges.mp4)

Naming test methods: `<Method name>_<Condition or arrange part of test description>_<Outcome or what we assert>`


Create a new ConsumableUse into production application as inherit from RateUse

![[Intelligen-Notes-1774515864301.png|930x387]]

TimingInfoType = Planning/Tracking/Original
And then we need to implement OriginalAuxiliaryEquipment/Staff in OperationEntry
And then we need to change the scheduling algorithm to take the original



![[Intelligen-Notes-1773318667345.png|719]]

 
> [!IINFO] Docker
> 192.168.56.1 host.docker.internal
> ​192.168.56.1 gateway.docker.internal
> ​127.0.0.1 kubernetes.docker.internal



- Στο library έχουμε useUTC αλλά στο caption text δεν το λαμβάνει υπόψη.
- Νομίζω ότι δείχνεις tooltip και σε break bars; Το θέλουμε αυτό;



Όταν ένα tooltip εμφανίζεται *πάνω* από το element που “hover-άρεις”, μπορεί να “κλέψει” τα pointer events.
Στο δικό σου `Tooltip.jsx` έχεις:
- όταν φαίνεται: `pointerEvents: "auto"` (`WebApps/CommonSpa/libraries/fluidence-gantt/components/Tooltip.jsx:209`)
- όταν κρύβεται: `pointerEvents: "none"`
Τι πάει στραβά:
1) Ο χρήστης έχει τον κέρσορα πάνω σε bar → γίνεται `onPointerMove/onPointerEnter` στο bar και καλείς `tooltipRef.current.show(...)`.
2) Το tooltip εμφανίζεται με `position: fixed` και μεγάλο `z-index` (CSS `z-index: 99999` στο `gantt.css`), άρα μπορεί να βρεθεί *κάτω από τον κέρσορα*.
3) Επειδή έχει `pointer-events: auto`, ο browser θεωρεί ότι τώρα ο κέρσορας είναι “πάνω στο tooltip”, όχι “πάνω στο bar”.
4) Το bar παίρνει `pointerleave` → εσύ καλείς `hide()` στο `onPointerLeave`.
5) Το tooltip εξαφανίζεται, ο κέρσορας ξαναβρίσκεται πάνω στο bar → ξαναεμφανίζεται.
Αυτό δημιουργεί flicker/τρέμουλο και “σπασμένο” hover.
Για tooltips που είναι καθαρά display (όχι clickable), η συνήθης λύση είναι:
- να έχει το tooltip **πάντα** `pointer-events: none` ώστε να μη μπορεί ποτέ να intercept-άρει hover/move/leave από το bar.
Αν κάποια στιγμή θες tooltip με clickable περιεχόμενο, τότε χρειάζεται διαφορετικό interaction model (π.χ. open on click, ή delay + hover state που λαμβάνει υπόψη και tooltip, κτλ.).


**Code quality / Performance**
- onPointerMove καλεί αρκετά “βαριά” computations σε κάθε mouse move (merge/subtract intervals + πολλαπλά getBoundingClientRect) μέσα στο BarChart.jsx (WebApps/CommonSpa/libraries/fluidence-gantt/components/BarChart.jsx:373 και χρήση στο :913), κάτι που μπορεί να κοστίσει σε μεγάλους πίνακες. Συνήθως θες throttle με requestAnimationFrame ή να κάνεις update μόνο όταν αλλάζει target bar / segment.
- Στο Tooltip.jsx χρησιμοποιείς autoUpdate μόνο σαν “scheduler” (ok), αλλά το positioning logic είναι custom και αρκετά “tight” (π.χ. const left = maxLeft; WebApps/CommonSpa/libraries/fluidence-gantt/components/Tooltip.jsx:110) → το tooltip θα “κολλάει” προς μια πλευρά, όχι ιδανικό οπτικά.


​```
c:\Code\ScpCloud>docker compose -f "C:\Code\ScpCloud\docker-compose.yml" -f "C:\Code\ScpCloud\docker-compose. override.yml" -f "C:\Code\ScpCloud\docker-compose.azure.yml" build nosqldata
c:\Code\ScpCloud>docker compose -f "C:\Code\ScpCloud\docker-compose.yml" -f "C:\Code\ScpCloud\docker-compose.override.yml" -f "C:\Code\ScpCloud\docker-compose.azure.yml" build sqldata
c:\Code\ScpCloud>docker compose -f "C:\Code\ScpCloud\docker-compose.yml" - "C:\Code\ScpCloud\docker-compose.override.yml" -f "C:\Code\ScpCloud\docker-compose.azure.yml" build sqldata
```
`docker push scpcloud.azurecr.io/nosqldata`
`az storage file copy --help`
​
`az storage file delete --share-name scpnosqldata-new --path "/_tmp"`




Docker compose command to build BE:

```bash
docker compose  -f "C:\Users\michael\developer\scpCloud\docker-compose.yml" -f "C:\Users\michael\developer\scpCloud\docker-compose.override.yml" -f "C:\Users\michael\developer\scpCloud\obj\Docker\docker-compose.vs.debug.g.yml" -f "C:\Users\michael\developer\scpCloud\docker-compose.vs.debug.yml" -p dockercompose15380257336922976358 --ansi never build admin-api keycloak mssqlscripts nosqldata planning-api production-api rabbitmq sqldata webadminbff webplanningbff webproductionbff
```

και μετά για up:
```shell
docker compose  -f "C:\Users\michael\developer\scpCloud\docker-compose.yml" -f "C:\Users\michael\developer\scpCloud\docker-compose.override.yml" -f "C:\Users\michael\developer\scpCloud\obj\Docker\docker-compose.vs.debug.g.yml" -f "C:\Users\michael\developer\scpCloud\docker-compose.vs.debug.yml" -p dockercompose15380257336922976358 up -d
```

### Μεταβλητή για να μη γράφεις συνέχεια paths
Σε PowerShell:
```
$ComposeFiles = @(​  "-f", "C:\Users\michael\developer\ScpCloud\docker-compose.yml",​  "-f", "C:\Users\michael\developer\ScpCloud\docker-compose.override.yml",​  "-f", "C:\Users\michael\developer\ScpCloud\docker-compose.azure.yml"​)
```
Μετά όλα τα commands γίνονται πιο καθαρά.
### Έλεγχος τελικού merged compose
```
docker compose @ComposeFiles config
```
Για να δεις μόνο το `keycloak` service:
```
docker compose @ComposeFiles config keycloak
```
Κοίτα να έχεις:
```
command:​  - start​  - --optimized
```
και όχι `start-dev`.
### Build
Κανονικό build:
```
docker compose @ComposeFiles build keycloak
```
Force rebuild χωρίς cache:
```
docker compose @ComposeFiles build --no-cache keycloak
```
Με plain progress για να βλέπεις καθαρά το `kc.sh build`:
```
docker compose @ComposeFiles build --no-cache --progress=plain keycloak
```
### Up τοπικά
Build και start:
```
docker compose @ComposeFiles up --build keycloak
```
Force recreate:
```
docker compose @ComposeFiles up --build --force-recreate keycloak
```
Detached mode:
```
docker compose @ComposeFiles up -d --build --force-recreate keycloak
```
### Logs
```
docker compose @ComposeFiles logs -f keycloak
```
Τελευταίες 200 γραμμές:
```
docker compose @ComposeFiles logs --tail=200 keycloak
```
Θες να **μην** βλέπεις αυτό:
```
Changes detected in configuration. Updating the server image.
```
### Show config μέσα από Keycloak
Αν το container τρέχει:
```
docker compose @ComposeFiles exec keycloak /opt/keycloak/bin/kc.sh show-config
```
Αν θες one-off container:
```
docker compose @ComposeFiles run --rm keycloak show-config
```
Έλεγξε ότι υπάρχουν:
```
kc.db = mssql​kc.transaction-xa-enabled = false
```
### Stop / down
Stop χωρίς διαγραφή containers:
```
docker compose @ComposeFiles stop keycloak
```
Down για τα services του compose:
```
docker compose @ComposeFiles down
```
Down και διαγραφή volumes:
```
docker compose @ComposeFiles down -v
```
Προσοχή: το `-v` σβήνει volumes. Αν έχεις local DB volume, θα χαθούν τα δεδομένα.
### Clean μόνο για Keycloak container/image
Σταμάτημα και αφαίρεση container:
```
docker compose @ComposeFiles rm -sf keycloak
```
Καθάρισμα dangling images/build cache:
```
docker builder prune
```
Πιο επιθετικό καθάρισμα build cache:
```
docker builder prune -a
```
Προσοχή: το `-a` πετάει περισσότερη cache και τα επόμενα builds θα αργήσουν.
### Full local clean test
```
docker compose @ComposeFiles down​docker compose @ComposeFiles rm -sf keycloak​docker builder prune -f​docker compose @ComposeFiles build --no-cache --progress=plain keycloak​docker compose @ComposeFiles up --force-recreate keycloak
```
### Push μετά το build
Αν το `image:` είναι δηλωμένο στο compose:
```
docker compose @ComposeFiles push keycloak
```
Αλλιώς με explicit tag:
```
docker tag <local-keycloak-image> <your-registry>.azurecr.io/keycloak:<tag>​docker push <your-registry>.azurecr.io/keycloak:<tag>
```
### Χρήσιμο debug command
Για να δεις ποια env περνάνε τελικά:
```
docker compose @ComposeFiles config | Select-String -Pattern "KC_DB|KC_TRANSACTION_XA_ENABLED|KC_DB_URL|KC_PROXY_HEADERS|command"
```