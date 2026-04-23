---
title: Keycloak Sessions
categories:
  - "[[Resources]]"
created: 2026-04-23
published: 2026-02-03
source: https://medium.com/@torinks/keycloak-sessions-67c118107263
author:
  - "[[Torin]]"
description: Keycloak sessions management guide
tags:
  - documentation/keycloak
  - tech/sessions
  - type/Guide
---
When you log into an application protected by Keycloak, it doesn’t just verify your credentials and forget about you — it creates a network of session objects that track who you are, which applications you’ve accessed, and how long you’ve been active. Understanding these sessions is important for anyone building secure applications or troubleshooting authentication issues.

This guide covers Keycloak’s session management — from the temporary authentication sessions created during login, to the long-lived offline sessions that enable mobile apps to work without constant re-authentication. We’ll examine the source code, understand the data structures, and see how all these pieces fit together to provide single sign-on across your applications.

## Session Types Overview

Before looking at the details, let’s establish a mental model of how Keycloak organizes sessions. Think of it as a hierarchy: when you start logging in, Keycloak creates temporary **Authentication Sessions** to track your progress through the login flow. Once you successfully authenticate, these transform into a **User Session** that represents your overall login to Keycloak. Then, as you access different applications, each one gets its own **Client Session** attached to your user session.

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*85qdwLUhhWSjm5s3.png)

This hierarchy is the foundation of Keycloak’s single sign-on (SSO) capability. Because your user session is separate from individual client sessions, you only need to authenticate once — Keycloak then creates client sessions automatically as you access different applications. Let’s explore each type in detail.

## User Session

The User Session is the heart of Keycloak’s authentication model. It represents your overall login to Keycloak itself (the Identity Provider), not to any specific application. When you enter your credentials and successfully authenticate, Keycloak creates exactly one user session for your browser.

**Key characteristics:**

- One per browser login — Created when user authenticates to Keycloak
- Contains user identity (`userId`, `loginUsername`)
- Login metadata (`ipAddress`, `authMethod`, `rememberMe`)
- Timestamps (`started`, `lastSessionRefresh`)
- Session state (`LOGGED_IN`, `LOGGING_OUT`, `LOGGED_OUT`, `LOGGED_OUT_UNCONFIRMED`)
- Broker info for federated identity (`brokerSessionId`, `brokerUserId`)
- Parent container — holds references to all client sessions

**Source files:**

- `UserSessionModel.java` – Main interface
- `UserSessionProvider.java` – Session provider interface

## Client Session

While the user session tracks who you are, client sessions track which applications you’ve accessed. Every time you visit a new application protected by Keycloak, a new client session is created and attached to your existing user session. This is what enables the “single” in single sign-on — the user session proves you’re authenticated, so Keycloak can issue tokens for new applications without asking for credentials again.

**Key characteristics:**

- One per application — Created when user accesses a specific client/app
- Which client (`clientId`)
- Protocol-specific data (`redirectUri`, `action`)
- Token metadata (refresh token reuse tracking)
- Client-specific notes and timestamps
- Child of user session — always attached to a parent user session

**Source files:**

- `AuthenticatedClientSessionModel.java` – Client session interface

## Authentication Sessions

Before we have a user session, we have authentication sessions. These are temporary, **transient sessions** that exist only during the login process. They track your progress through potentially complex authentication flows — maybe you’ve entered your password but still need to complete MFA, or you’re halfway through a social login redirect.

Keycloak handles multiple browser tabs by giving each tab its own authentication session (identified by a “tab ID”), but they all share a common “root” authentication session tied to your browser. This prevents confusion when you have the login page open in multiple tabs.

- Temporary sessions during the login flow (before authentication completes)
- Has a `RootAuthenticationSessionModel` parent representing the browser
- Uses tab IDs to handle multi-tab browsing
- Cleared after successful login
![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*EjV08CeGGVhWOdZd.png)

**Source files:**

- `AuthenticationSessionModel.java` – Auth session interface
- `RootAuthenticationSessionModel.java` – Root auth session

## Offline Sessions

So far, we’ve discussed sessions that live for hours — maybe a workday. But what about mobile apps that need to stay logged in for weeks? Or background services that refresh data overnight? That’s where offline sessions come in.

When a client requests the `offline_access` scope, Keycloak creates a parallel set of sessions with much longer lifespans. These offline sessions survive regular logout and can last for days or weeks. They’re stored persistently in the database, ensuring they survive server restarts.

- Created when offline tokens are requested (`offline_access` scope)
- Have longer lifespans than online sessions
- Linked to online sessions via `CORRESPONDING_SESSION_ID` note
![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*61urggiuob7-LUEo.png)

**Source files:**

- `OfflineUserSessionModel.java` – Offline session interface

## Storage Architecture

Now that we understand what sessions exist, let’s look at where they’re stored. Keycloak uses a two-tier architecture: a fast distributed cache (Infinispan) for active sessions, and a persistent database for durability.

The Infinispan configuration is a long story that needs a separate article, but for now, don’t forget to **enable sticky sessions** on your reverse proxy in front of Keycloak to minimize latency when working with Keycloak.

Frequently accessed sessions are kept in the cache, while the complete set is stored in the database. When a session is needed, Keycloak first checks the cache and only queries the database if necessary.

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*_75KIJ_hUPI1bz3R.png)

## Infinispan Cache (Primary/Hot Storage)

Infinispan serves as the primary storage for active sessions. It’s a distributed cache, meaning session data is replicated across Keycloak nodes in a cluster. This provides both speed (no database roundtrip for most operations) and resilience (if one node fails, sessions aren’t lost).

**Cache names** (defined in `InfinispanConnectionProvider.java`):

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*9JZBGRgv8ec6N23gWqzdqw.png)

**Source files:**

- `InfinispanConnectionProvider.java` – Cache configuration
- `InfinispanUserSessionProvider.java` – Session provider implementation

## JPA Database (Persistent Storage)

While Infinispan handles the hot path, the database provides durability. Offline sessions are always persisted, and online sessions can be persisted too for recovery after restarts. The database schema stores sessions as JSON blobs, allowing flexible storage of session notes and metadata.

**Source files:**

- `JpaUserSessionPersisterProvider.java` – JPA persistence provider
- `PersistentUserSessionEntity.java` – User session entity
- `PersistentClientSessionEntity.java` – Client session entity

## Realm Session Settings

Keycloak provides fine-grained control over session lifetimes through realm-level settings. These settings form a hierarchy where client-specific settings can override realm defaults, and “remember me” sessions can have different timeouts than regular ones.

## Timeout Hierarchy

Understanding this hierarchy is essential for configuring session behavior correctly. Client session timeouts fall back to SSO session timeouts if not explicitly set, and remember-me sessions have their own separate configuration:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*xjYIUnGJp-sLNxL6.png)

## SSO Session Settings (User Sessions)

These settings control how long user sessions remain valid. The idle timeout expires sessions after inactivity, while the max lifespan provides an absolute limit regardless of activity.

Defined in `RealmModel.java`:

- SSO Session Idle Timeout `getSsoSessionIdleTimeout()` 1800s (30 min)
- SSO Session Max Lifespan `getSsoSessionMaxLifespan()` 36000s (10 hours)
- SSO Idle Timeout (Remember Me) `getSsoSessionIdleTimeoutRememberMe()` Falls back to regular
- SSO Max Lifespan (Remember Me) `getSsoSessionMaxLifespanRememberMe()` Falls back to regular

## Offline Session Settings

Offline sessions typically have much longer timeouts since they’re designed for scenarios like mobile apps that need persistent access.

Defined in `RealmModel.java`:

- Offline Session Idle Timeout `getOfflineSessionIdleTimeout()` 2592000s (30 days)
- Offline Session Max Lifespan Enabled `isOfflineSessionMaxLifespanEnabled()` false
- Offline Session Max Lifespan `getOfflineSessionMaxLifespan()` 5184000s (60 days)

## Client Session Settings

Individual clients can have their own timeout settings that override the realm defaults. When set to 0, they inherit from the realm-level SSO settings.

Defined in `RealmModel.java`:

- Client Session Idle Timeout `getClientSessionIdleTimeout()` 0 (uses SSO idle)
- Client Session Max Lifespan `getClientSessionMaxLifespan()` 0 (uses SSO max)
- Client Offline Session Idle Timeout `getClientOfflineSessionIdleTimeout()` 0 (uses offline idle)
- Client Offline Session Max Lifespan `getClientOfflineSessionMaxLifespan()` 0 (uses offline max)

**Related files:**

- `RealmAttributes.java` – Attribute constants

## Session Expiration

Sessions don’t live forever — they expire based on either inactivity (idle timeout) or absolute time limits (max lifespan). Understanding how this works helps when troubleshooting “mysterious” logouts.

## How lastSessionRefresh Works

The `lastSessionRefresh` field is the key to idle timeout calculations. Every time you do something active—refresh a token, access a new application—this timestamp gets updated. When the difference between now and `lastSessionRefresh` exceeds the idle timeout, your session expires.

1. **Initial value**: Set when user session is created
2. **Updated on activity**: When a user performs an action (e.g., refreshes a token)
3. **Batch update**: `updateLastSessionRefreshes()` updates multiple sessions at once
4. **Used for expiration**: Sessions filtered by comparing `lastSessionRefresh` with idle timeout

**Source files:**

- `SessionExpirationUtils.java` – Expiration calculation utilities
- `SessionTimeouts.java` – Cache timeout utilities

## Session State Machine

Sessions don’t just exist or not exist — they have states that track the logout process. This is important because logout can involve notifying multiple client applications, which takes time.

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*i2UzcfEdU_rb6SDR.png)

## Cascade Behavior

When sessions are removed, the cascade behavior differs between online and offline scenarios. For online sessions, removing the user session automatically removes all client sessions. For offline sessions, removing the last client session for a particular client can trigger removal of the offline user session.

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*36dOGz-WS1XnaWRz.png)

## Session Lifecycle

Let’s trace through a complete session lifecycle, from initial login through activity and finally logout. This shows how all the pieces we’ve discussed fit together in practice:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*--9n_tNnVAab5MoC.png)

## Related Source Files Summary

For quick reference, here’s a consolidated list of the key source files we’ve discussed:

- User Session Model `UserSessionModel.java`
- Client Session Model `AuthenticatedClientSessionModel.java`
- User Session Provider `UserSessionProvider.java`
- Auth Session Model `AuthenticationSessionModel.java`
- Root Auth Session `RootAuthenticationSessionModel.java`
- Offline Session Model `OfflineUserSessionModel.java`
- Infinispan Provider `InfinispanUserSessionProvider.java`
- Cache Configuration `InfinispanConnectionProvider.java`
- JPA Persister `JpaUserSessionPersisterProvider.java`
- User Session Entity `PersistentUserSessionEntity.java`
- Client Session Entity `PersistentClientSessionEntity.java`
- Session Expiration Utils `SessionExpirationUtils.java`
- Session Timeouts `SessionTimeouts.java`
- Realm Model `RealmModel.java`

## Authentication Sessions (Details)

This section covers authentication sessions — the temporary sessions that manage the login flow. Understanding these is important if you’re customizing authentication flows or debugging login issues.

## What is an Authentication Session?

An **Authentication Session** is a short-lived, transient session that tracks the state of an in-progress authentication. It exists from the moment a user initiates login until authentication completes (success or failure). It stores the progress through potentially complex authentication flows.

*“Represents the state of the authentication. If the login is requested from different tabs of same browser, every browser tab has it’s own state of the authentication.”  
—* `*AuthenticationSessionModel.java:25-31*`

**Key characteristics:**

- **Transient**: Not persisted to database, only in distributed cache
- **Short-lived**: Expires after ~30 minutes (configurable)
- **Per-tab**: Each browser tab has its own authentication state
- **Cleared on completion**: Removed after successful authentication

## Two-Level Architecture

Authentication sessions use a two-level architecture to handle the complexity of modern browser behavior. At the top level, a **Root Authentication Session** represents your browser. Underneath it, individual **Authentication Sessions** represent each browser tab where you might be logging in.

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*18CRYgLvTuQJdgEM.png)

`RootAuthenticationSessionModel` Represents browser session, contains all tabs

`AuthenticationSessionModel` Per-tab authentication state

## Tab ID Concept

Each browser tab gets a unique **TabId** — a Base64Url encoded random identifier (8 bytes? 10–11 characters). This allows Keycloak to track multiple concurrent login attempts from the same browser without confusion.

**Generation:**

```c
// From RootAuthenticationSessionAdapter.java:127
String tabId = Base64Url.encode(SecretGenerator.getInstance().randomBytes(8));
```

**Compound ID Format:** `rootSessionId.tabId.clientUUID`

- Used for cluster-wide lookups and cross-datacenter synchronization
- Parsed by `AuthenticationSessionCompoundId`

## Multi-Tab Handling

Here’s what happens when you have the login page open in multiple tabs:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*xVFIkVP4-u4WLrKx.png)

**Tab Limit:** Maximum 300 concurrent tabs per root session (configurable)

- When limit reached, oldest tab is automatically removed
- Configuration: `InfinispanAuthenticationSessionProviderFactory:72`

## Authentication Session Lifecycle

An authentication session goes through several states as the user progresses through login:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*ctKdF7RG3S21kP62.png)

**Lifespan Calculation:**

```c
// From SessionExpiration.java:27-36
int lifespan = Math.max(
    realm.getAccessCodeLifespanLogin(),      // Default: 30 min
    Math.max(
        realm.getAccessCodeLifespanUserAction(), // Default: 5 min
        realm.getAccessCodeLifespan()            // Default: 1 min
    )
);
```

## Data Stored in Authentication Session

Authentication sessions store various types of data to track login progress.

### Execution Status

Each authenticator in your flow gets a status that tracks its outcome:

- `SUCCESS` Authenticator completed successfully
- `FAILED` Authentication failed
- `CHALLENGED` User prompted for input (form displayed)
- `ATTEMPTED` User attempted but didn’t complete
- `SKIPPED` Authenticator skipped (conditional)
- `SETUP_REQUIRED` Credential setup needed
- `EVALUATED_TRUE/FALSE` Conditional evaluator result

### Three Types of Notes

Authentication sessions maintain three separate note collections, each with different lifecycles:

- **Auth Notes (**Temporary flow state**),** examples**:** ACR level, forced flag
- **Client Notes (**Protocol-specific data), examples: OIDC nonce, scope, SAML assertions
- **User Session Notes (**Data for final UserSession**):** Max age, ACR claim
```c
// Auth Notes - cleared when auth restarts
authSession.setAuthNote("acr", "gold");
authSession.getAuthNote("acr");
 
// Client Notes - persist through restarts
authSession.setClientNote(OIDCLoginProtocol.NONCE_PARAM, nonce);
 
// User Session Notes - transferred to UserSession on success
authSession.setUserSessionNote("custom_claim", "value");
```

### Required Actions

The session tracks which required actions the user must complete:

```c
authSession.addRequiredAction("UPDATE_PASSWORD");
authSession.addRequiredAction("CONFIGURE_TOTP");
Set<string> actions = authSession.getRequiredActions();
authSession.removeRequiredAction("UPDATE_PASSWORD");
```

## Storage Implementation

Authentication sessions live only in the Infinispan distributed cache — they’re never persisted to the database. Since they’re short-lived, regenerating them from a cookie is straightforward.

**Implementation Classes:**

- `InfinispanAuthenticationSessionProvider` Main provider
- `RootAuthenticationSessionAdapter` Root session adapter
- `AuthenticationSessionAdapter` Tab session adapter
- `RootAuthenticationSessionEntity` Cache entity (root)
- `AuthenticationSessionEntity` Cache entity (tab)

## AuthSession vs UserSession Comparison

Knowing when you’re dealing with an authentication session versus a user session is useful for debugging:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*DvsH-627Q1YojHc62BlEiw.png)

## Transition to User Session

When authentication succeeds, data flows from the authentication session to the newly created user session:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*j9V4nPkXoU63IFCJ.png)

**Transfer happens in:**

- `AuthenticationSessionManager.updateAuthenticationSessionAfterSuccessfulAuthentication()`

## Configuration Options

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*J6oo9vH8RQr31fXtQvKNWw.png)

Related Source Files:

- Auth Session Model `AuthenticationSessionModel.java`
- Root Auth Session `RootAuthenticationSessionModel.java`
- Auth Session Provider `AuthenticationSessionProvider.java`
- Compound ID `AuthenticationSessionCompoundId.java`
- Session Manager `AuthenticationSessionManager.java`
- Auth Processor `AuthenticationProcessor.java`
- Infinispan Provider `InfinispanAuthenticationSessionProvider.java`
- Root Adapter `RootAuthenticationSessionAdapter.java`
- Session Expiration `SessionExpiration.java`
- Session Timeouts `SessionTimeouts.java`

## Session Cookies (Details)

Cookies tie browser sessions to Keycloak’s server-side session objects. Without them, Keycloak couldn’t remember who you are between requests. This section documents all session-related cookies based on source code analysis.

## Cookie Definitions

All cookies are defined in `CookieType.java`. Let’s examine each one and understand its role.

- AUTH\_SESSION\_ID, Authentication session identifier with route info, **Default Max Age** = Session (-1)
- KC\_AUTH\_SESSION\_HASH SHA256 hash of auth session ID for JS detection, **Default Max Age** = 60 seconds
- KC\_RESTART Allows restarting login flow after client timeout Session (-1)
- KC\_STATE\_CHECKER Internal state for detached info/error pages, **Default Max Age** = Access code lifespan
- KEYCLOAK\_IDENTITY User identity/SSO cookie with access token claims, **Default Max Age** = SSO Max or Remember-Me
- KEYCLOAK\_SESSION SHA256 hash of session ID for iframe checks, **Default Max Age** = SSO Max or Remember-Me
- KEYCLOAK\_REMEMBER\_ME Username for remember-me functionality, **Default Max Age** = 1 year (31536000s)
- KEYCLOAK\_LOCALE User’s locale preference, **Default Max Age** = Session (-1)
- WELCOME\_STATE\_CHECKER CSRF protection for welcome page, **Default Max Age** = 300 seconds

### Legacy Cookies (Auto-Expired)

These cookies are automatically expired on startup for backward compatibility cleanup:

- `AUTH_SESSION_ID_LEGACY`
- `KEYCLOAK_IDENTITY_LEGACY`
- `KEYCLOAK_SESSION_LEGACY`

## Cookie Security Scopes

Keycloak assigns each cookie to a security scope that determines its `SameSite` and `HttpOnly` attributes. This is defined in `CookieScope.java`:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*2H_AauCEyR3o5GRA.png)

**Secure Flag Logic:**

- If SameSite=None and context is HTTP (not HTTPS), automatically downgrade to SameSite=Lax
- Secure flag is always set to match the request context (HTTP/HTTPS)

## Cookie Attributes Summary

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*6oY_e84-thCkbfA2jIdNLg.png)

- *Downgraded to Lax if not in secure (HTTPS) context*

## Cookie Details by Purpose

### 1\. AUTH\_SESSION\_ID — Authentication Session Cookie

This cookie tracks the in-progress authentication session. It’s signed to prevent tampering and includes routing information for clustered deployments.

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*8HX8gFNMjbyQFHmO.png)

**Encoding Process** (`AuthenticationSessionManager.java:108-116`):

```c
// 1. Sign with INTERNAL signature algorithm
String signature = signatureProvider.sign(authSessionId.getBytes());
String signedValue = authSessionId + "." + Base64Url.encode(signature);
 
// 2. Base64Url encode the signed value
String encoded = Base64Url.encode(signedValue);
 
// 3. Add sticky session route for cluster affinity
String withRoute = stickyEncoder.encodeSessionId(encoded, authSessionId);
// Result: "NWUxNjFlMDAt...signature.node1"
```

**Cookie Format:**

`Without route: base64(sessionId.signature)`

`With route: base64(sessionId.signature).node1`

## Get Torin’s stories in your inbox

Join Medium for free to get updates from this writer.

**Lifecycle:**

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*qrDDXlAWuMTyi956.png)

### 2\. KC\_AUTH\_SESSION\_HASH — JavaScript Session Detection

This short-lived hash enables JavaScript-based session detection in iframes.

**Purpose:**

- Allows JavaScript to detect if authentication session exists
- Used for silent authentication checks in iframes
- Short TTL (60 seconds) prevents stale detection

**Value:** `SHA256(authSessionId)`? Base64Url encoded (no padding)

```c
// From AuthenticationSessionManager.java:121-127
String hash = HashUtils.sha256(authSessionId);
String encoded = Base64Url.encode(hash);
cookieProvider.set(CookieType.AUTH_SESSION_ID_HASH, encoded);
```

### 3\. KEYCLOAK\_IDENTITY — User Identity Cookie (SSO Cookie)

This is the primary SSO cookie. It contains a JWT with user identity information, allowing Keycloak to recognize you without re-authentication.

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*nuQMdv2d7Ett7lpa.png)

**Token Structure** (`IdentityCookieToken.java`):

```c
public class IdentityCookieToken extends AccessToken {
    // Inherits from AccessToken but with:
    // - type = "keycloak-id" (not "Bearer")
    // - Contains session binding info
    // - state_checker for CSRF protection
}
```

**Creation** (`AuthenticationManager.java:822-859`):

```c
IdentityCookieToken token = new IdentityCookieToken();
token.id(KeycloakModelUtils.generateId());
token.issuedNow();
token.subject(user.getId());
token.issuer(Urls.realmIssuer(uriInfo.getBaseUri(), realm.getName()));
token.type(TOKEN_TYPE_KEYCLOAK_ID);
token.exp(expiration);  // Based on SSO max or remember-me lifespan
 
// Add CSRF protection
token.setSessionState(userSession.getId());
token.setStateChecker(Base64Url.encode(SecretGenerator.randomBytes()));
```

**Max Age Calculation:**

```c
if (rememberMe &&; realm.getSsoSessionMaxLifespanRememberMe() >0) {
    maxAge = realm.getSsoSessionMaxLifespanRememberMe();
} else {
    maxAge = realm.getSsoSessionMaxLifespan();
}
```

### 4\. KEYCLOAK\_SESSION — Session Hash Cookie

This cookie enables OIDC session management through iframe-based session checks.

**Purpose:**

- OIDC session management spec compliance
- Allows `check_session_iframe` to detect session changes
- Intentionally NOT HttpOnly (JavaScript accessible)

**Value:** `SHA256(userSessionId)`? URL encoded

### 5\. KC\_RESTART — Login Restart Cookie

This cookie handles a common scenario: what happens when your authentication session expires because you took too long to log in?

The Problem KC\_RESTART Solves

When a user starts login but takes too long (reading terms of service, phone call, coffee break), the authentication session expires in Infinispan cache (default 30 minutes). Without `KC_RESTART`, the user would see an error and be sent back to the application to start over.

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*AFWFQ3DL4_Gu7sRI.png)

Content Structure

From `RestartLoginCookie.java`:

```c
{
    "cid": "my-client-app",           // Client ID - which app initiated login
    "pty": "openid-connect",          // Protocol type
    "ruri": "https://myapp.com/cb",   // Redirect URI - where to go after auth
    "act": "authenticate",            // Action being performed
    "notes": {                        // Client notes (protocol state)
        "scope": "openid profile",
        "nonce": "abc123",
        "state": "xyz789"
    }
}
```

Encoding

1. Serialize to JSON
2. Encode as JWT with `TokenCategory.INTERNAL`
3. Encrypt with JWE (direct encryption + signature using realm keys)

The cookie is **encrypted** (not just signed) because it contains potentially sensitive protocol state like OIDC nonce and state parameters.

Why Not Just Extend Auth Session TTL?

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*OpMgPoqBOr8QeHUV9Suc4A.png)

The cookie approach is **stateless** — the server doesn’t need to keep the session alive, but can recreate it on-demand from the cookie data.

## Cookie Lifecycle Flow

Here’s the complete flow showing how cookies are set, used, and expired during a typical login session:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*By-p6O5pTvrgvMTN.png)

## Token-Session Relationship (Details)

Tokens and sessions are bound in Keycloak — every token carries a reference to its parent session. This binding has important implications for token validation and revocation.

## Session ID (sid) Claim

Every access token and ID token includes a `sid` (session ID) claim that binds the token to a specific user session. This is the thread that connects the stateless JWT world to Keycloak’s stateful session management.

**Token Structure:**

```c
{
"exp": 1704067200,
"iat": 1704063600,
"jti": "unique-token-id",
"iss": "https://keycloak.example.com/realms/myrealm",
"sub": "user-uuid",
"sid": "user-session-uuid", // ? Session binding
"typ": "Bearer",
"azp": "my-client",
"session_state": "user-session-uuid", // ? Legacy field (same as sid)
"scope": "openid profile email"
}
```

**Source:** `TokenManager.java:663-671`

## Token Creation Flow

When Keycloak creates a token, it always ties it to the current session context:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*6ZRiHYeJ22dPo3OM.png)

Token-Session Binding Points:

- Access Token(`sid` claim = User Session ID), `AccessToken.java`
- ID Token(`sid` claim = User Session ID),`IDToken.java`
- Refresh Token (Contains user session ID),`RefreshToken.java`
- Identity Cookie(`sessionState` field) `IdentityCookieToken.java`

## Token Introspection and Session Validation

When a resource server introspects a token, Keycloak validates that the bound session is still active. This means tokens become invalid the moment their session expires or is revoked — even if the token’s own expiration time hasn’t been reached.

![](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*46gYhs9Pp_yDLLPB0-fZfw.png)

**Implementation:** `TokenManager.validateToken()`

```c
public TokenValidation validateToken(String tokenString) {
    // 1. Decode and verify signature
    AccessToken token = verifyAccessToken(tokenString);
 
    // 2. Check session binding
    String sessionId = token.getSessionId();
    if (sessionId != null) {
        UserSessionModel session = sessionProvider.getUserSession(realm, sessionId, false);
        if (session == null || session.getState() != State.LOGGED_IN) {
            throw new OAuthErrorException("invalid_token", "Session not active");
        }
 
        // 3. Check session expiration
        if (isSessionExpired(session)) {
            throw new OAuthErrorException("invalid_token", "Session expired");
        }
    }
 
    return new TokenValidation(token, session);
}
```

## Refresh Token and Session Updates

Each time you refresh a token, the client session timestamp is updated, keeping the session alive:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*sz-lqcy6WvH7oX07.png)

**Refresh Token Reuse Detection:**

Keycloak tracks refresh token usage to detect potential token theft. If someone tries to reuse an old refresh token after a new one has been issued, it’s a sign that the token may have been stolen.

```c
// From TokenManager.java - refresh token tracking
String currentRefreshToken = clientSession.getCurrentRefreshToken();
int currentRefreshTokenUseCount = clientSession.getCurrentRefreshTokenUseCount();
 
if (refreshToken.equals(currentRefreshToken)) {
    // Same token being reused - increment counter
    currentRefreshTokenUseCount++;
    if (currentRefreshTokenUseCount &gt; maxReuseCount) {
        // Potential token theft - revoke session
        userSessionProvider.removeUserSession(realm, userSession);
        throw new OAuthErrorException("invalid_grant", "Maximum reuse exceeded");
    }
} else {
    // New refresh cycle
    clientSession.setCurrentRefreshToken(newRefreshToken);
    clientSession.setCurrentRefreshTokenUseCount(0);
}
```

## Token Revocation Impact

When a session is terminated — whether by logout, admin action, or expiration — all bound tokens become invalid:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*pkMBeS-WlqLzkOBq.png)

## Transient Sessions (Stateless Tokens)

For scenarios where you don’t want the overhead of session management, Keycloak supports stateless tokens with “transient” sessions. These sessions exist only for the duration of the request and are never persisted.

**Configuration:** Set client’s “Use Refresh Tokens” to OFF and enable “Transient Sessions”

```c
// From UserSessionModel.SessionPersistenceState
public enum SessionPersistenceState {
    PERSISTENT,     // Normal persistent session
    TRANSIENT       // In-memory only, no database persistence
}
```

**Transient Session Behavior:**

- Session exists only in memory during request
- Tokens are fully self-contained (no sid lookup needed)
- Refresh tokens not issued
- Token introspection works without session lookup

Related Source Files:

- Token Manager `TokenManager.java`
- Access Token `AccessToken.java`
- Refresh Token `RefreshToken.java`
- ID Token `IDToken.java`
- Token Introspection `TokenIntrospectionEndpoint.java`
- Token Revocation `TokenRevocationEndpoint.java`

## Session Logout & Revocation (Details)

When it’s time to end a session, Keycloak doesn’t just delete some data — it goes through a process to notify all affected parties. Understanding the logout mechanisms is important for implementing applications that properly clean up session state.

## Logout Mechanisms Overview

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*d_Y7v6ec_-FPHWU4.png)

## Session State Machine During Logout

The logout process isn’t instantaneous — sessions transition through states as Keycloak notifies all affected clients:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*_fEXF9STXJOit5qM.png)

**State enum from** `**UserSessionModel.java:42-47**`**:**

```c
public enum State {
    LOGGED_IN,              // Active session
    LOGGING_OUT,            // Logout in progress
    LOGGED_OUT,             // Fully logged out
    LOGGED_OUT_UNCONFIRMED  // Logout with unconfirmed clients
}
```

## Direct Logout (RP-Initiated)

The standard OIDC logout flow starts when a user clicks “logout” in an application:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*uSkDavy6mMEZJKfJ.png)

**Implementation:** `LogoutEndpoint.java`

## Backchannel Logout

Backchannel logout is server-to-server communication — Keycloak directly calls each client’s logout endpoint. This is more reliable than frontchannel because it doesn’t depend on the user’s browser.

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*-hNFEIx6g3dJ51Kg.png)

**Logout Token Structure:**

```c
{
"iss": "https://keycloak.example.com/realms/myrealm",
"sub": "user-uuid",
"aud": "client-id",
"iat": 1704063600,
"jti": "unique-logout-token-id",
"sid": "user-session-uuid",
"events": {
"http://schemas.openid.net/event/backchannel-logout": {}
}
}
```

**Implementation:** `BackchannelLogoutAction.java`

## Frontchannel Logout

Frontchannel logout uses the user’s browser to notify clients via iframes. This works when backchannel isn’t available but is less reliable since it depends on the browser.

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*Vr8HWpB5YuBqk-db.png)

## Admin Session Revocation

Administrators can forcibly revoke sessions through the Admin API:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*-S9RhF864TbbbSC4.png)

**Implementation:** `UserResource.java`

## Token Revocation Endpoint

Clients can revoke tokens directly, which terminates the associated session:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*8O9zNrp8JtIZ1P3B.png)

Related source files:

- Logout Endpoint `LogoutEndpoint.java`
- Authentication Manager `AuthenticationManager.java`
- Backchannel Logout `BackchannelLogoutAction.java`
- Logout Token `LogoutToken.java`
- Token Revocation `TokenRevocationEndpoint.java`
- Session State `UserSessionModel.java`

## Offline Sessions (Details)

This section provides more detail on offline sessions. These long-lived sessions are what make “stay logged in” functionality work for mobile apps and background services.

## What are Offline Sessions?

Offline sessions are special sessions created when a client requests the `offline_access` scope. They’re designed for scenarios where users need persistent access without frequent re-authentication—think mobile apps that sync data in the background or services that run overnight jobs.

**Key Characteristics:**

- Created alongside regular sessions when `offline_access` scope is requested
- Have separate, longer timeout configurations
- Survive regular session logout (unless explicitly revoked)
- Stored in separate cache and database tables
- Each client has its own offline session (can be removed independently)

## Offline Session Creation

When a client requests `offline_access`, Keycloak creates parallel session structures:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*c-qB_X710W0H3oqW.png)

**Implementation:** `TokenManager.java`

```c
// Check if offline_access scope requested
if (TokenUtil.hasScope(tokenScopes, OAuth2Constants.OFFLINE_ACCESS)) {
    // Create offline session from online session
    UserSessionModel offlineSession = session.sessions()
        .createOfflineUserSession(userSession);
    session.sessions()
        .createOfflineClientSession(clientSession, offlineSession);
}
```

## Offline vs Online Session Relationship

Online and offline sessions are linked but independent. You can log out of your online session (ending browser-based access) while your mobile app continues working with its offline session.

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*IUQd1C4eQRxTU_Ds.png)

**Linking via Notes:**

```c
// When creating offline session, link to online session
offlineSession.setNote(
    UserSessionModel.CORRESPONDING_SESSION_ID,
    onlineSession.getId()
);
onlineSession.setNote(
    UserSessionModel.CORRESPONDING_SESSION_ID,
    offlineSession.getId()
);
```

## Offline Session Storage

Offline sessions use separate caches and are always persisted to the database for durability:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*H4764UShfnlS2xpP.png)

## Offline Session Expiration

Offline sessions have their own expiration rules, typically much longer than online sessions:

![](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*V1b2MBko2GqHiRpipUU_-A.png)

**Timeout Configuration:**

- `offlineSessionIdleTimeout` =30 days, Idle timeout for offline sessions
- `offlineSessionMaxLifespanEnabled` =false, Enable max lifespan limit
- `offlineSessionMaxLifespan` =60 days, Max lifespan (if enabled)
- `clientOfflineSessionIdleTimeout` =0, Client-specific idle timeout (0 = use realm)
- `clientOfflineSessionMaxLifespan` =0, Client-specific max lifespan (0 = use realm)

## Lazy Loading of Offline Sessions

Offline sessions are loaded lazily from the database — they’re not all kept in memory. This allows Keycloak to handle millions of offline sessions without exhausting memory:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*KPpvUjoDKXQBk47V.png)

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*0fujwFNrNgtw3rfRSRUQZQ.png)

Related source files:

- Offline User Session `OfflineUserSessionModel.java`
- Token Manager `TokenManager.java`
- Session Provider `InfinispanUserSessionProvider.java`
- Offline Session Entity `PersistentUserSessionEntity.java`
- Session Persister `JpaUserSessionPersisterProvider.java`

## User Sessions (Details)

This section covers the `UserSessionModel` interface—the core abstraction for representing authenticated users in Keycloak.

## UserSessionModel Interface

The interface is defined in `UserSessionModel.java`:

![](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*HE6ZHpZHQCCYfjGCpnGr0Q.png)

## User Session Creation

Here’s what happens when a new user session is created:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*p0U2to85cAlMv4dX.png)

**Creation method from** `**InfinispanUserSessionProvider.java**`**:**

```c
public UserSessionModel createUserSession(
    RealmModel realm,
    UserModel user,
    String loginUsername,
    String ipAddress,
    String authMethod,
    boolean rememberMe,
    String brokerSessionId,
    String brokerUserId) {
 
    String id = KeycloakModelUtils.generateId();
    int timestamp = Time.currentTime();
 
    UserSessionEntity entity = new UserSessionEntity(id);
    entity.setRealmId(realm.getId());
    entity.setUserId(user.getId());
    entity.setLoginUsername(loginUsername);
    entity.setIpAddress(ipAddress);
    entity.setAuthMethod(authMethod);
    entity.setRememberMe(rememberMe);
    entity.setStarted(timestamp);
    entity.setLastSessionRefresh(timestamp);
    entity.setState(State.LOGGED_IN);
    entity.setBrokerSessionId(brokerSessionId);
    entity.setBrokerUserId(brokerUserId);
 
    // Store in cache
    cache.put(id, entity);
 
    return wrap(realm, entity, false);
}
```

## User Session Notes

Notes provide a flexible way to attach metadata to sessions:

![](https://miro.medium.com/v2/resize:fit:1290/format:webp/1*jSg_VAF-kIQLbOOO5Ky3hg.png)

```c
// Setting notes
userSession.setNote("ACR", "gold");
userSession.setNote("AUTH_TIME", String.valueOf(Time.currentTime()));
 
// Reading notes
String acr = userSession.getNote("ACR");
Map<string, string=""> allNotes = userSession.getNotes();
```

## Session Refresh Mechanism

Keycloak doesn’t update `lastSessionRefresh` on every single activity—that would create too much cache/database traffic. Instead, it uses a threshold:

![](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*v8UdHX8tP5CCfG-QdxZUlg.png)

**Refresh threshold:**

- Updates happen if time since last refresh exceeds `SESSION_REFRESH_INTERVAL` (default: 60 seconds)
- Prevents excessive updates during rapid activity

Related source files:

- User Session Model `UserSessionModel.java`
- User Session Provider `UserSessionProvider.java`
- Infinispan Implementation `InfinispanUserSessionProvider.java`
- User Session Entity `UserSessionEntity.java`
- Session Adapter `UserSessionAdapter.java`

## Client Sessions (Details)

While user sessions represent the overall authentication, client sessions track the relationship between a user and specific applications. Let’s examine the `AuthenticatedClientSessionModel` interface in detail.

## AuthenticatedClientSessionModel Interface

The interface is defined in `AuthenticatedClientSessionModel.java`:

## Client Session Creation

Client sessions are created when a user first accesses a client application:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*_Y1tF6urNGY7j4dx.png)

## Client Session Notes

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*FIUd1f9Me7z4mchT8jL5qw.png)

## Refresh Token Tracking

Client sessions track refresh token usage to detect potential token theft:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*dfqXq_Dy3GK09Nju.png)

**Implementation:**

```c
// Tracking current refresh token
clientSession.setCurrentRefreshToken(newRefreshTokenId);
clientSession.setCurrentRefreshTokenUseCount(0);
 
// On reuse detection
int count = clientSession.getCurrentRefreshTokenUseCount();
if (count &gt; maxCount) {
    // Token theft detected - revoke everything
    sessionProvider.removeUserSession(realm, userSession);
    throw new OAuthErrorException("invalid_grant", "Token reuse detected");
}
```

## Detaching Client Sessions

The `detachFromUserSession()` method is used during refresh token rotation to create a snapshot for comparison:

```c
// Detach creates a snapshot for comparison
clientSession.detachFromUserSession();
 
// After generating new tokens, reattach
userSession.getAuthenticatedClientSessions().put(clientId, clientSession);
```
![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*y4YsJiVKGy9XrHLW.png)

Related source files:

- Client Session Model `AuthenticatedClientSessionModel.java`
- Client Session Entity `AuthenticatedClientSessionEntity.java`
- Client Session Adapter `AuthenticatedClientSessionAdapter.java`
- Token Manager `TokenManager.java`

## Persistent Sessions (Details)

To survive restarts and provide durability, Keycloak persists sessions to the database. This section covers the JPA persistence layer that makes this possible.

![](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*fDInIKNQ0BUiR6vNXU87gw.png)

### PersistentUserSessionEntity

From `PersistentUserSessionEntity.java`:

```c
@Entity
@Table(name = "OFFLINE_USER_SESSION")
@NamedQueries({
    @NamedQuery(name = "findUserSessionById",
        query = "SELECT s FROM PersistentUserSessionEntity s WHERE s.userSessionId = :sessionId"),
    @NamedQuery(name = "findUserSessionsByUser",
        query = "SELECT s FROM PersistentUserSessionEntity s WHERE s.userId = :userId"),
    @NamedQuery(name = "removeUserSessionsByRealm",
        query = "DELETE FROM PersistentUserSessionEntity s WHERE s.realmId = :realmId")
})
public class PersistentUserSessionEntity {
    @Id
    @Column(name = "USER_SESSION_ID")
    private String userSessionId;
 
    @Column(name = "REALM_ID")
    private String realmId;
 
    @Column(name = "USER_ID")
    private String userId;
 
    @Column(name = "LAST_SESSION_REFRESH")
    private int lastSessionRefresh;
 
    @Column(name = "OFFLINE_FLAG")
    private String offlineFlag;  // "0" = online, "1" = offline
 
    @Column(name = "DATA")
    private String data;  // JSON serialized session data
}
```

### PersistentClientSessionEntity

From `PersistentClientSessionEntity.java`:

```c
@Entity
@Table(name = "OFFLINE_CLIENT_SESSION")
@IdClass(PersistentClientSessionKey.class)
public class PersistentClientSessionEntity {
    @Id
    @Column(name = "USER_SESSION_ID")
    private String userSessionId;
 
    @Id
    @Column(name = "CLIENT_ID")
    private String clientId;
 
    @Id
    @Column(name = "OFFLINE_FLAG")
    private String offlineFlag;
 
    @Column(name = "TIMESTAMP")
    private int timestamp;
 
    @Column(name = "DATA")
    private String data;  // JSON serialized client session data
}
```

## Persistence Provider

```c
The JpaUserSessionPersisterProvider handles all database operations:

public class JpaUserSessionPersisterProvider implements UserSessionPersisterProvider {
 
    // Create new persistent session
    public void createUserSession(UserSessionModel userSession, boolean offline) {
        PersistentUserSessionEntity entity = new PersistentUserSessionEntity();
        entity.setUserSessionId(userSession.getId());
        entity.setRealmId(userSession.getRealm().getId());
        entity.setUserId(userSession.getUser().getId());
        entity.setLastSessionRefresh(userSession.getLastSessionRefresh());
        entity.setOfflineFlag(offline ? "1" : "0");
        entity.setData(serializeSessionData(userSession));
 
        em.persist(entity);
    }
 
    // Load session from database
    public UserSessionModel loadUserSession(
        RealmModel realm, String sessionId, boolean offline) {
 
        PersistentUserSessionEntity entity = em.find(
            PersistentUserSessionEntity.class, sessionId);
 
        if (entity == null) return null;
 
        return deserializeToModel(realm, entity);
    }
 
    // Batch update lastSessionRefresh
    public void updateLastSessionRefreshes(
        RealmModel realm, int lastSessionRefresh,
        Collection<string> sessionIds, boolean offline) {
 
        em.createNamedQuery("updateSessionRefreshes")
            .setParameter("lastSessionRefresh", lastSessionRefresh)
            .setParameter("sessionIds", sessionIds)
            .setParameter("offlineFlag", offline ? "1" : "0")
            .executeUpdate();
    }
}
```

## Data Serialization

Session data is stored as JSON in the `DATA` column, enabling flexible storage of notes and metadata:

```c
{
"loginUsername": "john.doe",
"ipAddress": "192.168.1.100",
"authMethod": "openid-connect",
"rememberMe": false,
"brokerSessionId": null,
"brokerUserId": null,
"notes": {
"AUTH_TIME": "1704063600",
"ACR": "1"
}
}
```

## Lazy Loading Architecture

Sessions are loaded from the database on-demand to conserve memory:

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*_pYlm_Kbqz6qnPnO.png)

Related source files:

- JPA Persister Provider `JpaUserSessionPersisterProvider.java`
- User Session Entity `PersistentUserSessionEntity.java`
- Client Session Entity `PersistentClientSessionEntity.java`
- User Session Adapter `PersistentUserSessionAdapter.java`
- Client Session Adapter `PersistentAuthenticatedClientSessionAdapter.java`
- Persister Provider Interface `UserSessionPersisterProvider.java`

## Conclusion

This document covered Keycloak’s session management. From the temporary authentication sessions that track your progress through login, to the long-lived offline sessions that keep mobile apps working for weeks, each component plays a role in providing secure authentication.

**Key takeaways:**

- **Sessions form a hierarchy**: Authentication sessions > User sessions > Client sessions, each serving a distinct purpose.
- **Two-tier storage**: Infinispan provides fast, distributed caching while the database ensures durability.
- **Cookies are the glue**: Multiple cookies with different security profiles tie browser state to server-side sessions.
- **Tokens and sessions are bound**: The `sid` claim creates a tight coupling between stateless JWTs and stateful sessions.
- **Logout is orchestrated**: Backchannel and frontchannel mechanisms ensure all parties are notified when sessions end.

Understanding these internals will help you configure Keycloak correctly, debug authentication issues, and build applications that work harmoniously with Keycloak’s session management.