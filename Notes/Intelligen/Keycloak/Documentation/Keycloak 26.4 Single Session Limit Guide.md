---
categories:
  - "[[Documentation]]"
created: 2026-04-23
product: ScpCloud
component: Keycloak
tags:
  - documentation/keycloak
  - topic/authentication
  - tech/sessions
---

## Summary

#### Στόχος
Να επιτρέπεται μόνο **1 ενεργό session ανά user** στο Keycloak.

---
#### Βασικό συμπέρασμα
Το Keycloak 26.4 το υποστηρίζει έτοιμα μέσω:
```text
User session count limiter
```
Δεν είναι realm setting. Είναι **authentication flow execution**.

---
### Σωστή διαδικασία
#### 1. Δεν πειράζεις built-in flows
Τα built-in flows είναι read-only.
Κάνεις copy του:
```text
Browser
```
π.χ.
```text
browser-single-session
```

---
#### 2. Bind το νέο flow
Το νέο copied flow πρέπει να γίνει active ως:
```text
Browser Flow
```
Αλλιώς δεν χρησιμοποιείται.

---
#### 3. Σωστή δομή Browser Flow
```text
Cookie                        Alternative
Identity Provider Redirector  Alternative
browser-single-session forms  REQUIRED
```
##### Σημαντικό
Το forms subflow πρέπει να είναι:
```text
Required
```
Όχι `Alternative`.
Αυτό έλυσε το πρόβλημα:
```text
Invalid username or password
```

---
#### 4. Μέσα στο forms subflow
```text
Username Password Form        Required
Conditional OTP              Conditional
User session count limiter   Required
```

---
### Limiter Config
#### Για μόνο 1 session συνολικά
```text
Maximum concurrent sessions for each user within this realm = 1
Maximum concurrent sessions for each user per keycloak client = 0
Behavior = Deny new session
```
#### Εναλλακτικά
```text
Behavior = Terminate oldest session
```
σημαίνει νέο login πετάει έξω το παλιό.

---
### Τι σημαίνουν οι τιμές
#### Realm sessions
Μετρά συνολικά sessions του user στο realm.
#### Client sessions
Ανά συγκεκριμένο client.
Αν βάλεις:
```text
realm = 1
client = 0
```
έχεις global single login.

---
### Testing σωστό
#### Test 1
Browser A login
#### Test 2
Incognito / άλλο browser login
##### Αναμενόμενο
##### Deny new session
Δεύτερο login reject.
##### Terminate oldest session
Πρώτο session logout.

---
### Αν δεις Invalid username or password
Δεν σημαίνει password λάθος απαραίτητα.
Συνήθως σημαίνει λάθος flow config.
Πρώτο πράγμα να δεις:
```text
forms subflow = Required
```

---
### Αν έχει React app
Δεν πειράζει.
Αν το React app κάνει redirect στο Keycloak login page, χρησιμοποιεί:
```text
Browser Flow
```
άρα σωστά δουλεύεις εκεί.

---
### Production Recommendation
```text
Browser Flow copied custom
forms subflow Required
Limiter realm=1
client=0
Behavior=Deny new session
Custom message:
Maximum active sessions reached.
```

---
### Συμπέρασμα
Το κρίσιμο fix όλου του thread ήταν:
```text
forms subflow = Required
```
και μετά ο limiter δουλεύει σωστά.

## Links
[[Keycloak Sessions]]