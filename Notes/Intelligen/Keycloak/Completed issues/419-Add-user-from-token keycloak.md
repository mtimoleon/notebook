---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-08-25T16:28
tags:
  - intelligen
  - keycloak
status: completed
product: ScpCloud
component: Keycloak
---

- [x] Add claims into token  
- [ ] Use claims when adding user  
Planning.Api.Application.Commands.WorkspaceCommands  
- [ ] CreateWorkspaceWithSchedulingBoardCommandHandler  
- [ ] CreateWorkspaceSchedulingBoardExampleCommandHandler  
- [ ] CreateWorkspaceCommandHandler
   

|   |   |   |
|---|---|---|
|**ADMIN**|**PLANNING**|**TOKEN**|
|AddressLine|AddressLine||
|City|City||
||ConcurrencyToken||
|Country|Country|==Country==|
|Email|Email|==email==|
|FirstName|FirstName|==FirstName==|
|Id|||
|Industry|Industry||
|JobTitle|JobTitle|==JobTitle==|
|LastName|LastName|==LastName==|
|MiddleName|MiddleName||
|OrganizationName|OrganizationName|==OrganizationName==|
|OrganizationType|OrganizationType||
|OrganizationWebsite|OrganizationWebsite||
|PhoneNumber|PhoneNumber||
|RegistrationStatus|||
|==UserId==|==Id==|==sub==|
|ZipCode|ZipCode||
|||==isAdmin==|
||==Username==|==Username==|
|||exp|
|||iat|
|||auth_time|
|||jti|
|||iss|
|||aud|
|||typ|
|||azp|
|||nonce|
|||session_state|
|||allowed-origins|
|||scope|
|||sid|
   

  =="exp": 1756193794,==  
  =="iat": 1756191994,==
  =="auth_time": 1756191993,==
  =="jti": "3bcd115d-e68c-43c4-957f-2e4f7a4b221d",==
  =="iss": " https://localhost:28443/realms/ScpCloud",==
  =="aud": "scpCloud",==
  =="sub": "250819c2-20b0-4968-add1-6da32726bee3",==
  =="typ": "Bearer",==
  =="azp": "scpCloud",==
  =="nonce": "b3ff3719-6949-44e4-b605-f24d285de3d1",==
  =="session_state": "1997f359-a5c8-4d56-a907-a027f3a674d0",==
  =="allowed-origins": [==
    =="*"==
  ==],==
  =="scope": "openid",==
  =="sid": "1997f359-a5c8-4d56-a907-a027f3a674d0",==
  =="isAdmin": "true"==

Από < https://www.jwt.io/> 

	• Add attributes to token
		Αναφορά εδώ https://chatgpt.com/share/68ad8840-a270-8012-825f-ab2c99cc7283
	
		Έτσι όπως είναι τα attributes τώρα στην εφαρμογή είναι unamanged, δλδ ο κάθε user τα έχει κατά την ώρα που δημιουργείται από την admin εφαρμογή και δεν έχουμε user profile ενεργό στο keycloak
		
		Για να φανούν τα attributes των user στο token πρέπει να γίνουν map από το user.
		
		Για την εφαρμογή πηγαίνεις στο Clients/scpCloud/Client details και από εκεί
		επιλέγεις καρτέλα Client scopes  και από τη λίστα scpCloud-dedicated και μετά mappers. Εκει φτιάχνεις mappers για τα attributes. Δες πρώτα στα buildin αν υπάρχει κάτι έτοιμο.
		Έτοιμα είναι (πιθανόν να θέλουν κάποιες αλλαγές, email, firstName, lastName)
		
		Τελικό token:
		
		{
		  "exp": 1756206595,
		  "iat": 1756204795,
		  "auth_time": 1756191993,
		  "jti": "0397b0a8-2acd-4405-aed1-c3b3d25c2b86",
		  "iss": " https://localhost:28443/realms/ScpCloud",
		  "aud": "scpCloud",
		  "sub": "250819c2-20b0-4968-add1-6da32726bee3",
		  "typ": "Bearer",
		  "azp": "scpCloud",
		  "nonce": "2fa7bd35-2b31-4597-8d10-71e1a5970249",
		  "session_state": "1997f359-a5c8-4d56-a907-a027f3a674d0",
		  "allowed-origins": [
		    "*"
		  ],
		  "scope": "openid",
		  "sid": "1997f359-a5c8-4d56-a907-a027f3a674d0",
		  "lastName": "admin2-last-name",
		  "country": "admin2-country",
		  "firstName": "admin2-first-name",
		  "organizationName": "admin2-organization-name",
		  "jobTitle": "admin2-job-title",
		  "isAdmin": "true",
		  "email": "admin2@domain.com"
		}
		```
		
		Κανονικά θα χρειαστεί να φτιαχτούν και mappers για το ldap
	
Εδώ είναι το token ενός user που δεν έχει όλα τα attributes

{
  "exp": 1756206830,
  "iat": 1756205030,
  "auth_time": 1756205028,
  "jti": "eafce939-4a62-4e26-ad0f-89c51d2c5c24",
  "iss": " https://localhost:28443/realms/ScpCloud",
  "aud": "scpCloud",
  "sub": "c7834e89-74ff-42ae-a6d8-8693f24b1351",
  "typ": "Bearer",
  "azp": "scpCloud",
  "nonce": "adc483c1-3d7b-4b66-9e57-0fd5eecb530b",
  "session_state": "2a35c5f8-4b45-4b7d-a6e3-24418ba410d0",
  "allowed-origins": [
    "*"
  ],
  "scope": "openid",
  "sid": "2a35c5f8-4b45-4b7d-a6e3-24418ba410d0",
  "lastName": "user",
  "country": "user-country",
  "firstName": "user",
  "organizationName": "user-organization",
  "email": "user@domain.com"
}


> [!Warning] Warning
> Όταν δεν είναι τα attributes set στο user, δλδ δεν υπάρχουν, τότε δεν εμφανίζονται καθόλου στο token.

globalAdmin
organizationAdmin
organizationUser

Active directory or premises
globalAdmin = organizationAdmin

localAdmin 


{
	"id": "02f5feea-b45f-4f0e-8f87-c9e1f4e5e288",
	"name": "username",
	"protocol": "openid-connect",
	"protocolMapper": "oidc-usermodel-attribute-mapper", //This is not correct because it searches the user attributes
	"consentRequired": false,
	"config": {
		"user.attribute": "username",
		"claim.name": "preferred_username",
		"id.token.claim": "true",
		"access.token.claim": "true",
		"userinfo.token.claim": "true",
		"jsonType.label": "String"
	}
},
{
	"name": "preferred_username",
	"protocol": "openid-connect",
	"protocolMapper": "oidc-usermodel-property-mapper",  //This is the correct 
	"consentRequired": false,
	"config": {
		"user.attribute": "username",
		"claim.name": "preferred_username",
		"jsonType.label": "String",
		"id.token.claim": "true",
		"access.token.claim": "true",
		"userinfo.token.claim": "true"
	}
},

Για να περάσεις τις αλλαγές του realm.json σε ήδη υπάρχον έχεις τις παρακάτω επιλογές:
	1. Σβήσιμο βάσης keycloak (όχι καλό)
	2. explicetly import μέσω docker file
	3. Partial import μέσω keycloak UI (το δοκίμασα και δούλεψε)
	4. Ειδικό script γι αυτή την εργασία
https://chatgpt.com/share/68c9083e-6c5c-8012-8772-8e9528227f67


