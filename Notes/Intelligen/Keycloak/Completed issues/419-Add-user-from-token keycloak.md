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

Ξ‘Ο€Ο < https://www.jwt.io/> 

	β€Ά Add attributes to token
		Ξ‘Ξ½Ξ±Ο†ΞΏΟΞ¬ ΞµΞ΄Ο https://chatgpt.com/share/68ad8840-a270-8012-825f-ab2c99cc7283
	
		ΞΟ„ΟƒΞΉ ΟΟ€Ο‰Ο‚ ΞµΞ―Ξ½Ξ±ΞΉ Ο„Ξ± attributes Ο„ΟΟΞ± ΟƒΟ„Ξ·Ξ½ ΞµΟ†Ξ±ΟΞΌΞΏΞ³Ξ® ΞµΞ―Ξ½Ξ±ΞΉ unamanged, Ξ΄Ξ»Ξ΄ ΞΏ ΞΊΞ¬ΞΈΞµ user Ο„Ξ± Ξ­Ο‡ΞµΞΉ ΞΊΞ±Ο„Ξ¬ Ο„Ξ·Ξ½ ΟΟΞ± Ο€ΞΏΟ… Ξ΄Ξ·ΞΌΞΉΞΏΟ…ΟΞ³ΞµΞ―Ο„Ξ±ΞΉ Ξ±Ο€Ο Ο„Ξ·Ξ½ admin ΞµΟ†Ξ±ΟΞΌΞΏΞ³Ξ® ΞΊΞ±ΞΉ Ξ΄ΞµΞ½ Ξ­Ο‡ΞΏΟ…ΞΌΞµ user profile ΞµΞ½ΞµΟΞ³Ο ΟƒΟ„ΞΏ keycloak
		
		Ξ“ΞΉΞ± Ξ½Ξ± Ο†Ξ±Ξ½ΞΏΟΞ½ Ο„Ξ± attributes Ο„Ο‰Ξ½ user ΟƒΟ„ΞΏ token Ο€ΟΞ­Ο€ΞµΞΉ Ξ½Ξ± Ξ³Ξ―Ξ½ΞΏΟ…Ξ½ map Ξ±Ο€Ο Ο„ΞΏ user.
		
		Ξ“ΞΉΞ± Ο„Ξ·Ξ½ ΞµΟ†Ξ±ΟΞΌΞΏΞ³Ξ® Ο€Ξ·Ξ³Ξ±Ξ―Ξ½ΞµΞΉΟ‚ ΟƒΟ„ΞΏ Clients/scpCloud/Client details ΞΊΞ±ΞΉ Ξ±Ο€Ο ΞµΞΊΞµΞ―
		ΞµΟ€ΞΉΞ»Ξ­Ξ³ΞµΞΉΟ‚ ΞΊΞ±ΟΟ„Ξ­Ξ»Ξ± Client scopes  ΞΊΞ±ΞΉ Ξ±Ο€Ο Ο„Ξ· Ξ»Ξ―ΟƒΟ„Ξ± scpCloud-dedicated ΞΊΞ±ΞΉ ΞΌΞµΟ„Ξ¬ mappers. Ξ•ΞΊΞµΞΉ Ο†Ο„ΞΉΞ¬Ο‡Ξ½ΞµΞΉΟ‚ mappers Ξ³ΞΉΞ± Ο„Ξ± attributes. Ξ”ΞµΟ‚ Ο€ΟΟΟ„Ξ± ΟƒΟ„Ξ± buildin Ξ±Ξ½ Ο…Ο€Ξ¬ΟΟ‡ΞµΞΉ ΞΊΞ¬Ο„ΞΉ Ξ­Ο„ΞΏΞΉΞΌΞΏ.
		ΞΟ„ΞΏΞΉΞΌΞ± ΞµΞ―Ξ½Ξ±ΞΉ (Ο€ΞΉΞΈΞ±Ξ½ΟΞ½ Ξ½Ξ± ΞΈΞ­Ξ»ΞΏΟ…Ξ½ ΞΊΞ¬Ο€ΞΏΞΉΞµΟ‚ Ξ±Ξ»Ξ»Ξ±Ξ³Ξ­Ο‚, email, firstName, lastName)
		
		Ξ¤ΞµΞ»ΞΉΞΊΟ token:
		
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
		
		ΞΞ±Ξ½ΞΏΞ½ΞΉΞΊΞ¬ ΞΈΞ± Ο‡ΟΞµΞΉΞ±ΟƒΟ„ΞµΞ― Ξ½Ξ± Ο†Ο„ΞΉΞ±Ο‡Ο„ΞΏΟΞ½ ΞΊΞ±ΞΉ mappers Ξ³ΞΉΞ± Ο„ΞΏ ldap
	
Ξ•Ξ΄Ο ΞµΞ―Ξ½Ξ±ΞΉ Ο„ΞΏ token ΞµΞ½ΟΟ‚ user Ο€ΞΏΟ… Ξ΄ΞµΞ½ Ξ­Ο‡ΞµΞΉ ΟΞ»Ξ± Ο„Ξ± attributes

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
> ΞΟ„Ξ±Ξ½ Ξ΄ΞµΞ½ ΞµΞ―Ξ½Ξ±ΞΉ Ο„Ξ± attributes set ΟƒΟ„ΞΏ user, Ξ΄Ξ»Ξ΄ Ξ΄ΞµΞ½ Ο…Ο€Ξ¬ΟΟ‡ΞΏΟ…Ξ½, Ο„ΟΟ„Ξµ Ξ΄ΞµΞ½ ΞµΞΌΟ†Ξ±Ξ½Ξ―Ξ¶ΞΏΞ½Ο„Ξ±ΞΉ ΞΊΞ±ΞΈΟΞ»ΞΏΟ… ΟƒΟ„ΞΏ token.

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

Ξ“ΞΉΞ± Ξ½Ξ± Ο€ΞµΟΞ¬ΟƒΞµΞΉΟ‚ Ο„ΞΉΟ‚ Ξ±Ξ»Ξ»Ξ±Ξ³Ξ­Ο‚ Ο„ΞΏΟ… realm.json ΟƒΞµ Ξ®Ξ΄Ξ· Ο…Ο€Ξ¬ΟΟ‡ΞΏΞ½ Ξ­Ο‡ΞµΞΉΟ‚ Ο„ΞΉΟ‚ Ο€Ξ±ΟΞ±ΞΊΞ¬Ο„Ο‰ ΞµΟ€ΞΉΞ»ΞΏΞ³Ξ­Ο‚:
	1. Ξ£Ξ²Ξ®ΟƒΞΉΞΌΞΏ Ξ²Ξ¬ΟƒΞ·Ο‚ keycloak (ΟΟ‡ΞΉ ΞΊΞ±Ξ»Ο)
	2. explicetly import ΞΌΞ­ΟƒΟ‰ docker file
	3. Partial import ΞΌΞ­ΟƒΟ‰ keycloak UI (Ο„ΞΏ Ξ΄ΞΏΞΊΞ―ΞΌΞ±ΟƒΞ± ΞΊΞ±ΞΉ Ξ΄ΞΏΟΞ»ΞµΟΞµ)
	4. Ξ•ΞΉΞ΄ΞΉΞΊΟ script Ξ³ΞΉ Ξ±Ο…Ο„Ξ® Ο„Ξ·Ξ½ ΞµΟΞ³Ξ±ΟƒΞ―Ξ±
https://chatgpt.com/share/68c9083e-6c5c-8012-8772-8e9528227f67






