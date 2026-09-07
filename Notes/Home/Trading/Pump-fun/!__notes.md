
### Shadow μετρήσεις

|       | 21/8 Fri | 22/8 Sat | 23/8 Sun | 24/8 Mon | 25/8 Tue | 26/8 Wed | 27/8 Thu | 28/8 Fri |
| ----- | :------: | :------: | :------: | :------: | :------: | :------: | :------: | :------: |
| 23-9  |          |    31    |    33    |    35    |    37    |    39    |          |          |
| 9-14  |          |          |          |          |          |          |          |          |
| 14-23 |    30    |    32    |    34    |    36    |   N 38   |          |          |          |


### v1 υλοποίηση

Η συνολική V1 shadow υλοποίηση είναι:
1. Στα `+150ms` γίνεται Stage2 και υπολογίζεται το frozen Aggressive score.
2. Χρησιμοποιούνται διαφορετικά thresholds για `14–23` και `23–09`. Το `09–14` δεν συμμετέχει.
3. Αν επιλεγεί, size `0,075 SOL` ή `0,15 SOL` όταν margin `>0,101`.
4. Η απόφαση γίνεται στο slot `N` και η αγορά στο `N+1`.
5. Αν υπάρχει πραγματικό curve snapshot στο `N+1`, χρησιμοποιείται αυτό. Αλλιώς χρησιμοποιείται η τελευταία causal curve που γνώριζε το πρόγραμμα έως το `N+1`.
6. Εφαρμόζεται `min_tokens_out`/buy slippage. Αν αποτύχει, δεν ανοίγει θέση.
7. Μετά την αγορά παρακολουθεί αν το RealSOL φτάσει:
    `Stage2 baseline +1,3 SOL`
8. Το `+1,3` πρέπει να εμφανιστεί έως `Stage2+2s`.
9. Αν δεν εμφανιστεί, ζητείται πώληση αμέσως στο τέλος των 2s.
10. Αν εμφανιστεί, τότε ξεκινά το παράθυρο των `500ms` — από το signal, όχι από την αγορά.
11. Μέσα στα 500ms μπορούν να ενεργοποιηθούν stop-loss, trailing stop, profit-lock ή take-profit. Αλλιώς πώληση στο timeout.
12. Η πώληση χρησιμοποιεί causal curve στο slot της απόφασης ή αργότερα, με sell slippage.
13. Αν αποτύχει η πώληση, γίνονται έως 3 προσπάθειες ανά `300ms`. Μετά πάει `manual_resolution`.
14. Καταγράφονται entry/exit slots, πραγματικό ή memory settlement, signal time, exit reason, `max_gain`, drawdown, winner/loser και καθαρό PnL.
Αυτό πλέον αναπαριστά ολόκληρη τη frozen V1 στρατηγική και όχι μόνο τον selector. Η βασική εκκρεμότητα είναι το startup backfill των prior-creator features.


### μεταβολή του rsol
Τα τρία αυτά features προσπαθούν να ξεχωρίσουν το «πραγματικά επιταχυνόμενο mint» από ένα στιγμιαίο spike.
1. `acceleration > threshold`
    - Δεν κοιτάμε μόνο αν ανεβαίνει γρήγορα το RealSOL, αλλά αν η ταχύτητα αυξάνεται.
    - DB30: crossers median `+3,44 SOL/s²`, non-crossers `-31,21 SOL/s²`.
    - Άρα είναι το ισχυρότερο early feature που βρήκαμε μέχρι τώρα.
2. `Z-score > threshold`
    - Μετρά πόσο ασυνήθιστα ψηλά βρίσκεται το τρέχον RealSOL σε σχέση με τα πρόσφατα samples.
    - Crossers median `1,228`, non-crossers `0,896`.
    - Δεν είναι τόσο ισχυρό όσο η acceleration, αλλά βοηθά να ξεχωρίσουμε σταθερή ανοδική κίνηση από κοινό θόρυβο.
3. `minimum realized ΔRealSOL`
    - Απαιτούμε να έχει ήδη πραγματοποιηθεί κάποια πραγματική άνοδος, π.χ. όχι να στέλνουμε transaction με `Δ=0.05`.
    - Αυτό είναι ιδιαίτερα σημαντικό επειδή στους `538` κακούς fills το median landing Δ ήταν μόλις `+0,25 SOL`.
Η λογική που αξίζει να δοκιμαστεί είναι περίπου:
\[ ProjectedCross=true \]
και
\[ acceleration>A \]
και
\[ Z>Z_{min} \]
και
\[ \Delta RealSOL>D_{min} \]
Δεν ξέρουμε ακόμη τα σωστά `A`, `Zmin`, `Dmin`. Δεν θα τα μαντέψουμε. Θέλει grid replay στο DB30 και optimization με **τελικό PnL**, όχι precision/AUC.
Το ενδιαφέρον είναι ότι τα τρία φίλτρα είναι συμπληρωματικά: `Δ` λέει «έχει ήδη κινηθεί», velocity «πάει αρκετά γρήγορα», acceleration «δυναμώνει αντί να ξεφουσκώνει», Z-score «η κίνηση ξεχωρίζει από το πρόσφατο noise». Τα αποτελέσματα εδώ είναι εμπειρικά μόνο από DB30.




Μπορούμε όμως να κάνουμε κάτι δυνητικά πολύ ενδιαφέρον:
`στείλε transaction επανειλημμένα/σε κατάλληλα slots → κάθε execution ελέγχει +1.3 → μόνο αυτό που το βρίσκει αληθές αγοράζει`.
Αυτό είναι ουσιαστικά **conditional retry**, όχι «transaction που περιμένει». Και επειδή το rejected transaction έχει για εμάς πολύ μικρό γνωστό κόστος, αξίζει να το εξετάσουμε ως εναλλακτική στο V1: μπορεί να μετατρέψει το `+1.3` από exit signal σε πραγματικό **on-chain entry guard**. Το σημαντικό όμως είναι ότι αυτό θα είναι διαφορετική στρατηγική από το OOS V1 που αγοράζει στο N+1 πριν δει το +1.3.



### Oracle

Και τα δύο experiments απαντούν στην ίδια ερώτηση:
> «Αν γνωρίζαμε τέλεια ποια mints πρόκειται να ανέβουν, πόσο κέρδος υπάρχει με πραγματική αγορά στο επόμενο slot;»
#### Oracle DB18–26
1. Στα 150ms περνούν τα mints από το Stage2.
2. Το oracle κοιτάζει το μέλλον και κρατά μόνο όσα θα φτάσουν αργότερα `+1,3 RealSOL`.
3. Η αγορά θεωρείται κανονικά στο επόμενο slot, όχι στην παλιά τιμή.
4. Μετά εφαρμόζονται τα production-like exits.
5. Αποτέλεσμα: περίπου 7.000 εκτελεσμένες αγορές και **+92,15 SOL συνολικά**.
#### Oracle DB30–33
1. Περιμένουμε μέχρι τα +300ms, ώστε να έχουμε περισσότερη πληροφορία.
2. Αποκλείονται όσα έχουν ήδη κάνει την άνοδο, επειδή σε αυτά θα μπαίναμε αργά.
3. Το oracle κρατά μόνο όσα θα κάνουν το `+1,3` αργότερα, συνήθως μετά τα 500ms.
4. Στέλνουμε στα +300ms, αγοράζουμε στο επόμενο slot και εφαρμόζουμε τα πραγματικά exits.
5. Αποτέλεσμα: περίπου **+9 έως +14 SOL ανά μεγάλη βάση**.
Η βασική διαφορά είναι ότι το πρώτο oracle αγοράζει πολύ νωρίς, στα 150ms, ενώ το δεύτερο περιμένει μέχρι τα 300ms και επιλέγει ειδικά κινήσεις που δεν έχουν ακόμη ολοκληρωθεί.
Το ουσιαστικό συμπέρασμα είναι:
- Το `N+1` execution δεν καταστρέφει το κέρδος.
- Υπάρχει πολύ μεγάλο οικονομικό περιθώριο.
- Το δύσκολο πρόβλημα είναι να αναγνωρίσουμε αυτά τα mints εγκαίρως χωρίς να γνωρίζουμε το μέλλον.
- Τα αποτελέσματα είναι θεωρητικά ανώτατα όρια, όχι εφαρμόσιμες στρατηγικές.



### Diagram




![[!__notes-1787474097171.png|1010x565]]

![[!__notes-1787474193084.png|1010x562]]


Το `+1.3` συνήθως έρχεται **μετά** το 600–700ms.
Η εικόνα που είδαμε είναι περίπου:
**0–500ms:** πολλοί ακόμα μοιάζουν μεταξύ τους
​
**~600ms:** αρχίζουν τα πρώτα ουσιαστικά events / flow
​
**~700ms:** αρχίζει η πραγματική επιτάχυνση
​
**~1.1s median:** γίνεται το `+1.3 rSOL crossing`
Άρα το `600+` δεν είναι το σημείο του `+1.3`.
Είναι περισσότερο το σημείο όπου **αρχίζει να φαίνεται ποιος ετοιμάζεται να φτάσει το +1.3 και ποιος όχι**.
Γι’ αυτό μας ενδιαφέρει τόσο η περιοχή **500–700ms**: θέλουμε να αναγνωρίσουμε το runner **πριν** φτάσει στο `+1.3`, ώστε να μπούμε στο N+1 πριν χαθεί το move.


### Curve program
**Hard slot guard μέσα στην transaction.** Αυτό είναι πιο ενδιαφέρον για εμάς: μπορούμε να βάλουμε πρώτη instruction ένα πολύ μικρό δικό μας Solana program που διαβάζει το `Clock.slot` και λέει:
​
**«εκτέλεσε μόνο αν current_slot == N+1, αλλιώς fail»**.
​​
Επειδή η transaction είναι atomic, αν το guard αποτύχει, το BUY δεν εκτελείται.

Deploying curve_guard program...
Program Id: 8R8d4VBaG6MEh2npNYh2qtpZXBj3r12Xwi9CyNWXeJVD
Signature: 5ykK4CNx8KQc6bxDxn12J4hAeCZtd6b1ZwnQxjjjLFN94PKeMtw4Pb7nNJbamFwbNrEhsng1WHrusbX7dVfzWkYb
DEPLOY_OK
guard_program=8R8d4VBaG6MEh2npNYh2qtpZXBj3r12Xwi9CyNWXeJVD
saved_program_id=/mnt/d/develop-tasks/punp-fun-sniper/solana-curve-guard-poc/.curve_guard_program_id


Fee 0.000005 SOL ($0.0004764)


### ευρήματα


Τα δεδομένα τα πήρα και έκανα ήδη ουσιαστικό πρώτο πλήρες πέρασμα. **Δεν θεωρώ ακόμη ότι έχω το τελικό μοντέλο**, οπότε δεν θέλω να σου παρουσιάσω κάποιο ενδιάμεσο candidate σαν λύση.
Το σημαντικότερο εύρημα είναι ότι τα +300ms δεδομένα αλλάζουν αρκετά το πρόβλημα. Έχω περίπου **59.7k exact evaluable observations DB18–32** και επιβεβαίωσα ότι το replay είναι πράγματι `decision → slot N+1`. Βρήκα επίσης **8 anomalous rows** όπου το timestamp του entry εμφανίζεται πριν από το +300ms decision· τα έχω βγάλει από το καθαρό evaluation ώστε να μη φουσκώσει τεχνητά το αποτέλεσμα.
#### Το βασικό εύρημα
Στο +300ms **δεν πρέπει να εκπαιδεύουμε απλώς πάνω στο παλιό Stage3 signal**.
Τα mints που έχουν ήδη κάνει το +1.3 rSOL crossing πολύ νωρίς, πριν ή γύρω από τα +300ms, είναι κατά μέσο όρο κακά entries: έχουμε ήδη αργήσει. Αντίθετα, αυτά που θα κάνουν το crossing **μετά** το entry είναι εξαιρετικά.
Ειδικά το target:
`Stage3 crossing = true AND Stage2→trigger >= 500ms`
είναι πολύ ισχυρό. Και στο `23-09` αυτό ταιριάζει ακριβώς και με τον πραγματικό Shadow κανόνα των **+500ms**.
Το θεωρητικό causal ceiling στο +300 → N+1 είναι τεράστιο:

|DB / regime|Trades που πληρούν late≥500 oracle|WR|+300 N+1 PnL|
|---|--:|--:|--:|
|DB28 `23-09`|635|86.5%|**+9.26 SOL**|
|DB29 `09-14`|100|88.0%|**+1.41 SOL**|
|DB30 `14-23`|819|89.6%|**+13.23 SOL**|
|DB31 `23-09`|821|91.1%|**+14.08 SOL**|
|DB32 `14-23`|763|89.5%|**+12.33 SOL**|
|DB32 `23-09`|85|98.8%|**+1.50 SOL**|
Αυτό είναι πολύ θετικό: **το N+1 στα +300ms δεν μας περιορίζει οικονομικά**. Το δύσκολο κομμάτι είναι να προβλέψουμε causal ποια είναι αυτά τα mints.
#### Τι έδωσαν τα πρώτα πραγματικά models
Έτρεξα ήδη LightGBM/XGBoost σε πολλά horizons `+50/+100/+150/+200/+250/+300`, trajectory/event combinations, direct PnL, weighted-win, profit targets, signal targets κ.λπ.
Ένα χαρακτηριστικό `14-23` candidate, επιλεγμένο μόνο από development DBs, έκανε:
- DB30: **+0.370 SOL** έναντι Aggressive **−0.058** και Shadow **+0.301** → πολύ καλό.
- DB32 `14-23`: μόνο **+0.047 SOL** έναντι Aggressive **+1.384** → αποτυχία.
Δηλαδή επιβεβαιώνεται ακριβώς αυτό που είχες παρατηρήσει: **το run-to-run reversal παραμένει το μεγάλο πρόβλημα**.
Στο `23-09`, τα πρώτα +300 models βελτιώνουν ορισμένες περιπτώσεις αλλά κανένα ακόμη δεν πιάνει τον DB31 Shadow. Για παράδειγμα ένας από τους καλύτερους πρώτους candidates έδωσε περίπου **+0.411 DB31**, αλλά δεν ήταν καλός στο DB28. Shadow DB31 είναι +1.521.
Δοκίμασα επίσης να προβλέψω απευθείας τα Shadow selections από τα +300ms features. Η πρόβλεψη βελτιώνεται, αλλά η precision δεν είναι ακόμη αρκετή ώστε τα false positives να μη μας τρώνε το PnL.
#### Πού θέλω να πάω μετά
Υπάρχει ένα σημαντικό search που **δεν πρόλαβα να ολοκληρώσω σωστά στον σημερινό υπολογιστικό γύρο**: το hybrid.
Δηλαδή όχι «πέτα το Aggressive και βάλε ένα νέο model», αλλά:
**Aggressive @150ms + νέα πληροφορία έως +300ms → veto/rerank/add trades**
Αυτό είναι ιδιαίτερα ενδιαφέρον επειδή:
- DB28 και DB32 δείχνουν ότι το Aggressive ήδη βρίσκει πραγματικό edge.
- DB30 και DB31 δείχνουν ότι μερικές φορές διαλέγει λάθος population.
- Άρα το +300 layer μπορεί να λειτουργήσει ως **regime-specific correction layer**, αντί να προσπαθούμε να ξαναμάθουμε όλο το πρόβλημα από το μηδέν.
Έχω ήδη ελέγξει ότι στα υπάρχοντα DB28–32 scored files έχουμε ανά mint τα `fp_econ`, `fp_win`, `fp_sig`, `fp_good`, `fp_xgbwin` και το `aggressive_score`, οπότε αυτός ο συνδυασμός είναι τεχνικά εφικτός.
**Δεν παγώνω λοιπόν κανένα από τα σημερινά +300 candidates.** Το πιο σημαντικό αποτέλεσμα μέχρι τώρα είναι ότι βρήκαμε πολύ ισχυρό late-signal target και αποδείξαμε ότι υπάρχει τεράστιο οικονομικό headroom. Αυτό που μένει είναι να μετατρέψουμε αυτή την πληροφορία σε selector αρκετά ακριβή ώστε να ξεπερνά σταθερά το σημερινό Aggressive και μετά να κυνηγήσουμε Shadow parity.
Και ειδικά στο `23-09` θα κρατήσω απαράβατο το **+500ms Shadow rule** σε όλη την επόμενη αναζήτηση.






### roadmap

Το roadmap μέχρι production θα το έβαζα έτσι:
1. ~~**DB30 — καθαρό OOS validation**~~
    ~~​~~
    ~~Τρέχουμε το frozen Absolute V1 χωρίς καμία αλλαγή. Συγκρίνουμε Aggressive / Balanced / Quality / Shadow σε PnL, PF, WR και downside. Αυτό είναι το πρώτο πραγματικά untouched test.~~
2. **DB31–DB33 — επιβεβαίωση σταθερότητας**
    ​
    Δεν θέλω να πάμε production επειδή μία βάση βγήκε καλή. Θέλουμε αρκετές νέες βάσεις, διαφορετικές ώρες/regimes, και κυρίως να μην υπάρχει ένα regime που καταστρέφει όλο το αποτέλεσμα.
3. **Επιλογή ενός production candidate**
    ​
    Πιθανότατα Aggressive αν συνεχίσει να δίνει καλύτερο συνολικό PnL/PF. Δεν θα επιλέξουμε με βάση WR μόνο — το DB29 ήδη έδειξε ότι υψηλό WR μπορεί να συνυπάρχει με αρνητικό PnL.
4. **Downside / risk validation**
    ​
    Για τον νικητή μετράμε:
    - max drawdown,
    - avg/median loss,
    - worst 5% losses,
    - συνεχόμενα losses,
    - PnL ανά regime,
    - SOL/hour.
        ​
        Αν εδώ υπάρχει σοβαρό πρόβλημα, φτιάχνουμε **V2** και ξαναρχίζει νέο untouched OOS.
5. **Production parity**
    ​
    Περνάμε το frozen model μέσα στο Go bot και αποδεικνύουμε ότι το online feature calculation δίνει **ίδια features → ίδιο score → ίδια απόφαση** με τον offline scorer. Αυτό είναι κρίσιμο.
6. **Live shadow με το πραγματικό production code**
    ​
    Το μοντέλο τρέχει online και καταγράφει τι θα αγόραζε, αλλά δεν στέλνει BUY. Ελέγχουμε latency, missing features, score distribution, regime selection και parity με το offline replay.
7. **Μικρό live canary**
    ​
    Πραγματικά BUY με πολύ μικρό exposure. Εδώ ελέγχουμε πλέον το κομμάτι που το replay δεν μπορεί να αποδείξει τέλεια: πραγματικό N+1 landing, slippage, failed transactions, fees και sell execution.
8. **Σταδιακό production rollout**
    ​
    Μόνο αν live canary ≈ shadow/replay μέσα σε λογικά όρια. Μετά αυξάνουμε exposure σταδιακά, όχι κατευθείαν πλήρες κεφάλαιο.
Άρα σήμερα βρισκόμαστε ουσιαστικά στο **στάδιο 1 από 8**. Το σημαντικό είναι να μη βιαστούμε να γράψουμε production integration πριν αποδείξει το Absolute V1 ότι κρατιέται σε DB30+· αλλιώς θα υλοποιούμε κάτι που πιθανόν θα αλλάξει.
#### Live tests
1. **Live canary 30–50 trades με 0,005 SOL/trade**.
    ​
    Στόχος δεν είναι το κέρδος αλλά να μάθουμε:
    - πόσα BUY landed στο N,
    - πραγματικό buy slippage,
    - πραγματικό sell latency,
    - live PnL έναντι shadow PnL.
2. Αν το νέο transport μεταφέρει σημαντικό ποσοστό των BUY από **N+1 → N**, τότε συνεχίζουμε σε 100–300 live trades. Αν εξακολουθεί να landed κυρίως N+1, τότε περνάμε στη δεύτερη λύση: **νωρίτερο/pre-Stage3 submit**.
Με λίγα λόγια: **πρώτα κλειδώνουμε ότι το strategy έχει edge στο shadow, μετά προσπαθούμε να κάνουμε το live execution να πιάσει το N.** Αυτό είναι πλέον το βασικό project.


Για το πρώτο live canary που λέμε:
- `0,005 SOL/trade`
- 30 trades = **0,15 SOL συνολικός τζίρος**
- 50 trades = **0,25 SOL συνολικός τζίρος**
Επειδή όμως τα SOL επιστρέφουν μετά από κάθε sell, δεν χρειάζεσαι 0,25 SOL διαθέσιμα ταυτόχρονα.
Εγώ θα είχα στο wallet περίπου **0,30 SOL** για να υπάρχει άνεση για:
- losses,
- fees,
- Jito tips,
- slippage,
- αποτυχημένες/retry συναλλαγές.
Και θα έβαζα **hard stop περίπου -0,10 έως -0,15 SOL cumulative loss** για το πρώτο canary.






#### Checks για live canary

```sql
WITH buys AS (
  SELECT landed_slot - decision_slot AS landed_slot_delta
  FROM orders
  WHERE side='buy' AND landed_slot > 0 AND decision_slot > 0
)
SELECT landed_slot_delta, COUNT(*) AS count,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM buys GROUP BY landed_slot_delta ORDER BY landed_slot_delta;
```

```sql
SELECT p.mint, o.signature, o.decision_slot, o.landed_slot,
       o.landed_slot-o.decision_slot AS slot_delta,
       ROUND(o.rpc_latency_us/1000.0,3) AS rpc_latency_ms,
       ROUND(o.jito_latency_us/1000.0,3) AS jito_latency_ms,
       o.rpc_accepted AS rpc_ok, o.jito_accepted AS jito_ok, o.bundle_id
FROM orders o JOIN positions p ON p.position_id=o.position_id
WHERE o.side='buy' ORDER BY o.created_at;
```

#### Checks για gross buy

Τρέχον run:

```sql
WITH current_run AS (SELECT MAX(run_id) AS run_id FROM runs)
SELECT
  COALESCE(SUM(p.entry_curve_debit),0)/1e9 AS total_gross_buy_sol,
  COALESCE(SUM(CASE WHEN p.state='closed' THEN p.realized_pnl_lamports ELSE 0 END),0)/1e9 AS realized_pnl_sol,
  SUM(CASE WHEN p.entry_signature<>'' THEN 1 ELSE 0 END) AS landed_buys
FROM positions p JOIN current_run r ON r.run_id=p.run_id
WHERE p.state IN ('holding','exit_pending','manual_resolution','closed');
```

Νέα entries μετά το πρώτο risk block — πρέπει να επιστρέψει `0`:

```sql
WITH r AS (SELECT MAX(run_id) run_id FROM runs),
hit AS (
  SELECT MIN(observed_at) at FROM decisions, r
  WHERE decisions.run_id=r.run_id
    AND reason IN ('live_risk_session_loss_limit','live_risk_gross_buy_limit')
)
SELECT COUNT(*) AS allowed_entries_after_limit
FROM decisions d, r, hit
WHERE d.run_id=r.run_id AND d.action='enter' AND d.observed_at>hit.at;
```



Ναι. Για τα **10.808** που έχουν επαρκές replay, αν πάρουμε ως βασικό signal το **RealSOL +0,5 SOL**, χωρίζονται πολύ καθαρά:

| Πότε ήρθε +0,5 SOL      |     Mints | WR αν αγοράζαμε στα 150ms |  PnL στα 150ms | Median max gain |
| ----------------------- | --------: | ------------------------: | -------------: | --------------: |
| ≤250ms                  |       612 |                     63,7% |      +2,05 SOL |          +18,3% |
| 251–500ms               |       407 |                     67,1% |      +2,43 SOL |          +22,2% |
| 501–1000ms              |       681 |                     72,7% |      +6,84 SOL |          +27,0% |
| 1001–2000ms             |       974 |                     74,3% |     +10,61 SOL |          +26,9% |
| **Δεν ήρθε μέσα σε 2s** | **8.134** |                 **30,5%** | **-53,66 SOL** |       **+1,7%** |
Και φαίνεται πολύ έντονα και στη μετέπειτα κίνηση:
- Όσα έδωσαν το signal, περίπου **86–95%** έφτασαν αργότερα τουλάχιστον +5%.
- Όσα **δεν** έδωσαν `+0,5 SOL` μέσα σε 2s, μόνο **42,6%** έφτασαν +5%.
- Στην ίδια no-signal ομάδα, **58,5%** έκαναν drawdown τουλάχιστον -10%.
Άρα μπορούμε να τα οργανώσουμε πολύ καθαρά σε:
​





Na ελέγξω να δω αν αγοράζει με ιντεντς που δεν ξεπερνούν τον κανόνα του 7%


Υπόθεση: trigger `age≥30s && curve_silence≥10s`, execution delay 1,5s και οι πραγματικοί τύποι quote/fees του repository.

Προσωρινή επιλογή: **4 συνεχόμενα sells**, αλλά όχι μόνο του. Ως αυτόνομος κανόνας παραμένει υπερβολικά επιθετικός· χρειάζεται συνδυασμό με silence ή `sell_all`.


Κρατάμε ως υποψήφιους κανόνες:
- `Death signal`: `position_age ≥ 30s && curve_silence ≥ 10s`.
- `Sell pressure`: exit μετά από `4 συνεχόμενα επιβεβαιωμένα sells`.
- Πιθανός τελικός συνδυασμός: `4 sells` μαζί με `curve silence` ή επιβεβαιωμένο `sell_all`.
- Δεν εφαρμόζονται ακόμη στον κώδικα· παραμένουν για τελική συνδυαστική αξιολόγηση.





https://gmgn.ai/api/v1/tokens/rug_history/sol/89jMLY3GJuh8KWKf8KenMa3v9YP4fyTJ5vFAsL3jpump?device_id=804a297f-3fcf-42c2-a223-bd311cf9c027&fp_did=bca4e603f3b22beb89ad4bf88505a07e&client_id=gmgn_web_20260807-3055-c6ad758&from_app=gmgn&app_ver=20260807-3055-c6ad758&tz_name=Europe%2FAthens&tz_offset=10800&app_lang=en-US&os=web&worker=0


|Σημείο σύνδεσης|Πιθανή διακοπή|Υπάρχον handling|Κενό / κίνδυνος|Κατάσταση|
|---|---|---|---|---|
|Deshred gRPC|`transport closing`, HTTP/2 reset, EOF|Αυτόματο reconnect, `deshredHealthy=false/true`, απόρριψη stale generation|Χάνονται intents κατά το κενό· δεν υπάρχει replay|Μερικό|
|Yellowstone gRPC|`Unavailable`, `RST_STREAM CANCEL`, EOF|Αυτόματο reconnect, νέο cache generation, resubscribe|Τα `Global/FeeConfig` πρέπει να ξαναφτάσουν. Αν το `FeeConfig` δεν εκπέμψει update, μπλοκάρουν όλα τα sells|**Προβληματικό**|
|Yellowstone curve accounts|Reconnect ή χαμένο subscription|Το tracked lifecycle διατηρεί active-position curves και κάνει reconcile ανά 250 ms|Queue-full update μπορεί να χαθεί· δεν διακρίνεται εγγυημένο retry|Μερικό|
|Yellowstone wallet transactions|Διακοπή ενώ έχει σταλεί trade|Reconnect και συνέχιση confirmation stream, blockhash expiry/manual resolution|Δεν υπάρχει εγγύηση replay των transactions που πέρασαν μέσα στο κενό|Υψηλό ρίσκο|
|Jito tip WebSocket|Abnormal closure, EOF|REST refresh, αναμονή `refresh_seconds`, νέο WebSocket connect|Αν αποτύχει και το REST, το tip cache παλιώνει και μπορεί να μπλοκάρει execution|Καλό/μερικό|
|Jito `sendBundle` HTTP|Timeout, DNS/TLS, 5xx|Παράλληλο ίδιο transaction μέσω Triton RPC· επιστρέφει στο πρώτο success|Αν αποτύχουν και οι δύο διαδρομές, μένει unknown/manual resolution|Αποδεκτό|
|Triton `sendTransaction` RPC|Timeout, transport error|Παράλληλο Jito, sell retries έως 3 με νέο blockhash|Οι δύο έξοδοι ίσως δεν είναι πραγματικά ανεξάρτητες υποδομές|Μερικό|
|Simulation/RPC reads|Timeout ή endpoint failure|Timeouts, safe failure και sell retry|Buy δεν επαναλαμβάνεται· ATA rent μόνο με fallback|Αποδεκτό|
|Jito tip-account preload|REST unavailable κατά το startup|Timeout 3 s|Η εφαρμογή τερματίζει χωρίς retry|Ελλιπές|
|SQLite async writer|Queue full ή writer failure|Μετρητής `db_dropped`, logging|Δεν υπάρχει reopen/recovery· μπορεί να χαθεί operational state|Ελλιπές|



GFee  4yo9CUuTBbds9NFhZd4MzPiZZkUvveXdTnAH8qMsE8ku <-> 4euyaqBe45J5dniAcNARERUo7B1wG96riG21sEpNndfU
Tom CEUA7zVoDRqRYoeHTP58UHU6TR8yvtVbeLrX1dppqoXJ

### Filters
#### Το Stage3 που προκύπτει
Για τα πραγματικά `+1.3` runs DB20–22, ο καλύτερος απλός κανόνας που βρήκα είναι:
1. Stage2 όπως είναι.
2. Stage3 `+1.3 RealSOL` μέσα σε 2s.
3. **Reject αν το +1.3 προήλθε από ένα single step >1.3.** Αυτό είναι ουσιαστικά το φίλτρο που ήδη μπήκε στο DB22.
4. Κατά τη διαδρομή από Stage2 μέχρι το `+1.3`, επιτρέπεται **το πολύ 1 αρνητικό RealSOL step**. Με ≥2 down-steps δεν αγοράζουμε.
5. `09:00–14:00` Ελλάδας: **δεν αγοράζουμε**.
6. `14:00–23:00`: κανονικά.
7. `23:00–09:00`: απαιτούμε το Stage3 να μην επιβεβαιωθεί πριν περάσουν **500ms από το Stage2**.
8. Μετά το entry: **έξοδος περίπου στα 500ms. Τέλος. Όχι 7.5s, όχι 15s max-hold.**
Το `≤1 negative step` δεν είναι ML. Είναι απλώς «το +1.3 χτίστηκε καθαρά ή είχε ήδη αρχίσει buy/sell chop;».


#### Αποτέλεσμα
Με κοινό replay στα πραγματικά entries και authoritative curve:

| DB         | Trades  | PnL νέου κανόνα |
| ---------- | ------- | --------------- |
| DB20       | 183     | **+1.064 SOL**  |
| DB21       | 161     | **+0.212 SOL**  |
| DB22       | 266     | **+0.181 SOL**  |
| **Σύνολο** | **610** | **+1.457 SOL**  |
Win rate περίπου **49.8%**, μέσο αποτέλεσμα περίπου **+0.00239 SOL/trade**.
Τα ίδια DB20–22 με τις πραγματικές policies τους είχαν συνολικά περίπου **-1.457 SOL**. Δεν είναι ακριβώς ίδιο population επειδή ο νέος κανόνας απορρίπτει trades, αλλά αυτή ακριβώς είναι η δουλειά της νέας policy.

#### Filter 1

```
go test -run TestNMinus1PreRuleReplay -v -args \
  -nminus1-dbs="databases/deshred.18.db,databases/deshred.19.db,databases/deshred.20.db,databases/deshred.21.db,databases/deshred.22.db,databases/deshred.23.db"
```

Ναι. Κατέληξα σε **δοκιμασμένο N-1 → N rule**, όχι σε θεωρητικό same-slot αποτέλεσμα.
Το πρακτικό rule είναι:
```
Stage2 PASS
→ πρώτο crossing +0,90 RealSOL
→ actual delta > +1,108 SOL
→ creator prior 1h = 0
→ rSOL@150ms > 3,936 SOL
→ χειρότερο negative step > -0,494 SOL
→ μεγαλύτερο positive step ≤ +1,314 SOL
→ vSOL delta@150ms ≤ 7,491 SOL
→ slot age ≤ 100ms
→ SEND ΤΩΡΑ για είσοδο στο επόμενο slot
```
Το `slot_age ≤100ms` το έβαλα επειδή χρειαζόμαστε πραγματικό χρόνο για να φτάσει το transaction στο **N**.

|Replay|WR|PnL|
|---|---|---|
|Train|51,6%|**+0,061 SOL**|
|Validation|37,5%|**+0,028 SOL**|
|Forward test|**100% (4/4)**|**+0,107 SOL**|
|Σύνολο|**53,5%**|**+0,195 SOL**|
Χρόνος που κερδίζουμε μέχρι το επόμενο slot:
- median **~395ms**
- 25ο percentile **~317ms**
Άρα πρακτικά έχουμε το περιθώριο **300–400ms που χρειαζόμαστε**.
Και το σημαντικότερο: το απλό `+1,3 → απόφαση N → είσοδος N+1` στο ίδιο dataset κατέρρεε περίπου σε **29% WR και -0,92 SOL**.
**Άρα αυτή τη στιγμή η λύση μου είναι αυτό το pre-rule.** Δεν είναι απλώς `+1,1`. Είναι το `+0,90/+1,108` μαζί με τη μορφή της κίνησης και το timing του slot.
Θα το έβαζα πρώτα **shadow ακριβώς έτσι, χωρίς άλλο tuning**, ώστε το επόμενο run να είναι πραγματικό OOS validation.

## Thor
This is your access code:
jjMpziruyKiMTwGbf6A5

Wallet
ETxjmD9Amvne2w6dnDBi25KuMMV8e9ibirgUz98ERQQF

## DeFade
​
Request URL  https://api.defade.org/api/analyze
Request Method POST
Remote Address 69.46.46.34:443
Referrer Policy strict-origin-when-cross-origin

Body { contractAddress: "\<address\>"}

---

![[!__notes-1785591607706.png|940x745]]
![[!__notes-1785591621643.png|940x207]]

![[!__notes-1785591673415.png|940x496]]

