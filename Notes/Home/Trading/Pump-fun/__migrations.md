
Migration:
1. Γράψε το token στο `secrets/triton-token`.
2. Βάλε το keypair στο `secrets/devnet-keypair.json`.
3. Αφαίρεσε token/keypair variables από `.env`.
4. Σε Unix: `chmod 700 secrets && chmod 600 secrets/*`.

Για το keypair για το wallet πρέπει να το κάνω σε wsl με το solana cli.
Εχει python tool μέσα στο ultra-early/tools