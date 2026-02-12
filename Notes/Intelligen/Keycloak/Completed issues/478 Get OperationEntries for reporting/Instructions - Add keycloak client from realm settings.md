---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-11-05T16:45
tags:
  - intelligen
  - keycloak
status: completed
product: ScpCloud
component: Keycloak
---

- Get into keycloak UI admin and select our realm
![Exported image](Exported%20image%2020260209140324-0.png)
 
- From the left menu select Realm settings
- You are viewing the ScpCloud realm settings page
- Up right corner select partial importοΏΌ
![Exported image](Exported%20image%2020260209140326-1.png)
 
- In the partial import modal, browse and find our οΏΌ..\scpCloud\volumes\keycloak\import\ScpCloud-realm.json
- Now select to import only clients and skip the existingοΏΌ
![Exported image](Exported%20image%2020260209140327-2.png)   - Now you should have a new client "develop-integration-api-service" in realm Clients. ![Exported image](Exported%20image%2020260209140328-3.png)



