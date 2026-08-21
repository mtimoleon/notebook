
### Shadow μετρήσεις

| 21/8 Fri  | 22/8 Sat | 23/8 Sun | 24/8 Mon |
| --------- | -------- | -------- | -------- |
|           | 23-9     | 23-9     | 23-8     |
|           | 9-14     | 9-14     | 9-14     |
| ~~14-23~~ | 14-23    | 14-23    |          |







Το `≤25ms micro-confirmation` που βρήκαμε το κρατάμε στην άκρη ως επόμενο experiment.


### Initial filter
### Το Stage3 που προκύπτει
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
### Αποτέλεσμα
Με κοινό replay στα πραγματικά entries και authoritative curve:

| DB         | Trades  | PnL νέου κανόνα |
| ---------- | ------- | --------------- |
| DB20       | 183     | **+1.064 SOL**  |
| DB21       | 161     | **+0.212 SOL**  |
| DB22       | 266     | **+0.181 SOL**  |
| **Σύνολο** | **610** | **+1.457 SOL**  |
Win rate περίπου **49.8%**, μέσο αποτέλεσμα περίπου **+0.00239 SOL/trade**.
Τα ίδια DB20–22 με τις πραγματικές policies τους είχαν συνολικά περίπου **-1.457 SOL**. Δεν είναι ακριβώς ίδιο population επειδή ο νέος κανόνας απορρίπτει trades, αλλά αυτή ακριβώς είναι η δουλειά της νέας policy.

### Filter 1

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













### Live tests
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





### Checks για live canary

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

### Checks για gross buy

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
**fast signal / medium signal / late signal / no signal**, και μετά να δούμε για κάθε κατηγορία αν συνέχισε ανοδικά, γύρισε κάτω ή πέθανε.
Και ήδη φαίνεται κάτι σημαντικό: **το signal που έρχεται στα 500–2000ms δεν είναι χειρότερο· αντίθετα αυτά είναι τα καλύτερα mints.**





Στα **2.998 FAST BUY** του dual model:
- `SURVIVOR`: **202 = 6,7%**
- `AMBIGUOUS`: **2.346 = 78,3%**
- `CLEAR_DEAD`: **450 = 15,0%**
Άρα μόνο το **6,7% είναι οι αυστηρά ορισμένοι SURVIVOR**. Τα `AMBIGUOUS` όμως δεν σημαίνει κακά· μέσα εκεί μπορεί να υπάρχουν αρκετά κερδοφόρα/tradeable mints.
Το πρόβλημα που βλέπω είναι κυρίως τα **450 CLEAR_DEAD που περνάνε FAST BUY**. Αυτά θέλουμε να μειώσουμε.





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

# Thor
This is your access code:
jjMpziruyKiMTwGbf6A5

Wallet
ETxjmD9Amvne2w6dnDBi25KuMMV8e9ibirgUz98ERQQF

# DeFade
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

