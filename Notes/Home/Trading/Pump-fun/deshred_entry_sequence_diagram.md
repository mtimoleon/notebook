---
categories:
  - "[[Home]]"
created: 2026-07-22
domain: []
tags:
  - tech/tokens
  - topic/trading
  - topic/pump-fun
---

## Notes# Deshred transaction-batch entry sequence

```mermaid
sequenceDiagram
    autonumber
    participant T as Triton Deshred
    participant S as Deshred stream
    participant D as Decoder
    participant A as App
    participant C as Candidate state
    participant E as Entry evaluator
    participant X as Executor
    participant B as Jito / Triton RPC
    participant Y as Yellowstone

    T->>S: Deshred transaction update
    S->>D: Raw versioned transaction
    D->>D: Resolve accounts and decode all Pump instructions in original order
    D-->>A: []MarketEvent for one signature
    A->>A: Persist/cache every decoded event
    A->>C: OnTransaction(events)

    C->>C: Deduplicate transaction signature
    loop Every decoded instruction
        alt create/create_v2
            C->>C: Create candidate and store create signature + instruction index
        else buy/buy_v2 and buyer == creator
            alt Same signature, after create, and no initial creator buy recorded
                C->>C: Record the initial creator buy
                C->>C: Quote amount/source once
            else Later or unrelated creator buy
                C->>C: Ignore for entry counts
            end
        else buy/buy_v2 and buyer != creator
            C->>C: ExternalBuyIntents++
            Note right of C: Same wallet and same transaction may count multiple times
        else sell/sell_v2
            C->>C: Update sell/dev-sell and predicted-flow state
        end
        C->>C: Apply event to predicted curve/state
    end

    C->>E: Evaluate candidate once after the complete transaction
    alt external_buys enabled and count > max
        E-->>A: REJECT external_buy_limit_exceeded
    else external_buys enabled and count < min
        E-->>A: WAIT for another transaction or expiry
    else initial_buy enabled and initial creator buy missing/pending
        E-->>A: WAIT for another transaction or expiry
    else initial creator buy/source/range invalid
        E-->>A: REJECT with creator-specific reason
    else All active entry filters pass
        E-->>A: ACCEPT
        alt shadow mode
            A->>X: Open virtual position
        else live mode
            A->>X: Queue buy
            Note right of X: Do not re-run initial_buy or external_buys
            X->>X: Deadline, fresh curve/blockhash, quote/slippage, build, optional simulation
            X->>B: Submit the same signed transaction
            Y-->>X: Authoritative transaction confirmation/reconciliation
        end
    end

    opt Candidate remains WAIT
        Y-->>E: Slot progress
        alt Entry window expired
            E-->>A: REJECT deterministic expiry reason
        else Window still open
            E-->>A: Continue waiting
        end
    end
```

## Classification rules

- `initial creator buy`: the first creator `buy/buy_v2` instruction after `create` in the same transaction signature.
- `external buy intent`: every decoded `buy/buy_v2` instruction where `buyer != creator`.
- Later creator buys never count as external and do not alter the initial creator amount.
- Transaction replay is deduplicated by signature; buy/sell events are also deduplicated by signature and instruction index.
- Deshred observations are predictive intents, not proof that the transaction landed.
