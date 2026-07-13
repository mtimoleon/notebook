---
categories:
  - "[[Home]]"
created: 2026-06-20
domain: []
tags:
  - tech/tokens
  - topic/trading
---

## Καλύτερη επιλογή
### 1. GMGN με alert / signal / dry-run
Το GMGN έχει ήδη TG Sniper Bot, auto buy, auto sell με TP/SL, copy trade, wallet tracking και signal channels. Στα docs γράφει ότι το auto buy αγοράζει όταν του στείλεις CA/token link και πληροί βασικά preset όπως ποσό αγοράς, min liquidity και max market cap. Επίσης υποστηρίζει auto sell με TP/SL presets. ([docs.gmgn.ai](https://docs.gmgn.ai/index/auto-buy-auto-buy-limit-buy "Auto Buy: Auto Buy ＆ Limit buy | GMGN Tutorial")) ([docs.gmgn.ai](https://docs.gmgn.ai/index/auto-sell-auto-sell-take-profit-stop-loss "Auto Sell: Auto sell ＆ Take-profit/Stop-loss | GMGN Tutorial"))
Το πρόβλημα: **δεν είναι πλήρες backtest/paper-trading όπως σε χρηματιστήριο**. Δεν του λες απλά “τρέχα όλο το preset1 σε όλα τα migrated και δείξε μου virtual PnL” με πλήρη αξιοπιστία. Για αυτό θες πρώτα **signal logger**.
## Πώς θα το δοκίμαζα πρακτικά
### Φάση Α
Για 2–3 μέρες:
```text
Auto-buy: OFF
Auto-sell: OFF
Alerts / signal monitoring: ON
Preset1: ενεργό ως φίλτρο παρακολούθησης
Καταγραφή: token, ώρα, MC, liquidity, volume, buys/sells, holders, top10, dev, sniper/bundler
Virtual entry: τιμή τη στιγμή που το token περνάει το preset
Virtual TP: +50%
Virtual SL: -25%
Time stop: 10–20 λεπτά
```
Μετράς:
```text
πόσα tokens βρήκε
πόσα χτύπησαν TP
πόσα χτύπησαν SL
πόσα έμειναν άχρηστα/flat
μέσο χρόνο μέχρι TP ή SL
μέσο slippage που θα χρειαζόταν
```
Αυτό είναι το πιο καθαρό “paper trading”.
### Φάση Β
Μετά δοκιμή με πολύ μικρό real ποσό:
```text
Buy: 0.03–0.05 SOL
TP1: +35%, sell 50%
TP2: +60%, sell 30%
Runner: 20%
SL: -25%
Max open positions: 1–2
Daily loss limit: -0.10 SOL
```
### Φάση Γ
Μόνο αν τα νούμερα βγουν καλά:
```text
Buy: 0.10 SOL
Max trades/day: 5–10
Auto-buy: ON μόνο σε A+ φίλτρο
Auto-sell: ON πάντα
```
## Ποια εργαλεία υπάρχουν

|Εργαλείο|Κάνει για αυτό;|Σχόλιο|
|---|---|---|
|GMGN TG Bot|Ναι, καλύτερη αρχή|Έχει auto buy, auto sell, TP/SL, signals, copy trade. ([docs.gmgn.ai](https://docs.gmgn.ai/index/gmgn-tg-sniper-bot-sol "GMGN TG Sniper Bot - SOL \| GMGN Tutorial"))|
|GMGN script/API style|Ναι, πιο σωστό για dry-run|Τα docs αναφέρουν automation script με Telegram API για monitoring signals/smart money και αποστολή εντολών στο GMGN bot. Θέλει προσοχή στην ασφάλεια. ([docs.gmgn.ai](https://docs.gmgn.ai/index/cooperation-script-how-to-quickly-create-an-automated-script-for-trading-with-gmgn-bot " Cooperation-Script:How to Quickly Create an Automated Script for Trading with GMGN Bot \| GMGN Tutorial"))|
|Maestro|Περισσότερο copy/sniper|Έχει copytrade σε Solana και χρεώνει 1% σε buy/sell/snipes. Καλό για wallets, όχι τόσο για preset scanning. ([docs.maestrobots.com](https://docs.maestrobots.com/copytrade "Copytrade \| Sniper Manual"))|
|Trojan|Καλό trading bot|Έχει Telegram bot με auto buy, auto sell, sniper, trenches, copy trade, limit/DCA ενότητες στα docs. ([docs.trojanonsolana.com](https://docs.trojanonsolana.com/ "Welcome to Trojan on Solana \| Trojan on Solana - Tutorials"))|
## Τι θα διάλεγα
Για αυτό που θες, θα πήγαινα έτσι:
```text
1η επιλογή: GMGN alerts/signals + manual/paper logging
2η επιλογή: GMGN Sniper Bot με auto sell, αλλά auto buy κλειστό στην αρχή
3η επιλογή: δικό σου μικρό logger/script που κρατάει virtual trades
```
Δεν θα ξεκινούσα με Maestro/Trojan για αυτό το συγκεκριμένο σενάριο, γιατί εσύ δεν θες κυρίως copy trading. Θες **preset-based migrated scanner**.
## Σημαντικό θέμα ασφάλειας
Μην βάλεις ποτέ main wallet/private key σε bot. Το GMGN προειδοποιεί ρητά για fake Telegram bots και ότι πρέπει να χρησιμοποιούνται μόνο τα official bots, γιατί υπάρχουν scam bots που μπορούν να αδειάσουν wallet. Επίσης αναφέρει 2FA στο Telegram και προσοχή σε private keys. ([docs.gmgn.ai](https://docs.gmgn.ai/index/gmgn-tg-sniper-bot-sol "GMGN TG Sniper Bot - SOL | GMGN Tutorial"))
## Συμπέρασμα
Ναι, γίνεται να το δοκιμάσεις, αλλά το σωστό setup είναι:
```text
GMGN signal/alert monitoring
χωρίς auto-buy στην αρχή
virtual trades για 100+ signals
μετά real test 0.03–0.05 SOL
μετά 0.10 SOL μόνο αν έχεις >55% πραγματικό win rate
```
Το ιδανικό για σένα ως developer είναι ένα απλό **dry-run logger**: παίρνει token όταν περνάει το preset, γράφει virtual entry, και μετά ελέγχει αν πρώτα χτύπησε TP ή SL. Αυτό θα σου δείξει σε 2–5 μέρες αν το preset έχει νόημα ή απλώς φαίνεται καλό στην οθόνη.


## DATA SAMPLES FLOW 


**Flow**
1. Πάρε το market universe.
2. Φτιάξε dynamic cohorts από αυτό το universe.
3. Κάνε enrichment μόνο στα candidate tokens.
4. Πάρε price-path data για backtesting λογικής TP/SL/time-stop.
5. Πάρε wallet-flow context για smart money / KOL.
6. Σώσε raw + normalized outputs σε dated folder.
7. Μετά τρέξε την ανάλυση πάνω στο saved dataset, όχι κατευθείαν στο live API.
**Phase 1: Universe Pull**
​
Τρέχω αυτά πρώτα για να ξέρω τι παίζει τώρα στην αγορά:
```
gmgn-cli.cmd market trending --chain sol --interval 1m --platform Pump.fun --platform letsbonk --order-by volume --limit 100 --raw
gmgn-cli.cmd market trending --chain sol --interval 5m --platform Pump.fun --platform letsbonk --order-by volume --limit 100 --raw
gmgn-cli.cmd market trending --chain sol --interval 1h --platform Pump.fun --platform letsbonk --order-by volume --limit 100 --raw
gmgn-cli.cmd market trenches --chain sol --type new_creation --launchpad-platform Pump.fun --launchpad-platform letsbonk --limit 80 --raw
gmgn-cli.cmd market trenches --chain sol --type near_completion --launchpad-platform Pump.fun --launchpad-platform letsbonk --limit 80 --raw
gmgn-cli.cmd market trenches --chain sol --type completed --launchpad-platform Pump.fun --launchpad-platform letsbonk --limit 80 --raw
```
Από εδώ παίρνουμε:
- market cap
- liquidity
- volume
- buys / sells
- holders
- top 10 concentration
- dev/team hold
- bundler / sniper / insider risk
- migrated vs non-migrated status
**Phase 2: Smart Money Context**
​
Μετά τραβάω το wallet flow για context:
```
gmgn-cli.cmd track smartmoney --chain sol --limit 100 --raw
gmgn-cli.cmd track kol --chain sol --limit 100 --raw
```
Προαιρετικά, για signal layer:
```
gmgn-cli.cmd market signal --chain sol --groups '[{"signal_type":[12,13]},{"signal_type":[6,7]}]' --raw
```
Αυτό δίνει:
- smart money buys/sells
- KOL buys/sells
- cluster signals
- price spike / ATH behavior
**Phase 3: Candidate Selection**
​
Από τα universes φτιάχνω cohorts, όχι fixed token list:
- `top 5m momentum cohort`
- `top 1h volume cohort`
- `recent migrated cohort`
- `90k-500k market-cap cohort`
- `strategy candidate cohort`
    ​
    Αυτό είναι union από:
    - top volume
    - migrated
    - tokens με `smart_degen_count >= 1`
    - tokens που περνάνε βασικά safety/liquidity cuts
**Phase 4: Per-Token Enrichment**
​
Για κάθε token στο `strategy candidate cohort` τραβάω:
```
gmgn-cli.cmd token info --chain sol --address <token_address> --raw
gmgn-cli.cmd token security --chain sol --address <token_address> --raw
gmgn-cli.cmd token pool --chain sol --address <token_address> --raw
```
Αυτά είναι τα minimum.
Για deeper strategy analysis, ειδικά αν θες να δούμε distribution / exits / whale risk, τραβάω και:
```
gmgn-cli.cmd token holders --chain sol --address <token_address> --limit 100 --raw
gmgn-cli.cmd token traders --chain sol --address <token_address> --limit 100 --raw
```
Από εδώ παίρνουμε:
- exact liquidity / pool
- fee / structure context
- holder concentration
- dev status
- bot / bundler / rat trader presence
- smart money holder/trader composition
**Phase 5: Price Path / Backtest Inputs**
​
Για κάθε enriched candidate τραβάω candles από `open_timestamp` αν είναι migrated, αλλιώς από `creation_timestamp`:
```
gmgn-cli.cmd market kline --chain sol --address <token_address> --resolution 1m --from <ts> --to <now> --raw
gmgn-cli.cmd market kline --chain sol --address <token_address> --resolution 5m --from <ts> --to <now> --raw
gmgn-cli.cmd market kline --chain sol --address <token_address> --resolution 15m --from <ts> --to <now> --raw
```
Το `1m` είναι για:
- TP/SL hit tests
- time stop
- early volatility
- run-up / drawdown
Το `5m` και `15m` είναι για:
- cleaner momentum structure
- later automation rules
- less noisy strategy comparisons
**Phase 6: Save Structure**
​
Το dataset πρέπει να γράφεται έτσι:
```
.gmgn-reference/YYYY-MM-DD/raw/
.gmgn-reference/YYYY-MM-DD/enriched/
.gmgn-reference/YYYY-MM-DD/samples/
.gmgn-reference/YYYY-MM-DD/derived/
.gmgn-reference/YYYY-MM-DD/manifest.json
.gmgn-reference/YYYY-MM-DD/README.md
```
Με λογική:
- `raw/` = exact API responses
- `enriched/` = per-token info/security/pool/holders/traders
- `samples/` = kline files
- `derived/` = normalized files για analysis
**Phase 7: Derived Files For Analysis**
​
Μετά χτίζω reusable outputs όπως:
- `universe_summary.json`
- `cohort_strategy_candidates.json`
- `filter_funnel_default.json`
- `runup_drawdown_baseline.json`
- `momentum_baseline.json`
- `smartmoney_context.json`
Αυτά είναι τα αρχεία πάνω στα οποία μετά μπορείς να πεις:
- “τρέξε preset A”
- “δοκίμασε TP +35 / SL -20”
- “σύγκρινε strategy X vs Y”
- “βγάλε automation rules”
**Τι χρειαζόμαστε για κάθε είδος ανάλυσης**
- Για filters/presets:
    ​
    `market trending` + `market trenches`
- Για TP/SL/time stop:
    ​
    `market kline`
- Για dev / concentration / rug risk:
    ​
    `token info` + `token security` + `token holders`
- Για liquidity / fee / execution realism:
    ​
    `token pool`
- Για copy-flow / conviction context:
    ​
    `track smartmoney` + `track kol` + προαιρετικά `market signal`
- Για whale dump / distribution:
    ​
    `token traders` + `token holders`
**Πρακτικό Rule**
​
Το σωστό operational flow είναι:
1. Τράβα universes.
2. Χτίσε cohorts.
3. Enrich top candidates.
4. Πάρε klines.
5. Σώσε dataset.
6. Μετά κάνε analysis.
Όχι:
7. Πάρε ένα-δύο tokens.
8. Βγάλε συμπέρασμα από ad hoc sample.
Αν θέλεις, επόμενο βήμα μπορώ να σου το μετατρέψω σε ένα πιο αυστηρό `analysis flow spec` αρχείο μέσα στο repo, ξεχωριστό από το prompt, ώστε να έχουμε:
- ένα prompt για `dataset refresh`
- ένα spec για `how analysis should run on saved datasets`



## Trading-bot
 - Αν θες, επόμενο βήμα μπορώ να βάλω και configurable `paper exit attempt multiplier` για να πλησιάσει κι άλλο το live sell behavior.
