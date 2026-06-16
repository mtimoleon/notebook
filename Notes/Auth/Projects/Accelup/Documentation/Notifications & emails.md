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

### Emails and Notifications
​
We currently use 4 core services in order to queue, build, and send project-related notification emails:
​
- `NotificationQueueService`
  Responsible for persisting notification rows in the `Notifications` table and reading pending email work.
​
- `NotificationsAggregateService`
  A background service that periodically pulls pending notifications by priority bucket.
​
- `NotificationDispatcher`
  Responsible for grouping pending notifications by type, building email work items, dispatching them through `EmailService`, and marking handled notifications as sent.
​
- `EmailService`
  The service that renders templates and sends emails.
​

---
​
### Typical Queued Notification Flow
​
Most queued project notifications follow this flow:
​
1. An endpoint or background worker enqueues a notification through `NotificationQueueService`.
2. The notification gets stored in the database.
3. `NotificationsAggregateService` periodically reads pending notifications for a priority bucket.
4. The aggregate service forwards the pending rows to `NotificationDispatcher`.
5. `NotificationDispatcher` asks `NotificationEmailWorkItemBuilder` to load the data needed for each notification type.
6. `NotificationDispatcher` sends each resulting work item through `EmailService`.
7. Once processing is complete, the handled notifications are marked with `IsEmailSent = true`.
​
Notifications with `ShouldSendEmail = false` stay persisted in the table, but they are never returned as pending email work.
​

---
​
### Instant Emails vs Aggregated Notifications
​
Not every email goes through the notification aggregation system.
​
Some actions are considered important enough to send emails instantly. In those cases, services or endpoints can call `EmailService` directly instead of enqueueing notifications.
​
For project status actions that are still immediate, the controller now calls `NotificationDispatcher` directly. The dispatcher uses the same builder-style payload assembly as the queued flow, but without persisting rows in `Notifications`.
​

---
​
### How Emails Work for Bid-Related Endpoints
​
Endpoints such as `AddBid` (and all bid-related endpoints) send emails instantly.
​
These endpoints bypass the notification aggregation system entirely and use `EmailService` directly.
​
The reasoning here is simple: bid-related actions are usually time-sensitive and users should be informed immediately.
​

---
​
### How Emails Work for `UpdateProjectStatus`
​
`UpdateProjectStatus` behaves slightly differently depending on the status being applied.
​
#### Statuses That Send Emails Instantly
​
If the new project status is:
​
- `In_dispute`
- `Cancelled_by_Admin`
​
then emails are sent immediately through `EmailService`.
​
These statuses are treated as special/high-importance cases and do not go through the notification aggregation system. They do, however, go through the direct `NotificationDispatcher` + builder path so that recipient discovery and payload assembly stay out of the controller.
​

---
​
#### All Other Statuses
​
For every other status update, two notifications are created:
​
- `UpdateProjectStatus`
- `UpdateProjectDetails`
​
These notifications are stored in the database and later picked up by `NotificationsAggregateService`.
​

---
​
### Expiry Notifications
​
`ProjectExpiryNotificationService` runs periodically and enqueues the following notification types:
​
- `ProjectNearExpiryMonthly`
- `ProjectNearExpiry`
- `ProjectExpired`
​
These are later dispatched through the same queue → dispatcher → builder → email service flow as the rest of the queued project notifications.
​

---
​
### `UpdateProjectStatus` Status Table
​

| Status               | Flow            | Final Recipients                                                           | Notes                                                       |
| -------------------- | --------------- | -------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `In_dispute`         | Immediate email | Project owners, winning bid organization users, admins                     | Goes through direct `NotificationDispatcher` + builder path |
| `Cancelled_by_Admin` | Immediate email | Bidding organization users, winning bid organization users, project owners | Goes through direct `NotificationDispatcher` + builder path |
| `Active`             | Queued          | Bidding organization users, winning bid organization users                 | Goes through `Notifications` + worker                       |
| `Bidding_closed`     | Queued          | Bidding organization users                                                 | Goes through `Notifications` + worker                       |
| `Employer_cancelled` | Queued          | Bidding organization users, winning bid organization users                 | Goes through `Notifications` + worker                       |
| `Closed`             | Queued          | Bidding organization users, winning bid organization users                 | Goes through `Notifications` + worker                       |
| `Under_development`  | Queued          | Winning bid organization users                                             | Goes through `Notifications` + worker                       |
| `Bidding_expired`    | Queued          | Bidding organization users                                                 | Goes through `Notifications` + worker                       |
| `Winner_selected`    | Queued          | Winning bid organization users                                             | Goes through `Notifications` + worker                       |
| `Payment_pending`    | Queued          | Winning bid organization users                                             | Goes through `Notifications` + worker                       |
| `Completed`          | Queued          | Bidding organization users, winning bid organization users                 | Goes through `Notifications` + worker                       |
​
## Links

