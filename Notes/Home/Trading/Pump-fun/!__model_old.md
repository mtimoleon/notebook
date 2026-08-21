Το μοντέλο που καταλήξαμε να χρησιμοποιούμε είναι ουσιαστικά ένα **σύστημα supervised binary classification με πολλαπλά targets**, όχι ένα ενιαίο “AI score”.
## Τι είδους μοντέλο είναι
Για κάθε mint φτιάχνουμε ένα feature vector στο checkpoint των 30 ms:
\[ x = [x_1, x_2, ..., x_n] \]
όπου τα \(x_i\) είναι πληροφορίες από:
- bonding curve,
- timing,
- buyer/seller activity,
- creator activity,
- Deshred intents,
- concentration,
- acceleration/ρυθμό αγορών.
Πάνω σε αυτό το ίδιο feature vector έχουμε εκπαιδεύσει **ξεχωριστά binary classifiers**.
Για παράδειγμα:
\[ f_{BE}(x) \rightarrow P(BE|x) \]\[ f_{004}(x) \rightarrow P(PnL \ge 0.004|x) \]\[ f_{008}(x) \rightarrow P(PnL \ge 0.008|x) \]\[ f_{dead}(x) \rightarrow P(dead|x) \]
Άρα δεν έχουμε ένα μοντέλο που προβλέπει ακριβές PnL. Έχουμε μοντέλα που απαντούν σε συγκεκριμένα δυαδικά ερωτήματα.
Αυτό ήταν σκόπιμη επιλογή.

---
## Γιατί classification και όχι regression
Θα μπορούσαμε θεωρητικά να εκπαιδεύσουμε ένα regression model:
\[ \hat{PnL}=f(x) \]
και να πούμε «αγόρασε αν predicted PnL > 0.008».
Αυτό όμως είναι προβληματικό στα meme coins.
Η κατανομή του PnL είναι εξαιρετικά μη κανονική:
- πολλά dead/flat,
- αρκετές μεγάλες απώλειες,
- λίγοι πολύ μεγάλοι winners,
- τεράστια skewness,
- πολλά outliers.
Ένας predictor μέσης τιμής μπορεί εύκολα να επηρεάζεται υπερβολικά από λίγους τεράστιους winners.
Για παράδειγμα, δύο mints μπορεί να έχουν ίδιο expected PnL:
```
Mint A:
90% πιθανότητα +0.002
10% πιθανότητα +0.100
Mint B:
60% πιθανότητα +0.010
40% πιθανότητα -0.005
```
Το expected value μπορεί να είναι παρόμοιο, αλλά η συμπεριφορά τους είναι τελείως διαφορετική.
Τα thresholds μάς επιτρέπουν να γνωρίζουμε **τη δομή του outcome**, όχι μόνο έναν μέσο αριθμό.

---
# Τι μαθαίνει πραγματικά το classifier
Το supervised learning ξεκινά από ιστορικά παραδείγματα.
Για κάθε παλιό mint έχουμε:
```
features στα 30 ms
+
τι συνέβη μετά
```
Για το target `+0.008`, για παράδειγμα:
```
y = 1   αν το mint μπόρεσε να φτάσει net +0.008
y = 0   διαφορετικά
```
Άρα έχουμε training observations:
\[ (x_i,y_i) \]
Το μοντέλο προσπαθεί να μάθει μια συνάρτηση:
\[ P(y=1|x) \]
δηλαδή:
> «Για mints που μοιάζουν με αυτό ως προς τα χαρακτηριστικά τους στα 30 ms, πόσο συχνά αργότερα επιτεύχθηκε ο συγκεκριμένος στόχος;»
Αυτό είναι η ουσία της probability estimation.

---
# Τι σημαίνει π.χ. `P(+0.008)=0.68`
Δεν σημαίνει:
> «Αυτό το mint έχει αντικειμενικά 68% πιθανότητα να ανέβει.»
Σημαίνει περισσότερο:
> «Με βάση τα patterns που έμαθε το μοντέλο από το training population, αυτό το feature vector βρίσκεται σε περιοχή όπου τα positive examples είναι σημαντικά συχνότερα.»
Η σωστή στατιστική ερμηνεία εξαρτάται και από το πόσο καλά calibrated είναι το μοντέλο.
Αν είναι τέλεια calibrated, τότε από 100 mints στα οποία λέει:
```
P(+0.008) ≈ 70%
```
θα περιμέναμε περίπου 70 να πετύχουν το target.
Στην πράξη κανένα classification model δεν είναι τέλεια calibrated, γι' αυτό εμείς δεν στηριχθήκαμε στο ότι «65% σημαίνει ακριβώς 65 στα 100».
Χρησιμοποιήσαμε τις probabilities κυρίως ως **ranking/filtering mechanism** και μετά επαληθεύσαμε εμπειρικά τα thresholds στα validation/holdout datasets.

---
# AUC: τι μετρούσαμε
Ένα βασικό metric που χρησιμοποιήσαμε ήταν το ROC AUC.
Το AUC δεν μας λέει αν το probability `0.70` είναι ακριβώς 70%.
Μας λέει πόσο καλά το μοντέλο **ταξινομεί** positives πάνω από negatives.
Ένας πολύ χρήσιμος τρόπος να το διαβάσεις είναι:
> Αν διαλέξουμε τυχαία ένα positive και ένα negative mint, ποια είναι η πιθανότητα το μοντέλο να δώσει μεγαλύτερο score στο positive;
Παράδειγμα:
```
AUC = 0.82
```
σημαίνει περίπου 82% πιθανότητα σωστής κατάταξης ενός τυχαίου positive/negative pair.
- `0.50` = τυχαίο
- `0.60` = αδύναμο
- `0.70` = χρήσιμο
- `0.80` = αρκετά ισχυρό
- `1.00` = τέλειος διαχωρισμός
Στα δικά μας δεδομένα είχαμε περίπου `0.82` στα profit targets και πάνω από `0.93` στο dead classification.
Για τόσο πρώιμο checkpoint, αυτό είναι ουσιαστικό signal.

---
# Γιατί το dead model είναι πολύ ισχυρότερο
Αυτό έχει και θεωρητικό νόημα.
Είναι συνήθως ευκολότερο να αναγνωρίσεις:
> «Αυτό μοιάζει με mint που δεν έχει πραγματική συνέχεια»
παρά:
> «Αυτό θα φτάσει συγκεκριμένα +0.008 SOL.»
Τα dead mints έχουν συχνά πιο έντονα patterns:
- αδύναμη συμμετοχή,
- χαμηλή diversity,
- creator-heavy flow,
- sell pressure,
- απουσία νέων intents,
- πολύ αργός ρυθμός activity.
Αντίθετα, το να ξεχωρίσεις αν ένα καλό mint θα κάνει +15%, +30% ή +100% είναι πολύ πιο stochastic.
Γι' αυτό το `P(dead)` είναι εξαιρετικό ως veto/filter.

---
# Τα features δεν είναι όλα ισοδύναμα
Ένα χρήσιμο θεωρητικό distinction είναι:
### Level features
Π.χ.:
```
buyers = 5
buy SOL = 1.8
```
Αυτά λένε πόση activity υπάρχει.
### Velocity features
Π.χ.:
```
5 buys σε 20 ms
```
Αυτά λένε πόσο γρήγορα έρχεται η activity.
### Acceleration features
Π.χ.:
```
πρώτα 10 ms: 1 buy
επόμενα 10 ms: 5 buys
```
Αυτά δείχνουν αν η ζήτηση επιταχύνεται.
### Balance features
Π.χ.:
```
buy/sell ratio
```
Δείχνουν αν η δραστηριότητα είναι directional.
### Diversity features
Π.χ.:
```
unique buyers
top buyer share
```
Ξεχωρίζουν οργανικό demand από concentrated activity.
### Intent-vs-confirmed features
Αυτά ήταν ιδιαίτερα σημαντικά επειδή δημιουργούν χρονικό πλεονέκτημα.

---
# Γιατί τα intents προσθέτουν predictive signal
Θεωρητικά μπορούμε να το δούμε ως partial observation του “future order flow”.
Στο χρόνο \(t\):
\[ Confirmed_t \]
είναι ό,τι έχει ήδη ολοκληρωθεί.
Τα intents δίνουν πληροφορία για ένα υποσύνολο του:
\[ FutureFlow_{t+\Delta t} \]
Άρα το μοντέλο δεν προβλέπει το μέλλον από το μηδέν. Βλέπει ένα πρώιμο, ατελές σήμα του επερχόμενου order flow.
Γι' αυτό είχαν μεγαλύτερη αξία από πιο περίπλοκες τεχνικές smoothing.

---
# Γιατί δεν βοήθησε ιδιαίτερα το Kalman
Δοκιμάσαμε state-space/Kalman ιδέα.
Η θεωρητική λογική ήταν καλή:
\[ ObservedState_t = TrueState_t + Noise_t \]
και ο Kalman filter προσπαθεί να εκτιμήσει το latent true state.
Αυτό είναι χρήσιμο όταν:
- υπάρχουν πολλές noisy observations,
- υπάρχει συνεχής time-series εξέλιξη,
- το noise model είναι σχετικά σταθερό.
Στα πρώτα **30 ms**, όμως, έχουμε πολύ μικρή χρονική ιστορία.
Το πρόβλημα δεν ήταν τόσο:
> «έχουμε πολλά noisy δεδομένα και πρέπει να τα εξομαλύνουμε»
όσο:
> «δεν έχουμε ακόμη αρκετά confirmed δεδομένα».
Τα raw intents έλυσαν το δεύτερο πρόβλημα πολύ καλύτερα.
Γι' αυτό:
```
baseline + intents
≈
baseline + intents + Kalman
```
και επιλέξαμε την απλούστερη λύση.

---
# Γιατί δεν πήγαμε σε Hawkes process
Ένα Hawkes process είναι πολύ ενδιαφέρον για order flow.
Η intensity μπορεί να γραφτεί σχηματικά:
\[ \lambda(t)=\mu+\sum_{t_i<t}\alpha e^{-\beta(t-t_i)} \]
Δηλαδή κάθε event αυξάνει προσωρινά την πιθανότητα να συμβούν και άλλα events.
Αυτό ταιριάζει πολύ σε trading flows, όπου:
```
buy → προκαλεί buys → προκαλούν περισσότερα buys
```
Όμως για να εκτιμήσεις αξιόπιστα Hawkes intensity χρειάζεσαι επαρκή event history.
Στα 30 ms τα confirmed events ήταν πολύ λίγα.
Άρα θεωρητικά ενδιαφέρον, πρακτικά όχι καλύτερο για το συγκεκριμένο checkpoint.

---
# Bias–variance tradeoff
Ένα από τα σημαντικότερα θέματα είναι να μην κάνουμε το μοντέλο υπερβολικά σύνθετο.
Πολύ απλό model:
```
high bias
underfitting
```
Δεν καταλαβαίνει τα patterns.
Υπερβολικά περίπλοκο model:
```
high variance
overfitting
```
Μαθαίνει ιδιαιτερότητες συγκεκριμένων DBs αντί για γενικό pattern.
Στο trading το δεύτερο είναι ιδιαίτερα επικίνδυνο, γιατί ένα backtest μπορεί να φαίνεται εξαιρετικό και live να καταρρεύσει.
Γι' αυτό θεωρώ σημαντικό ότι το baseline+intents κέρδισε στο validation και μετά κράτησε τη βελτίωση και σε μεταγενέστερο holdout.

---
# Γιατί ο χρονικός διαχωρισμός είναι σημαντικός
Σε financial/time-series problems δεν θέλουμε τυχαίο:
```
random train_test_split()
```
όπου mints από την ίδια χρονική περίοδο ανακατεύονται παντού.
Θέλουμε:
```
ΠΑΛΙΟΤΕΡΑ
Training
   ↓
Validation
   ↓
Holdout
ΝΕΟΤΕΡΑ
```
Γιατί το πραγματικό production πρόβλημα είναι:
> «Εκπαιδεύτηκα στο παρελθόν. Θα λειτουργήσω στο μέλλον;»
Όχι:
> «Μπορώ να προβλέψω άλλα τυχαία samples της ίδιας περιόδου;»
Αυτό μειώνει το temporal leakage.

---
# Data leakage
Εδώ είναι ίσως ο μεγαλύτερος κίνδυνος.
Στο feature vector των 30 ms δεν επιτρέπεται να μπει οτιδήποτε έγινε μετά τα 30 ms.
Ακόμη και φαινομενικά αθώα features μπορούν να προκαλέσουν leakage.
Παράδειγμα:
```
total_unique_buyers
```
αν υπολογίζεται μέχρι το τέλος του mint αντί μέχρι τα 30 ms, τότε το μοντέλο βλέπει έμμεσα το μέλλον.
Η σωστή μορφή είναι:
```
unique_buyers_observed_by_30ms
```
Γι' αυτό είχαμε δώσει τόσο μεγάλη σημασία στα χρονικά windows.

---
# Class imbalance
Ένα άλλο πρόβλημα είναι ότι positives/negatives δεν είναι πάντα ισορροπημένα.
Παράδειγμα:
```
dead:
35% positive
65% non-dead
```
ή για πιο απαιτητικό profit target μπορεί τα positives να είναι μικρότερο ποσοστό.
Ένα classifier που λέει συνέχεια:
```
negative
```
μπορεί να έχει φαινομενικά καλή accuracy.
Γι' αυτό **δεν χρησιμοποιήσαμε accuracy ως κύριο metric**.
Προτιμήσαμε:
- AUC,
- actual selected population,
- precision-like outcome rates,
- coverage,
- τελικά οικονομικά αποτελέσματα.

---
# Classification metric ≠ trading metric
Αυτό είναι ίσως το σημαντικότερο θεωρητικό σημείο όλης της προσέγγισης.
Ένα μοντέλο με:
```
AUC 0.85
```
δεν είναι απαραίτητα καλύτερο trading system από ένα με:
```
AUC 0.81
```
Γιατί το trading utility εξαρτάται από:
\[ ExpectedPnL \]
και όχι απλώς classification correctness.
Το πραγματικό objective είναι κάτι σαν:
\[ E[PnL|selected] \times N_{selected} - execution\ risk \]
Άρα μας ενδιαφέρει ο συνδυασμός:
```
precision
×
coverage
×
payoff distribution
```

---
# Γιατί δεν ανεβάζουμε απλά τα thresholds στο 90%
Για παράδειγμα θα μπορούσαμε να απαιτήσουμε:
```
P(BE) > 90%
P(+0.008) > 85%
P(dead) < 1%
```
Πιθανόν τα trades που μένουν να είναι πολύ καλά.
Αλλά ίσως μείνουν:
```
5 trades / ημέρα
```
αντί για:
```
100
```
και το συνολικό expected PnL να γίνει μικρότερο.
Αυτό είναι το precision–coverage tradeoff.
Η δουλειά του validation ήταν να βρούμε όχι το «πιο ασφαλές mint», αλλά ένα **χρήσιμο operating point**.

---
# Γιατί οι πιθανότητες δεν πρέπει να ξαναρυθμίζονται συνεχώς
Αν μετά από κάθε νέο DB κάνουμε:
```
«αυτό δεν πήγε καλά → ας αλλάξω 65 σε 62»
```
τότε κάνουμε implicit overfitting.
Ο σωστός κύκλος είναι:
```
Freeze model
Freeze thresholds
↓
Shadow collection
↓
αρκετό νέο sample
↓
Evaluation
↓
αν υπάρχει λόγος:
retrain / recalibrate / νέο version
```
Όχι συνεχής χειροκίνητη προσαρμογή.

---
# Concept drift
Υπάρχει όμως και το αντίθετο πρόβλημα.
Το Pump.fun ecosystem μπορεί να αλλάξει:
- bots,
- fees,
- block capacity,
- creator behavior,
- order flow,
- transaction propagation,
- participant mix.
Άρα:
\[ P_{train}(X,Y) \]
μπορεί μετά από μήνες να διαφέρει από:
\[ P_{live}(X,Y) \]
Αυτό λέγεται **concept/data drift**.
Γι' αυτό στο shadow θα πρέπει μελλοντικά να παρακολουθούμε:
- distribution των probabilities,
- pass rate,
- dead rate μετά το filter,
- realized target rate,
- feature distributions.
Αν αλλάζουν σημαντικά, ίσως χρειάζεται retraining.

---
# Το ιδανικό production interpretation
Δεν θα έβλεπα το model ως:
> «AI που αποφασίζει trades».
Πιο σωστά είναι:
> **Early-stage probabilistic risk filter πάνω σε ένα εξαιρετικά θορυβώδες universe.**
Το raw universe είναι πολύ κακής ποιότητας.
Το μοντέλο κάνει:
\[ Universe \rightarrow HigherQualitySubset \]
και μετά το execution/exit system αναλαμβάνει.
Αυτό είναι και ο λόγος που θεωρώ τη συγκεκριμένη αρχιτεκτονική πιο ασφαλή από το να εκπαιδεύσουμε ένα end-to-end μοντέλο που αποφασίζει Buy/Sell από μόνο του.
Η βασική υπόθεση που πλέον πρέπει να ελεγχθεί στο shadow είναι αν:
\[ P(Y|X)_{historical} \approx P(Y|X)_{live} \]
δηλαδή αν η σχέση που μάθαμε από τα raw historical DBs εξακολουθεί να ισχύει σε πραγματικό, μελλοντικό order flow. Αυτό είναι ουσιαστικά το τελευταίο μεγάλο validation πριν αποκτήσει νόημα ένα live canary.