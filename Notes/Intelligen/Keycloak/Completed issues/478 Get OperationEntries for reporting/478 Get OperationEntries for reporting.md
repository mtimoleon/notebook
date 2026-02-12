---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-10-31T08:54
tags:
  - intelligen
  - keycloak
status: completed
product: ScpCloud
component: Keycloak
---

```
{
  "exp": 1762334024,
  "iat": 1762332224,
  "jti": "f0a77b46-3f2c-45ae-a1d2-cfe3be01a7f8",
  "iss": "https://host.docker.internal:28443/realms/ScpCloud",
  "aud": [
    "scpCloud",
    "account"
  ],
  "sub": "bc2a72f4-d923-459a-be07-e37419516704",
  "typ": "Bearer",
  "azp": "integration-api-service",
  "allowed-origins": [
    "/*"
  ],
  "resource_access": {
    "account": {
      "roles": [
        "manage-account",
        "manage-account-links",
        "view-profile"
      ]
    }
  },
  "scope": "",
  "organizationId": "c7834e89-74ff-42ae-a6d8-8693f24b1351",
  "clientHost": "172.20.0.1",
  "clientAddress": "172.20.0.1",
  "client_id": "integration-api-service"
}
```
 
![Exported image](Exported%20image%2020260209140307-0.png) ![Exported image](Exported%20image%2020260209140309-1.png)                                                                                                                                                                                                                   

To Basic auth Ο€ΞΏΟ… Ο€ΟΞ­Ο€ΞµΞΉ Ξ½Ξ± Ξ΄ΟΟƒΞΏΟ…ΞΌΞµ ΟƒΟ„ΞΏΟ…Ο‚ customers ΞΈΞ± ΞµΞ―Ξ½Ξ±ΞΉ:  
Basic (base64)"serviec-client-name:service-client-secret"
 
Ξ‘Ξ»Ξ»Ξ±Ξ³Ξ­Ο‚ Ο€ΞΏΟ… Ο‡ΟΞµΞΉΞ¬Ξ¶ΞΏΞ½Ο„Ξ±ΞΉ Ξ³ΞΉΞ± Ο„ΞΏ production:  
- Setting in WebProductionBff to get keycloak base url for the request to get access token later  
- Setting in ProductionApi valid issuers (may not required), add the service token issuer

- **Add a new service account**

![Exported image](Exported%20image%2020260209140310-2.png)  
![Exported image](Exported%20image%2020260209140311-3.png)  
![Exported image](Exported%20image%2020260209140312-4.png)- **Add realm client scope**
![Exported image](Exported%20image%2020260209140313-5.png)- **In dedicated scope add mapper of a hardcoded claim**
![Exported image](Exported%20image%2020260209140315-6.png)  
![Exported image](Exported%20image%2020260209140321-7.png)  
- **Ξ“ΞΉΞ± claim value Ξ²Ξ¬Ξ¶ΞΏΟ…ΞΌΞµ Ο„ΞΏ id Ο„ΞΏΟ… admin Ξ³ΞΉΞ± Ο„ΞΏ develop. Ξ£Ο„ΞΏ production Ξ²Ξ¬Ξ¶ΞΏΟ…ΞΌΞµ Ο„ΞΏ id ΞµΞ½ΟΟ‚ user Ο„ΞΏΟ… ΞΏΟΞ³Ξ±Ξ½ΞΉΟƒΞΌΞΏΟ.**

![[478 Get OperationEntries for reporting - Ink.svg]]







