---
categories:
  - "[[Home]]"
created: 2026-06-08
domain: []
tags:
  - topic/trading
---

https://chatgpt.com/g/g-p-6a004382604c8191b1491e5176d29380/c/6a2563e3-6bcc-83eb-8711-53246c6a9a19

## Τι αγοράζεις ουσιαστικά
Στα **Kraken futures/perpetuals** δεν αγοράζεις το ίδιο το BTC/ETH/ZEC κ.λπ. Ανοίγεις ένα **παράγωγο συμβόλαιο** πάνω στην τιμή του asset. Δηλαδή παίρνεις έκθεση στην κίνηση της τιμής, χωρίς να κρατάς spot crypto στο wallet σου. Η Kraken το περιγράφει ως τρόπο να έχεις έκθεση σε crypto χωρίς να το αγοράζεις και να το κρατάς. ([Kraken][1])
## Long και short
1. **Long**: κερδίζεις αν ανέβει η τιμή.
2. **Short**: κερδίζεις αν πέσει η τιμή.
3. Κλείνεις τη θέση όταν θες, είτε με market/limit order είτε με TP/SL.
Αυτό είναι το βασικό πλεονέκτημα έναντι spot: μπορείς να παίξεις και πτωτική αγορά. Το βασικό μειονέκτημα: με leverage, το λάθος πληρώνεται γρήγορα.
## Perpetual vs fixed maturity
Στο Kraken υπάρχουν κυρίως:
1. **Perpetual futures**
   Δεν έχουν ημερομηνία λήξης. Μένουν ανοιχτά μέχρι να τα κλείσεις ή μέχρι να γίνει liquidation. Τα perpetuals έχουν funding rate ώστε η τιμή του contract να μένει κοντά στην spot/index τιμή. Στα Kraken EEA perpetuals γίνεται settlement/funding ανά ώρα. ([Kraken Support][2])
2. **Fixed maturity futures**
   Έχουν λήξη/ωρίμανση. Είναι πιο “κλασικά” futures. Για απλό trading engine, συνήθως ξεκινάς από perpetuals, γιατί δεν έχεις το θέμα expiry/rollover.
## Leverage
Το leverage σημαίνει ότι ελέγχεις μεγαλύτερη θέση από το κεφάλαιο που δεσμεύεις.
Παράδειγμα:

| Κεφάλαιο | Leverage | Notional θέση | Κίνηση αγοράς | PnL πριν fees/funding |
| -------: | -------: | ------------: | ------------: | --------------------: |
|     500€ |       1x |          500€ |           +2% |                  +10€ |
|     500€ |       3x |        1.500€ |           +2% |                  +30€ |
|     500€ |       5x |        2.500€ |           +2% |                  +50€ |
|     500€ |       5x |        2.500€ |           -2% |                  -50€ |
Το λάθος που κάνουν πολλοί: βλέπουν μόνο το upside. Στα futures, το **PnL υπολογίζεται πάνω στο notional**, όχι πάνω στο margin που έβαλες. Άρα 5x leverage σημαίνει περίπου 5 φορές πιο γρήγορο κέρδος αλλά και 5 φορές πιο γρήγορη ζημιά.
Για πελάτες **EEA**, άρα και Ελλάδα, τα Kraken EEA docs αναφέρουν **up to 10x leverage** στα Multi-Collateral derivatives. Τα γενικά/global Kraken pages μιλούν για έως 50x, αλλά για Ελλάδα πρέπει να κοιτάς τα EEA-specific όρια και το actual contract UI. ([Kraken Support][3])
## Margin
Το **margin** είναι το collateral που δεσμεύεις για να κρατήσεις τη θέση.
Υπάρχουν δύο βασικές λειτουργίες:

| Mode                | Τι σημαίνει                                                                   | Ρίσκο                                                     |
| ------------------- | ----------------------------------------------------------------------------- | --------------------------------------------------------- |
| **Cross margin**    | Όλο το διαθέσιμο balance στο derivatives wallet μπορεί να στηρίξει τις θέσεις | Αν στραβώσει η θέση, κινδυνεύει όλο το wallet             |
| **Isolated margin** | Βάζεις συγκεκριμένο ποσό margin μόνο για αυτή τη θέση                         | Αν γίνει liquidation, χάνεις κυρίως αυτό το isolated ποσό |
Για εσένα, πρακτικά: **isolated margin** είναι πιο καθαρό για automated strategies, γιατί περιορίζεις τη ζημιά ανά trade. Η Kraken λέει ότι στο isolated margin μόνο το ποσό που έχει απομονωθεί για τη θέση είναι σε κίνδυνο, ενώ στο cross margin όλο το wallet balance χρησιμοποιείται ως margin για τις ανοιχτές θέσεις. ([Kraken Support][4])
Σημαντικό: στο Kraken το margin mode πρέπει να οριστεί **πριν** ανοίξεις θέση στο contract. Δεν μπορείς να αλλάξεις από cross σε isolated αφού έχει ήδη ανοίξει η θέση. ([Kraken Support][5])
## Funding rate
Στα perpetuals υπάρχει **funding**. Δεν είναι fee προς Kraken με την κλασική έννοια· είναι περιοδική πληρωμή μεταξύ traders ώστε η τιμή του perpetual να μη φεύγει πολύ από την index/spot τιμή.
Χονδρικά:
1. Αν το perpetual είναι ακριβότερο από spot/index, συνήθως οι longs πληρώνουν shorts.
2. Αν το perpetual είναι φθηνότερο, συνήθως οι shorts πληρώνουν longs.
3. Στο Kraken EEA perpetual setup, το funding/settlement γίνεται ανά ώρα. ([Kraken Support][2])
Άρα μια θέση που φαίνεται σωστή τεχνικά μπορεί να “τρώει” funding αν την κρατάς πολλές ώρες/μέρες.
## Liquidation
Liquidation γίνεται όταν το equity/margin της θέσης ή του margin wallet δεν επαρκεί πλέον για το maintenance margin.
Η Kraken αναφέρει ότι liquidation ενεργοποιείται όταν το portfolio value του derivatives margin wallet πέσει κάτω από το απαιτούμενο maintenance margin. Επίσης, δεν παρέχει margin calls ή προειδοποιήσεις πριν τη liquidation· όταν πιαστεί το threshold, η θέση μπορεί να ρευστοποιηθεί. ([Kraken Support][6])
Πρακτικά:

| Leverage | Περίπου πόσο αντέχεις πριν γίνει επικίνδυνο   |
| -------: | --------------------------------------------- |
|       2x | Μεγάλη απόσταση                               |
|       3x | Ακόμα λογικό για συστηματικό trading          |
|       5x | Θέλει αυστηρό stop                            |
|      10x | Πολύ νευρικό, μικρή ανάποδη κίνηση σε διαλύει |
Δεν είναι ακριβώς “1/leverage” γιατί υπάρχουν maintenance margin, fees, funding, mark price και contract-specific rules. Αλλά σαν εμπειρικός κανόνας: όσο ανεβάζεις leverage, τόσο μικρότερη ανάποδη κίνηση χρειάζεται για να κινδυνεύσεις.
## Mark price
Η liquidation δεν βασίζεται απλά στο τελευταίο trade price. Το Kraken χρησιμοποιεί **mark price**, δηλαδή εκτίμηση δίκαιης τιμής βασισμένη σε index price και premium/discount του contract. Στα EEA perpetual specs αναφέρεται mark price ως index price συν EMA 30 δευτερολέπτων της διαφοράς order book mid price από index price, με caps στο premium. ([Kraken Support][2])
Αυτό σημαίνει ότι μπορεί να βλέπεις last price λίγο διαφορετικό, αλλά η liquidation να υπολογίζεται με mark price.
## Fees
Για EEA derivatives, τα fees ξεκινούν από:

| 30-day volume |   Maker |   Taker |
| ------------: | ------: | ------: |
|           $0+ | 0.0200% | 0.0500% |
Τα fees υπολογίζονται πάνω στο **notional value** του trade, όχι στο margin σου. Άρα αν έχεις 500€ margin και 5x θέση, πληρώνεις fee πάνω στα ~2.500€ notional. ([Kraken Support][7])
Market orders συνήθως είναι taker. Limit orders μπορεί να είναι maker ή taker, ανάλογα αν κάθονται πρώτα στο order book ή εκτελούνται αμέσως. ([Kraken Support][8])
## TP/SL και bracket orders
Στο Kraken Pro derivatives μπορείς να βάλεις **Take Profit / Stop Loss** μαζί με την αρχική order. Αν βάλεις και τα δύο, λειτουργούν ως OCO: αν ενεργοποιηθεί το ένα, ακυρώνεται το άλλο. ([Kraken Support][9])
Αυτό είναι σημαντικό για trading engine. Η σωστή λογική δεν είναι:
> μπαίνω τώρα και βλέπουμε.
Η σωστή λογική είναι:
> μπαίνω μόνο αν ξέρω entry, invalidation, stop, target, max loss και max exposure.
## Πρακτική ροή trade
Παράδειγμα BTC perpetual:
1. Επιλέγεις contract: π.χ. BTC/USD perpetual.
2. Διαλέγεις **long** ή **short**.
3. Διαλέγεις margin mode: προτιμότερο **isolated** για αρχή.
4. Διαλέγεις leverage: π.χ. 2x ή 3x, όχι 10x.
5. Βάζεις entry order:
   * limit για καλύτερο fee/slippage,
   * market μόνο αν θες άμεση εκτέλεση.
6. Βάζεις stop loss.
7. Βάζεις take profit ή trailing/partial exits.
8. Παρακολουθείς:
   * liquidation price,
   * funding rate,
   * margin usage,
   * unrealized PnL,
   * open orders,
   * fills.

## PnL
Το **PnL βγαίνει πάνω στο μέγεθος της θέσης**, δηλαδή στο **notional / position value**, όχι πάνω στο margin που έβαλες.
Για linear futures όπως αυτό που βλέπεις:
```
PnL = (Current price - Entry price) × Position size
```
Για long θέση. Για short είναι ανάποδα. Η Kraken δίνει αντίστοιχη λογική για unrealized PnL: current mark price μείον entry price, επί position size.

Το **PnL** δείχνει πόσα κερδίζεις/χάνεις σε χρήμα.

## RoE
**RoE = Return on Equity**.
Στα futures σημαίνει περίπου:
```
RoE % = Unrealized PnL / Initial margin × 100
```
Το **RoE** δείχνει πόσο είναι αυτό το ποσό που κερδίζεις ή χάνεις ως ποσοστό πάνω στο margin που δέσμευσες.
Είναι απόδοση πάνω στο **initial margin** της θέσης.

#### Σχέση με leverage
Πρακτικά, πριν fees/funding:
```
RoE ≈ price move % × leverage
```


## Τι είναι τα fixed maturity futures
Τα futures με συγκεκριμένη ημερομηνία είναι συμβόλαια που **λήγουν** σε προκαθορισμένη ημέρα και ώρα. Δεν είναι σαν τα perpetual που μένουν ανοιχτά επ’ αόριστον.
Στο Kraken τα derivatives έχουν maturities τύπου **perpetual, monthly, quarterly και semiannual**. Για EEA clients, τα linear fixed maturity contracts υπάρχουν για BTC/XBT, ETH και SOL, με BTC/ETH να έχουν εβδομαδιαία, μηνιαία, τριμηνιαία και εξαμηνιαία λήξη, ενώ το SOL έχει μηνιαία και τριμηνιαία. ([Kraken Support](https://support.kraken.com/articles/360030752992-settlement-derivatives "Settlement process for Derivatives | Kraken")) ([Kraken Support](https://support.kraken.com/el/articles/4844359082772-linear-multi-collateral-derivatives-contract-specifications "Προδιαγραφές Γραμμικών Συμβολαίων Παραγώγων Πολλαπλής Εγγύησης | Kraken"))
##### Διαφορά από perpetual

|Θέμα|Perpetual|Fixed maturity future|
|---|---|---|
|Λήξη|Δεν λήγει κανονικά|Λήγει σε συγκεκριμένη ημερομηνία|
|Funding|Ναι|Όχι όπως στα perpetual|
|Τιμή|Κοντά στο index μέσω funding|Μπορεί να έχει premium/discount μέχρι τη λήξη|
|Κράτημα|Μπορείς να το κρατάς χωρίς rollover|Πρέπει να το κλείσεις ή να το αφήσεις να διακανονιστεί|
|Κατάλληλο για|Short-term trading, συνεχές exposure|Hedging, trade με ορίζοντα ημερομηνίας|
Το fixed maturity είναι πιο “παραδοσιακό” futures. Δεν βασίζεται σε funding για να μείνει κοντά στο spot· όσο πλησιάζει η λήξη, η τιμή του τείνει να συγκλίνει προς το index/settlement price.
##### Τι γίνεται στη λήξη
Αν κρατήσεις τη θέση μέχρι τη λήξη, δεν παραλαμβάνεις BTC/SOL/ETH. Γίνεται **cash settlement**. Δηλαδή η θέση κλείνει λογιστικά με βάση τιμή εκκαθάρισης που υπολογίζεται από index. Η Kraken αναφέρει ότι οι fixed maturity θέσεις που κρατιούνται έως maturity διακανονίζονται σε μετρητά βάσει τιμής από index provider. ([Kraken Support](https://support.kraken.com/articles/360030752992-settlement-derivatives "Settlement process for Derivatives | Kraken"))
Για τα linear fixed maturity contracts, η τελευταία συναλλαγή είναι στις **08:00 UTC** και η εκκαθάριση γίνεται μέσα σε 15 λεπτά μετά. Η settlement price υπολογίζεται από παρατηρήσεις του real-time index στο παράθυρο **07:30–08:00 UTC** της τελευταίας ημέρας συναλλαγών. ([Kraken Support](https://support.kraken.com/el/articles/4844359082772-linear-multi-collateral-derivatives-contract-specifications "Προδιαγραφές Γραμμικών Συμβολαίων Παραγώγων Πολλαπλής Εγγύησης | Kraken"))
##### Οι ημερομηνίες λήξης
Για τα linear fixed maturity contracts στο Kraken:

|Τύπος|Λήξη|
|---|---|
|Weekly|Κάθε Παρασκευή|
|Monthly|Τελευταία Παρασκευή του μήνα|
|Quarterly|Τελευταία Παρασκευή Μαρτίου, Ιουνίου, Σεπτεμβρίου, Δεκεμβρίου|
|Semiannual|Στον ίδιο κύκλο, διαθέσιμο για BTC/ETH|
Η Kraken αναφέρει επίσης ότι για BTC και ETH υπάρχουν ταυτόχρονα τουλάχιστον τέσσερα συμβόλαια: weekly, monthly, quarterly και semiannual. Για SOL υπάρχουν monthly και quarterly. ([Kraken Support](https://support.kraken.com/el/articles/4844359082772-linear-multi-collateral-derivatives-contract-specifications "Προδιαγραφές Γραμμικών Συμβολαίων Παραγώγων Πολλαπλής Εγγύησης | Kraken"))
##### Πώς γράφονται συνήθως
Στο UI μπορεί να δεις κάτι σαν:

|Παράδειγμα|Τι σημαίνει|
|---|---|
|BTC Perp / XBT Perp|perpetual|
|BTC Jun 26 / XBT Jun 26|fixed maturity που λήγει τότε|
|ETH Monthly|μηνιαίο fixed maturity|
|SOL Quarterly|τριμηνιαίο fixed maturity|
Στο API/logs, η Kraken χρησιμοποιεί συχνά **XBT** για Bitcoin, ενώ στο UI μπορεί να βλέπεις **BTC**. Αυτό το αναφέρει και στα contract specs. ([Kraken Support](https://support.kraken.com/el/articles/4844359082772-linear-multi-collateral-derivatives-contract-specifications "Προδιαγραφές Γραμμικών Συμβολαίων Παραγώγων Πολλαπλής Εγγύησης | Kraken"))
##### PnL
Για linear derivatives, ο τύπος είναι ο ίδιος λογικά με αυτά που είδες:
```text
PnL = (Exit price - Entry price) × Position size
```
Για long. Για short αντιστρέφεται. Η Kraken δίνει τον ίδιο τύπο για linear derivatives και αναφέρει ότι το PnL υπολογίζεται ως διαφορά τιμής επί position size. ([Kraken Support](https://support.kraken.com/articles/what-are-derivatives-eea?utm_source=chatgpt.com "What are Derivatives? (FAQ for clients in the EEA)"))
Παράδειγμα:

|Trade|Τιμή|
|---|--:|
|Αγοράζεις BTC fixed maturity|62,000|
|Κλείνεις/settles|63,000|
|Quantity|0.0002 BTC|
```text
(63,000 - 62,000) × 0.0002 = 0.20 USD
```
Πριν fees.
##### Το σημαντικό: premium και discount
Το fixed future μπορεί να διαπραγματεύεται:
1. **πάνω από spot/index** → premium / contango,
2. **κάτω από spot/index** → discount / backwardation.
Παράδειγμα:

|Spot BTC|Future BTC|
|--:|--:|
|62,000|62,500|
Αν αγοράσεις το future στα 62,500 και στη λήξη το index είναι 62,000, τότε χάνεις, παρότι το spot “δεν έπεσε”. Πλήρωσες premium.
Αυτό είναι το σημείο που θέλει προσοχή. Στο perpetual κοιτάς κυρίως funding. Στο fixed maturity κοιτάς κυρίως **basis**, δηλαδή πόσο απέχει η τιμή του futures από το index.
##### Τι να κοιτάς πριν ανοίξεις fixed maturity

|Πεδίο|Τι σημαίνει|
|---|---|
|Expiry / maturity date|Πότε λήγει|
|Days to maturity|Πόσες μέρες μένουν|
|Future price|Τιμή συμβολαίου|
|Index price|Τρέχουσα τιμή αναφοράς|
|Basis / premium|Διαφορά future από index|
|Liquidity|Spread και order book|
|Mark price|Τιμή για margin/liquidation|
|Settlement time|Ώρα τελικής εκκαθάρισης|
|Fees|Αν κρατήσεις έως settlement, θεωρείται taker fee|
Η Kraken αναφέρει ότι οι προμήθειες στα derivatives υπολογίζονται πάνω στο notional order value και, ειδικά για fixed maturity που κρατάς έως settlement, η διακράτηση έως εκκαθάριση συνεπάγεται taker fee. ([Kraken Support](https://support.kraken.com/articles/fees-for-derivatives-trading-eea?utm_source=chatgpt.com "Fees for Derivatives trading for EEA clients")) ([Kraken Support](https://support.kraken.com/el/articles/4844359082772-linear-multi-collateral-derivatives-contract-specifications "Προδιαγραφές Γραμμικών Συμβολαίων Παραγώγων Πολλαπλής Εγγύησης | Kraken"))
##### Πότε έχει νόημα
Με fixed maturity future έχει νόημα όταν:
1. έχεις χρονικό σενάριο, π.χ. “μέχρι το τέλος του μήνα βλέπω άνοδο”,
2. θέλεις hedge σε spot θέση,
3. θέλεις να αποφύγεις funding των perpetuals,
4. θες trade που λήγει αναγκαστικά σε ημερομηνία,
5. θες να εκμεταλλευτείς basis/premium αν ξέρεις τι κάνεις.
Για απλό manual learning, είναι πιο καθαρό να το δεις ως:
> Ανοίγω θέση σε future που λήγει τότε. Αν δεν την κλείσω, θα κλείσει μόνη της στη λήξη με βάση το settlement index.
##### Για δοκιμή με 50€
Δεν θα ξεκινούσα από fixed maturity ως κύριο εργαλείο. Θα το δοκίμαζα μόνο με πολύ μικρό μέγεθος.
Πρόταση:

|Ρύθμιση|Επιλογή|
|---|---|
|Asset|BTC ή ETH|
|Maturity|Weekly ή monthly|
|Margin|Isolated|
|Leverage|1x–2x|
|Notional|5–10 USD|
|Stop|Υποχρεωτικό|
|Κλείσιμο|Πριν τη λήξη, όχι settlement στην πρώτη δοκιμή|
Για πρώτη δοκιμή, μην το κρατήσεις μέχρι expiry. Κλείσ’ το χειροκίνητα για να δεις πώς συμπεριφέρεται. Μετά, σε δεύτερο μικρό test, μπορείς να αφήσεις ένα ελάχιστο contract να πάει σε settlement μόνο για να δεις τι γράφει στο history.
##### Πρακτικός κανόνας
Αν δεις:
```text
Future price > Index price
```
τότε ως long αγοράζεις ακριβότερα από το spot/index. Θέλεις η αγορά να ανέβει αρκετά ώστε να καλύψει και αυτό το premium.
Αν δεις:
```text
Future price < Index price
```
τότε ως long αγοράζεις με discount, αλλά αυτό συνήθως σημαίνει ότι η αγορά τιμολογεί πίεση/φόβο ή αυξημένη ζήτηση για short exposure.
##### Συμπέρασμα
Τα fixed maturity futures στο Kraken είναι πιο “καθαρά” από τα perpetual ως προς το ότι **δεν έχεις funding**, αλλά έχουν άλλο ρίσκο: **ημερομηνία λήξης, settlement price και basis/premium**.
Για το δικό σου manual testing:
1. συνέχισε κυρίως με perpetuals,
2. δοκίμασε fixed maturity μόνο με BTC/ETH,
3. βάλε isolated και 1x–2x,
4. μη βάλεις μεγάλο notional,
5. κλείσε πριν τη λήξη στην πρώτη δοκιμή,
6. κράτα σημείωση: future price, index price, basis, expiry, fees, net PnL.


## Για trading engine
Για software implementation, θα το χώριζα έτσι:

| Component         | Τι κάνει                                           |
| ----------------- | -------------------------------------------------- |
| Market Data       | Παίρνει candles/orderbook/ticker                   |
| Signal Engine     | Βγάζει long/short/no trade                         |
| Risk Engine       | Υπολογίζει position size, leverage, stop           |
| Execution Engine  | Στέλνει orders                                     |
| Position Sync     | Συγχρονίζει open positions/fills/orders            |
| Liquidation Guard | Κόβει έκθεση αν πλησιάζει liquidation              |
| Funding Monitor   | Αποφεύγει trades όταν το funding είναι δυσμενές    |
| Journal           | Κρατά entry, exit, reason, fees, funding, slippage |
Για αρχή, αν το έστηνες σοβαρά, θα πρότεινα:

| Παράμετρος     | Συντηρητική επιλογή                              |
| -------------- | ------------------------------------------------ |
| Market         | BTC ή ETH perpetual                              |
| Margin         | Isolated                                         |
| Leverage       | 2x έως 3x                                        |
| Max risk/trade | 0.5% έως 1.0% του account                        |
| Entry          | Limit όπου γίνεται                               |
| Stop           | Πάντα, όχι χειροκίνητα                           |
| Funding filter | Μη μπαίνεις αν funding είναι έντονα εναντίον σου |
| Position sync  | Υποχρεωτικό πριν από κάθε νέο order              |
## Συμπέρασμα
Τα Kraken futures είναι χρήσιμα κυρίως για:
1. Να παίζεις και πτώση μέσω short.
2. Να χρησιμοποιείς μικρότερο κεφάλαιο για μεγαλύτερη έκθεση.
3. Να κάνεις hedge spot θέσεις.
4. Να φτιάξεις πιο καθαρό automated trading σύστημα από spot-only.
Αλλά για αρχή, όχι υψηλό leverage. Για το δικό σου trading engine, η λογική βάση είναι **BTC/ETH perpetual, isolated margin, 2x–3x leverage, fixed risk per trade, bracket orders, και αυστηρό position sync**.
[1]: https://www.kraken.com/features/futures "Crypto Futures Trading | Cryptocurrency Futures Market | Kraken"
[2]: https://support.kraken.com/articles/perpetual-contract-specifications-for-clients-in-the-eea?utm_source=chatgpt.com "Linear Multi-Collateral Derivatives Contract Specifications ..."
[3]: https://support.kraken.com/articles/multi-collateral-derivatives-contracts-eea?utm_source=chatgpt.com "Multi-collateral Derivatives contracts for EEA clients"
[4]: https://support.kraken.com/articles/multi-collateral-derivatives-contracts-eea "Multi-collateral Derivatives contracts for EEA clients | Kraken"
[5]: https://support.kraken.com/articles/4844429542676-trading-multi-collateral-derivatives "Trading Multi-Collateral Derivatives | Kraken"
[6]: https://support.kraken.com/articles/4402283092244-liquidation-faq-derivatives "Liquidation FAQ | Kraken"
[7]: https://support.kraken.com/articles/fees-for-derivatives-trading-eea "Fees for Derivatives trading for EEA clients | Kraken"
[8]: https://support.kraken.com/articles/first-derivative-trade-eea "Placing your first Derivative trade for EEA clients | Kraken"
[9]: https://support.kraken.com/articles/take-profit-stop-loss-bracket-orders-derivatives "Take Profit / Stop loss (bracket) orders | Kraken"


