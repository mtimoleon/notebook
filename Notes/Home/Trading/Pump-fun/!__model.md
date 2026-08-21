
# Dead Outcome Classifier – Methodology and Model Documentation
## 1. Σκοπός
Το `dead_outcome` model δημιουργήθηκε ως **early rejection filter** για Pump.fun mints.
Ο στόχος του δεν είναι να προβλέψει άμεσα αν ένα trade θα είναι κερδοφόρο. Προσπαθεί να απαντήσει, περίπου 50 ms μετά το create:
**«Πόσο πιθανό είναι αυτό το mint να μην αναπτύξει ουσιαστική συνέχεια μέσα στα επόμενα 7 δευτερόλεπτα;»**
Η έξοδος του μοντέλου είναι:
`P(dead)`
και η frozen απόφαση που χρησιμοποιήθηκε στο shadow test ήταν:
`would_reject = P(dead) >= 0.990`

---
# 2. Πώς προέκυψε το target
Αρχικά δεν επιβλήθηκε απευθείας ένας αυθαίρετος κανόνας για το τι είναι dead.
Έγινε trajectory analysis των πραγματικών mints για έως **7 δευτερόλεπτα μετά το create**.
Για την ανακατασκευή της πραγματικής κίνησης χρησιμοποιήθηκαν:
- Yellowstone `curve_snapshots`.
- Confirmed `trade_fills`.
- `virtual_sol_reserves`.
- `virtual_token_reserves`.
- creator identification.
- confirmed buy/sell activity.
Τα snapshots και τα confirmed fills ενώθηκαν χρονικά και έγινε deduplication. Στα development δεδομένα χρησιμοποιήθηκαν 35 databases, με 277.860 raw snapshot points και 286.816 trade-fill curve points, που μετά το merge έγιναν 338.914 curve points.
## 2.1 Trajectory χαρακτηριστικά
Για την ανακάλυψη των patterns χρησιμοποιήθηκαν χαρακτηριστικά όπως:
- `max_gain_pct`
- `min_gain_pct`
- `final_gain_pct`
- `time_to_peak_ms`
- `post_peak_drawdown_pct`
- `post_peak_recovery_pct`
- `mean_gain_time_weighted_pct`
- `positive_step_fraction`
- `buy_count_7s`
- `sell_count_7s`
- `unique_external_buyers_7s`
- `buy_sol_7s`
- `sell_sol_7s`
- `dev_sell_seen`
- `dev_sell_count_7s`
- `dev_sell_sol_7s`
- `dev_sell_share_of_sell_sol`
- `first_dev_sell_ms`
- `gain_at_first_dev_sell_pct`
- `max_gain_after_dev_sell_pct`
- `dev_post_drawdown_pct`
- `dev_post_recovery_pct`
- `new_high_after_dev_sell`
- post-dev buy/sell activity
- gain στα 100, 250, 500, 1000, 2000, 3000, 5000 και 7000 ms.
Αυτά τα χαρακτηριστικά χρησιμοποιήθηκαν **μόνο για την ανάλυση του μελλοντικού outcome και την κατασκευή labels**. Δεν δίνονται στο live μοντέλο.

---
# 3. Patterns που εντοπίστηκαν
Η trajectory analysis έδειξε χονδρικά τέσσερις συμπεριφορές:
1. Flat / weak mint.
2. Early dump / dev dump.
3. Strong continuation.
4. Early spike και στη συνέχεια fade.
Το clustering χρησιμοποιήθηκε ως εργαλείο **discovery**, όχι ως τελικό ground truth.
Από εκεί περάσαμε σε deterministic labels.

---
# 4. Αρχικός ορισμός labels
## CLEAR_DEAD
Ένα mint χαρακτηριζόταν `CLEAR_DEAD` όταν:
1. Υπήρχε μόνο ένα curve event σε πλήρως καλυμμένο 7s horizon,
ή
2. ίσχυαν ταυτόχρονα:
`max_gain_pct <= 15%`
και
`final_gain_pct <= 10%`
## SURVIVOR
Ο αρχικός ορισμός `SURVIVOR` απαιτούσε:
- `max_gain_pct >= 35%`
- `final_gain_pct >= 15%`
- `unique_external_buyers_7s >= 10`
- να έχει παρατηρηθεί dev sell
- να δημιουργήσει νέο high μετά το dev sell.
Όλα τα υπόλοιπα χαρακτηρίζονταν:
`AMBIGUOUS`
και **δεν χρησιμοποιούνταν στο training**.
Στο development dataset προέκυψαν:
- `CLEAR_DEAD`: 2.245
- `SURVIVOR`: 101
- `AMBIGUOUS`: 518
- Binary training labels: 2.346.

---
# 5. Input του πραγματικού μοντέλου
Το μοντέλο δεν βλέπει τα επόμενα 7s.
Βλέπει μόνο πληροφορία διαθέσιμη περίπου στα:
**50 ms από το create**
και χρησιμοποιεί συνολικά **111 features**.
## 5.1 Curve / Yellowstone state features – 27
- `n_updates`
- `n_updates_20ms`
- `n_updates_50ms`
- `first_snapshot_delay_ms`
- `time_since_update_ms`
- `spot_change_pct`
- `spot_change_20ms_pct`
- `spot_change_50ms_pct`
- `max_gain_seen_pct`
- `max_drawdown_seen_pct`
- `positive_steps`
- `negative_steps`
- `last_step_pct`
- `abs_step_sum_pct`
- `vsol_current_sol`
- `rsol_current_sol`
- `vsol_delta_sol`
- `rsol_delta_sol`
- `confirmed_trades`
- `confirmed_buys`
- `confirmed_sells`
- `confirmed_unique_buyers`
- `buy_sol`
- `sell_sol`
- `buy_sell_sol_ratio`
- `last_trade_age_ms`
- `creator_sell_seen`
Αυτή η ομάδα περιγράφει την πολύ πρώιμη πραγματική κατάσταση της bonding curve και ό,τι έχει ήδη επιβεβαιωθεί μέσω Yellowstone.
## 5.2 Raw Deshred intent features – 34
- `intent_total`
- `intent_buys`
- `intent_sells`
- `intent_unique_buy_signatures`
- `intent_unique_sell_signatures`
- `intent_unique_buyers`
- `intent_unique_sellers`
- `intent_external_buys`
- `intent_external_unique_buyers`
- `intent_buy_exact_quote_count`
- `intent_buy_exact_tokens_count`
- `intent_exact_quote_buy_sol`
- `intent_exact_quote_buy_sol_max`
- `intent_external_exact_quote_buy_sol`
- `intent_creator_buys`
- `intent_creator_sells`
- `intent_pre_anchor_buys`
- `intent_pre_anchor_sells`
- `intent_post_anchor_buys`
- `intent_post_anchor_sells`
- `intent_buys_last_100ms`
- `intent_buys_last_250ms`
- `intent_buys_last_1000ms`
- `intent_sells_last_100ms`
- `intent_sells_last_250ms`
- `intent_sells_last_1000ms`
- `intent_exact_quote_sol_last_1000ms`
- `intent_last_buy_age_ms`
- `intent_last_sell_age_ms`
- `intent_buy_interarrival_median_ms`
- `intent_buy_interarrival_min_ms`
- `intent_buy_accel_ratio`
- `intent_buy_sell_count_ratio`
- `intent_top_buyer_share`
Αυτά περιγράφουν κυρίως:
- πόση πρόθεση αγοράς υπάρχει,
- πόσο γρήγορα εμφανίζονται buyers,
- buy/sell imbalance,
- concentration,
- acceleration,
- πραγματικά γνωστά SOL amounts όπου υπάρχουν exact quotes.
Τα exact-token intents δεν μετατρέπονται αυθαίρετα σε SOL.
## 5.3 Creator / buyer structure features – 50
### Creator
- `creator_initial_buy_intents`
- `creator_initial_exact_quote_intents`
- `creator_initial_exact_token_intents`
- `creator_initial_buy_sol`
- `creator_initial_amount_complete`
### External buyer aggregate
- `external_buy_total_priced_sol`
- `external_buy_priced_wallets`
- `external_buy_unpriced_intents`
- `external_amount_complete`
- `external_creator_ratio`
- `external_each_wallet_has_exact_quote`
- `external_exact_quote_wallet_ratio`
### Buyer concentration
- `external_top1_priced_sol_share`
- `external_top2_priced_sol_share`
- `external_top3_priced_sol_share`
- `external_top25pct_wallets_priced_sol_share`
- `external_top50pct_wallets_priced_sol_share`
- `external_top75pct_wallets_priced_sol_share`
- `external_wallet_priced_sol_hhi`
### Buyer 1
- `buyer1_delay_ms`
- `buyer1_total_priced_sol`
- `buyer1_first_intent_priced_sol`
- `buyer1_intent_count`
- `buyer1_exact_quote_intents`
- `buyer1_exact_token_intents`
- `buyer1_amount_complete`
- `buyer1_priced_amount_share`
### Buyer 2
- `buyer2_delay_ms`
- `buyer2_total_priced_sol`
- `buyer2_first_intent_priced_sol`
- `buyer2_intent_count`
- `buyer2_exact_quote_intents`
- `buyer2_exact_token_intents`
- `buyer2_amount_complete`
- `buyer2_priced_amount_share`
### Buyer 3
- `buyer3_delay_ms`
- `buyer3_total_priced_sol`
- `buyer3_first_intent_priced_sol`
- `buyer3_intent_count`
- `buyer3_exact_quote_intents`
- `buyer3_exact_token_intents`
- `buyer3_amount_complete`
- `buyer3_priced_amount_share`
### Buyer timing / relationships
- `buyer_gap_1_2_ms`
- `buyer_gap_2_3_ms`
- `buyer2_to_buyer1_priced_amount_ratio`
- `buyers_ready_2_delay_ms`
- `buyers_ready_3_delay_ms`
- `buyers_ready_2_lead_to_checkpoint_ms`
- `buyers_ready_3_lead_to_checkpoint_ms`

---
# 6. Machine-learning model
Ο classifier είναι:
**HistGradientBoostingClassifier**
με:
- `max_iter = 240`
- `learning_rate = 0.035`
- `max_leaf_nodes = 15`
- `min_samples_leaf = 20`
- `l2_regularization = 3.0`
Η επιλογή gradient-boosted decision trees επιτρέπει:
- nonlinear relationships,
- interactions μεταξύ buyers, curve και intents,
- handling διαφορετικών scales,
- χωρίς ανάγκη manual linear weighting.
Επειδή τα dead mints είναι πολύ περισσότερα από τους survivors, χρησιμοποιήθηκαν **balanced sample weights**, με ανώτατο class-weight ratio `20`.

---
# 7. Probability calibration
Η raw πιθανότητα του gradient boosting δεν χρησιμοποιείται απευθείας.
Μετά το classifier εφαρμόζεται calibration μέσω:
**LogisticRegression πάνω στο logit της raw probability.**
Στόχος είναι το `P(dead)` να είναι πιο κοντά σε πραγματική πιθανότητα και όχι απλώς ranking score.

---
# 8. Chronological training
Δεν έγινε random train/test split.
Τα δεδομένα ταξινομήθηκαν χρονικά.
Η development διαδικασία χρησιμοποιεί:
- αρχικό ιστορικό: 40%
- expanding chronological OOF
- 5 folds
- calibration fraction: 15%.
Σε κάθε fold:
`παρελθόν → training/calibration`
και:
`μεταγενέστερα mints → OOF prediction`
Έτσι το μοντέλο δεν εκπαιδεύεται σε δεδομένα που χρονικά βρίσκονται μετά από το mint που αξιολογεί.

---
# 9. Threshold selection
Το threshold δεν επιλέχθηκε για maximum accuracy.
Οι safety constraints ήταν:
- `dead_precision >= 98%`
- `survivor_reject_rate <= 5%`
- τουλάχιστον 50 rejects.
Μέσα στα thresholds που περνούσαν αυτούς τους περιορισμούς επιλεγόταν εκείνο που έκοβε τα περισσότερα dead mints.
Το frozen αποτέλεσμα ήταν:
`P(dead) >= 0.990`

---
# 10. Offline αποτελέσματα
## Development OOF
Με `P(dead) >= 0.990`:
- dead precision: **99,60%**
- dead recall: **36,31%**
- survivor reject: **3,85%**
## Untouched validation
- dead precision: **99,78%**
- dead recall: **57,95%**
- survivor reject: **4,65%**
- AUC: περίπου **0,91**
Το validation δεν χρησιμοποιήθηκε για threshold selection.
## Frozen final holdout
Χωρίς retraining, recalibration ή νέο threshold search:
- 1.649 evaluated mints
- 1.557 `CLEAR_DEAD`
- 92 `SURVIVOR`
- 913 rejects
- 911 σωστά dead rejects
- 2 false survivor rejects
- dead precision: **99,78%**
- dead recall: **58,51%**
- survivor reject: **2,17%**
- AUC: **0,901**
Το offline αποτέλεσμα επομένως φαινόταν ιδιαίτερα ισχυρό.

---
# 11. Shadow implementation
Το frozen Python model μεταφέρθηκε σε native Go evaluator.
Το runtime:
1. συλλέγει τα ίδια 111 features,
2. αξιολογεί στα ~50 ms,
3. υπολογίζει `p_dead`,
4. εφαρμόζει μόνο εικονικά:
`would_reject = p_dead >= 0.990`
5. γράφει το αποτέλεσμα στον:
`dead_outcome_predictions`
Το shadow mode δεν άλλαζε την πραγματική entry απόφαση.

---
# 12. Σημαντικό εύρημα από το πραγματικό shadow run
Το shadow test αποκάλυψε μία ουσιαστική αδυναμία που δεν φαινόταν στα offline metrics.
Στο τελικό run:
- 464 πραγματικά closed trades.
- 126 winners.
- 17 από αυτούς τους winners θα είχαν απορριφθεί από το dead filter.
Δηλαδή:
**13,49% των πραγματικών winners θα χάνονταν.**
Επίσης, αν το φίλτρο εφαρμοζόταν στα πραγματικά trades:
- 326 trades θα περνούσαν.
- 109 θα ήταν wins.
- 217 θα ήταν losses.
- win rate: **33,44%**.
- realized PnL περίπου **-2,78 SOL**.
Το φίλτρο επομένως αφαιρεί κακές περιπτώσεις, αλλά **δεν αποτελεί profitability classifier**.

---
# 13. Γιατί εμφανίστηκε αυτή η διαφορά
Το πρόβλημα βρίσκεται κυρίως στο target definition.
Το αρχικό `SURVIVOR` ήταν υπερβολικά στενό:
- απαιτούσε dev sell,
- απαιτούσε νέο high μετά από dev sell,
- απαιτούσε συγκεκριμένη 7s συμπεριφορά.
Έτσι υπήρχαν mints που:
- ήταν πραγματικά profitable,
- έκαναν πολύ μεγάλη άνοδο,
- ή έγιναν profitable αργότερα μέσα στο 15s max hold,
αλλά δεν χαρακτηρίζονταν `SURVIVOR`.
Το μοντέλο επομένως έκανε αρκετά σωστά αυτό που του ζητήθηκε.
**Το πρόβλημα ήταν ότι το label δεν αντιπροσώπευε πλήρως τον πραγματικό trading στόχο.**

---
# 14. Σωστή ερμηνεία του σημερινού μοντέλου
Το `dead_outcome` πρέπει να θεωρείται:
**Stage-1 structural dead-mint filter**
και όχι:
**final entry profitability model.**
Η σημερινή αρχιτεκτονική πρέπει να εξελιχθεί προς:
`Mint`
​
→ `Stage 1: obvious dead/rejection probability`
​
→ `Stage 2: probability of profitable trade`
​
→ `Entry`
Το Stage 2 πρέπει να εκπαιδευτεί πάνω στον πραγματικό στόχο:
`50ms features → probability of positive realized/net PnL`
με ακριβώς τα πραγματικά:
- entry mechanics,
- fees,
- slippage,
- take profit,
- stop loss,
- trailing stop,
- profit lock,
- max hold,
- execution latency.

---
# 15. Τρέχουσα κατάσταση
Το υπάρχον dead model:
- έχει καλή ικανότητα να εντοπίζει προφανώς κακά mints,
- έχει πολύ υψηλή precision στα deterministic dead labels,
- αλλά δεν προστατεύει επαρκώς όλους τους πραγματικούς winners,
- και δεν μπορεί από μόνο του να ανεβάσει το win rate σε κερδοφόρο επίπεδο.
Επομένως η επόμενη έκδοση δεν πρέπει απλώς να «βελτιώσει το dead precision».
Πρέπει να αλλάξει ο τελικός optimization στόχος προς:
**διατήρηση των πραγματικών winners και απόρριψη των trades που θα καταλήξουν σε αρνητικό realized PnL.**