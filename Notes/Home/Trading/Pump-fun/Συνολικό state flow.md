
## Συνολικό state flow
```text
BUY confirmed
    ↓
HOLDING
    ↓
Αξιολόγηση exits σε κάθε market event και περιοδικά
    ↓
Ένα exit κερδίζει το atomic latch
    ↓
EXIT_PENDING
    ├─ ακύρωση πριν το submit ─────────────→ HOLDING
    ├─ predicted TP αποτυγχάνει με 6003 ──→ HOLDING, fast TP disabled
    ├─ αβέβαιο/εξαντλημένα retries ───────→ MANUAL_RESOLUTION
    └─ επιτυχής Yellowstone επιβεβαίωση ──→ CLOSED
                                                 ↓
                                         async ATA close
```
## 1. Πώς ξεκινά η αξιολόγηση του sell
Μόλις επιβεβαιωθεί το buy από Yellowstone:
- η θέση γίνεται `holding`,
- αποθηκεύεται το πραγματικό token amount,
- αποθηκεύονται τα πραγματικά fees,
- το confirmed post-buy curve γίνεται η βάση για stop-loss και exits.
Η `evaluatePositionExits()` καλείται:
- όταν έρχεται νέο buy/sell event για το mint,
- περιοδικά για time-based exits όπως `max_hold`,
- κατά το graceful shutdown.
Αν η θέση δεν είναι `holding`, δεν ξεκινά νέα αξιολόγηση. Άρα όσο υπάρχει sell σε εξέλιξη (`exit_pending`), άλλο trigger δεν μπορεί να ξεκινήσει δεύτερο sell.

---
# 2. Τα δύο διαφορετικά curve views
## Authoritative curve
Προέρχεται κατά σειρά από:
1. επιβεβαιωμένο Yellowstone `TradeEvent`,
2. Yellowstone account snapshot/cache,
3. RPC fallback μόνο όταν δεν υπάρχει usable memory state.
Αυτό αντιπροσωπεύει την πραγματική εκτελεσμένη κατάσταση της καμπύλης.
## Conservative curve
Χρησιμοποιεί:
```text
authoritative curve
+ νεότερα pending external sells
```
Δεν προσθέτει pending buys.
Χρησιμοποιείται για:
- stop-loss,
- sell pressure,
- creator sell,
- trailing stop,
- profit lock,
- max hold,
- confirmed sell-all.
Έτσι ένα μη επιβεβαιωμένο buy δεν μπορεί να κάνει ένα emergency exit να φαίνεται τεχνητά καλύτερο.
## Predicted curve
Χρησιμοποιεί:
```text
authoritative curve
+ pending external buys
+ pending external sells
```
Τα intents εφαρμόζονται με τη σειρά που παρατηρήθηκαν.
Αγνοούνται:
- το δικό μας wallet,
- το δικό μας entry intent,
- intents πριν από την είσοδό μας,
- διπλές signatures/instructions.
Χρησιμοποιείται αποκλειστικά για `take_profit_predicted`.

---
# 3. Σειρά προτεραιότητας των exits
Η σειρά μέσα στο `evaluatePositionExits()` είναι:
```text
1. Confirmed sell-all
2. Emergency/non-TP exits
3. Authoritative TP
4. Predicted fast TP
5. Max hold
```
Μόλις ένα trigger κάνει τη θέση `exit_pending`, τα επόμενα δεν αξιολογούνται.
## Emergency/non-TP exits
Με αυτή τη σειρά:
1. `creator_sell`
2. `creator_full_exit`
3. `sell_pressure_3s`
4. `stop_loss`
5. `failed_pump`
6. `early_stall`
7. `profit_lock`
8. `trailing_stop`
Αυτά ξεκινούν sell με:
```text
emergency = true
profitProtected = false
```
Δηλαδή προτεραιότητα έχει να κλείσει η θέση, όχι να προστατευτεί συγκεκριμένο minimum profit.

---
# 4. Authoritative Take Profit
Υπολογίζεται sell quote πάνω στο πραγματικό authoritative curve.
Το πραγματικό entry cost είναι:
```text
entry curve debit
+ entry base fee
+ entry priority fee
+ entry tip
```
Το αναμενόμενο sell cost είναι:
```text
sell base fee
+ sell priority fee
+ normal exit tip
+ εκτιμώμενο ATA close cost
```
Το TP ενεργοποιείται όταν:
```text
sell net proceeds
- entry cost
- expected sell costs
>= configured TP profit
```
Για παράδειγμα με TP `2%`:
```text
target profit = entry cost × 2%
```
Το minimum output του transaction γίνεται:
```text
entry cost
+ expected sell costs
+ target profit
```
Άρα το authoritative TP είναι **profit-protected**. Δεν χρησιμοποιεί απλώς «τρέχον quote με 5% slippage».
### Pre-submit επανέλεγχος
Πριν υπογραφεί και σταλεί το πρώτο sell:
1. ξαναδιαβάζεται το authoritative curve,
2. ξαναϋπολογίζονται fees και tip,
3. ελέγχεται ξανά το TP.
Αν δεν ισχύει πλέον:
```text
exit_pending → holding
order state → cancelled
reason → take_profit_no_longer_valid
```
Δεν καταναλώνεται sell attempt και δεν πληρώνεται fee.
Μετά το πρώτο πραγματικό submission, το authoritative TP θεωρείται latched και τα landed failures ακολουθούν την πολιτική retries.

---
# 5. Predicted Fast Take Profit
Το fast TP προσπαθεί να πουλήσει πριν επιβεβαιωθούν on-chain τα external buys.
Για να ενεργοποιηθεί χρειάζεται:
```text
predicted_take_profit.enabled = true
τουλάχιστον min_external_buy_intents
predicted net PnL >= fast TP threshold
```
Το threshold είναι:
```text
max(
    normal TP × multiplier,
    normal TP + minimum_extra_pct
)
```
Με:
```yaml
take_profit: 2%
multiplier: 1.5
minimum_extra_pct: 0.5
```
το fast threshold είναι:
```text
max(3%, 2.5%) = 3%
```
Το predicted PnL περιλαμβάνει:
- πραγματικό κόστος εισόδου,
- protocol/creator sell fees,
- network fees,
- normal exit tip,
- ATA close cost.
Δεν αρκεί απλώς να ανέβηκε το virtual SOL της curve.
## Pre-submit refresh του predicted TP
Πριν από το submission:
1. ελέγχεται πρώτα το authoritative TP,
2. αν πλέον ισχύει, το reason αναβαθμίζεται σε:
```text
take_profit_authoritative
```
3. διαφορετικά ξαναχτίζεται το predicted curve,
4. ξαναμετριούνται τα external buy intents,
5. ξαναϋπολογίζεται το predicted net PnL.
Αν δεν ισχύει πια:
```text
exit_pending → holding
reason → take_profit_predicted_cancelled
```
Δεν στέλνεται transaction.
## Μετά από `6003`
Το Pump error `6003` σημαίνει ότι το πραγματικό curve δεν μπορούσε να δώσει το απαιτούμενο minimum SOL.
Με την τελευταία πολιτική:
```text
πρώτο predicted TP sell
        ↓
landed failure 6003
        ↓
position → holding
        ↓
predicted TP disabled οριστικά για αυτή τη θέση
```
Δεν γίνεται δεύτερο fast TP για την ίδια θέση, ακόμη και αν αλλάξει το curve.
Παραμένουν ενεργά:
- authoritative TP,
- stop-loss,
- creator/sell-pressure exits,
- max hold,
- confirmed sell-all,
- graceful shutdown.

---
# 6. Stop-loss
Το stop-loss δεν συγκρίνει απλώς το συνολικό PnL της αγοράς.
Χρησιμοποιεί το confirmed post-entry curve και υπολογίζει:
```text
πόσα SOL θα παίρναμε αν πουλούσαμε αμέσως μετά την αγορά
```
Αυτό είναι το `entry liquidation value`.
Έπειτα το συγκρίνει με το σημερινό conservative liquidation value:
```text
entry liquidation value
vs
current liquidation value
```
Άρα η επίδραση της δικής μας αγοράς στο curve δεν θεωρείται από μόνη της ζημιά. Το stop-loss μετρά την κίνηση που έγινε **μετά** την είσοδό μας.

---
# 7. Confirmed sell-all
Το Deshred sell-all intent από μόνο του δεν προκαλεί άμεσο exit.
Η ακολουθία είναι:
```text
Deshred full-sell intent
    ↓
καταγράφεται ως pending
    ↓
Yellowstone transaction result
    ├─ failed → διαγράφεται
    └─ successful full sell TradeEvent
             ↓
       deshred_sell_all_confirmed
```
Για το quote χρησιμοποιείται:
```text
authoritative post-sell curve
+ μόνο νεότερα pending external sells
```
Το sell-all είναι emergency και χρησιμοποιεί emergency tip/slippage policy.

---
# 8. Δημιουργία και αποστολή sell transaction
Το `requestExit()` κάνει πρώτα atomic μετάβαση:
```text
holding → exit_pending
```
Μετά δημιουργεί `ExecutionRequest` με:
- όλο το token balance,
- exit reason,
- emergency flag,
- profit-protection flag,
- current quote,
- minimum lamports,
- tip,
- priority fee,
- sell slippage,
- max attempts.
Τα sell requests μπαίνουν στην urgent queue του per-mint worker.
Πριν από κάθε build:
1. ελέγχεται ότι η θέση είναι ακόμη `exit_pending`,
2. γίνεται refresh του curve/quote,
3. γίνεται refresh fee/tip,
4. υπολογίζεται νέο minimum output,
5. λαμβάνεται fresh blockhash,
6. χτίζεται και υπογράφεται το transaction.
Το ίδιο υπογεγραμμένο transaction μεταδίδεται μέσω:
- Triton RPC,
- Jito.
Το Jito `429` δεν σημαίνει απαραίτητα ότι απέτυχε το RPC path.

---
# 9. Confirmation και retries
Η επιτυχία ή αποτυχία κρίνεται από Yellowstone, όχι από την απάντηση του submit endpoint.
## Επιτυχία
Απαιτείται matching Pump `TradeEvent` με:
- ίδιο mint,
- δικό μας wallet,
- σωστό side,
- πραγματικό token και SOL amount.
Τότε:
```text
exit_pending → closed
```
Αποθηκεύονται:
- πραγματικό gross/net SOL,
- protocol fee,
- creator fee,
- network fee,
- priority fee,
- tip,
- exit signature,
- exit slot,
- exit reason,
- realized PnL.
Μετά ξεκινά async ATA close.
## Landed failure
### Predicted TP + `6003`
```text
χωρίς retry
→ holding
→ predicted TP disabled για τη θέση
```
### Άλλο sell + `6003`
Αυξάνεται προοδευτικά το sell slippage μέχρι το αντίστοιχο cap και γίνεται retry.
### Άλλο retryable failure
Γίνεται retry μέχρι:
```yaml
strategy.exit.retry.max_attempts
```
Μόνο πραγματικό transaction submission που απέτυχε on-chain καταναλώνει attempt. Build/refresh/quote failures πριν από submission δεν αυξάνουν το attempt.
## Submission unknown
Όταν δεν γνωρίζουμε με ασφάλεια αν το transaction μεταδόθηκε ή landed:
```text
position → manual_resolution
```
Δεν γίνεται τυφλό retry, επειδή μπορεί να πουληθεί δύο φορές.
## Exhausted attempts
```text
position → manual_resolution
reason → sell_attempts_exhausted
```
Αν αργότερα φτάσει επιβεβαίωση του transaction, η θέση μπορεί να μετακινηθεί από `manual_resolution` σε `closed`.

---
# 10. ATA close
Μετά το επιτυχές sell:
```text
position = closed
```
και ξεκινά ξεχωριστό `close_ata` transaction.
Η αποτυχία του ATA close:
- δεν ξανανοίγει τη θέση,
- δεν επηρεάζει την επιτυχία του sell,
- καταγράφεται ξεχωριστά,
- το rent θεωρείται recovered μόνο μετά την επιβεβαίωση του close.

---
# 11. Graceful shutdown
Στο shutdown:
1. σταματούν οι νέες entries,
2. όλες οι `holding` θέσεις παίρνουν emergency sell,
3. προτιμάται authoritative/reconciled curve,
4. μόνο αν δεν υπάρχει καθόλου authoritative snapshot επιτρέπεται predicted fallback,
5. το shutdown περιμένει να μη μείνουν active θέσεις.
Οι `manual_resolution` θέσεις θεωρούνται active. Γι’ αυτό μπορεί το console να γράφει `open_positions=0`, αλλά το shutdown να κάνει timeout με μία unresolved θέση.

---
## Τελική διάκριση

|Exit|Curve|Profit protected|Retry μετά από 6003|
|---|---|--:|--:|
|Authoritative TP|Πραγματικό authoritative|Ναι|Ναι, μετά το πρώτο submit|
|Predicted TP|Authoritative + pending buys/sells|Ναι|Όχι, απενεργοποιείται|
|Stop-loss / emergency|Authoritative + pending sells|Όχι|Ναι|
|Confirmed sell-all|Post-sell authoritative + νεότερα sells|Όχι|Ναι|
|Max hold|Authoritative + pending sells|Όχι|Ναι|
|Graceful shutdown|Authoritative, predicted μόνο fallback|Όχι|Ναι|