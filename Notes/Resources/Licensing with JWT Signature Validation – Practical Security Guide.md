---
categories:
  - "[[Resources]]"
created: 2026-03-19
url:
tags:
  - topic/license
  - tech/jwt
  - topic/how-to
---
## Notes

#### 1. Core Concept
A JWT has three parts:
```
header.payload.signature
```
- The **signature is created using the issuer’s private key**.
- The **client verifies it using the corresponding public key**.
With RSA (e.g. RS256):
```
signature = Sign(hash(header.payload), privateKey)
```
Verification:
```
isValid = Verify(hash(header.payload), signature, publicKey)
```
Key point:
- The signature protects **both header and payload**.
- Any modification → invalid signature.

---
#### 2. What This Model Guarantees
This approach ensures:
1. **Authenticity**
    - Only the holder of the private key can issue valid tokens.
2. **Integrity**
    - Payload cannot be modified without breaking the signature.
3. **Offline validation**
    - No need to call a server; verification is local.

---
#### 3. What It Does NOT Guarantee
This model does NOT protect against:
1. **Token reuse / sharing**
    - A valid token can be copied and reused.
2. **Client-side tampering**
    - If the binary is patched, validation can be bypassed.
3. **Revocation**
    - No way to invalidate already-issued tokens without server involvement.
4. **Expiration enforcement**
    - Only enforced if explicitly validated.

---
#### 4. Critical Security Rule

> The JWT header is **untrusted input** until the signature is verified.

Never allow the token to dictate how it should be validated.

---
#### 5. Known Attack Classes
##### 5.1 `alg = none` attack
Malicious token:
```json
{
  "alg": "none"
}
```
- No signature.
- Some broken implementations skip verification.
Impact:
- Attacker can forge arbitrary claims.
Mitigation:
- Always require a valid signature.
- Never accept unsigned tokens.

---
##### 5.2 Algorithm Confusion (RS256 ↔ HS256)
Attack flow:
1. System expects **RS256** (asymmetric).
2. Attacker changes header to:
```json
{
  "alg": "HS256"
}
```
3. Uses the **public key as HMAC secret**.
4. Signs token with HS256.
5. Broken validator accepts it.
Impact:
- Public key becomes a signing secret.
- Full forgery possible.
Mitigation:
- Do not switch algorithms based on token header.
- Enforce expected algorithm and key type.

---
#### 6. Secure Validation Principles
A correct validator must:
1. **Enforce allowed algorithms explicitly**
    - e.g. only RS256
2. **Bind algorithm to key type**
    - RSA key → only RSA algorithms
3. **Reject unsigned tokens**
    - never allow `alg=none`
4. **Ignore token-provided algorithm for policy decisions**
    - header is not trusted before verification
5. **Use strong, typed key objects**
    - e.g. `RsaSecurityKey`, not raw strings
6. **Fail closed**
    - any mismatch → reject

---
#### 7. Correct Mental Model
Wrong:
> “Read `alg` from token and adapt validation accordingly.”

Correct:
> “I define the validation rules. The token must conform or be rejected.”

---
#### 8. Practical Notes for Your Code
Good:
- Uses `RsaSecurityKey`
- Uses a standard library (`JsonWebTokenHandler`)
- Does not implement custom crypto
Risk areas:
1. `ValidateLifetime = false`
    - Expired tokens remain valid.
2. Silent failure (returning empty claims)
    - May hide validation issues.

---
#### 9. Summary
- JWT security relies on **private key secrecy** and **correct verification logic**.
- The signature guarantees **authenticity and integrity**, not full license control.
- The most common failures come from:
    - trusting the token header,
    - allowing algorithm switching,
    - accepting unsigned tokens.
If validation is strict and deterministic, the model is cryptographically sound.

For further info and examples check:
[[JWT Issuance And Validation Guide]]