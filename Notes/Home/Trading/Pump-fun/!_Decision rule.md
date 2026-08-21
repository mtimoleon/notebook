
Ο παρακάτω είναι ο **πλήρης frozen Candidate B entry rule**. Είναι ο ίδιος κανόνας που εφαρμόστηκε χωρίς νέο tuning στο validation και έδωσε precision **56,39%**, recall **53,78%**, specificity **86,99%**, με μηδενικό overlap development–validation.
# Candidate B Entry Decision Rule v1
## 1. Πεδίο εφαρμογής
Ο κανόνας αφορά αποκλειστικά την επιλογή mint για **BUY entry**.
Δεν περιλαμβάνει ακόμη:
- TP ή exit level,
- stop loss,
- timeout θέσης,
- post-entry creator-sell handling,
- fees, slippage ή πραγματικό net PnL,
- ειδικό entry branch για mint που έχει ήδη περάσει το 7%.
Όλοι οι χρόνοι μετρώνται από το authoritative:
```text
create_received_at
```
και όχι από το confirmed baseline.

---
## 2. Frozen παράμετροι
```yaml
candidate_b:
  enabled: true
  reject_mayhem: true
  early_gate:
    decision_window_ms: 100
    quote_present:
      creator_quote_first_sol_min: 1.0
      creator_sell_intent_count_max: 0
    quote_missing:
      exact_token_buy_intent_count_min: 2
      external_buyer1_to_buyer2_gap_ms_max: 45
  entry:
    primary_checkpoint_ms: 500
    fallback_checkpoint_ms: 1000
    observation_max_growth_pct: 7.0
    wallets_500ms_min: 6
    wallets_1000ms_min: 6
    confirmed_external_buy_count_min: 2
    buy_sell_count_ratio_1000ms_min: 1.15
    reject_creator_sell: true
```

---
# 3. Κατάσταση ανά mint
Κάθε mint διατηρεί μία μόνο state machine:
```text
NEW
  |
  v
EARLY_GATE_PENDING
  |
  +--> REJECTED
  |
  v
EARLY_GATE_PASSED
  |
  +--> ENTRY_SELECTED_500MS
  |
  +--> ENTRY_SELECTED_1000MS
  |
  +--> EXPIRED
```
Μόλις ένα mint γίνει:
```text
REJECTED
ENTRY_SELECTED_500MS
ENTRY_SELECTED_1000MS
EXPIRED
```
δεν επαναξιολογείται για δεύτερο entry.

---
# 4. Αρχικός έλεγχος στο create
Με την παραλαβή του authoritative create:
```text
decision_origin = create_received_at
```
Αποθηκεύονται:
```text
mint
creator_address
create_received_at
create_slot
is_mayhem
```
## Άμεσο reject
```text
IF create_is_mayhem == true
    => REJECTED_MAYHEM
```
Αν οποιοδήποτε authoritative πεδίο χαρακτηρίζει αργότερα το mint ως Mayhem πριν από την αγορά:
```text
=> REJECTED_MAYHEM
```

---
# 5. Frozen early gate στα 100ms
Το gate αξιολογείται μία φορά:
```text
decision_at = create_received_at + 100ms
```
Το gate χρησιμοποιεί μόνο intents που ήταν ορατά μέχρι τα 100ms.
## Branch A — υπάρχει creator quote
Το `quote_present` είναι true όταν υπάρχει έγκυρο θετικό:
```text
creator_quote_first_sol
```
Ο κανόνας περνά μόνο όταν:
```text
creator_quote_first_sol >= 1.0
AND
creator_sell_intent_count == 0
```
Διαφορετικά:
```text
=> REJECTED_EARLY_GATE_CREATOR_QUOTE
```
## Branch B — λείπει creator quote
Όταν δεν υπάρχει creator quote, ο κανόνας περνά μόνο όταν:
```text
exact_token_buy_intent_count >= 2
AND
external_buyer1_to_buyer2_gap_ms <= 45
```
Διαφορετικά:
```text
=> REJECTED_EARLY_GATE_QUOTE_MISSING
```
## Fail-closed συμπεριφορά
Αν λείπει απαιτούμενο πεδίο:
```text
creator_quote_first_sol
external_buyer1_to_buyer2_gap_ms
```
το gate αποτυγχάνει.
Δεν γίνεται υπόθεση ή default που επιτρέπει entry.

---
# 6. Κύρια απόφαση στα 500ms
Η απόφαση αξιολογείται στο:
```text
decision_at = create_received_at + 500ms
```
Προϋποθέσεις για να υπάρχει έγκυρο checkpoint:
```text
early_gate_passed == true
confirmed_baseline_available == true
current_confirmed_growth_pct < 7.0
```
Το `current_confirmed_growth_pct < 7%` είναι απαραίτητο για να αναπαραχθεί το dataset πάνω στο οποίο έγινε το validation. Τα time samples παραλείπονταν όταν η curve είχε ήδη περάσει το 7%.
## BUY στα 500ms
```text
IF unique_buy_intent_wallets >= 6
AND confirmed_external_buy_count >= 2
AND creator_sell_seen == false
THEN
    ENTRY_SELECTED_500MS
    => submit BUY
```
Αν δεν περάσει το rule στα 500ms:
```text
=> παραμένει candidate μέχρι το 1s
```
Δεν απορρίπτεται ακόμη, εκτός αν εμφανιστεί hard-reject event.

---
# 7. Fallback απόφαση στο 1s
Η fallback απόφαση αξιολογείται μόνο όταν:
```text
δεν έγινε entry στα 500ms
AND
το mint δεν έχει απορριφθεί
```
Χρόνος:
```text
decision_at = create_received_at + 1000ms
```
Προϋποθέσεις:
```text
confirmed_baseline_available == true
current_confirmed_growth_pct < 7.0
```
## BUY στο 1s
```text
IF unique_buy_intent_wallets >= 6
AND confirmed_external_buy_count >= 2
AND buy_sell_count_ratio >= 1.15
AND creator_sell_seen == false
THEN
    ENTRY_SELECTED_1000MS
    => submit BUY
ELSE
    EXPIRED
```
Μετά το 1s δεν γίνεται νέα entry αξιολόγηση από αυτόν τον κανόνα.

---
# 8. Ορισμοί χαρακτηριστικών
## `unique_buy_intent_wallets`
Αριθμός διαφορετικών wallet addresses που έχουν εμφανιστεί σε qualifying buy intents μέχρι το συγκεκριμένο checkpoint.
```text
distinct(user_address)
```
Δεν είναι:
```text
unique confirmed buyers
```
και δεν πρέπει να αντικατασταθεί με:
```text
unique_external_buyers
```
χωρίς νέα validation.

---
## `confirmed_external_buy_count`
Πλήθος confirmed buy events από wallets διαφορετικά από τον creator, ορατά μέχρι το checkpoint.
```text
count(
    confirmed_trade
    where side == BUY
    and user_address != creator_address
)
```
Μετρά confirmed buy events και όχι distinct wallets.
```text
confirmed_external_buy_count >= 2
```
δεν σημαίνει απαραίτητα δύο διαφορετικά confirmed wallets.

---
## `creator_sell_intent_count`
Πλήθος Deshred sell intents του creator που ήταν ορατά μέχρι τα 100ms.
```text
count(
    intent
    where kind == SELL
    and user_address == creator_address
)
```
Χρησιμοποιείται στο early gate, όχι ως confirmed sell.

---
## `creator_sell_seen`
Confirmed creator sell που έχει παρατηρηθεί μέχρι το checkpoint.
```text
creator_confirmed_sell_count > 0
```
Ο κανόνας απαιτεί:
```text
creator_sell_seen == false
```
και στα 500ms και στο 1s.
Δεν πρέπει να αντικατασταθεί από το:
```text
creator_sell_intent_count == 0
```
επειδή είναι διαφορετικό feature.

---
## `creator_quote_first_sol`
Το SOL quote του πρώτου creator buy intent για το mint.
Χρησιμοποιείται μόνο στο branch όπου υπάρχει διαθέσιμο creator quote.
```text
creator_quote_first_sol >= 1.0
```

---
## `exact_token_buy_intent_count`
Πλήθος buy intents με exact-token input που ήταν ορατά μέχρι τα 100ms.
Χρησιμοποιείται μόνο όταν λείπει το creator quote.

---
## `external_buyer1_to_buyer2_gap_ms`
Χρονική απόσταση ανάμεσα στην πρώτη και τη δεύτερη qualifying external buyer εμφάνιση.
```text
buyer2_received_at - buyer1_received_at
```
Ο κανόνας απαιτεί:
```text
<= 45ms
```

---
## `buy_sell_count_ratio`
Υπολογίζεται από όλα τα confirmed buys και sells μέχρι το checkpoint:
```text
confirmed_buy_count / confirmed_sell_count
```
Η analyzer υλοποίηση χρησιμοποιεί:
```text
if confirmed_sell_count == 0:
    buy_sell_count_ratio = confirmed_buy_count
```
Παραδείγματα:
```text
3 buys / 0 sells => ratio 3.0
3 buys / 1 sell  => ratio 3.0
3 buys / 2 sells => ratio 1.5
```
Δεν είναι buy/sell volume ratio.

---
# 9. Hard-reject γεγονότα πριν από entry
Οποιοδήποτε από τα παρακάτω πριν από το BUY ακυρώνει οριστικά το mint:
```text
mayhem detected
early 100ms gate failed
confirmed creator sell observed
checkpoint deadline > 1000ms
current confirmed growth >= 7%
missing confirmed baseline at 1000ms
duplicate or already pending entry
```
Προτεινόμενα reject reasons:
```text
REJECTED_MAYHEM
REJECTED_EARLY_GATE_CREATOR_QUOTE
REJECTED_EARLY_GATE_QUOTE_MISSING
REJECTED_CREATOR_SELL
REJECTED_ALREADY_CROSSED_7
REJECTED_BASELINE_UNAVAILABLE
REJECTED_500MS_RULE
EXPIRED_1000MS_RULE
REJECTED_DUPLICATE_ENTRY
```
Το `REJECTED_500MS_RULE` δεν είναι τελικό reject· σημαίνει μετάβαση στο fallback του 1s. Στον κώδικα μπορεί να αποθηκεύεται ως diagnostic και όχι ως terminal state.

---
# 10. Ακριβές pseudocode
```go
func EvaluateCandidateB(state *MintState, now time.Time) Decision {
    if state.Terminal() {
        return DecisionNone
    }
    if state.IsMayhem {
        return state.Reject("REJECTED_MAYHEM")
    }
    elapsed := now.Sub(state.CreateReceivedAt)
    if elapsed >= 100*time.Millisecond && !state.EarlyGateEvaluated {
        state.EarlyGateEvaluated = true
        if state.CreatorQuotePresent {
            state.EarlyGatePassed =
                state.CreatorQuoteFirstSOL >= 1.0 &&
                state.CreatorSellIntentCount == 0
        } else {
            state.EarlyGatePassed =
                state.ExactTokenBuyIntentCount >= 2 &&
                state.ExternalBuyer1ToBuyer2GapValid &&
                state.ExternalBuyer1ToBuyer2Gap <= 45*time.Millisecond
        }
        if !state.EarlyGatePassed {
            return state.Reject("REJECTED_EARLY_GATE")
        }
    }
    if !state.EarlyGatePassed {
        return DecisionNone
    }
    if state.CreatorSellSeen {
        return state.Reject("REJECTED_CREATOR_SELL")
    }
    if elapsed >= 500*time.Millisecond && !state.Checkpoint500Evaluated {
        state.Checkpoint500Evaluated = true
        if state.ConfirmedBaselineAvailable &&
            state.CurrentConfirmedGrowthPct < 7.0 &&
            state.UniqueBuyIntentWallets >= 6 &&
            state.ConfirmedExternalBuyCount >= 2 {
            return state.SelectEntry("ENTRY_SELECTED_500MS")
        }
    }
    if elapsed >= 1000*time.Millisecond && !state.Checkpoint1000Evaluated {
        state.Checkpoint1000Evaluated = true
        if !state.ConfirmedBaselineAvailable {
            return state.Reject("REJECTED_BASELINE_UNAVAILABLE")
        }
        if state.CurrentConfirmedGrowthPct >= 7.0 {
            return state.Reject("REJECTED_ALREADY_CROSSED_7")
        }
        if state.UniqueBuyIntentWallets >= 6 &&
            state.ConfirmedExternalBuyCount >= 2 &&
            state.BuySellCountRatio >= 1.15 &&
            !state.CreatorSellSeen {
            return state.SelectEntry("ENTRY_SELECTED_1000MS")
        }
        return state.Reject("EXPIRED_1000MS_RULE")
    }
    return DecisionNone
}
```

---
# 11. Event ordering
Για κάθε checkpoint χρησιμοποιούνται μόνο events με:
```text
event_observed_at <= checkpoint_at
```
Δεν χρησιμοποιείται event που έφτασε μετά το checkpoint, ακόμη κι αν ανήκει στο ίδιο slot.
Για intents της ίδιας create transaction πρέπει να διατηρηθεί η ίδια visibility semantics με τον analyzer: όσα instructions αποκωδικοποιούνται μαζί με το create θεωρούνται ορατά όταν παραλαμβάνεται το create.

---
# 12. Execution semantics
Μόλις επιστραφεί:
```text
ENTRY_SELECTED_500MS
```
ή:
```text
ENTRY_SELECTED_1000MS
```
πρέπει ατομικά να γίνει:
```text
entry_selected = true
buy_in_progress = true
decision_checkpoint = 500ms | 1000ms
decision_at = now
```
πριν ξεκινήσει build/sign/submit.
Αν η αποστολή αποτύχει ή είναι unknown, ακολουθείται το υπάρχον execution/manual-resolution flow. Δεν επανέρχεται το mint στον Candidate B για δεύτερη προσπάθεια επιλογής.

---
# 13. Ελάχιστα υποχρεωτικά tests
```text
1. Mayhem mint απορρίπτεται πριν από όλα τα gates.
2. Quote-present:
   quote=1.0 και creator sells=0 => pass.
   quote<1.0 => reject.
   creator sell intent>0 => reject.
3. Quote-missing:
   exact-token buys=2 και gap=45ms => pass.
   buys<2 => reject.
   gap>45ms => reject.
   missing gap => reject.
4. 500ms:
   wallets=6, confirmed external buys=2, no sell => entry.
   wallets=5 => fallback.
   buys=1 => fallback.
   creator sell=true => reject.
5. 1s:
   wallets=6, buys=2, ratio=1.15 => entry.
   ratio<1.15 => expire.
   missing ratio => expire.
6. confirmed sells=0:
   buy_sell_count_ratio πρέπει να ισούται με confirmed_buy_count.
7. Baseline unavailable στα 500ms:
   επιτρέπεται αναμονή μέχρι 1s.
8. Baseline unavailable στο 1s:
   terminal reject.
9. Curve >=7% πριν από decision:
   reject από τον Candidate B.
10. Entry στα 500ms:
    το checkpoint του 1s δεν αξιολογείται.
11. Concurrent events:
    δεν επιτρέπεται διπλό BUY.
12. Late event μετά το checkpoint:
    δεν αλλάζει αναδρομικά την απόφαση.
```

---
# 14. Κατάσταση validation
Ο frozen κανόνας έδωσε στο validation:
```text
population: 999
selected: 227
entries_500ms: 203
entries_1000ms: 24
precision: 56.39%
recall: 53.78%
specificity: 86.99%
precision_lift: 2.357x
```
Το validation επιβεβαιώνει την ικανότητα επιλογής του υπάρχοντος future-opportunity label. Δεν επιβεβαιώνει ακόμη θετικό executable net PnL.


Η υλοποίηση πρέπει να αντιγράψει ακριβώς τους παραπάνω feature definitions· ειδικά το `unique_buy_intent_wallets`, το `creator_sell_seen` και το zero-sell behavior του `buy_sell_count_ratio`.