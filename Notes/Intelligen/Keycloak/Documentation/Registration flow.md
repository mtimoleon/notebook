---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
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
        private Guid GetUser()
        {
            string id = User.Claims.First(i =\> i.Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier").Value.ToString();
            return Guid.Parse(id);
        }
```

[https://github.com/keycloak/keycloak/blob/main/testsuite/integration-arquillian/tests/base/src/test/java/org/keycloak/testsuite/admin/UserTest.java#L304](https://github.com/keycloak/keycloak/blob/main/testsuite/integration-arquillian/tests/base/src/test/java/org/keycloak/testsuite/admin/UserTest.java#L304)