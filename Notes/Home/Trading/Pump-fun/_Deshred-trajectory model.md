## Roadmap μοντελοποίησης τροχιάς curve
1. **CF17 – Export trajectories**
    - Για κάθε mint: curve από `create` έως `2s`.
    - Κοινό grid π.χ. ανά `25ms`.
    - Κύρια σειρά: `ΔRealSOL`.
2. **CF18 – Trajectory clustering**
    - `tslearn + DTW`.
    - Δοκιμή π.χ. `5, 8, 10` clusters.
    - Χωρίς predictor ακόμα.
3. **CF19 – Οικονομικός έλεγχος clusters**
    ​
    Για κάθε cluster:
    - αριθμός mint,
    - % που φτάνει `+1.3`,
    - max gain / drawdown,
    - WR / PnL / PF,
    - BUY στα `100/150/200/300ms`.
4. **Decision point**
    - Αν τα clusters δεν έχουν καθαρές οικονομικές διαφορές → σταματάμε.
    - Αν υπάρχουν «καλές» και «κακές» τροχιές → συνεχίζουμε.
5. **CF20 – Early trajectory prediction**
    - Features μόνο μέχρι `100/150/200/300ms`.
    - XGBoost/CatBoost προβλέπει σε ποιο trajectory cluster πάει το mint.
6. **CF21 – Execution replay**
    - `BUY NOW / WAIT 1 slot / WAIT 2 slots / SKIP`.
    - Πραγματικό N+1 execution και πραγματικό slippage.
7. **CF22 – Optimize policy**
    - Επιλογή καλύτερου decision time.
    - Thresholds ανά cluster/probability.
    - Σύγκριση με Shadow και τα προηγούμενα CF αποτελέσματα.
Το κρίσιμο πρώτο checkpoint είναι το **CF18–CF19**. Αν εκεί δεν δούμε καθαρό διαχωρισμό τροχιών σε profitable και bad patterns, δεν αξίζει να πάμε σε πιο σύνθετα μοντέλα.