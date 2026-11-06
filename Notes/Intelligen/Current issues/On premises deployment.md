---
categories:
  - "[[Work]]"
created: 2026-11-03
product: scpCloud
component:
tags:
  - tech/Azure
  - tech/containers
  - topic/license
---
###  Κατεύθυνση
Η κατεύθυνση που προτείνω για το scpCloud On-Premises είναι να δημιουργήσουμε ένα σύστημα εγκατάστασης, ενημερώσεων και αδειοδότησης, αξιοποιώντας τα Docker images που ήδη παράγουμε για το Azure.
Ο βασικός στόχος είναι ο διαχειριστής του πελάτη να μπορεί να εγκαταστήσει την εφαρμογή με ελάχιστες ενέργειες, χωρίς πρόσβαση στον πηγαίο κώδικα.
#### 1. Σύγκριση λύσεων εγκατάστασης

|Λύση|Πλεονεκτήματα|Μειονεκτήματα|
|---|---|---|
|A. Ubuntu VM + Installer|Ευέλικτη, εύκολη συντήρηση|Ο διαχειριστής εγκαθιστά Ubuntu|
|B. Έτοιμο Hyper-V VM (VHDX)|Σχεδόν έτοιμη εγκατάσταση|Μεγαλύτερο αρχείο, διαχείριση VM templates|
|C. PowerShell Installer στο Windows host|Αυτοματοποιεί τη δημιουργία VM και την εγκατάσταση|Περισσότερη αρχική ανάπτυξη|
|D. Docker απευθείας σε Windows|Χωρίς ξεχωριστό VM στη διαχείριση|Περιορισμοί Docker/Windows Server, ειδικά για Linux containers|
Το Ubuntu 24.04 LTS υποστηρίζεται επίσημα ως Hyper-V guest. Επίσης, το Docker Compose υποστηρίζει production deployments σε μεμονωμένους Linux servers.
Microsoft Learn+1
Προτιμώ έναν συνδυασμό B + C: Ένα έτοιμο Ubuntu VM και έναν Windows installer που το εισάγει στο Hyper-V, ζητά τις απαραίτητες ρυθμίσεις και ολοκληρώνει την εγκατάσταση.
Η λύση A παραμένει εναλλακτική για πελάτες που διαθέτουν ήδη Linux server ή διαφορετικό hypervisor.
#### 2. Πώς θα λειτουργεί η διανομή
						scpCloud Build Server
			Build όλων των Docker images και δημιουργία αριθμημένης έκδοσης  ->								

						Private Release Server
			Αποθήκευση εκδόσεων, έλεγχος licenses και διανομή updates  ->
			
					Customer's Windows Server / Hyper-V
					Ubuntu VM → Docker Compose → scpCloud

Ο πελάτης δεν κάνει ποτέ build. Κατεβάζει έτοιμες, ελεγμένες εκδόσεις. Μπορούμε να συνεχίσουμε να χρησιμοποιούμε το ACR ως αποθηκευτικό χώρο, αλλά η πρόσβαση στις εκδόσεις πρέπει να ελέγχεται από το δικό μας σύστημα.
#### 3. Licensing και updates
Προτείνω το license να καθορίζει δικαίωμα ενημερώσεων, όχι ημερομηνία λήξης λειτουργίας της εφαρμογής.
Για παράδειγμα:
		scpCloud License                                                                             Active
		Εγκατεστημένη έκδοση  Updates έως 
			2.4.1                         31/12/2027
		Λειτουργία εφαρμογής    Νεότερη έκδοση
		Απεριόριστη                 2.5.0

Μετά τη λήξη, η 2.4.1 παραμένει λειτουργική. Νέα έκδοση εγκαθίσταται μόνο με ανανέωση του δικαιώματος ενημερώσεων.
Το σύστημα πρέπει να υποστηρίζει υπογεγραμμένα licenses, ταυτοποίηση εγκατάστασης και επανεγκατάσταση της τελευταίας δικαιούμενης έκδοσης. Δεν θα βασιζόμουν μόνο σε credentials του ACR, επειδή τα repository-scoped tokens δεν περιορίζουν την πρόσβαση ανά image tag.
Microsoft Learn
#### 4. Εγκατάσταση και διαχείριση
Θα δημιουργούσα ένα μικρό scpCloud Management Portal, διαθέσιμο τοπικά, που θα επιτρέπει στον διαχειριστή:
- Αρχική ενεργοποίηση license και configuration.
- Προβολή εγκατεστημένης και διαθέσιμης έκδοσης.
- Update με έλεγχο συμβατότητας και δυνατότητα rollback.
- Backup και restore βάσης δεδομένων.
- Έλεγχο λειτουργίας των containers.
Θα υποστήριζα επίσης offline updates με υπογεγραμμένα πακέτα για εγκαταστάσεις χωρίς Internet.
#### 5. Σημαντικά σημεία που πρέπει να εξετάσουμε
1. Azure dependencies: Πρέπει να εξακριβώσουμε αν το scpCloud απαιτεί Azure SQL, Storage, Service Bus ή άλλες υπηρεσίες. Το Docker packaging από μόνο του δεν εγγυάται αυτόνομη on-premises λειτουργία.
2. Database migrations: Τα updates πρέπει να αντιμετωπίζουν migrations και backup, όχι μόνο αντικατάσταση containers.
3. Persistent data: Τα δεδομένα πρέπει να διαχωριστούν από την εφαρμογή, ώστε η αναβάθμιση ή αντικατάσταση του VM να μην τα καταστρέφει.
4. Security: Υπογεγραμμένα releases, ασφαλής αποθήκευση secrets και TLS. Σε VM που ελέγχει πλήρως ο πελάτης, δεν μπορεί να εξασφαλιστεί απόλυτη προστασία από αντιγραφή.
5. Versioning: Κάθε release να περιλαμβάνει συγκεκριμένες εκδόσεις όλων των containers, configuration και database schema.
#### 6. Προτεινόμενη πορεία
Θα χώριζα το έργο σε τρεις φάσεις:
1. On-Premises Runtime: Να λειτουργήσει ολόκληρο το scpCloud σε Ubuntu VM με Docker Compose, χωρίς Azure runtime dependencies.
2. Distribution: Να δημιουργήσουμε έτοιμο VM, installer και μηχανισμό εγκατάστασης/αναβάθμισης.
3. Licensing: Να υλοποιήσουμε license server, update entitlement και release management.
Το πρώτο που πρέπει να εξετάσουμε στο repository είναι ποιες εξαρτήσεις έχει σήμερα η εφαρμογή από το Azure, ιδιαίτερα για βάση δεδομένων, storage, authentication και messaging. Αυτό θα καθορίσει πόσο εύκολα μπορούμε να μεταφέρουμε το υπάρχον deployment σε on-premises περιβάλλον.


### Επιμέρους θέματα
#### Αλλαγή SPA url

 Εξήγησε μου λίγο τις αλλαγές για τα `let url = window.__SCP_CONFIG__?.BFF_BASE_URL ?? import.meta.env.VITE_BFF_BASE_URL;` γιατί το κάναμε έτσι; 

Το κάναμε για να μπορεί το ίδιο SPA image να λειτουργεί σε διαφορετικούς πελάτες χωρίς νέο build.
Πριν:
```
let url = import.meta.env.VITE_BFF_BASE_URL;
```
Το `import.meta.env` αντικαθίσταται από το Vite κατά το build. Άρα το URL «κλειδώνει» μέσα στο JavaScript image. Κάθε διαφορετικό customer hostname θα απαιτούσε νέο build.
Τώρα η σειρά προτεραιότητας είναι:
1. `window.__SCP_CONFIG__.BFF_BASE_URL`: runtime τιμή του συγκεκριμένου VM.
2. `import.meta.env.VITE_BFF_BASE_URL`: build-time fallback για Azure/development.
3. Το υπάρχον hostname/port fallback, αν και τα δύο λείπουν.
Το [runtime-config.js](C:/Users/michael/developer/scpCloud/WebApps/WebPlanningSpa/public/runtime-config.js) φορτώνεται πριν από το SPA. Κατά την εκκίνηση του on-premises container, το [40-runtime-config.sh](C:/Users/michael/developer/scpCloud/WebApps/CommonSpa/OnPremises/40-runtime-config.sh) το ξαναγράφει:
```
window.__SCP_CONFIG__ = {
    BFF_BASE_URL: "http://planning.scpcloud.customer.internal/bff",
    KEYCLOAK_URL: "http://identity.scpcloud.customer.internal"
};
```
Το `?.` αποφεύγει σφάλμα όταν δεν υπάρχει `__SCP_CONFIG__`. Το `??` χρησιμοποιεί το Vite URL μόνο όταν η runtime τιμή είναι `null` ή `undefined`.
Έτσι:
- Τα Azure/development builds συνεχίζουν να χρησιμοποιούν τα υπάρχοντα Vite variables.
- Τα on-premises images παίρνουν URLs κατά την εκκίνηση από Compose.
- Δεν χρειάζεται διαφορετικό SPA build για κάθε πελάτη.
- Δεν αποθηκεύονται secrets· πρόκειται μόνο για δημόσια browser URLs.



