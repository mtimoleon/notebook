
### ingestion

Μετά το SQLite ingestion, εγώ θα πήγαινα με αυτή τη σειρά:
1. **Έλεγχος ότι το master είναι πλήρες και καθαρό**
```bash
py master_dataset_mysql_v320.py stats
```
και μετά:
```bash
py master_dataset_mysql_v320.py prune-orphans
```
Θέλουμε να ελέγξουμε:
- πόσες sources είναι `ok`
- πόσα canonical mints
- πόσα `dm_curve_events`
- intents / fills / stored features
- αν έμειναν `error`, `running` ή duplicate sources
2. **Native ingest από `CoinTrades`**
    ​
    Θα φτιάξουμε `ingest-cointrades` με δεύτερο DSN:
```env
MYSQL_DSN=.../DeshredMaster?parseTime=true
COINTRADES_DSN=.../CoinTrades?parseTime=true
```
και θα πάρουμε επιλεκτικά:
- `observed_coins`
- `decoded_launch_cache`
- `normalized_token_events`
- `trade_fills`
- `trade_positions`
- `paper_positions`
- `trade_orders`
- `tx_submissions`
- `tx_confirmations`
- `token_processing_latencies`
- `creator_stats`
- πιθανώς `trade_curve_polls`, αφού πρώτα επιβεβαιώσουμε τι ακριβώς είναι το `curve_sol`.
Η `CoinTrades` θα είναι **incremental με checkpoints**, όχι full copy κάθε φορά.
3. **Canonical dedup / source priority**
    ​
    Πρέπει να καθορίσουμε όταν το ίδιο mint/event υπάρχει σε περισσότερες από μία βάσεις:
```text
ποια source είναι authoritative
ποιο row κρατάμε
ποια overlaps θεωρούνται duplicates
```
Δεν θέλουμε το ίδιο curve/event να μετρά δύο φορές επειδή εμφανίστηκε σε δύο overlapping DBs.
4. **Φτιάχνουμε derived dataset layer**
    ​
    Δεν εκπαιδεύουμε απευθείας πάνω στα raw `dm_*`.
Θα παράγουμε ανά mint/checkpoint:
```text
core features
dynamics
wallet/flow
intents
landing
creator history
stored Stage features
```
και targets:
```text
realized next-slot PnL
win/loss
+1.3 crossing diagnostic
replay outcomes
```
5. **Quality audit**
    ​
    Πριν ML:
- missingness ανά feature/schema
- coverage ανά ημέρα/DB/regime
- duplicates
- impossible timestamps
- source overlap
- RealSOL consistency
- label leakage
- train/validation contamination
6. **TRAIN / VALIDATION / HOLDOUT**
    ​
    Μόνο αφού έχουμε και SQLite + CoinTrades.
Χρονολογικά και grouped by mint/source period:
```text
TRAIN
VALIDATION
HOLDOUT
```
Το ίδιο mint ποτέ σε δύο splits.
7. **Ξανατρέχουμε την πρόγνωση**
    ​
    Τότε πλέον θα έχουμε πολύ μεγαλύτερο dataset και μπορούμε να ξαναδοκιμάσουμε:
- direct-PnL regression
- win probability
- quantile/downside models
- structural/dynamics features
- intent-flow models
- ensemble / rule extraction
με κύριο metric **net PnL και stability**, όχι AUC.
Άρα το αμέσως επόμενο πρακτικό βήμα μόλις τελειώσει το SQLite ingest είναι:
```bash
py master_dataset_mysql_v320.py stats
```
Στείλε μου αυτό το output και μετά πάμε κατευθείαν να φτιάξουμε το **CoinTrades native incremental adapter**.


Ωραία. Τότε το **προπαρασκευαστικό στάδιο τελείωσε**.
Κλειδώνουμε ως βάση:
- `core50_v1`
- **484.247 cases**
- **6.295.211 snapshots** συνολικά (`484.247 × 13`)
- SQLite authoritative RealSOL σωστό
- CoinTrades RealSOL πάντα `NULL`
- availability/NULL semantics σωστά
- causal counters σωστά
- **8.839 eligible actual-PnL targets**
- **7.858 strict actual targets**
- **6.413 paper targets**
Δεν κάνουμε άλλους γενικούς audits τώρα.
Επόμενο βήμα είναι να φτιάξουμε το **research layer**:
1. chronological/grouped splits χωρίς να περνά ίδιο mint μεταξύ splits,
2. dataset views για κάθε checkpoint `50…600ms`,
3. target families για **πορεία/crossing**, **direct PnL** και **failure/blow-up risk**,
4. και μετά ξεκινάμε πραγματικά τη σύγκριση features/models.
Αυτό είναι το επόμενο που πρέπει να φτιάξω.

