---
categories:
  - "[[Interests]]"
created: 2026-07-19
domain: []
tags:
  - tech/tokens
  - topic/trading
  - topic/pump-fun
---
# Αναλυτικό τελικό σχέδιο υλοποίησης
## 1. Αμετάβλητες τεχνικές παραδοχές
1. Το Deshred εμφανίζει συναλλαγές μετά την ένταξή τους σε block από τον leader αλλά πριν από το Replay του receiving validator, επομένως είναι speculative pre-execution signal και όχι mempool ([Triton](https://blog.triton.one/deshred-transactions-the-fastest-path-to-solana-data/)).
2. Τα Deshred transactions μπορεί να αποτύχουν, να βρεθούν σε dead fork ή να μην οριστικοποιηθούν.
3. Το Yellowstone παρέχει authoritative account state, execution status, slot lifecycle και reconciliation.
4. Το Jito χρησιμοποιείται για την υποβολή entry/exit συναλλαγών, αλλά ένα accepted bundle ID δεν εγγυάται landing ([Jito](https://docs.jito.wtf/lowlatencytxnsend/)).
5. Ο pre-entry Deshred όγκος είναι predictor συνέχισης και όχι volume που εξασφαλίζει την κερδοφορία της δικής μας μελλοντικής θέσης.

---
## 2. Προτεινόμενη δομή εφαρμογής
```
cmd/
  bot/
    main.go
internal/
  config/
    config.go
  ingest/
    triton/
      deshred_client.go
      yellowstone_client.go
      health.go
  pump/
    codec/
      instructions.go
      discriminators.go
    state/
      accounts.go
    simulator/
      buy.go
      sell.go
      fees.go
      required_delta.go
  marketstate/
    authoritative_store.go
    speculative_ledger.go
    slot_tracker.go
  costs/
    pump_oracle.go
    solana_oracle.go
    jito_oracle.go
    snapshot.go
  forecast/
    features.go
    empirical_model.go
    calibration.go
  strategy/
    entry.go
    exit.go
    risk.go
  execution/
    builder.go
    signer.go
    jito/
      client.go
      bundle_status.go
    rpc/
      client.go
  positions/
    actor.go
    allocator.go
    state_machine.go
  reconcile/
    transactions.go
    forks.go
  storage/
    event_log.go
    trades.go
    metrics.go
```
Το ingestion μπορεί να έχει decoder workers, αλλά όλα τα events του ίδιου mint πρέπει να καταλήγουν στον ίδιο actor ώστε να διατηρείται η σειρά χωρίς global mutex.

---
## 3. Αριθμητικές μονάδες
Όλα τα οικονομικά μεγέθη αποθηκεύονται σε base units:
```
type Lamports uint64
type TokenUnits uint64
type BasisPoints uint32
type Slot uint64
```
Δεν χρησιμοποιείται `float64` σε pricing, fees, reserves, slippage ή PnL.
Για ενδιάμεσους πολλαπλασιασμούς απαιτείται checked `u128` arithmetic, αρχικά με `math/big.Int` για correctness και αργότερα, αν χρειάζεται, με `math/bits` για το hot path.
Οι ρυθμίσεις αποθηκεύονται ως basis points:
```
TargetProfitBps = 1000       // 10%
SafetyFactorBps = 12500      // 1.25x
MaxSlippageBps = 300         // 3%
MinimumProbabilityBps = 6500 // 65%
```

---
## 4. Ρυθμίσεις στρατηγικής
```
type StrategyConfig struct {
    BuyAmountLamports          uint64
    TargetProfitBps            uint32
    SafetyFactorBps            uint32
    MinimumContinuationBps     uint32
    ForecastHorizonSlots       uint64
    DeadMomentumSlots          uint64
    MaxHoldSlots               uint64
    MaxEntrySlippageBps        uint32
    MaxExitSlippageBps         uint32
    StopLossBps                uint32
    EntryTipPercentile         uint8
    TakeProfitTipPercentile    uint8
    EmergencyTipPercentile     uint8
    MaxEntryTipLamports        uint64
    MaxExitTipLamports         uint64
    MaxEmergencyTipLamports    uint64
    MaxConcurrentPositions     uint32
    MaxTotalCapitalLamports    uint64
}
```
Εμπειρική πολιτική εκκίνησης:
```
EntryTipPercentile      = 75
TakeProfitTipPercentile = 75
EmergencyTipPercentile  = 95
```
Τα παραπάνω percentiles είναι αρχικές εμπειρικές τιμές και πρέπει να αναπροσαρμοστούν από τα πραγματικά landing statistics του bot.

---
## 5. Ingestion και κανονικοποίηση
### Deshred pipeline
Για κάθε Deshred update:
1. Έλεγχος `signature` στο deduplication cache.
2. Έλεγχος του σωστού Pump Program ID.
3. Αποκωδικοποίηση legacy και V2 discriminators από το επίσημο IDL.
4. Εξαγωγή mint, bonding curve, user, quote mint και instruction arguments.
5. Κατηγοριοποίηση ως `BUY`, `SELL`, `CREATE`, `MIGRATE` ή `OTHER`.
6. Αντιστοίχιση σε per-mint actor.
7. Speculative simulation.
8. Καταγραφή του raw event πριν από οποιαδήποτε απόφαση.
```
type Intent struct {
    Slot            uint64
    ArrivalSequence uint64
    Signature       [64]byte
    Mint            [32]byte
    Kind            IntentKind
    TokenAmount     uint64
    MaxQuoteCost    uint64
    MinQuoteOutput  uint64
    ReceivedAt      time.Time
}
```
Το `ArrivalSequence` διατηρεί τη σειρά του συγκεκριμένου gRPC stream, αλλά δεν πρέπει να παρουσιάζεται ως απόλυτη εγγύηση canonical transaction index.
### Yellowstone pipeline
Το authoritative stream παρέχει:
- Bonding-curve account updates.
- Processed transactions και execution errors.
- Slot-created/completed/dead events.
- Confirmed/finalized progression.
- Το πραγματικό token balance του bot μετά το entry/exit.

---
## 6. Authoritative και speculative state
```
type CurveState struct {
    Slot                  uint64
    VirtualQuoteReserves  uint64
    VirtualTokenReserves  uint64
    RealQuoteReserves     uint64
    RealTokenReserves     uint64
    Complete              bool
}
type SpeculativeLedger struct {
    BaseState       CurveState
    ProjectedState  CurveState
    AppliedIntents  []Intent
    SeenSignatures  map[[64]byte]struct{}
}
```
Κανόνες:
1. Κάθε speculative ledger ξεκινά από συγκεκριμένο authoritative slot.
2. Κάθε νέο intent εφαρμόζεται διαδοχικά στο `ProjectedState`.
3. Αν το Yellowstone επιβεβαιώσει επιτυχημένη συναλλαγή, το authoritative state προχωρά.
4. Αν η συναλλαγή αποτύχει ή το slot γίνει dead, αφαιρείται από το speculative ledger.
5. Μετά από authoritative update γίνεται rebase και επανεφαρμογή μόνο των μη συμφιλιωμένων intents.
6. Αν ανιχνευθεί stream gap ή ασυνέπεια reserves, απαγορεύονται νέα entries μέχρι πλήρες resync.

---
## 7. Exact Pump simulator
Ο simulator πρέπει να παρέχει καθαρές deterministic συναρτήσεις:
```
type BuyResult struct {
    NewState        CurveState
    TokensReceived  uint64
    CurveQuoteIn    uint64
    TotalUserDebit  uint64
    PumpFees        uint64
}
type SellResult struct {
    NewState        CurveState
    GrossQuoteOut   uint64
    PumpFees        uint64
    NetUserCredit   uint64
}
func SimulateBuy(
    state CurveState,
    requestedAmount uint64,
    maxQuoteCost uint64,
    feeConfig FeeConfig,
) (BuyResult, error)
func SimulateSell(
    state CurveState,
    tokenAmount uint64,
    minQuoteOutput uint64,
    feeConfig FeeConfig,
) (SellResult, error)
```
Πρέπει να αναπαράγει ακριβώς:
- Integer division και rounding direction.
- Protocol, creator και λοιπά Pump fees.
- `real_token_reserves` limits.
- Slippage bounds.
- `complete` state.
- SOL και λοιπά quote mints.
- Legacy και V2 instruction semantics.
Το `buy_v2.max_sol_cost` είναι cap και όχι πραγματικό SOL input, επομένως δεν χρησιμοποιείται ως πραγματοποιημένος όγκος ([Pump Buy V2](https://github.com/pump-fun/pump-public-docs/blob/main/docs/instructions/BUY.md)).

---
## 8. Cost Oracle
### Pump fees
Στην εκκίνηση:
- Fetch `Global`.
- Fetch Pump `FeeConfig`.
- Subscribe στις αλλαγές τους.
- Fetch ανά-mint `SharingConfig` όταν το mint γίνει candidate.
Τα Pump fees δεν πρέπει να παραμένουν hard-coded.
### Solana fees
Για κάθε πραγματικό transaction template:
1. Εκτίμηση compute units με simulation ή ιστορική κατανομή ίδιου transaction shape.
2. `ComputeUnitLimit = estimatedCU × margin`, π.χ. 110–115%.
3. Fetch account-specific recent priority fees.
4. Επιλογή CU price.
5. Υπολογισμός:
```
PriorityFee =
    ceil(ComputeUnitPrice × ComputeUnitLimit / 1,000,000)
```
6. Υπολογισμός base fee από το τελικό message μέσω `getFeeForMessage`.
Το priority fee εξαρτάται από το requested CU limit και όχι από τα πραγματικά consumed units ([Solana fee structure](https://solana.com/docs/core/fees/fee-structure)).
### Jito tips
Ο Jito oracle διατηρεί:
```
type JitoTipSnapshot struct {
    P25       uint64
    P50       uint64
    P75       uint64
    P95       uint64
    P99       uint64
    EMAP50    uint64
    UpdatedAt time.Time
}
```
Δεδομένα λαμβάνονται από το επίσημο `tip_stream` ή `tip_floor`.
Αν το snapshot είναι stale, δεν επιτρέπεται entry· για emergency exit εφαρμόζεται προκαθορισμένο capped fallback.

---
## 9. Οικονομικός στόχος
Το `BuyAmount` είναι το ρυθμιζόμενο trade notional, π.χ. `0.075 SOL`.
```
DesiredProfit =
    BuyAmount × TargetProfitPct
```
Μετά την exact entry simulation:
```
ActualEntryCost =
    ActualPumpDebit
    + EntryBaseFee
    + EntryPriorityFee
    + EntryJitoTip
    + EntryRentOrAccountCosts
```
Στη συνέχεια:
```
RequiredExitProceeds =
    ActualEntryCost
    + ExitBaseFee
    + ExitPriorityFee
    + ReservedExitJitoTip
    + OtherExitCosts
    + DesiredProfit
```
Το `NetSellOutput` πρέπει να είναι ήδη μετά το Pump sell fee, επομένως το sell fee δεν προστίθεται ξανά στο `RequiredExitProceeds`.

---
## 10. RequiredDeltaVSOL binary search
Μετά την προσομοίωση της εισόδου έχουμε:
```
StateAfterEntry
TokensOwned
VSOLAfterEntry
RequiredExitProceeds
```
Ψάχνουμε το ελάχιστο καθαρό `delta` ώστε:
```
SimulateSell(
    ApplySyntheticNetBuy(StateAfterEntry, delta),
    TokensOwned
).NetUserCredit >= RequiredExitProceeds
```
Ενδεικτικός αλγόριθμος:
```
func RequiredDeltaVSOL(
    stateAfterEntry CurveState,
    tokensOwned uint64,
    requiredExit uint64,
    maximumDelta uint64,
) (uint64, bool) {
    if netSell(stateAfterEntry, tokensOwned) >= requiredExit {
        return 0, true
    }
    low := uint64(1)
    high := uint64(1)
    for high < maximumDelta &&
        netSell(afterNetBuy(stateAfterEntry, high), tokensOwned) < requiredExit {
        high *= 2
    }
    if high > maximumDelta {
        high = maximumDelta
    }
    if netSell(afterNetBuy(stateAfterEntry, high), tokensOwned) < requiredExit {
        return 0, false
    }
    for low < high {
        mid := low + (high-low)/2
        if netSell(afterNetBuy(stateAfterEntry, mid), tokensOwned) >= requiredExit {
            high = mid
        } else {
            low = mid + 1
        }
    }
    return low, true
}
```
Το πραγματικό implementation χρειάζεται checked overflow και Pump-specific functions.
Υπολογίζεται επίσης:
```
RequiredVSOLIncreasePct =
    RequiredDeltaVSOL × 10,000 / VSOLAfterEntry
```
ώστε το αποτέλεσμα να παραμένει σε basis points.

---
## 11. Forecast και ιστορικό feasibility
Για κάθε candidate καταγράφονται, ακόμη και αν δεν γίνει αγορά:
```
VSOL range
token age
buy/sell volume
net VSOL change
transaction count
unique wallets
largest-wallet share
buy/sell imbalance
volume acceleration
slot position
forecast horizon
actual future delta VSOL
```
Το baseline μοντέλο μπορεί αρχικά να είναι empirical και όχι ML:
1. Bucket ανά VSOL range.
2. Bucket ανά token age.
3. Bucket ανά forecast horizon.
4. Υπολογισμός distribution του μελλοντικού `DeltaVSOL`.
5. Εξαγωγή P50/P75/P90/P95.
6. Υπολογισμός:
```
ContinuationProbability =
    P(ActualFutureDeltaVSOL >= RequiredDeltaVSOL | current features)
```
Το feasibility gate είναι:
```
FeasibleRequiredVSOLMove =
    RequiredVSOLIncreasePct <= HistoricalMoveP95
```
Αυτό δεν σημαίνει ότι το trade είναι πιθανό· απλώς απορρίπτει κινήσεις που βρίσκονται εκτός του ιστορικά παρατηρημένου εύρους.

---
## 12. Τελικός entry evaluator
Η σειρά ελέγχων πρέπει να είναι φθηνότεροι πρώτα:
```
1. Stream health
2. State freshness
3. Program/mint/quote filters
4. Curve completion and reserve limits
5. Wallet and capital limits
6. Entry simulation
7. Dynamic cost snapshot
8. RequiredDeltaVSOL
9. Historical feasibility
10. Forecast continuation
11. Expected value
12. Jito tip cap
13. Final state revalidation
```
Τελικός κανόνας:
```
Enter =
    StreamHealthOK
    && StateFresh
    && CurveSupported
    && !CurveComplete
    && CapitalAvailable
    && RequiredDeltaFound
    && RequiredMovePct <= HistoricalMoveP95
    && ForecastFutureNetVSOLLowerBound
         >= RequiredDeltaVSOL × SafetyFactor
    && ContinuationProbability
         >= MinimumContinuationProbability
    && ExpectedNetPnL >= MinimumExpectedNetPnL
    && EntryTip + ReservedExitTip
         <= MaxTotalTipBudget
```
Προαιρετικά:
```
ExpectedNetPnL =
    ContinuationProbability × ProfitIfContinuation
    + (1 - ContinuationProbability) × PnLIfFailure
```

---
## 13. Δυναμικό Jito tip
### Entry
```
MarketEntryTip = EWMA(Jito P75)
MaxTotalTipBudget =
    ProjectedNetSellOutput
    - BuyAmount
    - AllNonTipCosts
    - DesiredProfit
    - SafetyBuffer
MaxEntryTip =
    MaxTotalTipBudget - ReservedExitTip
```
Αν:
```
MarketEntryTip > MaxEntryTip
```
το entry ακυρώνεται.
### Normal exit
```
MarketExitTip = EWMA(Jito P75)
MaxExitTip =
    ExpectedNetSellOutput
    - ActualEntryCost
    - NonTipExitCosts
    - DesiredProfit
```
### Emergency exit
```
MarketEmergencyTip = EWMA(Jito P95)
MaxEmergencyTip =
    min(
        ConfiguredHardCap,
        ExpectedLossWithoutExit - ExpectedLossWithImmediateExit
    )
```
Το P95 χρησιμοποιείται μόνο όταν η προστασία κεφαλαίου αξίζει το επιπλέον κόστος.
Το bot αποθηκεύει δικά του αποτελέσματα:
```
region
leader
tip percentile
tip/CU
transaction shape
submission latency
landed/missed
landing slot
```
και προσαρμόζει σταδιακά το percentile ώστε να πετυχαίνει συγκεκριμένο landing-rate target χωρίς μόνιμη υπερπληρωμή.

---
## 14. Transaction building
Προτιμώμενο entry transaction:
```
SetComputeUnitLimit
Optional SetComputeUnitPrice
Pump buy_v2 / buy_exact_quote_in_v2
Jito tip transfer
```
Προτιμώμενο exit transaction:
```
SetComputeUnitLimit
Optional SetComputeUnitPrice
Pump sell_v2(min_sol_output)
Jito tip transfer
```
Το tip βρίσκεται στην ίδια συναλλαγή με το trade, ώστε αποτυχία οποιουδήποτε instruction να κάνει rollback ολόκληρη τη συναλλαγή.
Ακριβώς πριν από το signing:
1. Νέο blockhash.
2. Revalidation reserves.
3. Recalculation actual entry quote.
4. Refresh Jito tip.
5. Refresh base/priority fee.
6. Recalculation `RequiredExitProceeds`.
7. Recalculation `RequiredDeltaVSOL`.
8. Τελική επανεκτέλεση του entry rule.

---
## 15. Execution routing
### Entry και take-profit
- Χρήση Jito bundle.
- Παρακολούθηση `bundle_id`.
- Παρακολούθηση transaction signature μέσω Yellowstone.
- Το accepted bundle δεν μετακινεί τη θέση σε `LONG`.
- Η θέση γίνεται `LONG` μόνο όταν επιβεβαιωθεί το πραγματικό token balance.
### Emergency exit
- Αν υπάρχει κατάλληλος Jito leader, χρησιμοποιείται Jito με emergency tip.
- Διαφορετικά χρησιμοποιείται direct RPC/TPU route με δυναμικό priority fee και χωρίς άχρηστο Jito tip.
- Δεν αποστέλλονται ανεξέλεγκτα διαφορετικές sell συναλλαγές ταυτόχρονα.
- Ο position actor επιτρέπει μόνο ένα ενεργό exit attempt ανά mint.

---
## 16. Exit engine
### Take profit
Σε κάθε μεταγενέστερο Deshred buy:
1. Προσομοιώνεται η συναλλαγή.
2. Υπολογίζεται το projected post-buy state.
3. Υπολογίζεται το πραγματικό net sell output.
4. Ανανεώνεται το Jito exit tip.
5. Αν καλύπτεται το required profit, υποβάλλεται exit.
### Dump detection
Σε κάθε Deshred sell:
1. Προσομοιώνεται πρώτα το dump.
2. Υπολογίζεται το post-dump net sell output της θέσης.
3. Υπολογίζεται η πρόσθετη αναμενόμενη ζημιά αν περιμένουμε.
4. Υπολογίζεται το emergency tip cap.
5. Υποβάλλεται sell μετά το dump, στο υπόλοιπο του ίδιου slot ή στο επόμενο.
### Υπόλοιπα triggers
- Authoritative stop loss.
- Dead momentum μόνο μετά από completed slots και με υγιές stream.
- Max hold time σε slots.
- Stream degradation.
- Curve completion ή migration.
- Wallet/account inconsistency.

---
## 17. Position state machine
```
IDLE
  → ENTRY_RESERVED
  → ENTRY_SUBMITTED
  → ENTRY_PROCESSED
  → LONG
  → EXIT_RESERVED
  → EXIT_SUBMITTED
  → EXIT_PROCESSED
  → CLOSED
```
Failure transitions:
```
ENTRY_SUBMITTED → ENTRY_EXPIRED → IDLE
ENTRY_PROCESSED → FORK_RECONCILE
EXIT_SUBMITTED  → EXIT_EXPIRED → LONG
EXIT_PROCESSED  → FORK_RECONCILE
ANY_STATE       → HALTED
```
Βασικά invariants:
- Μία ενεργή θέση ανά mint.
- Ένα ενεργό entry ή exit attempt ανά θέση.
- Κάθε capital reservation έχει owner και expiry.
- Κανένα realized PnL πριν από authoritative balance reconciliation.
- Καμία νέα θέση όταν το stream health είναι degraded.

---
## 18. Αποθήκευση δεδομένων
Ελάχιστα tables:
```
stream_events
curve_snapshots
speculative_intents
strategy_candidates
strategy_decisions
cost_snapshots
jito_tip_samples
bundle_submissions
transaction_results
positions
position_events
realized_pnl
forecast_outcomes
```
Κάθε απορριφθείσα ευκαιρία πρέπει επίσης να καταγράφεται, διαφορετικά το continuation model θα έχει selection bias.
Το realized PnL υπολογίζεται από πραγματικές wallet balance μεταβολές:
```
RealizedPnL =
    FinalWalletCredit
    - ActualEntryPumpDebit
    - EntryNetworkFees
    - ExitNetworkFees
    - EntryJitoTip
    - ExitJitoTip
    - NonRefundableAccountCosts
```

---
## 19. Monitoring και kill switches
Μετρικές:
```
deshred_receive_latency
decode_latency
simulation_latency
decision_latency
signing_latency
jito_submission_latency
bundle_landing_latency
landing_rate_by_percentile
simulator_quote_error
forecast_calibration_error
realized_pnl
drawdown
stream_gap_count
fork_reconciliation_count
```
Kill switches:
- Deshred ή Yellowstone stream gap.
- Stale Pump fee config.
- Stale Jito tip snapshot.
- Simulator mismatch πάνω από ένα lamport.
- Υπερβολικά failed transactions.
- Ημερήσιο loss ή drawdown limit.
- Wallet balance mismatch.
- Απροσδόκητο Pump program/account layout.
- Αποτυχία reconciliation.

---
## 20. Testing και rollout
### Φάση 1: Simulator
- Golden vectors από πραγματικά Pump transactions.
- Buy/sell round-trip tests.
- Fee rounding tests.
- Reserve-boundary tests.
- Completion/migration tests.
- Fuzzing και overflow tests.
- Μέγιστη επιτρεπόμενη απόκλιση: ένα lamport.
### Φάση 2: Recorded-stream replay
- Deshred duplicates.
- Delayed Yellowstone confirmations.
- Failed transactions.
- Dead slots.
- Stream reconnects.
- Out-of-order arrival.
- Stale fee snapshots.
### Φάση 3: Shadow mode
- Καταγραφή όλων των candidates.
- Υπολογισμός θεωρητικού entry/exit με πραγματικό observation time.
- Καμία χρήση μελλοντικών δεδομένων κατά τη λήψη απόφασης.
- Μέτρηση forecast calibration, landing estimates και theoretical PnL.
### Φάση 4: Live canary
- Μικρό position size.
- Μία θέση κάθε φορά.
- Χαμηλό συνολικό capital cap.
- Αυστηρό emergency-tip cap.
- Αυτόματο halt σε οποιαδήποτε ασυνέπεια.
### Φάση 5: Κλιμάκωση
Η κλιμάκωση επιτρέπεται μόνο όταν υπάρχουν επαρκή δεδομένα για:
- Net profitability μετά από όλα τα fees.
- Stable landing rate.
- Αποδεκτό drawdown.
- Calibrated continuation probabilities.
- Μηδενικά unreconciled positions.
- Αποδεδειγμένη ορθότητα simulator και cost accounting.