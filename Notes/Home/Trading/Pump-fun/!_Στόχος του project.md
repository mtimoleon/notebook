# Ιστορικό έρευνας και τρέχουσα κατάσταση του Candidate B
## 1. Στόχος του project
Ο στόχος είναι να επιλεγούν πολύ νωρίς νέα Pump.fun mints που έχουν αρκετή μελλοντική δυναμική ώστε:
1. να γίνει entry πριν χαθεί το μεγαλύτερο μέρος της ανόδου,
2. να υπάρχει αρκετή μεταγενέστερη κίνηση για έξοδο με θετικό καθαρό PnL,
3. να απορρίπτεται μεγάλο μέρος των mints που παραμένουν σχεδόν επίπεδα ή καταρρέουν νωρίς,
4. η απόφαση να μπορεί να εφαρμοστεί live με Deshred intents και Yellowstone confirmed events.
Ο τελικός επιχειρηματικός στόχος δεν είναι απλώς υψηλό classification accuracy, αλλά:
```text
θετικό καθαρό SOL/ώρα
```
με επιθυμητό επίπεδο περίπου:
```text
>= 0.1 SOL/ώρα
```
Το μέχρι τώρα αποτέλεσμα είναι ένας validated classifier μελλοντικής opportunity. Δεν είναι ακόμη ολοκληρωμένη, cost-aware στρατηγική trading.

---
# 2. Η αρχική υπόθεση
Η έρευνα ξεκίνησε σε δύο ανεξάρτητες αλλά σχετιζόμενες κατευθύνσεις.
## Κατεύθυνση Α — Entry πριν από 20%, exit μετά από 30%
Η αρχική υπόθεση ήταν:
```text
Περιμένω ένα μικρό χρονικό διάστημα μετά το create.
Αν το mint παρουσιάζει αρκετά θετικά πρώιμα χαρακτηριστικά
και η curve βρίσκεται ακόμη πριν περίπου το 20%:
    κάνω BUY.
Αν αργότερα η curve φτάσει περίπου το 30% ή περισσότερο:
    κάνω SELL.
```
Τα όρια 20% και 30% ήταν αρχικά προσεγγιστικά και όχι παγωμένοι κανόνες.
Το ζητούμενο ήταν να βρεθεί:
- πόσο πρέπει να περιμένουμε,
- σε ποιο growth level μπορεί να γίνει entry,
- ποιο exit level δίνει καλύτερο αποτέλεσμα,
- πώς επηρεάζουν το αποτέλεσμα creator sell, fees, slippage, latency και self-impact.
## Κατεύθυνση Β — Διαχωρισμός `<7%` από `≥20%`
Η δεύτερη υπόθεση ήταν ότι τα περισσότερα mints χωρίζονται σχετικά νωρίς σε:
```text
dead:   τελικό max < 7%
middle: τελικό max 7% έως <20%
strong: τελικό max >=20%
```
Το ερώτημα ήταν:
```text
Τι έχουν τα mints που μένουν κάτω από 7%
και δεν έχουν όσα φτάνουν 20%;
Τι έχουν τα strong mints που λείπει από τα dead;
```
Η κατεύθυνση αυτή τελικά οδήγησε στον Candidate B.

---
# 3. Βασικοί ορισμοί
## Authoritative αρχή χρόνου
Οι χρονικές αποφάσεις μετρώνται από:
```text
create_received_at
```
δηλαδή από το authoritative create event όπως έγινε ορατό στον collector.
## Baseline
Για την curve χρησιμοποιήθηκε confirmed baseline:
1. πρώτο confirmed creator buy, όταν ήταν διαθέσιμο και έγκυρο,
2. διαφορετικά πρώτο confirmed curve snapshot μετά το create.
## Mayhem
Τα Mayhem αποκλείονται πριν από:
- baseline selection,
- curve loading,
- feature generation,
- checkpoint generation,
- labels,
- rule evaluation.
Άρα:
```text
Mayhem => SKIP
```
Τα Mayhem είχαν διαφορετική κατανομή και δυσανάλογα υψηλό αριθμό strong/positive περιπτώσεων. Η ανάμειξή τους με τα normal mints άλλαζε σημαντικά τα αποτελέσματα.

---
# 4. Dataset της early-opportunity analysis
Στην κύρια non-Mayhem development ανάλυση χρησιμοποιήθηκαν:
```text
32 development databases
5.470 creates πριν το Mayhem filter
1.064 Mayhem creates αφαιρέθηκαν
4.406 non-Mayhem creates
2.319 valid confirmed baselines
2.087 invalid λόγω έλλειψης baseline μέσα στο horizon
14.122 observation samples
4.315 positive labels
9.807 negative labels
```
Το label ορίστηκε ως:
```text
buy size: 0.3 SOL
entry growth: [0%, 20%)
observation μέχρι να περάσει το 7%
horizon: 15s από το create
gross target: 10%
self-impact: περιλαμβάνεται
fees/slippage/tips: δεν περιλαμβάνονται
```
Άρα το label σημαίνει:
```text
Υπήρχε αργότερα δυνατότητα entry πριν το 20%
και sell με τουλάχιστον 10% gross return,
με self-impact αλλά χωρίς τα υπόλοιπα κόστη.
```
Δεν σημαίνει:
```text
πραγματικό κερδοφόρο trade μετά από όλα τα κόστη.
```

---
# 5. Σημαντική προειδοποίηση για τα διαφορετικά denominators
Δεν χρησιμοποιούν όλα τα scripts ακριβώς το ίδιο πλήθος databases.
Για παράδειγμα, η creator-sell/growth ανάλυση χρησιμοποίησε:
```text
35 development databases
5.987 creates πριν το Mayhem filter
1.118 Mayhem αποκλείστηκαν
4.869 non-Mayhem creates
2.876 valid growth mints
```
Επομένως, οι αριθμοί:
```text
4.406 creates / 2.319 valid baselines
```
και:
```text
4.869 creates / 2.876 valid mints
```
δεν είναι αντίφαση. Προέρχονται από διαφορετικά analysis runs και διαφορετικό database coverage.
Δεν πρέπει να συνδυάζονται οι απόλυτοι αριθμοί μεταξύ scripts χωρίς πρώτα να επιβεβαιώνεται το population definition.

---
# 6. Τι έδειξε η curve distribution
Στα 2.876 έγκυρα non-Mayhem mints της growth analysis:
```text
<7%:       1.976 mints
7%-<20%:     301 mints
>=20%:       599 mints
```
Αυτό έδειξε ότι:
- η πλειονότητα είναι καθαρά dead,
- η ενδιάμεση περιοχή 7%–20% είναι σχετικά μικρή,
- το 7% λειτουργεί καλά ως descriptive όριο για dead/μη-dead,
- το 20% λειτουργεί ως descriptive όριο για strong mints.
Σημαντικό:
```text
Το 7% χρησιμοποιήθηκε ως label/observation boundary.
Δεν έχει αποδειχθεί ως ιδανικό live entry price.
```

---
# 7. Direct jump πάνω από 7%
Εξετάστηκε αν τα mints περνούν σταδιακά τα επίπεδα 1%, 2%, 3%, …, 7% ή αν η confirmed curve κάνει jump.
Ο κύριος ορισμός direct jump ήταν:
```text
crossed 7%
χωρίς confirmed observation στο [6%, 7%)
```
Από τα non-Mayhem mints:
```text
900 πέρασαν το 7%
664 ήταν direct jumps με τον παραπάνω ορισμό
```
Άρα περίπου το 73,8% των crossings δεν είχε confirmed observation στο 6%–7%.
Αυτό οδήγησε σε ένα πολύ σημαντικό συμπέρασμα:
```text
Δεν μπορεί ένα live entry rule να περιμένει να δει
ακριβώς 5%, 6% ή 7%.
Η curve συχνά θα έχει ήδη πηδήξει πάνω από το επίπεδο.
```
## Πού έφτασαν τελικά τα 664 direct-jump mints
```text
7%-<20%:    214
20%-<30%:   110
30%-<40%:    80
40%-<50%:    76
50%-<75%:    85
75%-<100%:   43
>=100%:      56
```
Συνολικά:
```text
>=20%: 450 / 664 = 67,8%
>=30%: 340 / 664 = 51,2%
>=50%: 184 / 664 = 27,7%
>=100%: 56 / 664 = 8,4%
```
Άρα:
```text
Το πέρασμα του 7% είναι σημαντικό transition signal,
αλλά μόνο του δεν είναι αρκετό για BUY.
Περίπου οι μισοί direct jumpers φτάνουν 30%,
οι άλλοι μισοί όχι.
```

---
# 8. Πρώιμα χρονικά checkpoints
Δοκιμάστηκαν checkpoints από το create:
```text
250ms
500ms
1s
1,5s
2s
3s
4s
5s
```
Το γενικό μοτίβο ήταν:
- όσο περιμένουμε περισσότερο, αυξάνεται η διαχωριστική ικανότητα,
- αλλά μειώνονται γρήγορα οι διαθέσιμες opportunities,
- πολλά mints έχουν ήδη περάσει το observation limit ή έχουν αλλάξει regime.
Στο non-Mayhem development:
```text
0,25s: opportunity rate περίπου 38,0%
0,50s: opportunity rate περίπου 34,6%
1,00s: opportunity rate περίπου 25,8%
1,50s: opportunity rate περίπου 21,5%
2,00s: opportunity rate περίπου 18,3%
3,00s: opportunity rate περίπου 13,2%
```
Οι positive opportunities/ώρα ήταν υψηλότερες περίπου στα 500ms, ενώ η AUC συνέχιζε να βελτιώνεται όσο περιμέναμε.
Το πρακτικό συμπέρασμα ήταν:
```text
500ms περίπου:
καλύτερο throughput
1s περίπου:
περισσότερη confirmed πληροφορία,
αλλά λιγότερες opportunities
```

---
# 9. Το ισχυρότερο early feature
Σε όλα τα checkpoints, το πιο σταθερό feature ήταν:
```text
unique_buy_intent_wallets
```
Δηλαδή:
```text
πόσα διαφορετικά wallets έχουν εμφανιστεί
σε qualifying buy intents μέχρι το checkpoint.
```
Ενδεικτικά development medians:
```text
250ms:
positive median = 7
negative median = 4
500ms:
positive median = 9
negative median = 4
1s:
positive median = 10
negative median = 4
```
Η AUC ανέβαινε όσο αυξανόταν το observation time.
Το σημαντικό συμπέρασμα ήταν:
```text
Η ευρεία συμμετοχή διαφορετικών wallets
είναι πιο σταθερό σήμα
από τον απλό αριθμό intents ή το συνολικό quote SOL.
```

---
# 10. Πρώτοι ενδεικτικοί rules
## Rule μόνο με wallets στα 500ms
```text
unique_buy_intent_wallets >= 6
```
Development:
```text
precision περίπου 50,6%
recall περίπου 82,9%
περίπου 40 selected samples/ώρα
περίπου 20,2 positive opportunities/ώρα
```
Το rule είχε καλό throughput αλλά πολλά false positives.
## Αυστηρότερο rule στα 500ms
```text
unique_buy_intent_wallets >= 6
AND confirmed_external_buy_count >= 2
AND creator_sell_seen == false
```
Development:
```text
precision περίπου 53,2%
recall περίπου 56,9%
περίπου 13,9 positive opportunities/ώρα
```
## Rule στο 1s
```text
unique_buy_intent_wallets >= 7
AND confirmed_external_buy_count >= 2
AND buy_sell_count_ratio >= 1.2
AND creator_sell_seen == false
```
Development:
```text
precision περίπου 50,0%
recall περίπου 59,4%
περίπου 12,3 positive opportunities/ώρα
```
Αυτά ήταν αρχικά candidate rules και όχι frozen τελικός κανόνας.

---
# 11. Early intent separator στα 45ms / 100ms / 150ms
Έγινε ξεχωριστή αναζήτηση κανόνα για:
```text
dead <7%
έναντι
strong >=20%
```
με παράθυρα:
```text
45ms
100ms
150ms
```
Τα Mayhem είχαν ήδη αφαιρεθεί.
Το καλύτερο πρακτικό branch pipeline ήταν στα 100ms:
```text
Αν υπάρχει creator quote:
    creator_quote_first_sol >= 1 SOL
    AND creator_sell_intent_count == 0
Αν λείπει creator quote:
    exact_token_buy_intent_count >= 2
    AND external_buyer1_to_buyer2_gap_ms <= 45
```
Development αποτέλεσμα:
```text
dead rejection: 67,86%
strong retention: 82,14%
strong precision: 43,66%
precision lift: 1,88x
middle retention: 75,75%
```
Σύγκριση windows:
```text
45ms:
dead rejection 67,66%
strong retention 80,47%
100ms:
dead rejection 67,86%
strong retention 82,14%
150ms:
dead rejection 65,54%
strong retention 85,31%
```
Τα 150ms κρατούσαν λίγα περισσότερα strong, αλλά:
- άφηναν περισσότερα dead,
- πρόσθεταν 50ms latency.
Έτσι παγώθηκε το 100ms gate ως καλύτερος πρακτικός συμβιβασμός.

---
# 12. Creator sell analysis
Εξετάστηκε η πρώτη πραγματική confirmed πώληση του creator:
```text
first successful trade_fill sell
where user_address == creator
```
Τα sell intents καταγράφηκαν ξεχωριστά αλλά δεν θεωρήθηκαν πραγματική πώληση.
Στα 2.876 valid non-Mayhem mints:
```text
1.749 είχαν confirmed creator sell
60,8% των valid mints
```
Από αυτά:
```text
1.226 sells πριν από το 7%
206 sells μεταξύ 7% και 20%
317 sells στο 20% ή αργότερα
```
## ==Creator sell πριν από 7%==
Από τα 1.226:
```text
15,2% έφτασαν αργότερα 7%
9,9% έφτασαν αργότερα 20%
```
Άρα:
```text
confirmed creator sell πριν από 7%
είναι πολύ ισχυρό αρνητικό σήμα.
```
Δεν είναι όμως απόλυτο, επειδή περίπου 1 στα 10 έφτασε τελικά 20%.
## Creator sell μεταξύ 7% και 20%
Από τα 206:
```text
30,6% έφτασαν αργότερα 20%
```
Είναι αρνητικό σήμα, αλλά όχι αρκετά καθαρό για απόλυτο SKIP.
## Creator sell στο 20% ή αργότερα
Από τα 317:
```text
58,7% έφτασαν αργότερα 30%
```
Άρα:
```text
creator sell μετά από 20%
δεν πρέπει να προκαλεί αυτόματο exit
χωρίς να εξεταστεί το external flow.
```

---
# 13. Τι διαφοροποιεί όσα επιβιώνουν μετά από early creator sell
Για creator sell πριν από 7%, τα mints που συνέχισαν είχαν πολύ ισχυρότερο recent intent flow.
Ισχυρά features:
```text
unique_buy_intent_wallets_last_1s_before_sell
unique_buy_intent_wallets_last_500ms_before_sell
unique_buy_intent_wallets_before_sell
buy_intent_count_last_500ms_before_sell
confirmed_external_buy_count_before_sell
confirmed_external_buy_sol_before_sell
```
Για την απλούστερη περίπτωση «έφτασε αργότερα 7%»:
```text
unique wallets τελευταίου 1s:
positive median = 5
negative median = 2
AUC περίπου 0,779
unique wallets τελευταίων 500ms:
positive median = 4
negative median = 1
AUC περίπου 0,776
```
Άρα ο creator-sell κανόνας που προκύπτει είναι:
```text
Creator sell πριν από 7%
AND χαμηλό recent unique-wallet flow
=> πολύ ισχυρό SKIP
Creator sell πριν από 7%
AND πολύ ισχυρό recent wallet flow
AND confirmed external demand
=> πιθανή εξαίρεση
```
Η εξαίρεση αυτή δεν ενσωματώθηκε ακόμη στον frozen Candidate B. Ο Candidate B απαιτεί να μην έχει παρατηρηθεί creator sell πριν από entry.

---
# 14. Post-20 creator sell
Για creator sell αφού η αγορά είχε ήδη γίνει ισχυρή, το σημαντικότερο feature ήταν το πραγματικό confirmed external flow.
Ισχυρά χαρακτηριστικά:
```text
confirmed_external_net_flow_sol_before_sell
confirmed_external_buy_sol_before_sell
confirmed_external_buy_count_before_sell
unique_external_buyers_before_sell
buy_count_last_1s_before_sell
buy_sell_count_ratio_before_sell
```
Το συμπέρασμα ήταν:
```text
Μετά το 20%:
υψηλό confirmed external net flow
=> αυξημένη πιθανότητα απορρόφησης του creator sell
χαμηλό flow και απουσία recent buys
=> αυξημένη πιθανότητα ότι η κίνηση τελειώνει
```
Αυτό αφορά μελλοντικό exit/trailing logic και δεν έχει ακόμη γίνει frozen ή validation.

---
# 15. Δημιουργία ενιαίου decision flow
Με βάση τα παραπάνω, κατασκευάστηκε grid search με:
```text
wallets στα 500ms: 4, 5, 6, 7
wallets στο 1s: 5, 6, 7, 8
confirmed external buys: 1, 2, 3
buy/sell count ratio: 1.15, 1.20, 1.25, 1.30, 1.35
```
Συνολικά:
```text
240 combinations
42 πραγματικά διαφορετικά selected-mint sets
```
Το decision flow ήταν:
```text
100ms:
    frozen early gate
500ms:
    wallets >= W500
    confirmed external buys >= B
    no creator sell
    => entry
αλλιώς στο 1s:
    wallets >= W1
    confirmed external buys >= B
    buy/sell ratio >= R
    no creator sell
    => entry
```
Το development ranking επέλεγε αρχικά ως throughput optimum:
```text
W500 = 4
W1 = 6
confirmed buys = 1
ratio = 1.15
```
με:
```text
precision 52,08%
recall 75,12%
19,17 positive opportunities/ώρα
```
Ωστόσο, επιλέχθηκε σκόπιμα ο πιο αυστηρός Candidate B, επειδή είχε:
- υψηλότερη precision,
- καλύτερο Wilson lower bound,
- λιγότερα false positives,
- πιο κατάλληλη συμπεριφορά για μελλοντικό πραγματικό execution.
Το grid αξιολογούσε το future-opportunity label και όχι executable PnL.

---
# 16. Candidate B που παγώθηκε
Ο Candidate B ορίστηκε ως:
```text
100ms early gate
500ms:
    unique_buy_intent_wallets >= 6
    confirmed_external_buy_count >= 2
    creator_sell_seen == false
fallback στο 1s:
    unique_buy_intent_wallets >= 6
    confirmed_external_buy_count >= 2
    buy_sell_count_ratio >= 1.15
    creator_sell_seen == false
```
Development αποτέλεσμα:
```text
population: 1.448 mints
selected: 440
true positives: 242
false positives: 198
precision: 55,00%
recall: 55,89%
specificity: 80,49%
F1: 55,44%
entries στα 500ms: 397
entries στο 1s: 43
positive opportunities/ώρα: 14,23
median best gross return: 18,81%
median entry growth: περίπου 2,00%
```
Το 1s ratio threshold δεν έχει αποδειχθεί ισχυρό από μόνο του. Πολλά διαφορετικά ratio thresholds επέλεγαν τα ίδια mints, επειδή η μεγάλη πλειονότητα των entries γινόταν ήδη στα 500ms.

---
# 17. Frozen validation του Candidate B
Ο Candidate B εφαρμόστηκε αυτούσιος στα validation data:
- χωρίς νέο grid,
- χωρίς αλλαγή thresholds,
- χωρίς επιλογή βάσει validation αποτελεσμάτων,
- με μηδενικό mint overlap development–validation.
Validation population:
```text
999 mints
409 πέρασαν το 100ms gate
227 επιλέχθηκαν
203 entries στα 500ms
24 entries στο 1s
```
Validation metrics:
```text
baseline opportunity rate: 23,92%
precision: 56,39%
recall: 53,78%
specificity: 86,99%
F1: 55,05%
precision lift: 2,357x
Wilson precision lower 95%: 49,88%
selected/hour: 50,53
positive opportunities/hour: 28,49
```
Σύγκριση:
```text
Development precision: 55,00%
Validation precision: 56,39%
Development recall: 55,89%
Validation recall: 53,78%
```
Άρα ο classifier γενίκευσε χωρίς ουσιαστική πτώση.
Δεν έγινε validation threshold search και τα thresholds δεν πρέπει να αλλάξουν μετά την επιθεώρηση του validation.

---
# 18. Πλήρης frozen entry rule
## 18.1 Mayhem
```text
IF mint is Mayhem:
    SKIP
```
## 18.2 Early gate στα 100ms
Αξιολόγηση μία φορά στα:
```text
create_received_at + 100ms
```
### Αν υπάρχει creator quote
```text
creator_quote_first_sol >= 1.0
AND creator_sell_intent_count == 0
```
### Αν λείπει creator quote
```text
exact_token_buy_intent_count >= 2
AND external_buyer1_to_buyer2_gap_ms <= 45
```
Αν το αντίστοιχο branch αποτύχει:
```text
terminal SKIP
```
## 18.3 Απόφαση στα 500ms
Προϋποθέσεις:
```text
early gate passed
confirmed baseline available
current confirmed growth < 7%
```
BUY όταν:
```text
unique_buy_intent_wallets >= 6
AND confirmed_external_buy_count >= 2
AND creator_sell_seen == false
```
## 18.4 Fallback στο 1s
Μόνο αν δεν έγινε entry στα 500ms.
Προϋποθέσεις:
```text
confirmed baseline available
current confirmed growth < 7%
```
BUY όταν:
```text
unique_buy_intent_wallets >= 6
AND confirmed_external_buy_count >= 2
AND buy_sell_count_ratio >= 1.15
AND creator_sell_seen == false
```
Διαφορετικά:
```text
EXPIRE
```
Μετά το 1s δεν γίνεται νέα αξιολόγηση από αυτόν τον κανόνα.

---
# 19. Ακριβείς feature definitions
## `unique_buy_intent_wallets`
```text
distinct user_address
σε qualifying buy intents
ορατά μέχρι το checkpoint
```
Δεν είναι confirmed buyers.
## `confirmed_external_buy_count`
```text
πλήθος confirmed buy events
με user_address != creator
ορατά μέχρι το checkpoint
```
Είναι count events, όχι distinct wallets.
## `creator_sell_intent_count`
```text
πλήθος Deshred sell intents του creator
ορατά μέχρι τα 100ms
```
Χρησιμοποιείται μόνο στο early gate.
## `creator_sell_seen`
```text
υπάρχει confirmed successful creator sell
μέχρι το checkpoint
```
Δεν είναι το ίδιο με creator sell intent.
## `buy_sell_count_ratio`
```text
confirmed_buy_count / confirmed_sell_count
```
Στην analyzer semantics:
```text
αν confirmed_sell_count == 0:
    ratio = confirmed_buy_count
```
Δεν είναι volume ratio.
## `current_confirmed_growth_pct`
Growth της τελευταίας confirmed curve κατάστασης σε σχέση με το baseline.
Για να αναπαραχθεί ακριβώς το validated population:
```text
current_confirmed_growth_pct < 7%
```
στα checkpoints.

---
# 20. Χαρακτηριστικά που χρησιμοποιούνται στον frozen Candidate B
## Mayhem / create
```text
is_mayhem
create_received_at
creator_address
```
## Early gate
```text
creator_quote_first_sol
creator_sell_intent_count
exact_token_buy_intent_count
external_buyer1_to_buyer2_gap_ms
```
## Entry checkpoints
```text
unique_buy_intent_wallets
confirmed_external_buy_count
buy_sell_count_ratio
creator_sell_seen
confirmed_baseline_available
current_confirmed_growth_pct
```

---
# 21. Χαρακτηριστικά που αναλύθηκαν αλλά δεν μπήκαν στον Candidate B
Αναλύθηκαν, αλλά δεν επιλέχθηκαν στον frozen rule:
```text
current curve growth
maximum curve growth
curve slope 250ms / 500ms / 1s / 2s
growth acceleration
drawdown από το high
stall duration
number of new highs
curve point frequency
positive curve-step ratio
confirmed net flow
confirmed external net flow
buy/sell volume ratio
buy size mean / median / max
external buy SOL
recent buy counts
recent sell counts
unique confirmed buyers
top-buyer concentration
repeat buyers
intent count
buy-intent count
sell-intent count
intent rates
intent quote totals
intent acceleration
intent confirmation ratio
intent-to-confirmation latency
creator buy amount
creator sell amount
creator sell timing
```
Ορισμένα είναι ισχυρά για post-entry/creator-sell decisions, αλλά δεν πρόσθεσαν αρκετή αξία ή δεν ήταν διαθέσιμα αρκετά νωρίς για το entry classifier.

---
# 22. Χαρακτηριστικά που δεν έχουν εξεταστεί επαρκώς
Δεν έχει γίνει ουσιαστική αξιολόγηση στα:
```text
creator history σε προηγούμενα launches
buyer-wallet history / wallet quality
wallet clustering ή κοινή χρηματοδότηση
holder concentration
token metadata / name / symbol / URI
instruction/accounts topology
market regime
ώρα ημέρας
network congestion
priority fee regime
Jito route
πιθανότητα εκτέλεσης κάθε intent
πραγματικό buy slippage
πραγματικό sell slippage
```

---
# 23. Τι θεωρείται σήμερα ισχυρό
Μπορούν να θεωρηθούν ισχυρά και επαναλήψιμα:
```text
1. Mayhem => SKIP.
2. Το unique_buy_intent_wallets είναι
   το ισχυρότερο early feature.
3. Confirmed external buys προσθέτουν
   πραγματική επιβεβαίωση στη ζήτηση.
4. Το κύριο entry checkpoint είναι τα 500ms.
5. Το 1s είναι δευτερεύον fallback.
6. Δεν πρέπει να περιμένουμε exact observation
   στο 7%, επειδή τα direct jumps είναι συχνά.
7. Confirmed creator sell πριν από 7%
   είναι πολύ ισχυρό αρνητικό σήμα.
8. Ο Candidate B διατήρησε precision/recall
   από development σε validation.
```

---
# 24. Τι παραμένει λιγότερο σίγουρο
Δεν έχουν ακόμη αποδειχθεί:
```text
1. Ότι τα 6 wallets είναι το παγκόσμια βέλτιστο threshold.
2. Ότι τα 2 confirmed buys είναι το βέλτιστο threshold
   για πραγματικό net PnL.
3. Ότι το ratio 1.15 στο 1s έχει ανεξάρτητη αξία.
4. Ότι το 7% είναι σωστό live entry level.
5. Ότι entry πριν από 20% και exit μετά από 30%
   είναι κερδοφόρο μετά από όλα τα κόστη.
6. Ότι creator sell μετά από 20%
   πρέπει να οδηγεί σε hold αντί exit
   σε πραγματικό execution.
7. Ότι η ίδια συμπεριφορά θα παραμείνει
   σε τελικό untouched holdout.
```

---
# 25. Πολύ σημαντικός περιορισμός
Το validation απέδειξε:
```text
Ο Candidate B μπορεί να εντοπίζει
το υπάρχον future-opportunity label
με περίπου 56% precision.
```
Δεν απέδειξε:
```text
56% πραγματικό win rate
ή
θετικό καθαρό PnL.
```
Το label:
- περιλαμβάνει self-impact,
- δεν περιλαμβάνει fees,
- δεν περιλαμβάνει slippage,
- δεν περιλαμβάνει tips/priority fees,
- δεν μοντελοποιεί πλήρως entry/exit latency,
- δεν εφαρμόζει πραγματικό frozen TP/SL.
Άρα ο Candidate B είναι πλέον:
```text
validated entry classifier
```
αλλά όχι ακόμη:
```text
validated trading strategy
```

---
# 26. Ακριβές επόμενο βήμα
Το επόμενο experiment πρέπει να κρατήσει **εντελώς παγωμένο** τον Candidate B και να κάνει executable replay.
Δεν πρέπει να αλλάξουν:
```text
100ms gate
wallets >= 6
confirmed external buys >= 2
creator sell == false
500ms primary checkpoint
1s fallback
ratio >= 1.15
growth <7% eligibility
```
Πρέπει να προστεθεί:
```text
πραγματική αγορά
buy self-impact
sell self-impact
Pump.fun buy fee
Pump.fun sell fee
priority fee
Jito tip
actual/assumed slippage
entry latency
exit latency
timeout
creator-sell handling
```
Να δοκιμαστούν ξεχωριστά:
```text
buy size:
0.075 SOL
0.15 SOL
0.30 SOL
exit multipliers:
1.15
1.20
1.25
1.30
1.35
```
και πιθανές exit λογικές:
```text
fixed TP
TP + trailing
creator sell πριν από 20% => emergency exit
creator sell μετά από 20% + strong external flow => hold/trailing
timeout exit
liquidity/breakeven exit
```
Κύρια τελική μετρική:
```text
net SOL/ώρα
```
Δευτερεύουσες:
```text
net PnL/trade
trade count
win rate
max drawdown
loss distribution
TP/timeout/creator-sell exits
entry latency sensitivity
exit latency sensitivity
```

---
# 27. Βασικά scripts και outputs
## Early opportunity
```text
early opportunity prediction v2.1.0
output/early-opportunity-prediction-v2-non-mayhem/
    early-opportunity-samples.csv
    checkpoint-summary.csv
    feature-separation.csv
    top-features-by-checkpoint.csv
    data-quality.json
```
## Growth distribution
```text
development_creator_curve_growth_distribution_v3_non_mayhem.py
```
## Direct jump
```text
development_direct_jump_over_7_analysis_v1.py
development-direct-jump-over-7-summary-v1.csv
development-direct-jump-first-landing-v1.csv
development-direct-jump-final-max-v1.csv
development-direct-jump-over-7-detail-v1.csv
```
## Creator sell
```text
development_creator_sell_7_20_outcome_analysis_v1_1.py
development-creator-sell-7-20-summary-v1_1.csv
development-creator-sell-7-20-timing-v1_1.csv
development-creator-sell-feature-separation-v1_1.csv
development-creator-sell-7-20-detail-v1_1.csv
```
## Decision-flow grid
```text
development_decision_flow_grid_v1.py
development-decision-flow-grid-v1.csv
development-decision-flow-top-v1.csv
development-decision-flow-selected-mints-v1.csv
development-decision-flow-frozen-config-v1.json
development-decision-flow-report-v1.txt
```
## Candidate B validation
```text
validate_candidate_b_decision_flow_v1.py
candidate-b-validation-result-v1.csv
candidate-b-validation-selected-mints-v1.csv
candidate-b-validation-stage-summary-v1.csv
candidate-b-development-vs-validation-v1.csv
candidate-b-validation-report-v1.txt
VALIDATION_EXECUTED.json
```

---
# 28. Συνοπτική κατάσταση για συνέχιση
```text
Έχουμε έναν frozen non-Mayhem entry classifier:
100ms early gate
500ms:
    >=6 unique buy-intent wallets
    >=2 confirmed external buys
    no confirmed creator sell
fallback 1s:
    ίδια thresholds
    + buy/sell count ratio >=1.15
Το rule είχε:
development precision 55,0%
validation precision 56,39%
και:
development recall 55,89%
validation recall 53,78%
Δεν έγινε validation tuning.
Δεν υπήρχε development/validation mint overlap.
Το rule είναι validated για future-opportunity classification,
όχι για executable net PnL.
Το επόμενο βήμα είναι πλήρες cost-aware replay,
με τον Candidate B απολύτως παγωμένο.
```