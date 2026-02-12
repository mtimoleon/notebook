---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2024-01-25T10:15
tags:
  - intelligen
status: completed
product: ScpCloud
---

Admin registrations handling
 
- [x] -, submit -\> create keycloak user, create registration, send email to admin  
- [x] submitted, submit - Error  
- [x] approved, submit - Error  
- [x] rejected, submit - Error
 
- [x] submitted, approve -\> keycloak user enable and send email, approved, send event-\> create user command  
- [x] approved, approve - Error  
- [x] rejected, approve -\> keycloak user enable (should be with unverified email from rejection) and send email, approved
 
- [x] submitted, reject -\> keycloak user is already disabled with unverified email, rejected -  
- [x] approved, reject -\> keycloak disable and set email as unverified, rejected  
- [x] rejected, reject - Error
 
- [x] submitted, delete -\> delete keycloak user, remove registration  
- [x] approved, delete -\> delete keycloak user, remove registration, send delete event -\> delete user and data command  
- [x] rejected, delete -\> delete keycloak user, remove registration, send delete event -\> delete user and data command
   

- [x] Registration is submitted, resubmit not allowed  
- [x] Removing a registration should remove keycloak user and planning user
 
- [ ] Service to sync registrations to keycloak  
- [ ] Service to sync approved registrations to planning users
 
Edge cases  
- [ ] User created in keycloak after approval but email to verify email failed  
- [x] User created in keycloak after approval but email to verify email expired - keycloak takes care this  
- [ ] User submits registration, keycloak succeeds but db fails, cannot resubmit same data
 
Todo  
- [x] Write tests for commands triggered from events (in planning)  
- [x] Discuss other registration statuses liked suspended, blocked - will not do
 
==In delete user and data we do not take care of concurrency token==







