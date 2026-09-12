
Παρακάτω είναι το operational manual του σημερινού `UE Guard v0`, βασισμένο στο τελευταίο ZIP και στο πραγματικό source. Έλεγξα επίσης το σημερινό επίσημο Pump IDL: το `buy_exact_quote_in_v2`, ο discriminator και το 27-account layout που περιμένει ο guard εξακολουθούν να συμφωνούν με το Pump interface.
## 1. Τι είναι το chain program
Το `UE Guard` **δεν εκτελεί το BUY με CPI**.
Η transaction είναι:
```text
[AdvanceNonceAccount]     optional
[ComputeBudget...]
[ATA/setup...]            αν χρειάζονται
[UE Guard]
[Pump buy_exact_quote_in_v2]   <-- ΠΡΕΠΕΙ να είναι ακριβώς το επόμενο instruction
[Jito tip...]             optional
```
Ο guard κοιτάζει την πραγματική bonding curve **τη στιγμή που εκτελείται on-chain**.
Αν όλα είναι ΟΚ:
```text
UE Guard -> SUCCESS
Pump BUY -> εκτελείται αμέσως μετά
```
Αν κάτι δεν είναι ΟΚ:
```text
UE Guard -> FAIL
Pump BUY -> δεν εκτελείται
ολόκληρη η transaction αποτυγχάνει
```
Αυτό εκμεταλλεύεται την atomicity της Solana transaction.
Με durable nonce, το `AdvanceNonceAccount` πρέπει να είναι το πρώτο instruction. Αν η execution αργότερα αποτύχει, το nonce εξακολουθεί να θεωρείται consumed και τα fees χρεώνονται, κάτι που είναι χρήσιμο για το one-shot fan-out που θέλουμε. ([solana.com](https://solana.com/el/docs/core/transactions/durable-nonces?utm_source=chatgpt.com "Ανθεκτικά nonces | Solana"))

---
## 2. Τι προστατεύει σήμερα
Ο guard ελέγχει:

|Έλεγχος|Τι κάνει|
|---|---|
|Authorized user|Μόνο το `8LBEh85...6ppC` μπορεί να αγοράσει|
|Pump program|Απαιτεί το επίσημο `6EF8...F6P`|
|Curve owner|Η curve πρέπει να ανήκει στο Pump|
|Curve PDA|Πρέπει να είναι PDA `bonding-curve + mint`|
|Curve discriminator|Πρέπει να είναι πραγματικό Pump BondingCurve|
|Complete|`complete=false`|
|Reserve|`current_real_token_reserve <= supplied threshold`|
|Slot|Προαιρετικό maximum execution slot|
|BUY type|Μόνο `buy_exact_quote_in_v2`|
|Amount|Exact pinned SOL amount|
|Slippage|Exact pinned `min_tokens_out`|
|Mint|Το BUY πρέπει να χρησιμοποιεί το ίδιο mint|
|User|Το BUY πρέπει να χρησιμοποιεί τον ίδιο authorized signer|
|Accounts|Ελέγχει το συγκεκριμένο Pump v2 layout και βασικά PDAs/ATAs/program IDs|
Το current Pump IDL εξακολουθεί να έχει το ίδιο BondingCurve discriminator και τα πρώτα fields `virtual_token_reserves`, `virtual_quote_reserves`, `real_token_reserves`, `real_quote_reserves`, `token_total_supply`, `complete`, άρα τα offsets που χρησιμοποιεί σήμερα ο guard είναι συμβατά.

---
## 3. Τι δέχεται ο guard
Ο guard instruction δέχεται **ακριβώς 4 accounts**, με αυτή τη σειρά:

|#|Account|
|---|---|
|0|Pump bonding curve|
|1|mint|
|2|user/buyer — signer|
|3|`Sysvar1nstructions1111111111111111111111111`|
Το Instructions Sysvar είναι αυτό που του επιτρέπει να διαβάσει το **επόμενο instruction της ίδιας transaction** και να επιβεβαιώσει ότι είναι το σωστό Pump BUY.

---
## 4. Παράμετροι instruction
Το ABI είναι version `2`, συνολικά 40 bytes:
```text
byte 0       version = 2
byte 1       flags
bytes 2..7   reserved = 0
bytes 8..15
spendable_quote_in   u64 LE
bytes 16..23
min_tokens_out       u64 LE
bytes 24..31
XOR-obfuscated max_real_token_reserve
bytes 32..39
max_execution_slot   u64 LE
```
Οι πραγματικές λογικές παράμετροι είναι:

|Παράμετρος|Παράδειγμα|Σημασία|
|---|--:|---|
|`SpendableQuoteIn`|`75_000_000`|0.075 SOL|
|`MinTokensOut`|π.χ. `123456789`|ελάχιστα tokens που δεχόμαστε|
|`MaxRealTokenReserve`|`783299315022675`|economic guard|
|`CheckSlot`|`false`|ενεργοποίηση slot guard|
|`MaxExecutionSlot`|`0`|0 όταν slot check OFF|
Το `0.100 SOL` είναι hard maximum μέσα στο program:
```rust
MAX_SPENDABLE_QUOTE_IN = 100_000_000
```
Άρα:
```text
0.075 SOL -> επιτρέπεται
0.100 SOL -> επιτρέπεται
0.101 SOL -> απορρίπτεται
```
Για αλλαγή αυτού του ceiling χρειάζεται rebuild/redeploy.

---
## 5. Reserve threshold / XOR
Το πραγματικό threshold **δεν βρίσκεται hardcoded** μέσα στο program.
Στον ιδιωτικό client έχεις:
```go
cfg := ueguard.Config{
    SpendableQuoteIn:    75_000_000,
    MinTokensOut:        minTokensOut,
    MaxRealTokenReserve: 783299315022675,
    CheckSlot:           false,
    MaxExecutionSlot:    0,
}
data, err := cfg.Encode(mint)
```
Το `Encode()` δημιουργεί mask από:
```text
mint
spendable_quote_in
min_tokens_out
max_execution_slot
flags
```
και βάζει:
```text
encoded_threshold = real_threshold XOR mask
```
On-chain γίνεται το αντίστροφο.
Αυτό **καμουφλάρει** το threshold αλλά δεν αποτελεί cryptographic secrecy. Κάποιος που reverse-engineerάρει το program μπορεί να το ανακατασκευάσει.

---
## 6. Optional slot check
Χωρίς slot constraint:
```go
CheckSlot:        false,
MaxExecutionSlot: 0,
```
και το program δεν καλεί καν `Clock::get()` για comparison.
Με slot constraint:
```go
CheckSlot:        true,
MaxExecutionSlot: candidateSlot + 1,
```
τότε απαιτεί:
```text
actual execution slot <= max_execution_slot
```
Το πραγματικό current slot διαβάζεται από το Solana Clock. Δεν το δηλώνει ο client.
Για το πρώτο production prototype θα το κρατούσα **OFF**, μέχρι να έχουμε πραγματικά execution statistics.

---
## 7. Πώς κατασκευάζεται η BUY transaction
Για κάθε candidate ο bot πρέπει να έχει ήδη:
```text
mint
curve PDA
candidate curve state
spendable_quote_in
min_tokens_out
threshold
optional max slot
```
Μετά:
```text
off-chain reserve pre-check
        |
        v
Config.Encode(mint)
        |
        v
UE Guard instruction
        |
        v
Pump buy_exact_quote_in_v2
```
Κρίσιμο:
```text
UE Guard
Pump BUY
```
πρέπει να είναι **διαδοχικά instructions**.
Δεν επιτρέπεται:
```text
UE Guard
Jito Tip
Pump BUY
```
γιατί τότε ο guard θα δει το Jito instruction ως "next instruction" και θα απορρίψει.

---
## 8. Τι pinάρει απέναντι στο Pump BUY
Το Pump BUY πρέπει να έχει ακριβώς:
```text
spendable_quote_in == guard.spendable_quote_in
min_tokens_out     == guard.min_tokens_out
mint               == guard mint
bonding_curve      == guard curve
user               == authorized user
```
και πρέπει να είναι:
```text
buy_exact_quote_in_v2
```
με discriminator:
```text
[194, 171, 28, 70, 104, 77, 91, 47]
```
Το σημερινό επίσημο Pump IDL εξακολουθεί να ορίζει ακριβώς αυτά τα δύο arguments και το ίδιο discriminator.
Άρα δεν μπορεί ο client κατά λάθος να κάνει:
```text
candidate A
↓
guard A
↓
requote B
↓
BUY B
```
Το guard θα το απορρίψει.

---
## 9. Hardcoded στοιχεία του program
Σήμερα μέσα στο `lib.rs` είναι hardcoded:
```text
Pump Program ID
authorized BUY wallet
SPL Token Program
Token-2022 Program
Associated Token Program
Wrapped SOL mint
System Program
Pump Fee Program
MAX_SPENDABLE_QUOTE_IN
Pump instruction discriminator
Pump account layout
BondingCurve discriminator
```
Το threshold και το slot **δεν** είναι hardcoded.
Άρα αλλαγή:
```text
threshold          -> ΔΕΝ θέλει redeploy
slot policy        -> ΔΕΝ θέλει redeploy
min_tokens_out     -> ΔΕΝ θέλει redeploy
buy amount <=0.1   -> ΔΕΝ θέλει redeploy
authorized wallet  -> ΘΕΛΕΙ rebuild/redeploy
max buy >0.1       -> ΘΕΛΕΙ rebuild/redeploy
Pump ABI change    -> πιθανό rebuild/redeploy
```

---
# 10. Πώς ετοιμάζεις νέα έκδοση
Για μια πραγματική release θα ακολουθούσα αυτή τη μοναδική σειρά:
1. Ορίζεις στο `lib.rs` το production `AUTHORIZED_USER`.
2. Αποφασίζεις το hard maximum BUY (`MAX_SPENDABLE_QUOTE_IN`).
3. Ελέγχεις ότι το επίσημο Pump IDL εξακολουθεί να συμφωνεί με discriminator/account layout. Το Pump έχει αλλάξει interfaces στο παρελθόν, άρα αυτό πρέπει να αποτελεί release check. Το σημερινό IDL συμφωνεί με το guard μας. ([GitHub](https://github.com/pump-fun/pump-public-docs?utm_source=chatgpt.com "GitHub - pump-fun/pump-public-docs: Pump public docs · GitHub"))
4. Τρέχεις:
```bash
go test ./...
go vet ./...
```
5. Τρέχεις Rust unit tests:
```bash
cd program/ue_guard
cargo test
```
6. Κάνεις SBF build:
```bash
cargo build-sbf
```
7. Παίρνεις:
```text
target/deploy/ue_guard.so
target/deploy/ue_guard-keypair.json
```
Το `.so` είναι το executable. Το keypair καθορίζει το Program ID. Αυτή είναι και η επίσημη διαδικασία build/deploy της Solana. ([solana.com](https://solana.com/docs/programs/deploying?utm_source=chatgpt.com "Deploying Programs | Solana"))
​
8. Κρατάς **εκτός Git**:
```text
program keypair
upgrade-authority keypair
trading-wallet private key
```
και ιδανικά είναι τρία διαφορετικά secrets.
​
9. Κάνεις πρώτα devnet deployment/test.
​
10. Μόνο όταν περάσουν όλα τα execution tests, κάνεις mainnet deployment.

---
## 11. Program keypair vs upgrade authority vs trading wallet
Είναι τρία διαφορετικά πράγματα:

|Secret|Χρήση|
|---|---|
|`ue_guard-keypair.json`|καθορίζει το Program ID|
|upgrade authority|επιτρέπει νέα έκδοση του deployed program|
|`8LBE...` private key|υπογράφει BUY transactions|
**Δεν πρέπει να είναι το ίδιο key.**
Για mainnet θα δημιουργούσα νέο dedicated **mainnet upgrade authority**, που δεν χρησιμοποιείται από το bot.
Το loader-v3 που χρησιμοποιήσαμε επιτρέπει upgrades όσο υπάρχει upgrade authority. Αν κάνεις `--final`, το program γίνεται μόνιμα immutable και δεν μπορεί να διορθωθεί ποτέ. ([solana.com](https://solana.com/docs/programs/deploying?utm_source=chatgpt.com "Deploying Programs | Solana"))
Δεν θα το έκανα immutable ακόμη.

---
## 12. Mainnet deployment όταν φτάσουμε εκεί
Πρώτα:
```bash
solana config set --url mainnet-beta
solana config get
solana balance
```
Build:
```bash
cd program/ue_guard
cargo build-sbf
```
Deploy με συγκεκριμένο Program ID:
```bash
solana program deploy \
  ./target/deploy/ue_guard.so \
  --program-id ./target/deploy/ue_guard-keypair.json
```
Έλεγχος:
```bash
solana program show <PROGRAM_ID>
```
Η επίσημη Solana CLI χρησιμοποιεί `cargo build-sbf`, `solana program deploy` και `solana program show` γι' αυτή τη ροή. ([solana.com](https://solana.com/docs/programs/deploying?utm_source=chatgpt.com "Deploying Programs | Solana"))

---
## 13. Update υπάρχουσας έκδοσης
Εφόσον κρατήσεις την upgrade authority:
```text
αλλάζεις source
↓
τρέχεις όλα τα tests
↓
cargo build-sbf
↓
solana program deploy νέο .so
↓
ίδιο Program ID
```
Το Program account παραμένει ίδιο και αλλάζει το bytecode στο ProgramData account. Η νέα έκδοση γίνεται ενεργή από επόμενο slot. ([solana.com](https://solana.com/de/docs/core/programs/program-deployment?utm_source=chatgpt.com "Programm-Deployment | Solana"))

---
## 14. Errors που μας ενδιαφέρουν περισσότερο

|Custom|Σημασία|
|--:|---|
|4|wrong curve owner|
|5|wrong bonding-curve PDA|
|8|curve complete|
|10|reserve πάνω από threshold|
|11|invalid spend|
|15|επόμενο instruction δεν είναι Pump|
|18|BUY spend mismatch|
|19|BUY min_tokens mismatch|
|21|Pump account mismatch|
|26|execution slot exceeded|
|28|unauthorized user|
Fail σημαίνει: **Pump BUY δεν πρέπει να εκτελεστεί**.

---
## 15. Τι ΔΕΝ έχει ακόμη αποδειχθεί
Εδώ είναι το σημαντικότερο: η σημερινή έκδοση **δεν είναι ακόμη production-ready**.
Έχουμε ήδη αποδείξει στο πραγματικό devnet:
```text
program deploy             PASS
unauthorized user          PASS -> Custom(28)
authorized user            PASS authorization
```
Μένει να αποδειχθούν πριν από mainnet χρήση:
```text
real curve reserve FAIL
real curve reserve PASS
slot OFF
slot PASS / slot FAIL
complete curve rejection
spend mismatch
min_tokens mismatch
wrong Pump accounts
real Pump BUY after guard
guard FAIL -> πραγματικά κανένα BUY
guard PASS -> πραγματικό BUY
durable nonce failure semantics
same signed transaction fan-out
duplicate delivery -> no double BUY
```
Και μετά tiny canary.

---
## 16. Μία βελτίωση που θα έκανα πριν production
Το σημερινό guard ελέγχει πολύ μεγάλο μέρος των 27 Pump accounts, αλλά **όχι κάθε account ανεξάρτητα**. Για παράδειγμα το τρέχον Pump `buy_exact_quote_in_v2` έχει και `sharing_config` στο account layout. Το Pump program το ελέγχει μέσω των δικών του constraints, αλλά ο δικός μας guard δεν το pinάρει ρητά.
Πριν χαρακτηρίσουμε κάποια έκδοση production, θα πρόσθετα στον guard explicit validation και για όσα Pump-derived accounts σήμερα αφήνουμε να τα επικυρώσει μόνο το Pump. Αυτό δεν αλλάζει το economic rule· είναι καθαρό security hardening.
### Συνολική εικόνα
Το τελικό runtime που θέλουμε είναι:
```text
CREATE
  ↓
early curve observation
  ↓
off-chain threshold check
  ↓
quote + min_tokens_out
  ↓
reserve nonce
  ↓
build ONE transaction
  ↓
AdvanceNonce
ComputeBudget
setup
UE GUARD
PUMP BUY
tip
  ↓
sign once
  ↓
fan-out same serialized transaction
  ↓
on-chain guard reads CURRENT curve
  ↓
FAIL ───────────────> no BUY
PASS
  ↓
Pump BUY
  ↓
confirmed execution
  ↓
+1500 ms
  ↓
SELL ALL
```
Αυτή είναι η αρχιτεκτονική που πρέπει να θεωρούμε reference για την έκδοση χρήσης.