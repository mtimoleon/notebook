---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2023-05-19T11:28
tags:
  - intelligen
  - keycloak
---

User registration flow
 - Introduce a new page for registration.
- User is entering registration data and a register request is issued to our BE
- An entry with registration data is created in users database
- Administrator gets an email with the new request and a link to perform automated approval or rejection
- Administrator can view all requests in a registration table and can approve or reject registration also from this table
- On registration approval a request to keycloak create user is performed
- Keycloak is set to send an email to verify user email
- After user email verification, user can use the app
  
```
Β Β Β Β Β Β Β Β privateΒ GuidΒ GetUser()
Β Β Β Β Β Β Β Β {
Β Β Β Β Β Β Β Β Β Β Β Β stringΒ idΒ =Β User.Claims.First(iΒ =\>Β i.TypeΒ ==Β "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier").Value.ToString();
Β Β Β Β Β Β Β Β Β Β Β Β returnΒ Guid.Parse(id);
Β Β Β Β Β Β Β Β }
```

[https://github.com/keycloak/keycloak/blob/main/testsuite/integration-arquillian/tests/base/src/test/java/org/keycloak/testsuite/admin/UserTest.java#L304](https://github.com/keycloak/keycloak/blob/main/testsuite/integration-arquillian/tests/base/src/test/java/org/keycloak/testsuite/admin/UserTest.java#L304)




