---
categories:
  - "[[Documentation]]"
created: 2026-05-17
product: Accelup
component:
tags:
  - documentation/auth
  - accelup/notifications
---

## Summary
Email and notifications inside accelup project.
## Details

Παρακάτω είναι ένα ενιαίο high-level διάγραμμα που δείχνει όλα τα βασικά use cases, τη βασική απόφαση `direct email` vs `notifications queue`, και τους τελικούς παραλήπτες.
```mermaid
flowchart TD
    U["Use Case / API Call"] --> C{"Τύπος περίπτωσης;"}
    C --> ACC["Account / Access"]
    C --> CON["Contact Us"]
    C --> MSG["User Message"]
    C --> BID["Bid Action"]
    C --> PROJ["Project Create / Edit / File"]
    C --> STAT["Project Status Change"]
    C --> ADM["Admin Broadcast"]
    ACC --> ACCD{"Ποιο account flow;"}
    ACCD --> REG["Register"]
    ACCD --> FP["Forgot Password"]
    ACCD --> RR["Role Request Accept / Deny"]
    REG --> REG1{"Freelancer role request;"}
    REG1 -->|Yes| REG2["Direct Email"]
    REG2 --> REG3["Admins / Contact mailbox"]
    REG --> REG4{"Skip verification off;"}
    REG4 -->|Yes| REG5["Direct Email"]
    REG5 --> REG6["New user"]
    FP --> FP1["Direct Email"]
    FP1 --> FP2["User who requested reset"]
    RR --> RR1["Direct Email"]
    RR1 --> RR2["User whose request was approved/rejected"]
    CON --> CON1["Direct Email"]
    CON1 --> CON2["Admins / Contact mailbox"]
    CON2 --> CON3{"Admin send succeeded;"}
    CON3 -->|Yes| CON4["Direct Email"]
    CON4 --> CON5["Client confirmation email"]
    MSG --> MSG1["Store message in DB"]
    MSG1 --> MSG2["Direct Email"]
    MSG2 --> MSG3["Message recipient"]
    BID --> BIDD{"Ποιο bid flow;"}
    BIDD --> BA["Add / Update / Withdraw Bid"]
    BIDD --> BAC["Accept Bid"]
    BA --> BA1["Direct Email"]
    BA1 --> BA2["Project owners"]
    BAC --> BAC1["Direct Email"]
    BAC1 --> BAC2["Project owners"]
    BAC1 --> BAC3["Winning bidder organization users"]
    BAC1 --> BAC4["Losing bidder organization users"]
    PROJ --> PROJ1["Create Notification row"]
    PROJ1 --> Q["Notifications table / queue"]
    STAT --> STATD{"Ποιο status change;"}
    STATD --> DISP["In dispute"]
    STATD --> CANC["Cancelled by Admin"]
    STATD --> OTH["Other status changes"]
    DISP --> DISP1["Direct Email"]
    DISP1 --> DISP2["Project owners"]
    DISP1 --> DISP3["Winning bid users"]
    DISP1 --> DISP4["Admins"]
    CANC --> CANC1["Direct Email"]
    CANC1 --> CANC2["Bidding organization users"]
    CANC1 --> CANC3["Winning bid users"]
    CANC1 --> CANC4["Project owners"]
    OTH --> OTH1["Create Notification row(s)"]
    OTH1 --> Q
    ADM --> ADM1["Direct Email"]
    ADM1 --> ADM2["Active users"]
    Q --> AGG{"Background aggregation"}
    AGG --> MID["Every 20 min: UpdateProjectStatus"]
    AGG --> LOW["Every 12h: CreateProject / UpdateProjectDetails"]
    MID --> MID1["Resolve recipients by status rules"]
    MID1 --> MID2["Email to bidding organization users, if allowed"]
    MID1 --> MID3["Email to winning bid organization users, if allowed"]
    LOW --> LOW1["Aggregate projects into batch email"]
    LOW1 --> LOW2["Advanced active users / interested audience"]
    MID2 --> SMTP["EmailService -> SMTP"]
    MID3 --> SMTP
    LOW2 --> SMTP
    REG3 --> SMTP
    REG6 --> SMTP
    FP2 --> SMTP
    RR2 --> SMTP
    CON5 --> SMTP
    CON2 --> SMTP
    MSG3 --> SMTP
    BA2 --> SMTP
    BAC2 --> SMTP
    BAC3 --> SMTP
    BAC4 --> SMTP
    DISP2 --> SMTP
    DISP3 --> SMTP
    DISP4 --> SMTP
    CANC2 --> SMTP
    CANC3 --> SMTP
    CANC4 --> SMTP
    ADM2 --> SMTP
    SMTP --> OUT["Outbound emails delivered"]
    MID --> CLEAN["Processed notification rows deleted"]
    LOW --> CLEAN
```
**Πώς να το διαβάζεις**
- `Direct Email`: το request οδηγεί κατευθείαν στο `EmailService` και μετά σε SMTP.
- `Create Notification row`: το request δεν στέλνει αμέσως email. Γράφει event στον πίνακα `Notifications`.
- `Background aggregation`: ο worker μαζεύει queued notifications και τα μετατρέπει αργότερα σε emails.
- `Project Status Change` έχει μικτό μοντέλο:
  - `In dispute` και `Cancelled by Admin` -> direct email
  - τα υπόλοιπα status changes -> queue -> delayed email

**Το βασικό decision tree σε μία πρόταση**
- account, contact, messages, bids, admin broadcast, dispute/cancel flows -> `direct email`
- project create/edit/file upload και τα περισσότερα generic project status updates -> `notifications queue` -> background aggregation -> email

Παρακάτω είναι μια πιο καθαρή, business-friendly εκδοχή, με έμφαση στις αποφάσεις και στο πού καταλήγει κάθε ειδοποίηση.
```mermaid
flowchart TB
    START["User action / system event"] --> DECISION{"Immediate ενημέρωση ή batched ενημέρωση;"}
    DECISION -->|Immediate| DIRECT["Direct Email Flow"]
    DECISION -->|Batched| QUEUE["Notifications Queue Flow"]
    DIRECT --> D1["Account events
    Register verification
    Password reset
    Role request created
    Role request approved/rejected"]
    DIRECT --> D2["Communication events
    Contact us
    New user-to-user message"]
    DIRECT --> D3["Bid events
    Bid added
    Bid updated
    Bid withdrawn
    Bid accepted"]
    DIRECT --> D4["Critical project status events
    In dispute
    Cancelled by admin"]
    DIRECT --> D5["Admin communication
    Broadcast to active users"]
    D1 --> D1R["Recipients
    New user
    Requesting user
    Admin mailbox"]
    D2 --> D2R["Recipients
    Admin mailbox
    Message recipient
    Contact form sender"]
    D3 --> D3R["Recipients
    Project owners
    Winning bidder users
    Losing bidder users"]
    D4 --> D4R["Recipients
    Project owners
    Winning bid users
    Bidding organization users
    Admins"]
    D5 --> D5R["Recipients
    Active users"]
    D1R --> EMAIL["EmailService -> Templates -> SMTP"]
    D2R --> EMAIL
    D3R --> EMAIL
    D4R --> EMAIL
    D5R --> EMAIL
    QUEUE --> Q1["Queued project activity
    Project created
    Project details updated
    Project files changed
    Non-critical project status updates"]
    Q1 --> STORE["Store lightweight notification record
    EntityId + Type"]
    STORE --> WORKER["Background aggregation worker"]
    WORKER --> W1["Every 20 minutes
    Process status update notifications"]
    WORKER --> W2["Every 12 hours
    Process project create / update notifications"]
    W1 --> W1R["Recipients decided by status rules
    Bidding organization users
    Winning bid organization users"]
    W2 --> W2R["Recipients decided by audience rules
    Advanced active users"]
    W1R --> BATCH["Aggregate / batch email creation"]
    W2R --> BATCH
    BATCH --> EMAIL
    BATCH --> CLEANUP["Processed queue entries removed"]
    EMAIL --> END["Outbound email delivered"]
```
**Η ουσία του συστήματος**
- Υπάρχουν δύο παράλληλα μονοπάτια: `Direct Email Flow` και `Notifications Queue Flow`.
- Το direct flow χρησιμοποιείται όταν η ενημέρωση πρέπει να φύγει αμέσως ή είναι πολύ συγκεκριμένη ως προς παραλήπτες.
- Το queue flow χρησιμοποιείται κυρίως για project-related activity που θέλουν batching και όχι spam με άμεσα πολλά mails.
**Πρακτικός κανόνας**
- αν το event είναι προσωπικό, transactional ή κρίσιμο -> direct email
- αν το event είναι “project activity update” που μπορεί να ομαδοποιηθεί -> queue -> background worker -> batch email
Αν θέλεις, μπορώ να δώσω και τρίτη εκδοχή, ακόμα πιο executive, σαν one-slide architecture diagram με μόνο 6-7 κουτιά.
## Links
Αναλυτικά διαγράμματα ανά περίπτωση: [[Notifications & emails code flows]]
