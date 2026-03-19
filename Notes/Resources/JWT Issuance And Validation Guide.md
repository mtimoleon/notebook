---
categories:
  - "[[Resources]]"
created: 2026-03-19
url:
tags:
  - topic/license
  - tech/jwt
  - topic/code
  - topic/how-to
  - topic/authentication
---

## Purpose
​
This document defines a practical and secure baseline for teams that issue and validate JWT tokens they control.
​
It covers:
​
1. how to issue JWTs,
2. how to validate them,
3. which security rules must stay fixed,
4. which JWT pitfalls must be avoided.
​
The central rule is:
​
**The validator must never trust the token to decide how verification should work.**
​
The token is untrusted input until validation succeeds.
​

---
​
## When JWT Is Appropriate
​
JWT is a good fit when you need:
​
- signed claims passed between systems,
- stateless verification,
- offline or semi-offline verification,
- a standard format for issuer, audience, expiration, and custom claims.
​
JWT does not solve by itself:
​
- revocation,
- session invalidation,
- anti-replay,
- permission changes after issuance,
- key compromise.
​
If you need immediate revoke behavior or highly dynamic permissions, you usually need server-side state in addition to JWT.
​

---
​
## Trust Model
​
There are two common models.
​
### 1. Symmetric signing
​
- Algorithm: `HS256`
- The same secret is used for signing and verification
​
Use this only when issuer and validator are in the same trust boundary.
​
It is usually a poor fit when:
​
- tokens are verified by clients,
- many services should verify but not sign,
- you do not want verification material to become signing material.
​
### 2. Asymmetric signing
​
- Algorithms: `RS256`, `ES256`, `EdDSA`
- The issuer signs with a private key
- Validators verify with a public key
​
This is the preferred model for most distributed systems and issued tokens that cross trust boundaries.
​
For broad compatibility, `RS256` is often the most practical baseline.
​

---
​
## Recommended Baseline Policy
​
For tokens your platform issues, the default policy should be:
​
1. Use asymmetric signing.
2. Choose one allowed algorithm and keep it fixed.
3. Sign only with a private key that never leaves the issuer.
4. Verify only with trusted public keys.
5. Require `iss`, `aud`, and `exp`.
6. Use short expirations where practical.
7. Include `kid` in the header for key rotation.
8. Do not place secrets in the payload.
9. Do not treat claims as authorization truth without explicit policy mapping.
10. Log validation failures without leaking sensitive internals.
​

---
​
## Token Structure
​
A JWT has the form:
​
```text
header.payload.signature
```
​
### Header
​
Typical example:
​
```json
{
  "alg": "RS256",
  "typ": "JWT",
  "kid": "key-2026-01"
}
```
​
### Payload
​
Example:
​
```json
{
  "iss": "https://issuer.example.com",
  "aud": "gantt-api",
  "sub": "customer-123",
  "jti": "d6c9ef5c-f0c7-49fb-9db7-398f0d9ac6cb",
  "iat": 1773916800,
  "nbf": 1773916800,
  "exp": 1773920400,
  "scope": ["read:gantt", "write:gantt"],
  "tenantId": "tenant-01"
}
```
​
### Signature
​
The signature is **produced from the header and payload** using the allowed algorithm and the signing key.
​

---
​
## Claims Policy
​
### Required claims
​
Most issued tokens should include:
​
- `iss`: who issued the token
- `aud`: which system the token is for
- `sub`: who or what the token represents
- `exp`: when the token expires
- `iat`: when the token was issued
- `jti`: a unique token identifier
​
### Optional but useful claims
​
- `nbf`
- `scope` or `roles`
- `tenantId`
- `clientId`
- `ver` for schema versioning
​
### Rules
​
- `sub` should be a stable identifier, not a display name.
- `aud` should match the intended consumer exactly.
- `exp` should not be arbitrarily far in the future.
- `jti` helps with revocation and replay protection.
- Claims should stay minimal.
​

---
​
## Issuance Rules
​
When issuing a JWT:
​
1. The issuer decides outside the token:
   - algorithm,
   - signing key,
   - issuer value,
   - audience policy,
   - token lifetime,
   - claim schema.
2. The payload contains only necessary claims.
3. The header includes `alg`, `typ`, and usually `kid`.
4. The token is signed.
5. Nothing modifies payload semantics after signing.
​
### Do not do this
​
- switch algorithms dynamically without policy,
- reuse the same key material for both HMAC and RSA modes,
- use unnecessarily long token lifetimes,
- embed secrets, passwords, hashes, or private internal data in the payload.
​

---
​
## Validation Rules
​
The validator must enforce its own policy before accepting a token as valid.
​
### Validation checklist
​
1. Require a signature.
2. Reject unsigned tokens.
3. Reject `alg=none`.
4. Allow only a specific algorithm or algorithm set.
5. Use only the expected key type.
6. Resolve keys in a controlled way, usually through `kid`.
7. Validate `iss`.
8. Validate `aud`.
9. Validate `exp`.
10. Validate `nbf` if present and required.
11. Use a small clock skew tolerance.
12. If needed, validate `jti` against replay or revocation state.
​
### Golden rule
​
**The header does not define the security policy.**
​
The header may help with trusted key lookup. It must not change the verification strategy.
​

---
​
## Critical JWT Pitfalls
​
### 1. `alg=none`
​
Bad implementation:
​
1. reads the header,
2. sees `alg=none`,
3. skips signature verification,
4. accepts a forged token.
​
Correct implementation:
​
- requires a signature,
- never allows unsigned acceptance.
​
### 2. Algorithm confusion
​
Classic example:
​
1. the system expects `RS256`,
2. an attacker changes the header to `HS256`,
3. a buggy validator uses the RSA public key as an HMAC secret,
4. a forged token becomes valid.
​
Correct implementation:
​
- the validator knows in advance which algorithm and key type are allowed,
- it does not fall back,
- it does not reinterpret key material across crypto modes.
​
### 3. Trusting claims without audience isolation
​
A valid token for another API must not be accepted by your service.
​
Fix:
​
- strict audience validation.
​
### 4. Ignoring expiration
​
If `exp` is not enforced, the token effectively becomes a long-lived bearer credential.
​
Fix:
​
- `ValidateLifetime = true`
- a small, documented clock skew
​
### 5. No revocation model
​
A valid token may stay usable until expiration.
​
If that is not acceptable, add:
​
- a revoke list by `jti`,
- short-lived access tokens,
- refresh token rotation,
- introspection or online status checks.
​

---
​
## Key Management
​
### Principles
​
- The private key lives only on the issuer.
- Public keys are distributed to validators.
- Every key should have an identifier with `kid`.
- Rotation must be supported without downtime.
​
### Rotation strategy
​
1. Generate a new key pair.
2. Publish the new public key.
3. Start issuing new tokens with the new `kid`.
4. Keep the old public key available until old tokens expire.
5. Remove the old key only after the safe overlap window ends.
​
### Do not do this
​
- hardcode private keys in client apps,
- commit private keys to source control,
- reuse one signing key forever,
- reuse the same signing key across all environments.
​

---
​
## Lifetime Strategy
​
Token lifetime must match the use case.
​
Examples:
​
- Access token: minutes to a few hours
- Service token: as short as practical
- Offline license token: potentially longer, but then revocation becomes harder
​
If a token has a long lifetime:
​
- treat key rotation more carefully,
- consider versioned claims,
- consider additional online checks,
- do not pretend immediate revoke exists if it does not.
​

---
​
## Authorization Guidance
​
A valid token is not the same thing as an authorized action.
​
The correct separation is:
​
1. Authentication:
   - is the token valid?
   - who is the subject?
2. Authorization:
   - what is this subject allowed to do on this resource?
​
Do not build authorization on loosely defined custom claims without explicit policy mapping.
​
Prefer:
​
- `scope` for capability-based access,
- `roles` only where a stable role model exists,
- resource-level checks in the application layer.
​

---
​
## Logging And Error Handling
​
During validation:
​
- log the category of failure,
- avoid logging the full token unless there is a strong reason,
- do not return detailed internal failure reasons to attackers,
- monitor validation failures for anomaly detection.
​
Useful validation failure categories:
​
- invalid signature
- unknown `kid`
- invalid issuer
- invalid audience
- expired token
- token not active yet
- revoked `jti`
​

---
​
## Reference Issuance Flow
​
```text
1. Build claims from trusted server-side data
2. Set iss, aud, sub, iat, nbf, exp, jti
3. Choose fixed alg and signing key
4. Set kid
5. Sign token
6. Return token to caller over TLS
```
​

---
​
## Reference Validation Flow
​
```text
1. Parse token
2. Reject malformed input
3. Load trusted verification keys
4. Enforce allowed algorithm
5. Verify signature with the expected key type
6. Validate issuer and audience
7. Validate exp and nbf
8. Validate jti or revocation state if required
9. Map claims to application identity
10. Run authorization checks
```
​

---
​
## C# Example
​
Issuance with `RS256`:
​
```csharp
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
​
var credentials = new SigningCredentials(privateKey, SecurityAlgorithms.RsaSha256);
​
var token = new JwtSecurityToken(
    issuer: "https://issuer.example.com",
    audience: "gantt-api",
    claims: new[]
    {
        new Claim(JwtRegisteredClaimNames.Sub, "customer-123"),
        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
        new Claim("tenantId", "tenant-01"),
        new Claim("scope", "read:gantt")
    },
    notBefore: DateTime.UtcNow,
    expires: DateTime.UtcNow.AddMinutes(30),
    signingCredentials: credentials
);
​
token.Header["kid"] = "key-2026-01";
​
var jwt = new JwtSecurityTokenHandler().WriteToken(token);
```
​
Validation:
​
```csharp
using Microsoft.IdentityModel.Tokens;
​
var parameters = new TokenValidationParameters
{
    ValidateIssuerSigningKey = true,
    IssuerSigningKey = publicKey,
    ValidateIssuer = true,
    ValidIssuer = "https://issuer.example.com",
    ValidateAudience = true,
    ValidAudience = "gantt-api",
    ValidateLifetime = true,
    ClockSkew = TimeSpan.FromMinutes(2),
    RequireSignedTokens = true
};
​
var handler = new JwtSecurityTokenHandler();
var principal = handler.ValidateToken(jwt, parameters, out _);
```
​
Important note:
​
- Do not set `ValidateLifetime = false` unless there is a documented business reason.
- If you do, you are explicitly accepting expired tokens.
​

---
​
## Node.js Example
​
Issuance with `jsonwebtoken` and RSA keys:
​
```js
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
​
const token = jwt.sign(
  {
    sub: "customer-123",
    tenantId: "tenant-01",
    scope: ["read:gantt"]
  },
  privateKeyPem,
  {
    algorithm: "RS256",
    issuer: "https://issuer.example.com",
    audience: "gantt-api",
    keyid: "key-2026-01",
    expiresIn: "30m",
    notBefore: 0,
    jwtid: crypto.randomUUID()
  }
);
```
​
Validation:
​
```js
const payload = jwt.verify(token, publicKeyPem, {
  algorithms: ["RS256"],
  issuer: "https://issuer.example.com",
  audience: "gantt-api",
  clockTolerance: 120
});
```
​
The critical line is:
​
```js
algorithms: ["RS256"]
```
​
This prevents the validator from blindly following whatever the token header declares.
​

---
​
## Testing Checklist
​
Every issuer and validator implementation should be tested with:
​
1. a valid token
2. a token with an invalid signature
3. a token with the wrong `iss`
4. a token with the wrong `aud`
5. an expired token
6. a token with a future `nbf`
7. a token with an unknown `kid`
8. a token using `alg=none`
9. a token using a different algorithm than allowed
10. a malformed token
11. a revoked `jti`, if revocation exists
​
If any of these passes when it should fail, that is a security bug.
​

---
​
## Operational Checklist
​
Before production:
​
1. Allowed algorithms are fixed and documented.
2. Keys are separated by environment.
3. `kid` and rotation process are documented.
4. `iss`, `aud`, and `exp` are validated.
5. The need for `nbf` and `jti` has been decided explicitly.
6. The need for revocation has been decided explicitly.
7. Private keys are never shipped in client-distributed code.
8. Negative-path security tests exist.
9. Validation failures are monitored.
10. Authorization claims are mapped to application policy.
​

---
​
## Practical Conclusion
​
A secure JWT system that issues its own tokens depends on a few invariants:
​
1. The issuer enforces a fixed signing policy.
2. The validator enforces a fixed verification policy.
3. The token does not decide how it will be verified.
4. A valid signature is not enough without issuer, audience, and lifetime validation.
5. If you need revoke or anti-replay, you need more than the JWT format itself.
​
If these invariants hold, JWT remains a useful transport and identity format instead of turning into a source of security regressions.
​