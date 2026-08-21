
Ναι, αυτή είναι η σωστή αρχική προσέγγιση: **στατιστικό scoring, όχι ML**.
1. Από τον collector βγάζουμε ιστορικές πιθανότητες:
    - ανά `instruction_name`,
    - payer/wallet,
    - transaction template,
    - CU price/limit,
    - intent age,
    - ποσό,
    - retries και προηγούμενο success rate.
2. Για κάθε live intent υπολογίζουμε:
```text
pᵢ = εκτιμώμενη πιθανότητα να εκτελεστεί
expectedImpactᵢ = pᵢ × curveImpactᵢ
```
3. Έπειτα:
```text
predictedCurve = confirmedCurve + Σ(expectedImpactᵢ)
```
Τα buys έχουν θετικό impact, τα sells αρνητικό.
4. **Entry**
    - predicted curve πάνω από το απαιτούμενο επίπεδο,
    - αρκετή συνολική πιθανότητα buy flow,
    - αναμενόμενο κέρδος μετά fees/slippage θετικό,
    - όχι υψηλή πιθανότητα creator sell.
5. **Exit**
    - predicted curve πέφτει κάτω από όριο,
    - εμφανίζεται ισχυρό expected sell pressure,
    - προβλεπόμενη τιμή ενεργοποιεί TP/SL νωρίτερα από την confirmed curve.
Δύο κρίσιμες διορθώσεις:
- Intents της ίδιας signature δεν αθροίζονται ανεξάρτητα· έχουν κοινό outcome.
- Πολλά retries του ίδιου payer/template πρέπει να θεωρούνται ένα economic intent, αλλιώς υπερεκτιμάται το flow.
Επίσης πρέπει να κρατάμε uncertainty:
```text
variance = Σ[pᵢ × (1-pᵢ) × impactᵢ²]
```
Άρα η απόφαση δεν θα βασίζεται μόνο στο `predictedCurve`, αλλά και στο πόσο αξιόπιστη είναι η πρόβλεψη. Αυτό είναι επαρκές για πρώτο MVP και πολύ πιο ελέγξιμο από classifier.


Από εδώ και πέρα χρειάζονται τα εξής, με αυτή τη σειρά:
1. **Μείωση όγκου collector**
    - compact schema,
    - χωρίς περιττά curve/account rows,
    - aggregation competing activity.
    - Αλλιώς πολλές ώρες συλλογής θα παράγουν δεκάδες GB.
2. **Συλλογή μεγαλύτερου δείγματος**
    - διαφορετικές ώρες και επίπεδα φόρτου,
    - τουλάχιστον δεκάδες χιλιάδες unique signatures.
    - Όχι για να αλλάξει το συνολικό 5–10%, αλλά για να σταθεροποιηθούν οι υποομάδες.
3. **Analyzer/exporter**
    ​
    Θα παράγει στατιστικά ανά:
    - `instruction_name`,
    - payer,
    - transaction template,
    - payer + template,
    - CU price/limit,
    - ποσό και intent age.
4. **Probability tables με smoothing**
```text
p = (successes + α × globalRate) / (attempts + α)
```
Έτσι payer με `1/1` δεν παίρνει τεχνητά probability `100%`.
5. **Live scoring κάθε economic intent**
```text
pᵢ = score(payer, template, instruction, priority, age)
expectedImpactᵢ = pᵢ × curveImpactᵢ
```
6. **Predicted curve**
```text
predictedCurve =
    confirmedCurve
    + Σ(expected buy impacts)
    - Σ(expected sell impacts)
```
Retries και intents της ίδιας signature ομαδοποιούνται, ώστε να μη μετριούνται πολλές φορές.
7. **Replay πάνω στα collector data**
    ​
    Συγκρίνουμε:
    - confirmed-only,
    - raw intents,
    - probability-weighted intents.
    Μετρικές: false entries, missed entries, predicted/actual curve error και πιθανό PnL μετά fees.
8. **Shadow integration στο Deshred**
    ​
    Αρχικά το score καταγράφει μόνο προτεινόμενο `ENTRY/WAIT/EXIT`, χωρίς πραγματικές συναλλαγές. Μετά από επαλήθευση ενεργοποιείται live.
Το αμέσως επόμενο πρακτικό βήμα είναι: **compact collector και ξεχωριστό analyzer που δημιουργεί probability lookup tables και replay report**.


## Βασικός κανόνας BUY/SKIP
Στα πρώτα **25 ms μετά το create**, κάνουμε `BUY` μόνο όταν ισχύουν όλα:
```text
1. Υπάρχει creator buy.
2. Το token δεν είναι mayhem.
3. Δεν υπάρχει κανένα sell intent.
4. Υπάρχουν 1–3 μοναδικά external buy wallets.
```
Διαφορετικά γίνεται `SKIP`.
## Ratio A
```text
ratio_A = external_buy_total_SOL / creator_buy_total_SOL
```
Αποδεκτό range:
```text
0.1 <= ratio_A < 2.0
```
Παράδειγμα: creator αγοράζει `2 SOL`. Τα external buys των πρώτων 25 ms πρέπει συνολικά να είναι:
```text
0.2 SOL <= external_buy_total < 4 SOL
```
Ο τελικός υποψήφιος κανόνας είναι:
```text
Βασικός κανόνας
AND
0.1 <= external_buy_total_SOL / creator_buy_total_SOL < 2.0
```




Το επόμενο λογικό βήμα είναι **feature discovery μόνο στις 17 development βάσεις**: να συγκρίνουμε winners και losers με στοιχεία διαθέσιμα πριν από την είσοδο, όπως:
```
ρυθμός άφιξης buys
χρόνος μεταξύ των buys
επιτάχυνση volume
κατανομή ποσών ανά wallet
curve growth
buy/sell imbalance
creator behaviour
χρόνος trigger
```
Μετά φτιάχνουμε έναν απλό στατιστικό score με walk-forward validation μέσα στις 17 βάσεις. Μόνο αν φτάσει κοντά στο 60%, το παγώνουμε και το δοκιμάζουμε στις 3 holdout.


|Τεχνική|Trades|Wins|Win rate|Συνολικό PnL|Αξιολόγηση|
|---|--:|--:|--:|--:|---|
|Deshred 25 ms, βασικός κανόνας|490|205|**41,8%**|**+1,1166 SOL**|Μη ρεαλιστική είσοδος περίπου στα 50 ms|
|Deshred 25 ms + amount ratio A|344|163|**47,4%**|**+1,0848 SOL**|Καλύτερη διαλογή, αλλά ίδια μη ρεαλιστική latency|
|Same-transaction, entry 200 ms|2.278|164|**7,2%**|**−3,8400 SOL**|Απορρίφθηκε|
|Confirmed momentum: 3 buyers, ≥1 SOL|262|60|**22,9%**|**−0,3470 SOL**|Απορρίφθηκε|
|GMGN φίλτρο, πρώτο trigger, μέγιστο rate|782|386|**49,4%**|**−1,6215 SOL**|TP 3%, hold 10 s|
|GMGN φίλτρο, πρώτο trigger, μικρότερη ζημιά|782|305|**39,0%**|**−0,6783 SOL**|TP 12%, hold 3 s|
|Curve metrics + fixed exit, chronological OOS|129|70|**54,3%**|**−0,1193 SOL**|Καλύτερο συνολικό OOS rate|
|Curve metrics + profit lock/trailing, non-mayhem OOS|39|14|**35,9%**|**−0,0814 SOL**|Δεν γενίκευσε|

