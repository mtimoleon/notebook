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

### A. General concept
#### 1. Core Concept
A JWT has three parts:
```id="7gd3re"
header.payload.signature
```
- The **signature is created using the issuer’s private key**.
- The **client verifies it using the corresponding public key**.
With RSA (e.g. RS256):
```id="1u9opt"
signature = Sign(hash(header.payload), privateKey)
```
Verification:
```id="ly275z"
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

---
### B. Keycloak Offline Validation (JWKS-based)
#### 1. Core Model
With Keycloak:
1. Tokens are **signed JWTs (JWS)** issued by the realm.
2. Your API does **local validation** using public keys.
3. Public keys are retrieved from the realm JWKS endpoint:
```
/realms/{realm}/protocol/openid-connect/certs
```
This follows the same principle:
- private key (Keycloak) → sign
- public key (API) → verify

---
#### 2. Validation Flow
Typical offline validation flow:
1. Fetch JWKS (public keys) from Keycloak.
2. Cache keys locally.
3. For each incoming token:
    - read `kid` from header
    - select matching key
    - verify signature
    - validate:
        - issuer (`iss`)
        - audience (`aud`)
        - expiration (`exp`)
        - optionally `nbf`

---
#### 3. Key Rotation Handling
Keycloak may expose **multiple active keys**.
Correct handling:
1. Match token `kid` → correct key
2. If `kid` not found:
    - refresh JWKS immediately
3. Periodically refresh JWKS (e.g. every few hours)
4. Keep old keys for overlap window

---
#### 4. Offline vs Online Validation
Two distinct models:
1. **Offline (local) validation**
    - signature + claims
    - no network call per request
    - fast, scalable
2. **Online validation (introspection)**
    - call Keycloak endpoint
    - checks token “active” state
    - slower, but aware of revocation
Do not confuse them.

---
#### 5. Limitations of Offline Validation
Offline validation does NOT detect:
1. Logout / session termination
2. Token revocation
3. Disabled users / clients
4. Immediate policy changes
Mitigation strategies:
5. Short token lifetime
6. Hybrid model (offline + occasional introspection)
7. Refresh tokens instead of long-lived access tokens

---
#### 6. Token Type Considerations
Keycloak may issue different token variants.
Important:
- Ensure you receive **full JWT access tokens with required claims**
- Lightweight tokens may require introspection instead of local validation

---
#### 7. Security Requirements
For secure Keycloak offline validation:
1. Enforce issuer (`iss`)
2. Enforce audience (`aud`)
3. Validate lifetime (`exp`, `nbf`)
4. Verify signature using JWKS
5. Enforce allowed algorithms (e.g. RS256)
6. Do not trust token header before verification

---
#### 8. When to Use This Approach
Appropriate when:
1. High performance required
2. Low latency APIs
3. Reduced dependency on IdP availability
4. Standard resource-server architecture
Not sufficient when:
5. Real-time revocation is required
6. Strong session control is needed
7. Security policy changes must apply immediately

---
#### 9. Summary
- Keycloak offline validation is a **standard JWS verification flow using JWKS**.
- It is cryptographically sound and widely used.
- Its main trade-off is lack of real-time state awareness.
- Proper key management and strict validation rules are essential.

---

For further info and examples check:
[[JWT Issuance And Validation Guide]]