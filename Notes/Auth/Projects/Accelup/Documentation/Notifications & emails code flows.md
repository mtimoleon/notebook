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
Code flows for notifications and emails.

## Details

### Διάγραμμα Ροών
Παρακάτω είναι το συνολικό routing των emails/notifications στο backend.
```mermaid
flowchart TD
    A["HTTP Request"] --> B["Controller"]
    B --> C["Business Service"]
    C --> D{"Direct email ή queued notification;"}
    D -->|Direct email| E["EmailService"]
    E --> F["Load HTML template + replace placeholders"]
    F --> G["SMTP"]
    G --> H["Παραλήπτες"]
    D -->|Queued notification| I["NotificationService.CreateNotificationAsync"]
    I --> J["Notifications table"]
    J --> K["NotificationsAggregateService (background timers)"]
    K --> L["NotificationService send methods"]
    L --> E
```
#### 1. Account / Access Flows
```mermaid
flowchart TD
    A["Register API"] --> B["AccountsController"]
    B --> C["AccountService.RegisterAsync"]
    C --> D{"Freelancer role request?"}
    D -->|Yes| E["Create role request"]
    E --> F["EmailService.SendRoleRequestCreatedEmailAsync"]
    F --> G["SMTP -> Admin/Contact email"]
    C --> H{"SkipVerification = false?"}
    H -->|Yes| I["EmailService.SendVerificationEmailAsync"]
    I --> J["SMTP -> New user"]
    K["Forgot Password API"] --> L["AccountService.ForgotPasswordAsync"]
    L --> M["Generate reset token"]
    M --> N["EmailService.SendPasswordResetEmailAsync"]
    N --> O["SMTP -> User"]
    P["Admin Accept/Deny Role Request"] --> Q["RequestService"]
    Q --> R["EmailService.SendRequestAccepted/RejectedEmailAsync"]
    R --> S["SMTP -> User"]
```
Τι πάει πού:
- verification email -> στον νέο χρήστη
- password reset email -> στον χρήστη που ζήτησε reset
- role request created -> στους admins
- role request approved/rejected -> πίσω στον χρήστη

#### 2. Contact Form
```mermaid
flowchart TD
    A["Contact API"] --> B["ContactController"]
    B --> C["EmailService.SendContactUsEmailToAdminsAsync"]
    C --> D["SMTP -> Admin contact email"]
    D --> E{"Admin send OK?"}
    E -->|Yes| F["EmailService.SendContactUsEmailToClientAsync"]
    F --> G["SMTP -> Client"]
```
Τι πάει πού:
- το αρχικό μήνυμα -> στους admins
- confirmation/copy -> στον πελάτη μόνο αν το πρώτο send πετύχει

#### 3. User-to-User Messages
```mermaid
flowchart TD
    A["Send Message API"] --> B["MessageController"]
    B --> C["MessageService.SendMessageAsync"]
    C --> D["Store message in DB"]
    B --> E["EmailService.SendMessageNotificationEmailToReceiverAsync"]
    E --> F["SMTP -> Recipient user"]
```
Τι πάει πού:
- το actual message αποθηκεύεται στη DB
- email notification -> μόνο στον παραλήπτη, σαν ειδοποίηση ότι έχει νέο μήνυμα

#### 4. Bid Flows
```mermaid
flowchart TD
    A["Add / Update / Withdraw Bid API"] --> B["ProjectsController"]
    B --> C1["SendBidAddedNotificationEmailsAsync"]
    B --> C2["SendBidUpdatedNotificationEmailsAsync"]
    B --> C3["SendBidWithdrawnNotificationEmailsAsync"]
    C1 --> D["Resolve project owner org emails"]
    C2 --> D
    C3 --> D
    D --> E["SMTP -> Project owners"]
    F["Accept Bid API"] --> G["ProjectsController"]
    G --> H["SendBidAcceptNotificationEmailsToOwnersUsersAsync"]
    G --> I["SendBidAcceptNotificationEmailsToBiddingOrganizationUsersAsync"]
    H --> J["SMTP -> Project owners"]
    I --> K["SMTP -> Winning org users"]
    I --> L["SMTP -> Losing org users"]
```
Τι πάει πού:
- new bid / updated bid / withdrawn bid -> στους owners του project
- accepted bid:
  - owners -> ενημέρωση ότι επιλέχθηκε bid
  - winning bidder org -> winning email
  - losing bidder orgs -> losing email

#### 5. Project Create / Edit / File Upload: Queued Aggregate Notifications
Αυτό είναι το βασικό queued flow.
```mermaid
flowchart TD
    A["Create Project / Edit Project / Upload File API"] --> B["ProjectsController"]
    B --> C["NotificationService.CreateNotificationAsync"]
    C --> D["Notifications table"]
    D --> E["NotificationsAggregateService"]
    E -->|Every 12 hours| F["Aggregate by type"]
    F --> G["SendCreatedProjectsNotificationsAsync"]
    F --> H["SendUpdatedProjectsNotificationsAsync"]
    G --> I["Resolve interested advanced users"]
    H --> I
    I --> J["EmailService.SendCreated/UpdatedProjectsAggregateEmailsAsync"]
    J --> K["SMTP -> Many recipients (BCC batches)"]
    J --> L["Processed notifications deleted"]
```
Τι πάει πού:
- δεν φεύγει άμεσα email
- γράφεται event στον πίνακα `Notifications`
- ο background worker τα μαζεύει
- στέλνει ένα aggregate email σε πολλούς recipients
- μετά διαγράφει τα processed notification rows

#### 6. Project Status Change
Υπάρχουν 2 διαφορετικά branches.
```mermaid
flowchart TD
    A["Update Project Status API"] --> B["ProjectsController"]
    B --> C{"Ποιο status;"}
    C -->|In dispute| D["Direct dispute emails"]
    D --> E["SMTP -> Project owners"]
    D --> F["SMTP -> Winning bid users"]
    D --> G["SMTP -> Admins"]
    C -->|Cancelled by Admin| H["Direct cancellation emails"]
    H --> I["SMTP -> Bidding org users"]
    H --> J["SMTP -> Winning bid users"]
    H --> K["SMTP -> Project owners"]
    C -->|Other status changes| L["CreateNotificationAsync x2"]
    L --> M["Notifications table"]
    M --> N["NotificationsAggregateService"]
    N -->|Every 20 minutes| O["SendUpdatedProjectStatusNotificationsAsync"]
    O --> P["Resolve recipients by project status rules"]
    P --> Q["SMTP -> Bidding org users if allowed"]
    P --> R["SMTP -> Winning bid org users if allowed"]
    O --> S["Delete processed notification rows"]
```
Τι πάει πού:
- `In_dispute` -> άμεσο email σε owners, winning users, admins
- `Cancelled_by_Admin` -> άμεσο email σε bidders, winners, owners
- άλλα status changes -> queued notification, μετά batch send ανά status rules

Παρακάτω είναι ο καθαρός πίνακας για το current behavior.

| Status | Flow | Τελικοί παραλήπτες | Σχόλιο |
|---|---|---|---|
| `In_dispute` | Direct email | Project owners, winning bid users, admins | Άμεσο special-case flow |
| `Cancelled_by_Admin` | Direct email | Bidding organization users, winning bid users, project owners | Άμεσο special-case flow |
| `Active` | Queued | Bidding organization users, winning bid organization users | Περνά από `Notifications` + worker |
| `Bidding_closed` | Queued | Bidding organization users | Περνά από `Notifications` + worker |
| `Employer_cancelled` | Queued | Bidding organization users, winning bid organization users | Περνά από `Notifications` + worker |
| `Closed` | Queued | Bidding organization users, winning bid organization users | Περνά από `Notifications` + worker |
| `Under_development` | Queued | Winning bid organization users | Περνά από `Notifications` + worker |
| `Bidding_expired` | Queued | Κανείς, με βάση το current code | Γράφεται notification αλλά δεν βλέπω τελικό send |
| `Winner_selected` | Queued | Κανείς, με βάση το current code | Γράφεται notification αλλά δεν βλέπω τελικό send |
| `Payment_pending` | Queued | Κανείς, με βάση το current code | Γράφεται notification αλλά δεν βλέπω τελικό send |
| `Completed` | Queued | Κανείς, με βάση το current code | Γράφεται notification αλλά δεν βλέπω τελικό send |
Η βασική παρατήρηση είναι ότι το queued branch δεν σημαίνει πάντα και τελικό email. Για 4 statuses το event μπαίνει στην ουρά, αλλά ο `NotificationService` δεν τα θεωρεί eligible για αποστολή.
Αν το δούμε από πλευράς requirement, το πιο σημαντικό κενό είναι:
- δεν ενημερώνονται σταθερά οι `project owners` για generic status changes
- κάποια statuses αλλάζουν, μπαίνουν στην ουρά, αλλά δεν παράγουν καθόλου outgoing notification
Αν θέλεις, επόμενο βήμα μπορώ να σου γράψω ένα πολύ σύντομο `coverage verdict` για το requirement ανά status, π.χ. `fully covered / partially covered / not covered`.

#### 7. Admin Broadcast
```mermaid
flowchart TD
    A["Admin Send Email API"] --> B["AdminController"]
    B --> C["EmailService.AdminSendEmailToActiveUsersAsync"]
    C --> D["Resolve active users"]
    D --> E["Sanitize body / optional template"]
    E --> F["SMTP -> Active users via BCC chunks"]
```
Τι πάει πού:
- ένα admin-authored μήνυμα -> σε όλους τους active users που περνάνε τα φίλτρα
**Πρακτικά, τα “μηνύματα” πάνε σε 3 προορισμούς**
1. Άμεσο SMTP send προς συγκεκριμένους παραλήπτες.
2. `Notifications` table ως προσωρινό queue marker.
3. Από το queue ξανά στο `EmailService`, που τελικά τα στέλνει με SMTP.

**Σημεία του code που αντιστοιχούν στα παραπάνω**
- Controller entry points: [ProjectsController.cs](C:/Users/michael/developer/accelup/accelup-backend/Enoll/Controllers/ProjectsController.cs), [AccountsController.cs](C:/Users/michael/developer/accelup/accelup-backend/Enoll/Controllers/AccountsController.cs), [MessageController.cs](C:/Users/michael/developer/accelup/accelup-backend/Enoll/Controllers/MessageController.cs), [ContactController.cs](C:/Users/michael/developer/accelup/accelup-backend/Enoll/Controllers/ContactController.cs), [AdminController.cs](C:/Users/michael/developer/accelup/accelup-backend/Enoll/Controllers/AdminController.cs), [RequestController.cs](C:/Users/michael/developer/accelup/accelup-backend/Enoll/Controllers/RequestController.cs)
- Direct mail layer: [EmailService.cs](C:/Users/michael/developer/accelup/accelup-backend/Enoll/Services/EmailService.cs)
- Queue/event layer: [NotificationService.cs](C:/Users/michael/developer/accelup/accelup-backend/Enoll/Services/NotificationService.cs)
- Background aggregation: [NotificationsAggregateService.cs](C:/Users/michael/developer/accelup/accelup-backend/Enoll/Services/NotificationsAggregateService.cs)
- Stored notification model: [Notification.cs](C:/Users/michael/developer/accelup/accelup-backend/Enoll/Model/Entities/Notification.cs)


## Links
