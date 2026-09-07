
Το βασικό που πρέπει να κρατήσεις είναι ότι **δεν έχουμε απλώς “3 μοντέλα”**. Έχουμε ένα μικρό ensemble από **5 βασικούς ML scorers**, και πάνω σε αυτούς έχουμε φτιάξει **3 διαφορετικά trading rules/policies**: Aggressive, Balanced και Quality.
Παρακάτω είναι ο πρακτικός οδηγός του **Absolute V1**.

---
# 1. Τι προσπαθεί να κάνει όλο το σύστημα
Το πρόβλημα είναι:
> Στα **150ms από το anchor**, έχω αρκετή πληροφορία ώστε να αποφασίσω αν αξίζει να στείλω BUY, γνωρίζοντας ότι η πραγματική αγορά θα γίνει περίπου στο **slot N+1**;
Δεν περιμένουμε πλέον το Stage3 `+1.3 RealSOL`, γιατί τότε η πληροφορία έρχεται αργά. Προσπαθούμε να **προβλέψουμε νωρίτερα** αν η κατάσταση που βλέπουμε στα πρώτα 150ms είναι καλή.
Το μοντέλο βλέπει αποκλειστικά πληροφορία που υπάρχει έως το Stage2 @150ms. Η οικονομική αξιολόγηση γίνεται με exact replay **Stage2 → entry N+1**, buy `0.075 SOL`, και όχι με το ιδανικό same-slot Shadow.
Η αλυσίδα είναι ουσιαστικά:
```text
Mint εμφανίζεται
       ↓
Μαζεύουμε δεδομένα 0–150ms
       ↓
Υπολογίζονται features
       ↓
5 base ML scorers
       ↓
Aggressive / Balanced / Quality score
       ↓
score >= fixed threshold του regime;
       ↓
     BUY N+1
```
Το **Shadow δεν είναι μέρος αυτής της απόφασης**. Το κρατάμε μόνο σαν benchmark.

---
# 2. Τι μοντέλα είναι αυτά τεχνικά
Χρησιμοποιούμε κυρίως **LightGBM classifiers** και έναν **XGBoost classifier**. Είναι gradient-boosted decision trees.
Απλά: αντί να προσπαθεί ένα τεράστιο δέντρο να μάθει τα πάντα, εκπαιδεύονται διαδοχικά πολλά μικρά δέντρα. Κάθε νέο δέντρο προσπαθεί να διορθώσει τα λάθη των προηγούμενων.
Για τέτοια δεδομένα είναι καλή επιλογή γιατί:
- χειρίζονται πολύ καλά tabular/numerical features,
- βρίσκουν μη γραμμικές σχέσεις,
- βρίσκουν αλληλεπιδράσεις μεταξύ features,
- δεν χρειάζονται normalization όπως ένα neural network,
- μπορούν π.χ. να μάθουν ότι `rSOL slope` είναι καλό **μόνο όταν** το `buyer delay` και το `spot change` βρίσκονται σε συγκεκριμένη περιοχή.
Δεν τους λέμε απλά:
```text
rSOL > X → BUY
```
Μπορούν να μάθουν κάτι σαν:
```text
αν rSOL ανεβαίνει γρήγορα
AND η καμπύλη έχει αρκετά positive steps
AND ο πρώτος buyer ήρθε γρήγορα
AND ο creator δεν έχει ύποπτη προηγούμενη δραστηριότητα
AND η αγορά δεν έχει ήδη τρέξει υπερβολικά
→ αυξάνεται η πιθανότητα να είναι καλό entry
```
χωρίς να γράψουμε εμείς αυτόν τον κανόνα.

---
# 3. Οι 5 βασικοί scorers
Αυτό είναι ίσως το σημαντικότερο κομμάτι για να καταλάβεις τι φτιάξαμε.
## `fp_econ`
LightGBM classifier με target:
```text
pnl_sol > 0
```
Άρα προσπαθεί να προβλέψει:
> «Αν αγοράσω αυτό το mint τώρα με το N+1 execution model, θα καταλήξει θετικό το trade;»
Όμως υπάρχει μία διαφορά: τα trades έχουν **weight ανάλογα με το οικονομικό μέγεθος του PnL**.
Ένα trade `+0.020 SOL` έχει μεγαλύτερη σημασία στην εκπαίδευση από ένα `+0.0002 SOL`. Το ίδιο και ένα μεγάλο loss.
Γι' αυτό το λέμε **economic classifier**.
Δεν προσπαθεί απλώς να ανεβάσει το WR. Προσπαθεί να μάθει καλύτερα τα trades που **έχουν οικονομική σημασία**.
Αυτός είναι ο βασικός λόγος που το Aggressive μπορεί να έχει χαμηλό WR αλλά καλό PnL.

---
## `fp_win`
Επίσης LightGBM:
```text
target = pnl_sol > 0
```
Αλλά χωρίς το economic weighting.
Εδώ κάθε trade έχει περισσότερο ίση σημασία:
```text
+0.0002 SOL win
```
και
```text
+0.020 SOL win
```
είναι και τα δύο wins.
Άρα αυτό το head ενδιαφέρεται περισσότερο για:
> «Πόσο πιθανό είναι αυτό το trade απλώς να κλείσει θετικό;»
Αυτό βοηθά περισσότερο το WR.

---
## `fp_sig`
LightGBM με διαφορετικό target:
```text
eligible_stage3_label
```
δηλαδή:
```text
θα φτάσει +1.3 RealSOL μέσα σε 2 sec;
```
Αυτό **δεν προβλέπει PnL**.
Προβλέπει momentum / μελλοντική επιβεβαίωση.
Ρωτά ουσιαστικά:
> «Από αυτά που βλέπω στα πρώτα 150ms, φαίνεται ότι αργότερα θα εμφανιστεί το γνωστό καλό +1.3 RealSOL signal;»
Είναι σημαντικό γιατί ξέρουμε ότι το `+1.3` έχει πληροφορία, απλώς όταν το περιμένουμε κανονικά φτάνουμε αργά.

---
## `fp_good`
LightGBM με αυστηρότερο target:
```text
pnl_sol > 0
AND
eligible_stage3_label == 1
```
Άρα πρέπει να συμβούν **και τα δύο**:
1. να εμφανιστεί το +1.3,
2. και το πραγματικό N+1 trade να βγει κερδοφόρο.
Αυτό είναι το πιο «quality oriented» head.
Δεν του αρκεί:
```text
είδα momentum
```
ούτε:
```text
βγήκε οριακά θετικό trade
```
Θέλει:
```text
σωστό momentum + σωστό οικονομικό αποτέλεσμα
```

---
## `fp_xgbwin`
Είναι XGBoost και προβλέπει πάλι:
```text
pnl_sol > 0
```
Γιατί έχουμε και δεύτερο algorithm;
Για **diversification του λάθους**.
LightGBM και XGBoost είναι συγγενείς τεχνικές αλλά δεν κατασκευάζουν ακριβώς τα ίδια δέντρα. Αν δύο διαφορετικά algorithms συμφωνούν για ένα trade, η πληροφορία μπορεί να είναι πιο ανθεκτική.
Τα πέντε heads και οι ακριβείς frozen παράμετροί τους είναι καταγεγραμμένα στο Absolute V1 handoff.

---
# 4. Προσοχή: τα scores δεν είναι χρήματα
Αν δεις:
```text
fp_win = 0.72
```
δεν πρέπει να το διαβάζεις αυστηρά ως:
> «Έχει ακριβώς 72% πιθανότητα να κερδίσει».
Τα tree classifiers επιστρέφουν probability-like scores, αλλά εμείς κυρίως τα χρησιμοποιούμε ως **ranking/selection scores**.
Το σημαντικό είναι:
```text
0.72 > 0.55
```
άρα το πρώτο mint μοιάζει καλύτερο σύμφωνα με το συγκεκριμένο model.
Το ίδιο ισχύει και για τα composite scores.

---
# 5. Τα 3 trading rules
Τα τρία «μοντέλα» που λέμε στην καθημερινή συζήτηση είναι στην πραγματικότητα **τρεις διαφορετικοί συνδυασμοί των παραπάνω heads**.
## Aggressive
```text
Aggressive =
0.90 × fp_econ
+ 0.05 × fp_xgbwin
+ 0.05 × fp_sig
```
Δηλαδή το **90% της απόφασης** έρχεται από το economically weighted model.
Η λογική είναι:
> «Προτεραιότητα στο συνολικό οικονομικό edge. Δεν με νοιάζει τόσο αν θα έχω υψηλό WR.»
Γι' αυτό μπορεί να βλέπεις:
```text
WR 30–36%
```
και παρ' όλα αυτά θετικό PnL.
Τα absolute thresholds είναι:

|Regime|BUY αν score ≥|
|---|--:|
|09–14|**0.463084380**|
|14–23|**0.469837931**|
|23–09|**0.528385514**|

---
# 6. Balanced
```text
Balanced =
0.45 × fp_econ
+ 0.45 × fp_win
+ 0.10 × fp_good
```
Εδώ έχουμε σχεδόν ίσο βάρος:
```text
οικονομικό αποτέλεσμα
+
πιθανότητα win
```
και λίγο joint-quality confirmation.
Η φιλοσοφία είναι:
> «Θέλω αρκετό PnL αλλά δεν θέλω να πληρώσω με πολύ χαμηλό WR.»
Thresholds:

|Regime|BUY αν score ≥|
|---|--:|
|09–14|**0.459770601**|
|14–23|**0.486455639**|
|23–09|**0.527949388**|

---
# 7. Quality
```text
Quality =
0.10 × fp_econ
+ 0.30 × fp_win
+ 0.60 × fp_good
```
Εδώ το `fp_good` έχει το 60%.
Άρα ζητά κυρίως:
> «Βρες μου trades που μοιάζουν ταυτόχρονα με μελλοντικό +1.3 signal και με πραγματικό profitable N+1 trade.»
Thresholds:

|Regime|BUY αν score ≥|
|---|--:|
|09–14|**0.422874029**|
|14–23|**0.442877715**|
|23–09|**0.428179368**|
Μην συγκρίνεις π.χ.:
```text
Aggressive threshold 0.528
Quality threshold 0.428
```
και συμπεράνεις ότι το Quality είναι πιο χαλαρό.
**Δεν είναι η ίδια κλίμακα**, επειδή η formula είναι διαφορετική.

---
# 8. Γιατί μπορεί το Aggressive να κερδίζει με WR 30%;
Εδώ είναι βασική trading θεωρία.
Το WR μόνο του δεν λέει σχεδόν τίποτα χωρίς το μέγεθος winners/losses.
Αν έχεις:
```text
3 wins × +10 = +30
7 losses × -2 = -14
```
έχεις:
```text
WR = 30%
PnL = +16
```
Το αντίθετο:
```text
6 wins × +1 = +6
4 losses × -3 = -12
```
έχει:
```text
WR = 60%
PnL = -6
```
Αυτό ακριβώς είδαμε στο DB29: το Quality είχε **54.55% WR αλλά -0.0485 SOL**, ενώ το Aggressive είχε μόλις **25.76% WR αλλά +0.0388 SOL**.
Άρα για μας η σειρά προτεραιότητας πρέπει να είναι περίπου:
```text
PnL
PF
PnL/trade
Drawdown
WR
```
όχι WR πρώτο.

---
# 9. Τα features — τα βασικά 14
Αυτά είναι τα `current14`.

|Feature|Απλή έννοια|
|---|---|
|`max_gain_seen_150_pct`|Πόσο ψηλά είχε καταφέρει να φτάσει ήδη η τιμή μέσα στα πρώτα 150ms.|
|`spot_change_anchor_150_pct`|Μεταβολή spot price από το anchor μέχρι τα 150ms.|
|`rsol_150_sol`|RealSOL reserves ακριβώς γύρω στο Stage2. Πραγματική κατάσταση της curve.|
|`creator_prior_exact111_mints_1h`|Πόσα αντίστοιχα προηγούμενα mints είχε ο creator την τελευταία ώρα. Δείκτης συμπεριφοράς creator.|
|`vsol_delta_anchor_150_sol`|Πόσο άλλαξε το VirtualSOL από anchor μέχρι 150ms.|
|`rsol_delta_anchor_150_sol`|Πόσο πραγματικό SOL μπήκε/βγήκε από την curve μέχρι τα 150ms. Πολύ σημαντικό momentum feature.|
|`creator_prior_exact111_mints_10m`|Το ίδιο creator-history αλλά πολύ βραχυπρόθεσμα, τελευταία 10 λεπτά.|
|`abs_step_sum_pct_150`|Συνολική κίνηση της τιμής, ανεξάρτητα αν ήταν πάνω ή κάτω. Μετρά «νευρικότητα/δραστηριότητα» της διαδρομής.|
|`vsol_150_sol`|Απόλυτο VirtualSOL level στα 150ms.|
|`intent_exact_quote_buy_sol`|Πόσο SOL αντιστοιχεί στο priced BUY intent που βλέπουμε.|
|`buyer1_first_intent_priced_sol`|Μέγεθος του πρώτου buyer intent όταν μπορέσαμε να το τιμολογήσουμε.|
|`buy_sol_150`|Συνολικό BUY flow που έχει εμφανιστεί μέχρι τα 150ms.|
|`buyer1_delay_ms`|Πόσο γρήγορα μετά το anchor εμφανίστηκε ο πρώτος buyer.|
|`external_top50pct_wallets_priced_sol_share`|Μέτρο συγκέντρωσης του external buying: πόσο μέρος του flow προέρχεται από το ισχυρότερο τμήμα των wallets.|
Δεν είναι κανένα από αυτά «μαγικό» μόνο του.
Το edge προέρχεται περισσότερο από συνδυασμούς.

---
# 10. Τα trajectory features — το σημαντικό νέο κομμάτι
Τα current14 λένε αρκετά για την κατάσταση στα 150ms.
Όμως υπήρχε ένα πρόβλημα:
```text
δύο mints μπορεί να έχουν rSOL=2.0 στα 150ms
```
αλλά να έχουν φτάσει εκεί εντελώς διαφορετικά.
Παράδειγμα:
```text
Mint A:
0.5 → 0.8 → 1.1 → 1.4 → 1.7 → 2.0
```
καθαρή ανοδική κίνηση.
Mint B:
```text
0.5 → 2.5 → 1.3 → 2.2 → 1.5 → 2.0
```
ίδιο τελικό `rSOL`, εντελώς διαφορετική συμπεριφορά.
Γι' αυτό προσθέσαμε τα **curve trajectory features**.
Για RealSOL και VirtualSOL έχουμε μεταξύ άλλων:

|Trajectory feature|Τι λέει|
|---|---|
|`count`|Πόσα curve observations είχαμε.|
|`start`|Από πού ξεκίνησε.|
|`end`|Πού βρίσκεται στα 150ms.|
|`delta`|Συνολική μεταβολή.|
|`range`|Απόσταση μεταξύ minimum και maximum.|
|`mean`|Μέσο επίπεδο στο window.|
|`std`|Πόσο ασταθής ήταν η κίνηση.|
|`at_25ms`|Τιμή περίπου στα 25ms.|
|`at_50ms`|Τιμή περίπου στα 50ms.|
|`at_75ms`|Τιμή περίπου στα 75ms.|
|`at_100ms`|Τιμή περίπου στα 100ms.|
|`at_125ms`|Τιμή περίπου στα 125ms.|
|`at_150ms`|Τιμή στο τέλος.|
|`delta_25ms` κ.λπ.|Πόσο είχε ήδη αλλάξει μέχρι κάθε checkpoint.|
|`abs_step_sum`|Πόση συνολική κίνηση έγινε στην πορεία.|
|`pos_steps`|Πόσα updates κινήθηκαν θετικά.|
|`neg_steps`|Πόσα κινήθηκαν αρνητικά.|
|`max_pos_step`|Μεγαλύτερο μεμονωμένο ανοδικό jump.|
|`max_neg_step_abs`|Μεγαλύτερη μεμονωμένη πτώση.|
|`slope_per_ms`|Μέση ταχύτητα κατεύθυνσης της curve.|
Αυτά υπάρχουν ως `wide_curve_rsol_*` και αντίστοιχα `wide_curve_vsol_*`.
Και είναι **causal**: χρησιμοποιούν μόνο observations από το anchor έως τα 150ms.

---
# 11. Τα δύο feature sets `r` και `rv`
Το `r` περιλαμβάνει:
```text
current14
+ RealSOL trajectory
+ stage2_p_dead
+ baseline_real_sol
```
Το `rv` περιλαμβάνει:
```text
όλα του r
+ VirtualSOL trajectory
```
### `stage2_p_dead`
Είναι η υπάρχουσα εκτίμηση του Stage2 dead-filter.
Απλά:
> «Πόσο dead μοιάζει ήδη αυτό το mint σύμφωνα με το προηγούμενο Stage2 model;»
Δεν χρειάζεται το νέο model να ξαναμάθει από το μηδέν ό,τι ήδη ξέρει το Stage2.
### `baseline_real_sol`
Είναι το RealSOL επίπεδο αναφοράς από το οποίο μετράμε τη μεταγενέστερη κίνηση.
Χωρίς baseline, το:
```text
+0.8 SOL
```
δεν έχει σωστή έννοια ως trajectory.

---
# 12. Γιατί το `fp_sig` χρησιμοποιεί μόνο `r`, ενώ τα άλλα `rv`
Εμπειρικά η **RealSOL trajectory** είχε την πιο χρήσιμη πληροφορία για το μελλοντικό `+1.3`.
Για την οικονομική έκβαση του trade, όμως, και η ευρύτερη κατάσταση της curve, συμπεριλαμβανομένου του VirtualSOL, πρόσθετε πληροφορία.
Γι' αυτό:
```text
fp_sig → r
```
ενώ:
```text
fp_econ
fp_win
fp_good
fp_xgbwin
→ rv
```

---
# 13. Γιατί υπάρχουν διαφορετικά models ανά regime
Δεν έχουμε απαραίτητα την ίδια αγορά στις 03:00 και στις 17:00.
Αλλάζουν:
- activity,
- trader mix,
- order flow,
- volume,
- launch frequency,
- latency competition,
- πιθανότητα fast pumps,
- ποιότητα των incoming mints.
Γι' αυτό το Absolute V1 έχει **ξεχωριστά frozen model instances ανά regime**.
Η παρούσα διαίρεση είναι:
```text
09:00–14:00
14:00–23:00
23:00–09:00
```
και το training/calibration έγινε χρονολογικά:

|Regime|Train|Calibration|
|---|---|---|
|23–09|DB18–23|DB24|
|09–14|DB18–24|DB25|
|14–23|DB18–26|DB27|
Άρα πρακτικά υπάρχουν διαφορετικά fitted trees για κάθε regime, παρότι η formula `Aggressive = 0.90 econ + ...` παραμένει ίδια.

---
# 14. Τι είναι training, validation/calibration και OOS
Αυτό πρέπει να το κρατήσουμε αυστηρά γιατί αλλιώς μπορούμε πολύ εύκολα να κοροϊδέψουμε τον εαυτό μας.
## Training
Στο training δίνουμε στο model:
```text
features + πραγματικό outcome
```
και μαθαίνει.
Παράδειγμα:
```text
features στα 150ms
→ τελικά το N+1 trade ήταν +0.006 SOL
```
Αυτό μπορεί να χρησιμοποιηθεί για να αλλάξουν τα δέντρα.

---
## Validation / development
Εδώ δοκιμάζουμε επιλογές όπως:
- ποια features,
- ποια model architecture,
- ποια weights,
- ποια formula,
- ποια selection aggressiveness.
Αν δούμε το αποτέλεσμα και αλλάξουμε κάτι εξαιτίας του, **αυτό το dataset παύει να είναι OOS**.
Γίνεται development data.
Γι' αυτό τα DB21–27 είναι πλέον development.

---
# 15. Calibration
Αφού έχουμε model και policy, πρέπει να αποφασίσουμε:
```text
πάνω από ποιο score αγοράζω;
```
Παλιά κάναμε:
```text
πάρε το top 5% της νέας DB
```
Αυτό ήταν λάθος για production, γιατί πρέπει να ξέρεις πρώτα όλη τη μελλοντική DB.
Τώρα έχουμε:
```text
score >= 0.528385514
```
π.χ. για Aggressive 23–09.
Αυτό μπορεί να αποφασιστεί **εκείνη τη στιγμή**, χωρίς καμία γνώση του μέλλοντος.
Τα absolute thresholds παγώθηκαν από προηγούμενα calibration δεδομένα και στη νέα DB δεν γίνεται κανένα percentile ή νέο fitting.

---
# 16. Τι είναι πραγματικό OOS
OOS σημαίνει:
> Το dataset δεν το έχω κοιτάξει καθόλου όταν αποφασίζω model, threshold, formula ή rule.
Η σωστή διαδικασία είναι:
```text
Freeze V1
     ↓
έρχεται DB30
     ↓
τρέχω V1 χωρίς καμία αλλαγή
     ↓
γράφονται selections
     ↓
ΜΟΝΟ μετά κοιτάζω PnL
```
DB28 και DB29 δεν χρησιμοποιήθηκαν για fitting του Absolute V1, αλλά είχαμε ήδη δει τα αποτελέσματά τους ενώ διορθώναμε τη μεθοδολογία. Γι' αυτό τα θεωρούμε **retrospective validation**.
Το επόμενο εντελώς untouched DB μετά το freeze είναι η πραγματική δοκιμή.

---
# 17. Πότε ΔΕΝ κάνουμε retrain
Δεν κάνουμε retrain επειδή:
```text
χάσαμε σήμερα
```
ή επειδή:
```text
το WR έπεσε 5%
```
Αν το κάνουμε αυτό, θα κυνηγάμε συνεχώς noise.
Ένα model μπορεί απολύτως φυσιολογικά να έχει:
```text
καλή μέρα
κακή μέρα
πολύ καλή μέρα
δύο κακές
```
και συνολικά να έχει edge.
Μια βάση μόνη της **δεν είναι λόγος retraining**.

---
# 18. Πότε αρχίζω να υποψιάζομαι ότι θέλει adjustment
Θα κοιτάζω πρώτα τέσσερα πράγματα:
### 1. Economic performance
Αν για αρκετό νέο sample έχουμε:
```text
PF <= 1
PnL/trade <= 0
cumulative PnL <= 0
```
υπάρχει πρόβλημα.
### 2. Selection-rate drift
Παράδειγμα:
historically το Aggressive 23–09 επιλέγει περίπου λίγα % της population.
Ξαφνικά επί μέρες επιλέγει:
```text
15–20%
```
ή:
```text
0.1%
```
χωρίς να αλλάξαμε threshold.
Αυτό σημαίνει ότι η distribution των scores έχει μετακινηθεί.
### 3. Score quality
Θέλουμε τα high-score trades να εξακολουθούν να είναι καλύτερα από τα lower-score trades.
Αν:
```text
score 0.70
```
δεν είναι πλέον καλύτερο κατά μέσο όρο από:
```text
score 0.50
```
τότε δεν έχουμε απλώς calibration drift. Έχει χαλάσει το ίδιο το ranking.
### 4. Feature drift
Αν ξαφνικά αλλάξουν πολύ:
```text
rSOL trajectories
buyer delays
buy sizes
creator activity
curve step distributions
```
η αγορά που βλέπει το model δεν μοιάζει πια με αυτήν στην οποία εκπαιδεύτηκε.

---
# 19. Πρακτικός κανόνας retraining
Εγώ θα χρησιμοποιούσα αυτό σαν operating rule:
**Δεν αγγίζουμε model για ένα κακό regime ή μία κακή DB.**
Αρχίζουμε investigation όταν έχουμε περίπου:
```text
2–3 συνεχόμενα συγκρίσιμα regime windows
και τουλάχιστον ~100 selected trades
```
με σαφή deterioration.
Για πραγματική απόφαση retrain, εκτός αν υπάρχει προφανές structural bug, θα ήθελα περισσότερο:
```text
~300–500 selected trades
```
και επίμονη ένδειξη:
```text
PF <= 1
ή
αρνητικό PnL/trade
ή
σοβαρό score/feature drift
```
Αυτά είναι operational guardrails, όχι μαθηματικοί νόμοι.

---
# 20. Threshold adjustment ή ολόκληρο retrain;
Δεν είναι πάντα το ίδιο πρόβλημα.
### Περίπτωση Α — το ranking παραμένει καλό
Τα υψηλά scores παραμένουν τα καλύτερα trades, αλλά το model επιλέγει υπερβολικά πολλά ή λίγα.
Τότε μπορεί να χρειάζεται μόνο:
```text
threshold recalibration
```
όχι retraining.
Θα γίνει π.χ. νέα:
```text
Absolute V1.1
```
και θα χρειαστεί νέο untouched OOS μετά.
### Περίπτωση Β — το ranking χάλασε
Αν τα high scores δεν έχουν πλέον καλύτερο PnL:
```text
retrain
```
πιθανότατα χρειάζεται νέα έκδοση:
```text
Absolute V2
```
### Περίπτωση Γ — άλλαξε το regime
Αν επιβεβαιωθεί π.χ.:
```text
09:00–14:30 κακό
14:30+ καλό
```
δεν αλλάζουμε κρυφά το `14:00`.
Φτιάχνουμε νέα έκδοση με boundary `14:30` και μετά νέο OOS.

---
# 21. Πώς γίνεται σωστό retrain
Όταν έρθει η ώρα:
```text
V1 δουλεύει μέχρι DB40
```
και αποφασίσουμε ότι θέλουμε V2.
Τότε τα παλιά OOS:
```text
DB30…DB40
```
μπορούν πλέον να μπουν στο **development/training history**.
Αλλά πρέπει να κρατήσουμε κάτι νεότερο που το V2 **δεν θα δει ποτέ**.
Παράδειγμα:
```text
Train: DB18–38
Calibration: DB39
Validation/dev: DB40
FREEZE V2
OOS: DB41+
```
Το ακριβές split μπορεί να αλλάξει, αλλά η αρχή δεν αλλάζει ποτέ:
> Δεν βελτιώνω το model πάνω στο ίδιο dataset στο οποίο μετά ισχυρίζομαι ότι το δοκίμασα.

---
# 22. Τι δεδομένα πρέπει οπωσδήποτε να κρατάς στο production
Αυτό είναι πολύ σημαντικό. **Μην κρατάς μόνο reports.**
Κράτα τα raw DBs.
Συγκεκριμένα χρειάζονται τουλάχιστον:
### Raw Deshred events
`deshred_confirmation_samples`
Χρειαζόμαστε τα intents και τα timestamps τους ώστε να ξαναχτίσουμε τα first-150ms features.
### Curve snapshots
`account_snapshots`
Χρειαζόμαστε:
```text
RealSOLReserves
VirtualSOLReserves
VirtualTokenReserves
timestamps
```
ώστε να ξαναφτιάξουμε όλη την curve trajectory.
### Decisions
`decisions`
Χρειαζόμαστε:
```text
anchor
Stage2 time
decision
Stage2 scores/features
reason
```
### Dead-filter output
`dead_filter_predictions`
ώστε να έχουμε το `stage2_p_dead` που χρησιμοποιείται και σαν feature.
### Actual execution / settlement
`landed_transactions`
​
`curve_settlement_samples`
​
`curve_validation_samples`
για να ξέρουμε:
```text
ποιο slot αποφασίσαμε
ποιο slot αγοράσαμε πραγματικά
N+1 ή N+2
ποια curve state χρησιμοποιήθηκε
```
### Positions
`positions`
Για:
```text
entry
exit
realized PnL
exit reason
fees
```
### Runs/config
`runs`
Χρειαζόμαστε να ξέρουμε με ποια έκδοση/config παρήχθη κάθε trade.
Το handoff ήδη καταγράφει ότι οι raw DB18–29 και όλες οι επόμενες πρέπει να παραμείνουν διαθέσιμες για exact replay και feature rebuilding.

---
# 23. Τι θα πρόσθετα οπωσδήποτε όταν πάει production το ML
Για κάθε Stage2 candidate θα ήθελα να αποθηκεύεται μια γραμμή telemetry σαν:
```text
mint
run_id
timestamp
model_version = absolute_v1
regime
fp_econ
fp_win
fp_sig
fp_good
fp_xgbwin
aggressive_score
balanced_score
quality_score
aggressive_threshold
balanced_threshold
quality_threshold
selected_aggressive
selected_balanced
selected_quality
actual_entry_slot_offset
actual_pnl
```
Και ιδανικά είτε:
```text
ολόκληρο το feature vector
```
είτε αρκετή raw πληροφορία ώστε να το ξαναφτιάξουμε ακριβώς.
Αυτό θα μας επιτρέπει μετά να πούμε:
> «Το model αποφάσισε λάθος;»
ή:
> «Το model αποφάσισε σωστά αλλά το BUY κατέληξε N+2 αντί N+1;»
Είναι τελείως διαφορετικά προβλήματα.

---
# 24. Το πιο επικίνδυνο production drift δεν είναι απαραίτητα το ML
Θυμήσου ότι τα models έχουν αξιολογηθεί με **entry N+1**.
Αν στην πραγματική εφαρμογή ξαφνικά έχουμε συχνά:
```text
N+2
N+3
```
μπορεί το model να είναι μια χαρά αλλά το PnL να καταρρεύσει.
Άρα πρέπει να παρακολουθούμε ξεχωριστά:
```text
decision → submit latency
decision slot
landed slot
entry price
expected N+1 price
actual slippage
```
Αν το offline replay λέει:
```text
+0.30 SOL
```
αλλά το live λέει:
```text
-0.10 SOL
```
πρώτα ελέγχουμε execution parity και **μετά** κατηγορούμε το ML.

---
# 25. Τι πρέπει να κρατάς σαν αρχεία
Θα κρατούσα αυτή τη δομή:
```text
model-research/
│
├── frozen/
│   └── absolute_v1/
│       ├── models
│       ├── frozen_policy.json
│       ├── thresholds
│       └── SHA256
│
├── research-checkpoints/
│   └── deshred_model_research_checkpoint_20260821.zip
│
├── raw-databases/
│   ├── deshred.28.db
│   ├── deshred.29.db
│   ├── deshred.30.db
│   └── ...
│
└── evaluations/
    ├── db28_absolute/
    ├── db29_absolute/
    ├── db30_absolute/
    └── ...
```
Από κάθε evaluation κράτα τουλάχιστον:
```text
*_absolute_report.txt
*_absolute_summary.csv
*_absolute_scored.csv
```
και αν έχεις χώρο:
```text
master CSV
wide features CSV
diagnostics
build logs
```

---
# 26. Τι κάνεις κάθε φορά που τελειώνει μία νέα DB
Η διαδικασία πρέπει να γίνει βαρετή και ίδια κάθε φορά.
1. **Δεν αλλάζεις τίποτα στο model.**
2. Τρέχεις `run_db_three_models_absolute.sh`.
3. Παίρνεις Aggressive / Balanced / Quality.
4. Συγκρίνεις με Shadow benchmark.
5. Κοιτάμε:
    - total PnL,
    - PF,
    - PnL/trade,
    - WR,
    - trades,
    - selection rate,
    - max drawdown,
    - avg win/loss,
    - worst tail.
6. Αποθηκεύεις report + scored CSV.
7. Προσθέτουμε τη βάση στο cumulative OOS history.
8. Δεν κάνουμε αλλαγή επειδή δεν μας άρεσε ένα αποτέλεσμα.

---
# 27. Τι να βλέπεις για τα τρία μοντέλα
Μια πολύ απλή νοητική εικόνα:

|Policy|Τι κυνηγά|Τι περιμένουμε|
|---|---|---|
|**Aggressive**|Economic edge|Περισσότερα trades, χαμηλότερο WR, μεγαλύτερο PnL/upside|
|**Balanced**|Economy + consistency|Λιγότερα trades, καλύτερο WR/PF|
|**Quality**|Strong confirmation|Πολύ επιλεκτικό, θεωρητικά καλύτερη ποιότητα, αλλά μπορεί να χάσει μεγάλα winners|
Στο DB28 το Aggressive έδωσε **+0.5264 SOL / PF 2.09**, έναντι Shadow `+0.3606`. Balanced και Quality ήταν επίσης θετικά.
Στο DB29 το πρωινό regime έδειξε το άλλο άκρο: Aggressive μόλις `+0.0388`, Balanced `-0.1236`, Quality `-0.0485`, Shadow `-0.0362`.
Αυτό είναι ακριβώς γιατί κρατάμε και τα τρία μέχρι να έχουμε πραγματικό OOS sample.

---
# 28. Πριν γίνει πραγματικό live BUY
Το Absolute V1 αυτή τη στιγμή είναι **σωστή offline/deployable policy definition**, αλλά αυτό δεν σημαίνει αυτομάτως ότι έχει ήδη production parity μέσα στο Go bot.
Πριν του επιτρέψουμε πραγματικά BUY, πρέπει να αποδείξουμε:
```text
Python feature == Go production feature
Python base scores == production scores
Python composite score == production score
ίδιο regime
ίδιο threshold
ίδιο selected/rejected
```
πάνω σε μεγάλο κοινό sample.
Ιδανικά για κάθε mint:
```text
offline: Aggressive = 0.54831 → BUY
runtime: Aggressive = 0.54831 → BUY
```
και όχι απλώς «περίπου ίδιο».
Μόνο τότε το model implementation είναι production-ready.

---
# 29. Το μικρό cheat-sheet που αξίζει να θυμάσαι
**Μία κακή DB;**
​
Δεν αλλάζω τίποτα.
**Υψηλό WR αλλά αρνητικό PnL;**
​
Το model δεν είναι καλό οικονομικά. WR μόνο του δεν αρκεί.
**PF > 1 και χαμηλό WR;**
​
Μπορεί να είναι απολύτως καλό strategy.
**Ξαφνικά επιλέγει πολύ περισσότερα trades;**
​
Ελέγχω score/feature drift.
**Offline καλό, live κακό;**
​
Πρώτα ελέγχω N+1/N+2, latency, slippage και feature parity.
**Θέλω να αλλάξω threshold;**
​
Νέα version + νέο OOS.
**Θέλω 14:30 αντί 14:00;**
​
Νέα version + νέο OOS.
**Θέλω retrain;**
​
Χρησιμοποιώ τα παλιά OOS ως νέο history, αλλά κρατάω νεότερη untouched βάση για απόδειξη.
**Τι δεν διαγράφω ποτέ όσο κάνουμε αυτή την έρευνα;**
​
Raw DBs, frozen model bundle, scored outputs και version/config metadata.

---
## Το σημαντικότερο συμπέρασμα
Το **Absolute V1 δεν είναι ένα μοντέλο που “μαντεύει αν θα ανέβει το mint”**.
Είναι ένα ensemble που προσπαθεί να απαντήσει ταυτόχρονα σε διαφορετικές ερωτήσεις:
```text
Θα κερδίσει το trade;
Θα είναι οικονομικά σημαντικό;
Θα εμφανιστεί μελλοντικό momentum;
Θα συνυπάρξουν momentum και πραγματικό profit;
Συμφωνεί και δεύτερο ML algorithm;
```
και μετά τα Aggressive / Balanced / Quality δίνουν **διαφορετικό βάρος σε αυτές τις ερωτήσεις**.
Αυτό είναι και το δυνατό σημείο της αρχιτεκτονικής: δεν στηριζόμαστε σε ένα μόνο target όπως «θα φτάσει +1.3;» ή «θα είναι win;». Προσπαθούμε να συνδυάσουμε **market prediction και economic outcome** σε απόφαση που μπορεί πραγματικά να παρθεί στα 150ms.
Αυτόν τον οδηγό θα τον θεωρούσα το operational manual του **Absolute V1**.

# Διαδικασία διαμόρφωσης των δεδομένων

Η διαδικασία που κάναμε για να μετατρέψουμε τις raw βάσεις σε dataset κατάλληλο για ML ήταν αυτή:
1. **Ξεκινήσαμε από τις raw SQLite DBs**
    ​
    Κρατήσαμε τα πραγματικά δεδομένα από:
    - `deshred_confirmation_samples` για intents / buyer flow,
    - `account_snapshots` για bonding-curve κατάσταση,
    - `decisions` / Stage2 timing,
    - dead-filter predictions,
    - execution/settlement δεδομένα,
    - `positions` για το τελικό οικονομικό αποτέλεσμα.
2. **Ορίσαμε ένα κοινό decision point: Stage2 @150ms**
    ​
    Για κάθε candidate χρησιμοποιήσαμε μόνο πληροφορία που ήταν διαθέσιμη από το anchor μέχρι τα **150ms**. Αυτό είναι κρίσιμο για να μην υπάρχει leakage από το μέλλον.
3. **Φτιάξαμε το exact master dataset με Go replay**
    ​
    Με το `TestBuildExactStage2MasterPolicyDataset` αναπαράγαμε το πραγματικό σενάριο:
    - απόφαση στα 150ms,
    - BUY στο **N+1**,
    - buy size `0.075 SOL`,
    - πραγματικά fees/slippage/exits,
    - τελικό `pnl_sol`.
    Έτσι κάθε γραμμή αντιστοιχεί σε ένα πραγματικό υποθετικό trade που θα μπορούσε να γίνει live.
4. **Δημιουργήσαμε τα labels**
    ​
    Κυρίως:
    - `pnl_sol > 0` → win/loss target,
    - πραγματικό `pnl_sol` → οικονομικό αποτέλεσμα,
    - `eligible_stage3_label` → αν έφτασε `+1.3 RealSOL <=2s`,
    - `goodlabel` → ταυτόχρονα `PnL > 0` και `+1.3 signal`.
5. **Χτίσαμε τα causal wide features**
    ​
    Από τα raw events και curve snapshots φτιάξαμε features μόνο μέχρι τα 150ms:
    - RealSOL trajectory,
    - VirtualSOL trajectory,
    - κατάσταση στα 25/50/75/100/125/150ms,
    - slopes,
    - positive/negative steps,
    - volatility/range,
    - buyer flow,
    - buyer delays,
    - creator history κ.λπ.
    Το script ήταν το `wide_features.py`.
6. **Ενώσαμε master + wide features**
    ​
    Με keys κυρίως:
    - `run_id`
    - `mint`
    Έτσι κάθε trade είχε στην ίδια γραμμή:
    ```text
    features στα 150ms
    +
    πραγματικό N+1 outcome
    +
    labels
    ```
7. **Καθαρίσαμε το population**
    ​
    Κρατήσαμε μόνο γραμμές όπου:
    - το Stage2 ήταν πραγματικά evaluable,
    - υπήρχε valid entry/exit,
    - υπήρχε τελικό PnL,
    - υπήρχαν τα απαραίτητα causal features.
8. **Χωρίσαμε χρονολογικά τα DBs**
    ​
    Δεν κάναμε random train/test split.
    ​
    Παλαιότερες βάσεις → training, επόμενη → calibration/validation, νεότερη → OOS.
    Αυτό είναι σημαντικό γιατί θέλουμε να προσομοιώνουμε το πραγματικό production:
    > εκπαιδεύω στο παρελθόν και προβλέπω το μέλλον.
9. **Εκπαιδεύσαμε διαφορετικά targets**
    ​
    Από το ίδιο prepared dataset βγήκαν:
    - economic win model,
    - απλό win model,
    - +1.3 signal model,
    - good-trade model,
    - XGBoost win model.
10. **Τέλος παγώσαμε models + thresholds**
    ​
    Αφού ολοκληρώθηκε το development:
    - δεν ξαναπειράζουμε features,
    - δεν ξαναεκπαιδεύουμε στη νέα DB,
    - δεν βρίσκουμε percentile πάνω στη νέα DB,
    - χρησιμοποιούμε fixed absolute thresholds.
Η ουσία σε μία γραμμή:
```text
Raw SQLite
→ exact N+1 replay
→ causal features έως 150ms
→ labels/outcomes
→ merged clean ML table
→ chronological training/validation/OOS
→ frozen models + absolute thresholds
```
Αυτό είναι το pipeline που πρέπει να κρατήσεις σαν επίσημη διαδικασία προετοιμασίας δεδομένων.

Ναι. Σου έφτιαξα ένα **ενιαίο rebuild/archive kit** ώστε αν χρειαστεί σε μήνες να ξανακάνουμε όλη τη δουλειά, να μην ψάχνουμε τι χρησιμοποιήσαμε.

`DESHRED_ML_REBUILD_KIT_ABSOLUTE_V1_20260821.zip`

Μέσα έχει:
- **Research checkpoint** `deshred_model_research_checkpoint_20260821.zip`
- **Frozen Absolute V1 bundle** με models, thresholds, runner/scorer
- `wide_features.py`
- `pipeline.py`
- `wide_model.py`
- πλήρες handoff Absolute V1
- DB28/DB29/DB30 reference reports
- `requirements.txt`
- **`README_REBUILD.md` με όλη τη διαδικασία βήμα-βήμα**
- SHA256 checksums
Το `README_REBUILD.md` περιγράφει συγκεκριμένα:
```text
Raw SQLite
→ safe snapshot
→ exact Stage2 → N+1 Go replay
→ master dataset
→ causal wide features 0–150ms
→ merge/clean
→ labels
→ chronological training/calibration
→ model freeze
→ absolute thresholds
→ untouched OOS
```
Κράτα χωριστά οπωσδήποτε μόνο δύο πράγματα που **δεν χωράνε/δεν περιλαμβάνονται** στο kit:
1. **Όλες τις raw DB18 και μετά**
2. **Το Go repo / συγκεκριμένο commit** που περιέχει το
    ​
    `TestBuildExactStage2MasterPolicyDataset`
Αν έχεις αυτά + το συγκεκριμένο zip, μπορούμε πρακτικά να ξαναχτίσουμε, να retrainάρουμε ή να φτιάξουμε Absolute V2 χωρίς να εξαρτόμαστε από το ιστορικό αυτού του νήματος.

### Πρώτα τρέχεις το 
```bash
michael@LAPTOP-B63J8AK0 MINGW64 ~/developer/pump-fun-sniper-bot/deshred (deshred)

$bash run_db_three_models_absolute.sh 34   ./databases/deshred.34.db   ./frozen_three_models_absolute_v1   ./temp/db34_absolute

$ bash run_stage2_plus300_dataset.sh

$ bash run_exact_horizons_n1.sh 34 ./databases/deshred.34.db 600
```
μετά:
```bash
cd tools
py export_stage2_flow_volume_v2.py \
  --db 33 \
  --master ../temp/stage2_plus300/db33/db33_master_plus300.csv \
  --out-dir db33_flow \
  --prefix db33 \
  --pre-ms 150 \
  --max-ms 1000 \
  --step-ms 25
```
