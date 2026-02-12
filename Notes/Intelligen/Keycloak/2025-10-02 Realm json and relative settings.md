---
categories:
  - "[[Work]]"
created: 2025-05-19T09:50
tags:
  - intelligen
  - keycloak
---

Export 2025-10-02
 
{  
Β Β "id": "ScpCloud",  
Β Β "realm": "ScpCloud",  
Β Β "displayName": "Schedule Pro Cloud",  
Β Β "displayNameHtml": "Schedule Pro Cloud",  
Β Β "notBefore": 0,  
Β Β "defaultSignatureAlgorithm": "RS256",  
Β Β "revokeRefreshToken": true,  
Β Β "refreshTokenMaxReuse": 1,  
Β Β "accessTokenLifespan": 1800,  
Β Β "accessTokenLifespanForImplicitFlow": 900,  
Β Β "ssoSessionIdleTimeout": 86400,  
Β Β "ssoSessionMaxLifespan": 86400,  
Β Β "ssoSessionIdleTimeoutRememberMe": 0,  
Β Β "ssoSessionMaxLifespanRememberMe": 0,  
Β Β "offlineSessionIdleTimeout": 2592000,  
Β Β "offlineSessionMaxLifespanEnabled": false,  
Β Β "offlineSessionMaxLifespan": 5184000,  
Β Β "clientSessionIdleTimeout": 0,  
Β Β "clientSessionMaxLifespan": 0,  
Β Β "clientOfflineSessionIdleTimeout": 0,  
Β Β "clientOfflineSessionMaxLifespan": 0,  
Β Β "accessCodeLifespan": 60,  
Β Β "accessCodeLifespanUserAction": 300,  
Β Β "accessCodeLifespanLogin": 1800,  
Β Β "actionTokenGeneratedByAdminLifespan": 604800,  
Β Β "actionTokenGeneratedByUserLifespan": 300,  
Β Β "oauth2DeviceCodeLifespan": 600,  
Β Β "oauth2DevicePollingInterval": 5,  
Β Β "enabled": true,  
Β Β "sslRequired": "none",  
Β Β "registrationAllowed": true,  
Β Β "registrationEmailAsUsername": false,  
Β Β "rememberMe": true,  
Β Β "verifyEmail": true,  
Β Β "loginWithEmailAllowed": true,  
Β Β "duplicateEmailsAllowed": false,  
Β Β "resetPasswordAllowed": true,  
Β Β "editUsernameAllowed": false,  
Β Β "bruteForceProtected": false,  
Β Β "permanentLockout": false,  
Β Β "maxFailureWaitSeconds": 900,  
Β Β "minimumQuickLoginWaitSeconds": 60,  
Β Β "waitIncrementSeconds": 60,  
Β Β "quickLoginCheckMilliSeconds": 1000,  
Β Β "maxDeltaTimeSeconds": 43200,  
Β Β "failureFactor": 30,  
Β Β "roles": {  
Β Β Β Β "realm": [  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "2720c15c-8bee-4781-b963-35a71ee21152",  
Β Β Β Β Β Β Β Β "name": "offline_access",  
Β Β Β Β Β Β Β Β "description": "${role_offline-access}",  
Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β "clientRole": false,  
Β Β Β Β Β Β Β Β "containerId": "ScpCloud",  
Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β },  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "3582d016-58d9-4555-9621-24bbe50ba746",  
Β Β Β Β Β Β Β Β "name": "default-roles-scpcloud",  
Β Β Β Β Β Β Β Β "description": "${role_default-roles}",  
Β Β Β Β Β Β Β Β "composite": true,  
Β Β Β Β Β Β Β Β "composites": {  
Β Β Β Β Β Β Β Β Β Β "realm": [  
Β Β Β Β Β Β Β Β Β Β Β Β "offline_access",  
Β Β Β Β Β Β Β Β Β Β Β Β "uma_authorization"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "client": {  
Β Β Β Β Β Β Β Β Β Β Β Β "account": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "view-profile",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "manage-account"  
Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β "clientRole": false,  
Β Β Β Β Β Β Β Β "containerId": "ScpCloud",  
Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β },  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "535008dc-832e-4700-97d8-cc15cea545ff",  
Β Β Β Β Β Β Β Β "name": "uma_authorization",  
Β Β Β Β Β Β Β Β "description": "${role_uma_authorization}",  
Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β "clientRole": false,  
Β Β Β Β Β Β Β Β "containerId": "ScpCloud",  
Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β }  
Β Β Β Β ],  
Β Β Β Β "client": {  
Β Β Β Β Β Β "realm-management": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "bbf8f7e7-2d52-43e2-a466-3d8f84deb00f",  
Β Β Β Β Β Β Β Β Β Β "name": "view-clients",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_view-clients}",  
Β Β Β Β Β Β Β Β Β Β "composite": true,  
Β Β Β Β Β Β Β Β Β Β "composites": {  
Β Β Β Β Β Β Β Β Β Β Β Β "client": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "realm-management": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "query-clients"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "00c16927-47f4-4802-a7fc-65a3ab1c8638",  
Β Β Β Β Β Β Β Β Β Β "name": "query-clients",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_query-clients}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "1cdaacca-7cfe-40b2-9695-51b051d6932b",  
Β Β Β Β Β Β Β Β Β Β "name": "view-users",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_view-users}",  
Β Β Β Β Β Β Β Β Β Β "composite": true,  
Β Β Β Β Β Β Β Β Β Β "composites": {  
Β Β Β Β Β Β Β Β Β Β Β Β "client": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "realm-management": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "query-groups",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "query-users"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "4cbd241f-a043-4deb-aba1-ca0d3b1d3a8c",  
Β Β Β Β Β Β Β Β Β Β "name": "manage-authorization",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_manage-authorization}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "c6433ffa-9c54-4c66-bdf7-ce3026796a1d",  
Β Β Β Β Β Β Β Β Β Β "name": "view-realm",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_view-realm}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "25d39955-6bb7-4a33-ad89-bc886f422b4e",  
Β Β Β Β Β Β Β Β Β Β "name": "query-users",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_query-users}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "ec6cd771-3599-47a7-8f15-093b498cd23b",  
Β Β Β Β Β Β Β Β Β Β "name": "create-client",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_create-client}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "f9ec89c5-7be6-4d75-a850-aa8928cb4c4f",  
Β Β Β Β Β Β Β Β Β Β "name": "manage-clients",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_manage-clients}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "431881eb-764b-4474-949a-daf2ca5dccc2",  
Β Β Β Β Β Β Β Β Β Β "name": "query-groups",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_query-groups}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "2dd2871d-5807-4c60-bd54-7d1b33cecdef",  
Β Β Β Β Β Β Β Β Β Β "name": "view-authorization",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_view-authorization}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "752dc232-21e0-45f9-9022-0f920328560a",  
Β Β Β Β Β Β Β Β Β Β "name": "view-identity-providers",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_view-identity-providers}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "308d44c1-7cf0-4916-aaa6-d0fffebcbb4e",  
Β Β Β Β Β Β Β Β Β Β "name": "view-events",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_view-events}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "095812f1-7186-4ce9-9ca2-254dc17f8df6",  
Β Β Β Β Β Β Β Β Β Β "name": "manage-events",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_manage-events}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "2f903b91-4ce6-4651-bb94-7d8eaaab6f90",  
Β Β Β Β Β Β Β Β Β Β "name": "manage-users",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_manage-users}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "28dc2c91-a30c-43e3-9b1f-ffbd8287dd74",  
Β Β Β Β Β Β Β Β Β Β "name": "impersonation",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_impersonation}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "a206d136-9816-4450-8bd6-c55dc6e78aa6",  
Β Β Β Β Β Β Β Β Β Β "name": "manage-realm",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_manage-realm}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "01160ec0-0ee6-4b6b-8a41-a31635de631a",  
Β Β Β Β Β Β Β Β Β Β "name": "realm-admin",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_realm-admin}",  
Β Β Β Β Β Β Β Β Β Β "composite": true,  
Β Β Β Β Β Β Β Β Β Β "composites": {  
Β Β Β Β Β Β Β Β Β Β Β Β "client": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "realm-management": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "view-clients",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "query-clients",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "view-users",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "manage-authorization",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "view-realm",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "query-users",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "create-client",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "manage-clients",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "query-groups",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "view-authorization",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "view-identity-providers",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "view-events",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "manage-events",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "manage-users",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "impersonation",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "manage-realm",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "query-realms",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "manage-identity-providers"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "88b4fdf1-0794-474f-9f79-7f6f07780479",  
Β Β Β Β Β Β Β Β Β Β "name": "query-realms",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_query-realms}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "2d2f7337-2041-42d4-ad97-afe691015d47",  
Β Β Β Β Β Β Β Β Β Β "name": "manage-identity-providers",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_manage-identity-providers}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "scpCloud": [],  
Β Β Β Β Β Β "scp-admin-service": [],  
Β Β Β Β Β Β "security-admin-console": [],  
Β Β Β Β Β Β "admin-cli": [],  
Β Β Β Β Β Β "account-console": [],  
Β Β Β Β Β Β "broker": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "8628877a-a20c-4311-a4bb-eba1bda55373",  
Β Β Β Β Β Β Β Β Β Β "name": "read-token",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_read-token}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "36017054-cfa8-4acc-a2a2-743768d969f1",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "account": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "928d10a4-7b97-4658-95bb-fc1673b9abcf",  
Β Β Β Β Β Β Β Β Β Β "name": "view-consent",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_view-consent}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "513e5d77-63cd-48d3-9f7a-dcb986d37210",  
Β Β Β Β Β Β Β Β Β Β "name": "delete-account",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_delete-account}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "95ce849f-7509-4cfb-9c08-a1af5d35841c",  
Β Β Β Β Β Β Β Β Β Β "name": "manage-consent",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_manage-consent}",  
Β Β Β Β Β Β Β Β Β Β "composite": true,  
Β Β Β Β Β Β Β Β Β Β "composites": {  
Β Β Β Β Β Β Β Β Β Β Β Β "client": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "account": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "view-consent"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "926a32c9-e618-49a5-9ae9-580997a1c8d6",  
Β Β Β Β Β Β Β Β Β Β "name": "view-profile",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_view-profile}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "c70d50ca-70e8-4a93-b9a9-8627b3e4b7b0",  
Β Β Β Β Β Β Β Β Β Β "name": "manage-account",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_manage-account}",  
Β Β Β Β Β Β Β Β Β Β "composite": true,  
Β Β Β Β Β Β Β Β Β Β "composites": {  
Β Β Β Β Β Β Β Β Β Β Β Β "client": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "account": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "manage-account-links"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "70939c91-dff4-426a-bcbb-1d836ced65ac",  
Β Β Β Β Β Β Β Β Β Β "name": "manage-account-links",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_manage-account-links}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "1cb015bc-b8b6-4b43-9435-9254569d0f0a",  
Β Β Β Β Β Β Β Β Β Β "name": "view-applications",  
Β Β Β Β Β Β Β Β Β Β "description": "${role_view-applications}",  
Β Β Β Β Β Β Β Β Β Β "composite": false,  
Β Β Β Β Β Β Β Β Β Β "clientRole": true,  
Β Β Β Β Β Β Β Β Β Β "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
Β Β Β Β Β Β Β Β Β Β "attributes": {}  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β }  
Β Β },  
Β Β "groups": [],  
Β Β "defaultRole": {  
Β Β Β Β "id": "3582d016-58d9-4555-9621-24bbe50ba746",  
Β Β Β Β "name": "default-roles-scpcloud",  
Β Β Β Β "description": "${role_default-roles}",  
Β Β Β Β "composite": true,  
Β Β Β Β "clientRole": false,  
Β Β Β Β "containerId": "ScpCloud"  
Β Β },  
Β Β "requiredCredentials": [  
Β Β Β Β "password"  
Β Β ],  
Β Β "otpPolicyType": "totp",  
Β Β "otpPolicyAlgorithm": "HmacSHA1",  
Β Β "otpPolicyInitialCounter": 0,  
Β Β "otpPolicyDigits": 6,  
Β Β "otpPolicyLookAheadWindow": 1,  
Β Β "otpPolicyPeriod": 30,  
Β Β "otpPolicyCodeReusable": false,  
Β Β "otpSupportedApplications": [  
Β Β Β Β "totpAppGoogleName",  
Β Β Β Β "totpAppFreeOTPName",  
Β Β Β Β "totpAppMicrosoftAuthenticatorName"  
Β Β ],  
Β Β "webAuthnPolicyRpEntityName": "keycloak",  
Β Β "webAuthnPolicySignatureAlgorithms": [  
Β Β Β Β "ES256"  
Β Β ],  
Β Β "webAuthnPolicyRpId": "",  
Β Β "webAuthnPolicyAttestationConveyancePreference": "not specified",  
Β Β "webAuthnPolicyAuthenticatorAttachment": "not specified",  
Β Β "webAuthnPolicyRequireResidentKey": "not specified",  
Β Β "webAuthnPolicyUserVerificationRequirement": "not specified",  
Β Β "webAuthnPolicyCreateTimeout": 0,  
Β Β "webAuthnPolicyAvoidSameAuthenticatorRegister": false,  
Β Β "webAuthnPolicyAcceptableAaguids": [],  
Β Β "webAuthnPolicyPasswordlessRpEntityName": "keycloak",  
Β Β "webAuthnPolicyPasswordlessSignatureAlgorithms": [  
Β Β Β Β "ES256"  
Β Β ],  
Β Β "webAuthnPolicyPasswordlessRpId": "",  
Β Β "webAuthnPolicyPasswordlessAttestationConveyancePreference": "not specified",  
Β Β "webAuthnPolicyPasswordlessAuthenticatorAttachment": "not specified",  
Β Β "webAuthnPolicyPasswordlessRequireResidentKey": "not specified",  
Β Β "webAuthnPolicyPasswordlessUserVerificationRequirement": "not specified",  
Β Β "webAuthnPolicyPasswordlessCreateTimeout": 0,  
Β Β "webAuthnPolicyPasswordlessAvoidSameAuthenticatorRegister": false,  
Β Β "webAuthnPolicyPasswordlessAcceptableAaguids": [],  
Β Β "users": [  
Β Β Β Β {  
Β Β Β Β Β Β "id": "3df22a99-7760-41b3-97fa-3318a75a8e92",  
Β Β Β Β Β Β "createdTimestamp": 1759320156624,  
Β Β Β Β Β Β "username": "service-account-scp-admin-service",  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "totp": false,  
Β Β Β Β Β Β "emailVerified": false,  
Β Β Β Β Β Β "serviceAccountClientId": "scp-admin-service",  
Β Β Β Β Β Β "disableableCredentialTypes": [],  
Β Β Β Β Β Β "requiredActions": [],  
Β Β Β Β Β Β "realmRoles": [  
Β Β Β Β Β Β Β Β "default-roles-scpcloud"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "notBefore": 0,  
Β Β Β Β Β Β "groups": []  
Β Β Β Β }  
Β Β ],  
Β Β "scopeMappings": [  
Β Β Β Β {  
Β Β Β Β Β Β "clientScope": "offline_access",  
Β Β Β Β Β Β "roles": [  
Β Β Β Β Β Β Β Β "offline_access"  
Β Β Β Β Β Β ]  
Β Β Β Β }  
Β Β ],  
Β Β "clients": [  
Β Β Β Β {  
Β Β Β Β Β Β "id": "99857312-8203-4b2e-ba45-7c9346898d5f",  
Β Β Β Β Β Β "clientId": "account",  
Β Β Β Β Β Β "name": "${client_account}",  
Β Β Β Β Β Β "rootUrl": "${authBaseUrl}",  
Β Β Β Β Β Β "baseUrl": "/realms/ScpCloud/account/",  
Β Β Β Β Β Β "surrogateAuthRequired": false,  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "alwaysDisplayInConsole": false,  
Β Β Β Β Β Β "clientAuthenticatorType": "client-secret",  
Β Β Β Β Β Β "redirectUris": [  
Β Β Β Β Β Β Β Β "/realms/ScpCloud/account/*"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "webOrigins": [],  
Β Β Β Β Β Β "notBefore": 0,  
Β Β Β Β Β Β "bearerOnly": false,  
Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β "standardFlowEnabled": true,  
Β Β Β Β Β Β "implicitFlowEnabled": false,  
Β Β Β Β Β Β "directAccessGrantsEnabled": false,  
Β Β Β Β Β Β "serviceAccountsEnabled": false,  
Β Β Β Β Β Β "publicClient": true,  
Β Β Β Β Β Β "frontchannelLogout": false,  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "post.logout.redirect.uris": "+"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "authenticationFlowBindingOverrides": {},  
Β Β Β Β Β Β "fullScopeAllowed": false,  
Β Β Β Β Β Β "nodeReRegistrationTimeout": 0,  
Β Β Β Β Β Β "defaultClientScopes": [  
Β Β Β Β Β Β Β Β "web-origins",  
Β Β Β Β Β Β Β Β "profile",  
Β Β Β Β Β Β Β Β "roles",  
Β Β Β Β Β Β Β Β "email"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "optionalClientScopes": [  
Β Β Β Β Β Β Β Β "address",  
Β Β Β Β Β Β Β Β "phone",  
Β Β Β Β Β Β Β Β "offline_access",  
Β Β Β Β Β Β Β Β "microprofile-jwt"  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "b15de58e-7862-4c14-aad3-8c9e765f8b6b",  
Β Β Β Β Β Β "clientId": "account-console",  
Β Β Β Β Β Β "name": "${client_account-console}",  
Β Β Β Β Β Β "rootUrl": "${authBaseUrl}",  
Β Β Β Β Β Β "baseUrl": "/realms/ScpCloud/account/",  
Β Β Β Β Β Β "surrogateAuthRequired": false,  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "alwaysDisplayInConsole": false,  
Β Β Β Β Β Β "clientAuthenticatorType": "client-secret",  
Β Β Β Β Β Β "redirectUris": [  
Β Β Β Β Β Β Β Β "/realms/ScpCloud/account/*"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "webOrigins": [],  
Β Β Β Β Β Β "notBefore": 0,  
Β Β Β Β Β Β "bearerOnly": false,  
Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β "standardFlowEnabled": true,  
Β Β Β Β Β Β "implicitFlowEnabled": false,  
Β Β Β Β Β Β "directAccessGrantsEnabled": false,  
Β Β Β Β Β Β "serviceAccountsEnabled": false,  
Β Β Β Β Β Β "publicClient": true,  
Β Β Β Β Β Β "frontchannelLogout": false,  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "post.logout.redirect.uris": "+",  
Β Β Β Β Β Β Β Β "pkce.code.challenge.method": "S256"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "authenticationFlowBindingOverrides": {},  
Β Β Β Β Β Β "fullScopeAllowed": false,  
Β Β Β Β Β Β "nodeReRegistrationTimeout": 0,  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "e849bacd-9110-45c6-83fd-0c090fad2c36",  
Β Β Β Β Β Β Β Β Β Β "name": "audience resolve",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-audience-resolve-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {}  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "defaultClientScopes": [  
Β Β Β Β Β Β Β Β "web-origins",  
Β Β Β Β Β Β Β Β "profile",  
Β Β Β Β Β Β Β Β "roles",  
Β Β Β Β Β Β Β Β "email"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "optionalClientScopes": [  
Β Β Β Β Β Β Β Β "address",  
Β Β Β Β Β Β Β Β "phone",  
Β Β Β Β Β Β Β Β "offline_access",  
Β Β Β Β Β Β Β Β "microprofile-jwt"  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "0cdbb35c-0471-46b7-bf35-8a01d9407081",  
Β Β Β Β Β Β "clientId": "admin-cli",  
Β Β Β Β Β Β "name": "${client_admin-cli}",  
Β Β Β Β Β Β "surrogateAuthRequired": false,  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "alwaysDisplayInConsole": false,  
Β Β Β Β Β Β "clientAuthenticatorType": "client-secret",  
Β Β Β Β Β Β "redirectUris": [],  
Β Β Β Β Β Β "webOrigins": [],  
Β Β Β Β Β Β "notBefore": 0,  
Β Β Β Β Β Β "bearerOnly": false,  
Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β "standardFlowEnabled": false,  
Β Β Β Β Β Β "implicitFlowEnabled": false,  
Β Β Β Β Β Β "directAccessGrantsEnabled": true,  
Β Β Β Β Β Β "serviceAccountsEnabled": false,  
Β Β Β Β Β Β "publicClient": true,  
Β Β Β Β Β Β "frontchannelLogout": false,  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "post.logout.redirect.uris": "+"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "authenticationFlowBindingOverrides": {},  
Β Β Β Β Β Β "fullScopeAllowed": false,  
Β Β Β Β Β Β "nodeReRegistrationTimeout": 0,  
Β Β Β Β Β Β "defaultClientScopes": [  
Β Β Β Β Β Β Β Β "web-origins",  
Β Β Β Β Β Β Β Β "profile",  
Β Β Β Β Β Β Β Β "roles",  
Β Β Β Β Β Β Β Β "email"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "optionalClientScopes": [  
Β Β Β Β Β Β Β Β "address",  
Β Β Β Β Β Β Β Β "phone",  
Β Β Β Β Β Β Β Β "offline_access",  
Β Β Β Β Β Β Β Β "microprofile-jwt"  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "36017054-cfa8-4acc-a2a2-743768d969f1",  
Β Β Β Β Β Β "clientId": "broker",  
Β Β Β Β Β Β "name": "${client_broker}",  
Β Β Β Β Β Β "surrogateAuthRequired": false,  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "alwaysDisplayInConsole": false,  
Β Β Β Β Β Β "clientAuthenticatorType": "client-secret",  
Β Β Β Β Β Β "redirectUris": [],  
Β Β Β Β Β Β "webOrigins": [],  
Β Β Β Β Β Β "notBefore": 0,  
Β Β Β Β Β Β "bearerOnly": true,  
Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β "standardFlowEnabled": true,  
Β Β Β Β Β Β "implicitFlowEnabled": false,  
Β Β Β Β Β Β "directAccessGrantsEnabled": false,  
Β Β Β Β Β Β "serviceAccountsEnabled": false,  
Β Β Β Β Β Β "publicClient": false,  
Β Β Β Β Β Β "frontchannelLogout": false,  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "post.logout.redirect.uris": "+"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "authenticationFlowBindingOverrides": {},  
Β Β Β Β Β Β "fullScopeAllowed": false,  
Β Β Β Β Β Β "nodeReRegistrationTimeout": 0,  
Β Β Β Β Β Β "defaultClientScopes": [  
Β Β Β Β Β Β Β Β "web-origins",  
Β Β Β Β Β Β Β Β "profile",  
Β Β Β Β Β Β Β Β "roles",  
Β Β Β Β Β Β Β Β "email"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "optionalClientScopes": [  
Β Β Β Β Β Β Β Β "address",  
Β Β Β Β Β Β Β Β "phone",  
Β Β Β Β Β Β Β Β "offline_access",  
Β Β Β Β Β Β Β Β "microprofile-jwt"  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
Β Β Β Β Β Β "clientId": "realm-management",  
Β Β Β Β Β Β "name": "${client_realm-management}",  
Β Β Β Β Β Β "surrogateAuthRequired": false,  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "alwaysDisplayInConsole": false,  
Β Β Β Β Β Β "clientAuthenticatorType": "client-secret",  
Β Β Β Β Β Β "redirectUris": [],  
Β Β Β Β Β Β "webOrigins": [],  
Β Β Β Β Β Β "notBefore": 0,  
Β Β Β Β Β Β "bearerOnly": true,  
Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β "standardFlowEnabled": true,  
Β Β Β Β Β Β "implicitFlowEnabled": false,  
Β Β Β Β Β Β "directAccessGrantsEnabled": false,  
Β Β Β Β Β Β "serviceAccountsEnabled": false,  
Β Β Β Β Β Β "publicClient": false,  
Β Β Β Β Β Β "frontchannelLogout": false,  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "post.logout.redirect.uris": "+"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "authenticationFlowBindingOverrides": {},  
Β Β Β Β Β Β "fullScopeAllowed": false,  
Β Β Β Β Β Β "nodeReRegistrationTimeout": 0,  
Β Β Β Β Β Β "defaultClientScopes": [  
Β Β Β Β Β Β Β Β "web-origins",  
Β Β Β Β Β Β Β Β "profile",  
Β Β Β Β Β Β Β Β "roles",  
Β Β Β Β Β Β Β Β "email"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "optionalClientScopes": [  
Β Β Β Β Β Β Β Β "address",  
Β Β Β Β Β Β Β Β "phone",  
Β Β Β Β Β Β Β Β "offline_access",  
Β Β Β Β Β Β Β Β "microprofile-jwt"  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "fb1f9c97-61cf-4c63-9908-348b3983b8c0",  
Β Β Β Β Β Β "clientId": "scp-admin-service",  
Β Β Β Β Β Β "name": "${client_scp-admin-service}",  
Β Β Β Β Β Β "description": "",  
Β Β Β Β Β Β "rootUrl": "",  
Β Β Β Β Β Β "adminUrl": "",  
Β Β Β Β Β Β "baseUrl": "",  
Β Β Β Β Β Β "surrogateAuthRequired": false,  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "alwaysDisplayInConsole": true,  
Β Β Β Β Β Β "clientAuthenticatorType": "client-secret",  
Β Β Β Β Β Β "secret": "**********",  
Β Β Β Β Β Β "redirectUris": [  
Β Β Β Β Β Β Β Β "/*"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "webOrigins": [  
Β Β Β Β Β Β Β Β "/*"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "notBefore": 0,  
Β Β Β Β Β Β "bearerOnly": false,  
Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β "standardFlowEnabled": true,  
Β Β Β Β Β Β "implicitFlowEnabled": false,  
Β Β Β Β Β Β "directAccessGrantsEnabled": false,  
Β Β Β Β Β Β "serviceAccountsEnabled": true,  
Β Β Β Β Β Β "publicClient": false,  
Β Β Β Β Β Β "frontchannelLogout": true,  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "oidc.ciba.grant.enabled": "false",  
Β Β Β Β Β Β Β Β "client.secret.creation.time": "1693898402",  
Β Β Β Β Β Β Β Β "backchannel.logout.session.required": "true",  
Β Β Β Β Β Β Β Β "post.logout.redirect.uris": "+",  
Β Β Β Β Β Β Β Β "oauth2.device.authorization.grant.enabled": "false",  
Β Β Β Β Β Β Β Β "backchannel.logout.revoke.offline.tokens": "false"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "authenticationFlowBindingOverrides": {},  
Β Β Β Β Β Β "fullScopeAllowed": true,  
Β Β Β Β Β Β "nodeReRegistrationTimeout": -1,  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "3f6a23ad-86d0-4013-9e3f-dc2871a4f189",  
Β Β Β Β Β Β Β Β Β Β "name": "Client Host",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usersessionmodel-note-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "user.session.note": "clientHost",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "clientHost",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "c85eaf7a-82ec-438b-93b7-ab22b25098ea",  
Β Β Β Β Β Β Β Β Β Β "name": "Client IP Address",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usersessionmodel-note-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "user.session.note": "clientAddress",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "clientAddress",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "29cd1180-8dec-4f58-b142-9f58c03b58ec",  
Β Β Β Β Β Β Β Β Β Β "name": "Client ID",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usersessionmodel-note-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "user.session.note": "client_id",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "client_id",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "defaultClientScopes": [  
Β Β Β Β Β Β Β Β "web-origins",  
Β Β Β Β Β Β Β Β "profile",  
Β Β Β Β Β Β Β Β "roles",  
Β Β Β Β Β Β Β Β "email"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "optionalClientScopes": [  
Β Β Β Β Β Β Β Β "address",  
Β Β Β Β Β Β Β Β "phone",  
Β Β Β Β Β Β Β Β "offline_access",  
Β Β Β Β Β Β Β Β "microprofile-jwt"  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "5624a877-0ee6-4f02-bba3-6657aa062db2",  
Β Β Β Β Β Β "clientId": "scpCloud",  
Β Β Β Β Β Β "name": "",  
Β Β Β Β Β Β "description": "",  
Β Β Β Β Β Β "rootUrl": "",  
Β Β Β Β Β Β "adminUrl": "",  
Β Β Β Β Β Β "baseUrl": "",  
Β Β Β Β Β Β "surrogateAuthRequired": false,  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "alwaysDisplayInConsole": false,  
Β Β Β Β Β Β "clientAuthenticatorType": "client-secret",  
Β Β Β Β Β Β "redirectUris": [  
Β Β Β Β Β Β Β Β "*"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "webOrigins": [  
Β Β Β Β Β Β Β Β "*"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "notBefore": 0,  
Β Β Β Β Β Β "bearerOnly": false,  
Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β "standardFlowEnabled": true,  
Β Β Β Β Β Β "implicitFlowEnabled": false,  
Β Β Β Β Β Β "directAccessGrantsEnabled": false,  
Β Β Β Β Β Β "serviceAccountsEnabled": false,  
Β Β Β Β Β Β "publicClient": true,  
Β Β Β Β Β Β "frontchannelLogout": false,  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "saml.force.post.binding": "false",  
Β Β Β Β Β Β Β Β "saml.multivalued.roles": "false",  
Β Β Β Β Β Β Β Β "post.logout.redirect.uris": "+",  
Β Β Β Β Β Β Β Β "oauth2.device.authorization.grant.enabled": "false",  
Β Β Β Β Β Β Β Β "backchannel.logout.revoke.offline.tokens": "false",  
Β Β Β Β Β Β Β Β "saml.server.signature.keyinfo.ext": "false",  
Β Β Β Β Β Β Β Β "use.refresh.tokens": "true",  
Β Β Β Β Β Β Β Β "oidc.ciba.grant.enabled": "false",  
Β Β Β Β Β Β Β Β "backchannel.logout.session.required": "true",  
Β Β Β Β Β Β Β Β "client_credentials.use_refresh_token": "false",  
Β Β Β Β Β Β Β Β "require.pushed.authorization.requests": "false",  
Β Β Β Β Β Β Β Β "saml.client.signature": "false",  
Β Β Β Β Β Β Β Β "pkce.code.challenge.method": "S256",  
Β Β Β Β Β Β Β Β "id.token.as.detached.signature": "false",  
Β Β Β Β Β Β Β Β "saml.assertion.signature": "false",  
Β Β Β Β Β Β Β Β "saml.encrypt": "false",  
Β Β Β Β Β Β Β Β "saml.server.signature": "false",  
Β Β Β Β Β Β Β Β "exclude.session.state.from.auth.response": "false",  
Β Β Β Β Β Β Β Β "saml.artifact.binding": "false",  
Β Β Β Β Β Β Β Β "saml_force_name_id_format": "false",  
Β Β Β Β Β Β Β Β "tls.client.certificate.bound.access.tokens": "false",  
Β Β Β Β Β Β Β Β "saml.authnstatement": "false",  
Β Β Β Β Β Β Β Β "display.on.consent.screen": "false",  
Β Β Β Β Β Β Β Β "saml.onetimeuse.condition": "false"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "authenticationFlowBindingOverrides": {},  
Β Β Β Β Β Β "fullScopeAllowed": false,  
Β Β Β Β Β Β "nodeReRegistrationTimeout": -1,  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "cf6ef27a-ac36-43ad-9618-420beaecf857",  
Β Β Β Β Β Β Β Β Β Β "name": "organizationName",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "organizationName",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "organizationName",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "9b0071ae-6813-4406-b898-cd3c651b83b9",  
Β Β Β Β Β Β Β Β Β Β "name": "family name",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "aggregate.attrs": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "multivalued": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "lastName",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "lastName",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "16333f32-af7a-4f22-8ceb-467a9996433b",  
Β Β Β Β Β Β Β Β Β Β "name": "jobTitle",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "aggregate.attrs": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "multivalued": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "jobTitle",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "jobTitle",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "46d373bb-93a9-447f-b8b3-79295c554914",  
Β Β Β Β Β Β Β Β Β Β "name": "preferred_username",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-property-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "username",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "username",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "fe6e431d-d4bf-44ac-8584-3b845553118b",  
Β Β Β Β Β Β Β Β Β Β "name": "given name",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "aggregate.attrs": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "multivalued": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "firstName",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "firstName",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "f57feba2-8bcd-4ec7-8b63-ca8ef7efc83d",  
Β Β Β Β Β Β Β Β Β Β "name": "isAdmin",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "isAdmin",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "isAdmin",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "c2b63249-7106-4caf-8c02-b85f9aabe764",  
Β Β Β Β Β Β Β Β Β Β "name": "email",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "email",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "email",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "c20e9135-5d2d-4921-a969-cd0d4e0737bb",  
Β Β Β Β Β Β Β Β Β Β "name": "country",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "aggregate.attrs": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "multivalued": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "country",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "country",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "defaultClientScopes": [  
Β Β Β Β Β Β Β Β "web-origins",  
Β Β Β Β Β Β Β Β "scpCloud-client-scope",  
Β Β Β Β Β Β Β Β "profile",  
Β Β Β Β Β Β Β Β "roles",  
Β Β Β Β Β Β Β Β "email"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "optionalClientScopes": [  
Β Β Β Β Β Β Β Β "address",  
Β Β Β Β Β Β Β Β "phone",  
Β Β Β Β Β Β Β Β "offline_access",  
Β Β Β Β Β Β Β Β "microprofile-jwt"  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "8c926e37-bb78-42f7-870c-5341730427a2",  
Β Β Β Β Β Β "clientId": "security-admin-console",  
Β Β Β Β Β Β "name": "${client_security-admin-console}",  
Β Β Β Β Β Β "rootUrl": "${authAdminUrl}",  
Β Β Β Β Β Β "baseUrl": "/admin/ScpCloud/console/",  
Β Β Β Β Β Β "surrogateAuthRequired": false,  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "alwaysDisplayInConsole": false,  
Β Β Β Β Β Β "clientAuthenticatorType": "client-secret",  
Β Β Β Β Β Β "redirectUris": [  
Β Β Β Β Β Β Β Β "/admin/ScpCloud/console/*"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "webOrigins": [  
Β Β Β Β Β Β Β Β "+"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "notBefore": 0,  
Β Β Β Β Β Β "bearerOnly": false,  
Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β "standardFlowEnabled": true,  
Β Β Β Β Β Β "implicitFlowEnabled": false,  
Β Β Β Β Β Β "directAccessGrantsEnabled": false,  
Β Β Β Β Β Β "serviceAccountsEnabled": false,  
Β Β Β Β Β Β "publicClient": true,  
Β Β Β Β Β Β "frontchannelLogout": false,  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "post.logout.redirect.uris": "+",  
Β Β Β Β Β Β Β Β "pkce.code.challenge.method": "S256"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "authenticationFlowBindingOverrides": {},  
Β Β Β Β Β Β "fullScopeAllowed": false,  
Β Β Β Β Β Β "nodeReRegistrationTimeout": 0,  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "e6b5a475-d7c8-4ca7-8b3d-9feb4c56a5be",  
Β Β Β Β Β Β Β Β Β Β "name": "locale",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "locale",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "locale",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "defaultClientScopes": [  
Β Β Β Β Β Β Β Β "web-origins",  
Β Β Β Β Β Β Β Β "profile",  
Β Β Β Β Β Β Β Β "roles",  
Β Β Β Β Β Β Β Β "email"  
Β Β Β Β Β Β ],  
Β Β Β Β Β Β "optionalClientScopes": [  
Β Β Β Β Β Β Β Β "address",  
Β Β Β Β Β Β Β Β "phone",  
Β Β Β Β Β Β Β Β "offline_access",  
Β Β Β Β Β Β Β Β "microprofile-jwt"  
Β Β Β Β Β Β ]  
Β Β Β Β }  
Β Β ],  
Β Β "clientScopes": [  
Β Β Β Β {  
Β Β Β Β Β Β "id": "4d5891b2-4e28-4d54-9035-5c1ab92bf2bd",  
Β Β Β Β Β Β "name": "profile",  
Β Β Β Β Β Β "description": "OpenID Connect built-in scope: profile",  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "include.in.token.scope": "false",  
Β Β Β Β Β Β Β Β "display.on.consent.screen": "true",  
Β Β Β Β Β Β Β Β "consent.screen.text": "${profileScopeConsentText}"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "1c3e74cb-7498-4d88-9f97-c804aa3d7286",  
Β Β Β Β Β Β Β Β Β Β "name": "profile",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "profile",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "profile",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "6e8b07df-459d-414a-95be-e4a4d48bc0c0",  
Β Β Β Β Β Β Β Β Β Β "name": "zoneinfo",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "zoneinfo",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "zoneinfo",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "923ffd9a-567c-4f20-82b1-2ed2d1080165",  
Β Β Β Β Β Β Β Β Β Β "name": "gender",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "gender",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "gender",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "0a293c18-c85c-4b28-9ac1-3071a06188e8",  
Β Β Β Β Β Β Β Β Β Β "name": "locale",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "locale",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "locale",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "71dd6414-77a0-4748-bdbe-02616ca52351",  
Β Β Β Β Β Β Β Β Β Β "name": "picture",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "picture",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "picture",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "8d8568be-27a4-49db-833b-c5a4588aa97c",  
Β Β Β Β Β Β Β Β Β Β "name": "given name",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-property-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "firstName",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "given_name",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "547d0476-3441-4511-8b83-0804018d952e",  
Β Β Β Β Β Β Β Β Β Β "name": "nickname",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "nickname",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "nickname",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "473f9dc2-6ad8-477c-b8a3-4abdc4991e60",  
Β Β Β Β Β Β Β Β Β Β "name": "family name",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-property-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "lastName",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "family_name",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "acfe2bd5-11bb-4c0d-83b5-3327445bf33e",  
Β Β Β Β Β Β Β Β Β Β "name": "full name",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-full-name-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "9587f889-360e-430f-b716-7bf9786efd2a",  
Β Β Β Β Β Β Β Β Β Β "name": "birthdate",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "birthdate",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "birthdate",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "24275dee-5206-48b8-8f2d-ea16b66c478d",  
Β Β Β Β Β Β Β Β Β Β "name": "username",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-property-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "username",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "preferred_username",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "55d994a7-2503-44e5-a385-4e7b7a0b0a58",  
Β Β Β Β Β Β Β Β Β Β "name": "website",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "website",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "website",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "4f3a00a7-40be-4dbb-a25e-64b5bf849a80",  
Β Β Β Β Β Β Β Β Β Β "name": "middle name",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "middleName",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "middle_name",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "c4bf400f-a66d-484a-b8b4-0078f7fe11cf",  
Β Β Β Β Β Β Β Β Β Β "name": "updated at",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "updatedAt",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "updated_at",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "353e8b94-c3d5-4a50-82e1-dc3f1a0b61c6",  
Β Β Β Β Β Β "name": "scpCloud-client-scope",  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "include.in.token.scope": "false",  
Β Β Β Β Β Β Β Β "display.on.consent.screen": "true"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "72f0ab18-3ed1-4d0f-bbf1-17aac1eddb6d",  
Β Β Β Β Β Β Β Β Β Β "name": "audience",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-audience-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "included.client.audience": "scpCloud",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "false"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "097fe1b3-8aa1-4355-bcc0-99012dd53652",  
Β Β Β Β Β Β Β Β Β Β "name": "User_ID",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "aggregate.attrs": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "multivalued": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "LDAP_ID",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "userId",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "298af755-eadf-4401-866d-195db312083e",  
Β Β Β Β Β Β Β Β Β Β "name": "User_groups",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-group-membership-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "full.path": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "multivalued": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "groups"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "c38c2232-7962-4df7-b476-0fe1932305f8",  
Β Β Β Β Β Β "name": "web-origins",  
Β Β Β Β Β Β "description": "OpenID Connect scope for add allowed web origins to the access token",  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "include.in.token.scope": "false",  
Β Β Β Β Β Β Β Β "display.on.consent.screen": "false",  
Β Β Β Β Β Β Β Β "consent.screen.text": ""  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "6906b64d-1ef6-4637-96f7-8a8c35142af2",  
Β Β Β Β Β Β Β Β Β Β "name": "allowed web origins",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-allowed-origins-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {}  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "5016c776-4e4e-40ec-9685-927a03d5d5c2",  
Β Β Β Β Β Β "name": "offline_access",  
Β Β Β Β Β Β "description": "OpenID Connect built-in scope: offline_access",  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "consent.screen.text": "${offlineAccessScopeConsentText}",  
Β Β Β Β Β Β Β Β "display.on.consent.screen": "true"  
Β Β Β Β Β Β }  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "bad369f7-5367-45d1-aa26-9a777b782672",  
Β Β Β Β Β Β "name": "roles",  
Β Β Β Β Β Β "description": "OpenID Connect scope for add user roles to the access token",  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "include.in.token.scope": "false",  
Β Β Β Β Β Β Β Β "display.on.consent.screen": "true",  
Β Β Β Β Β Β Β Β "gui.order": "",  
Β Β Β Β Β Β Β Β "consent.screen.text": "${rolesScopeConsentText}"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "5b29ac40-2f85-400b-ae7b-6567da4ebaea",  
Β Β Β Β Β Β Β Β Β Β "name": "audience resolve",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-audience-resolve-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {}  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "72df4f7b-5e2e-40af-8623-f8253838ef04",  
Β Β Β Β Β Β Β Β Β Β "name": "client roles",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-client-role-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "multivalued": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "foo",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "resource_access.${client_id}.roles",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "08b23f06-a039-4315-8db5-735207c033c0",  
Β Β Β Β Β Β Β Β Β Β "name": "realm roles",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-realm-role-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "multivalued": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "foo",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "realm_access.roles",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "04edf013-73c5-40b2-a4f3-a53978be74c7",  
Β Β Β Β Β Β "name": "phone",  
Β Β Β Β Β Β "description": "OpenID Connect built-in scope: phone",  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "include.in.token.scope": "false",  
Β Β Β Β Β Β Β Β "display.on.consent.screen": "true",  
Β Β Β Β Β Β Β Β "consent.screen.text": "${phoneScopeConsentText}"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "13ee797a-f312-42f5-8223-220e5becd745",  
Β Β Β Β Β Β Β Β Β Β "name": "phone number verified",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "phoneNumberVerified",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "phone_number_verified",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "boolean"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "bd9550e5-613d-4691-a17a-8ae8f6f6e4b4",  
Β Β Β Β Β Β Β Β Β Β "name": "phone number",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "phoneNumber",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "phone_number",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "d42d5ff8-74b4-49b4-8342-6ad4df4b1b4f",  
Β Β Β Β Β Β "name": "role_list",  
Β Β Β Β Β Β "description": "SAML role list",  
Β Β Β Β Β Β "protocol": "saml",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "consent.screen.text": "${samlRoleListScopeConsentText}",  
Β Β Β Β Β Β Β Β "display.on.consent.screen": "true"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "e43e30f8-8b98-43a3-8946-4c1b573eb6cf",  
Β Β Β Β Β Β Β Β Β Β "name": "role list",  
Β Β Β Β Β Β Β Β Β Β "protocol": "saml",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "saml-role-list-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "single": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "attribute.nameformat": "Basic",  
Β Β Β Β Β Β Β Β Β Β Β Β "attribute.name": "Role"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "edf2dc67-df58-4f9c-8401-77031cc7f340",  
Β Β Β Β Β Β "name": "email",  
Β Β Β Β Β Β "description": "OpenID Connect built-in scope: email",  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "include.in.token.scope": "false",  
Β Β Β Β Β Β Β Β "display.on.consent.screen": "true",  
Β Β Β Β Β Β Β Β "consent.screen.text": "${emailScopeConsentText}"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "07b40387-335f-4b02-bb1a-dd11ac56bd32",  
Β Β Β Β Β Β Β Β Β Β "name": "email verified",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-property-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "emailVerified",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "email_verified",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "boolean"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "ffe8a165-fdb4-48d8-b259-8f3e770755ee",  
Β Β Β Β Β Β Β Β Β Β "name": "email",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-property-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "email",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "email",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "e9137f0a-edc4-4896-be5e-1c742ac5107e",  
Β Β Β Β Β Β "name": "address",  
Β Β Β Β Β Β "description": "OpenID Connect built-in scope: address",  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "include.in.token.scope": "false",  
Β Β Β Β Β Β Β Β "display.on.consent.screen": "true",  
Β Β Β Β Β Β Β Β "consent.screen.text": "${addressScopeConsentText}"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "3d193e7a-0d9b-4ac4-a894-5e2aed2df7ca",  
Β Β Β Β Β Β Β Β Β Β "name": "address",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-address-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute.formatted": "formatted",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute.country": "country",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute.postal_code": "postal_code",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute.street": "street",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute.region": "region",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute.locality": "locality"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "30f8384b-8c6c-4397-8278-d34010b9ed73",  
Β Β Β Β Β Β "name": "microprofile-jwt",  
Β Β Β Β Β Β "description": "Microprofile - JWT built-in scope",  
Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β "attributes": {  
Β Β Β Β Β Β Β Β "include.in.token.scope": "false",  
Β Β Β Β Β Β Β Β "display.on.consent.screen": "false"  
Β Β Β Β Β Β },  
Β Β Β Β Β Β "protocolMappers": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "c46917f9-180c-4563-a683-0aada80950b1",  
Β Β Β Β Β Β Β Β Β Β "name": "groups",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-realm-role-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "multivalued": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "foo",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "groups",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "id": "8c191e6d-a85c-40e6-8c48-93a69fa5ecbb",  
Β Β Β Β Β Β Β Β Β Β "name": "upn",  
Β Β Β Β Β Β Β Β Β Β "protocol": "openid-connect",  
Β Β Β Β Β Β Β Β Β Β "protocolMapper": "oidc-usermodel-property-mapper",  
Β Β Β Β Β Β Β Β Β Β "consentRequired": false,  
Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β "userinfo.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "user.attribute": "username",  
Β Β Β Β Β Β Β Β Β Β Β Β "id.token.claim": "true",  
Β Β Β Β Β Β Β Β Β Β Β Β "access.token.claim": "false",  
Β Β Β Β Β Β Β Β Β Β Β Β "claim.name": "upn",  
Β Β Β Β Β Β Β Β Β Β Β Β "jsonType.label": "String"  
Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β }  
Β Β ],  
Β Β "defaultDefaultClientScopes": [  
Β Β Β Β "profile",  
Β Β Β Β "roles",  
Β Β Β Β "web-origins",  
Β Β Β Β "role_list",  
Β Β Β Β "email"  
Β Β ],  
Β Β "defaultOptionalClientScopes": [  
Β Β Β Β "phone",  
Β Β Β Β "microprofile-jwt",  
Β Β Β Β "offline_access",  
Β Β Β Β "address"  
Β Β ],  
Β Β "browserSecurityHeaders": {  
Β Β Β Β "contentSecurityPolicyReportOnly": "",  
Β Β Β Β "xContentTypeOptions": "nosniff",  
Β Β Β Β "referrerPolicy": "no-referrer",  
Β Β Β Β "xRobotsTag": "none",  
Β Β Β Β "xFrameOptions": "SAMEORIGIN",  
Β Β Β Β "contentSecurityPolicy": "frame-src 'self'; frame-ancestors 'self'; object-src 'none';",  
Β Β Β Β "xXSSProtection": "1; mode=block",  
Β Β Β Β "strictTransportSecurity": ""  
Β Β },  
Β Β "smtpServer": {  
Β Β Β Β "replyToDisplayName": "scp-cloud@intelligen.com",  
Β Β Β Β "starttls": "true",  
Β Β Β Β "auth": "true",  
Β Β Β Β "envelopeFrom": "scp-cloud@intelligen.com",  
Β Β Β Β "ssl": "false",  
Β Β Β Β "password": "**********",  
Β Β Β Β "port": "587",  
Β Β Β Β "host": "smtp.mail.yahoo.com",  
Β Β Β Β "replyTo": "scp-cloud@intelligen.com",  
Β Β Β Β "from": "scp-cloud@intelligen.com",  
Β Β Β Β "fromDisplayName": "Scp Cloud App",  
Β Β Β Β "user": "scp-cloud@intelligen.com"  
Β Β },  
Β Β "loginTheme": "scpCloud",  
Β Β "accountTheme": "",  
Β Β "adminTheme": "",  
Β Β "emailTheme": "scpCloud",  
Β Β "eventsEnabled": false,  
Β Β "eventsListeners": [  
Β Β Β Β "jboss-logging"  
Β Β ],  
Β Β "enabledEventTypes": [],  
Β Β "adminEventsEnabled": false,  
Β Β "adminEventsDetailsEnabled": false,  
Β Β "identityProviders": [],  
Β Β "identityProviderMappers": [],  
Β Β "components": {  
Β Β Β Β "org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy": [  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "3cee9da5-89ac-4da1-aa41-711c69e3f71b",  
Β Β Β Β Β Β Β Β "name": "Full Scope Disabled",  
Β Β Β Β Β Β Β Β "providerId": "scope",  
Β Β Β Β Β Β Β Β "subType": "anonymous",  
Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β "config": {}  
Β Β Β Β Β Β },  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "ae350135-ef8f-4ac3-95ca-d7a2ee11d13b",  
Β Β Β Β Β Β Β Β "name": "Consent Required",  
Β Β Β Β Β Β Β Β "providerId": "consent-required",  
Β Β Β Β Β Β Β Β "subType": "anonymous",  
Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β "config": {}  
Β Β Β Β Β Β },  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "f17eabf3-3815-488b-b832-2963912afe29",  
Β Β Β Β Β Β Β Β "name": "Allowed Client Scopes",  
Β Β Β Β Β Β Β Β "providerId": "allowed-client-templates",  
Β Β Β Β Β Β Β Β "subType": "anonymous",  
Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β "allow-default-scopes": [  
Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β },  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "ae6f7177-3195-466b-a785-1b8803f37f92",  
Β Β Β Β Β Β Β Β "name": "Allowed Protocol Mapper Types",  
Β Β Β Β Β Β Β Β "providerId": "allowed-protocol-mappers",  
Β Β Β Β Β Β Β Β "subType": "authenticated",  
Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β "allowed-protocol-mapper-types": [  
Β Β Β Β Β Β Β Β Β Β Β Β "oidc-sha256-pairwise-sub-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "oidc-address-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "saml-user-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "oidc-usermodel-property-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "saml-role-list-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "saml-user-property-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "oidc-full-name-mapper"  
Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β },  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "c6d55cc5-d105-4ac5-afb7-dbd18b28a825",  
Β Β Β Β Β Β Β Β "name": "Trusted Hosts",  
Β Β Β Β Β Β Β Β "providerId": "trusted-hosts",  
Β Β Β Β Β Β Β Β "subType": "anonymous",  
Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β "host-sending-registration-request-must-match": [  
Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "client-uris-must-match": [  
Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β },  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "a84dabca-c335-449c-8775-b75ac420a60a",  
Β Β Β Β Β Β Β Β "name": "Allowed Protocol Mapper Types",  
Β Β Β Β Β Β Β Β "providerId": "allowed-protocol-mappers",  
Β Β Β Β Β Β Β Β "subType": "anonymous",  
Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β "allowed-protocol-mapper-types": [  
Β Β Β Β Β Β Β Β Β Β Β Β "saml-user-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "saml-role-list-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "oidc-usermodel-attribute-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "oidc-sha256-pairwise-sub-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "saml-user-property-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "oidc-usermodel-property-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "oidc-full-name-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β "oidc-address-mapper"  
Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β },  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "fb7f494f-b0e5-4b95-bd9b-72a5e3aa76fc",  
Β Β Β Β Β Β Β Β "name": "Max Clients Limit",  
Β Β Β Β Β Β Β Β "providerId": "max-clients",  
Β Β Β Β Β Β Β Β "subType": "anonymous",  
Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β "max-clients": [  
Β Β Β Β Β Β Β Β Β Β Β Β "200"  
Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β },  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "a62dcdbc-fed1-4ba0-8876-b1c97738e9c5",  
Β Β Β Β Β Β Β Β "name": "Allowed Client Scopes",  
Β Β Β Β Β Β Β Β "providerId": "allowed-client-templates",  
Β Β Β Β Β Β Β Β "subType": "authenticated",  
Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β "allow-default-scopes": [  
Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β }  
Β Β Β Β ],  
Β Β Β Β "org.keycloak.storage.UserStorageProvider": [  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "591e353f-455d-4272-8cf7-0fc37e7f5578",  
Β Β Β Β Β Β Β Β "name": "ldap",  
Β Β Β Β Β Β Β Β "providerId": "ldap",  
Β Β Β Β Β Β Β Β "subComponents": {  
Β Β Β Β Β Β Β Β Β Β "org.keycloak.storage.ldap.mappers.LDAPStorageMapper": [  
Β Β Β Β Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "id": "e8b6d47e-c17c-4105-91ee-304a03e73c53",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "name": "LDAP_ID",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "providerId": "user-attribute-ldap-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "ldap.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "objectGUID"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "attribute.force.default": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "is.mandatory.in.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "is.binary.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "read.only": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "user.model.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "LDAP_ID"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "id": "534b28bd-fc9c-458f-84ee-8c3e86592cdf",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "name": "Read-only Group Mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "providerId": "group-ldap-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "membership.attribute.type": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "DN"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "group.name.ldap.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "cn"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "preserve.group.inheritance": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "membership.user.ldap.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "userPrincipalName"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "groups.dn": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "OU=AllUsers,DC=test,DC=local"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "mode": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "READ_ONLY"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "user.roles.retrieve.strategy": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "LOAD_GROUPS_BY_MEMBER_ATTRIBUTE"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "ignore.missing.groups": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "membership.ldap.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "member"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "group.object.classes": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "group"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "memberof.ldap.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "memberOf"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "groups.path": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "/"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "drop.non.existing.groups.during.sync": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "id": "3ccd7971-4e88-4884-9138-f742fe04d053",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "name": "modify date",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "providerId": "user-attribute-ldap-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "ldap.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "whenChanged"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "is.mandatory.in.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "read.only": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "always.read.value.from.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "user.model.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "modifyTimestamp"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "id": "5f63b9f8-d96c-4d62-bdeb-16e6f36189bb",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "name": "last name",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "providerId": "user-attribute-ldap-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "ldap.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "sn"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "is.mandatory.in.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "read.only": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "always.read.value.from.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "user.model.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "lastName"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "id": "86aa7539-1a87-4c05-a052-4af4cdc07394",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "name": "username",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "providerId": "user-attribute-ldap-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "ldap.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "cn"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "is.mandatory.in.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "read.only": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "always.read.value.from.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "user.model.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "username"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "id": "262339e9-03d5-4234-a886-732466b1e4de",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "name": "email",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "providerId": "user-attribute-ldap-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "ldap.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "mail"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "is.mandatory.in.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "read.only": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "always.read.value.from.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "user.model.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "email"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "id": "e8507e27-57ec-442c-bb34-11fbc7750a45",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "name": "MSAD account controls",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "providerId": "msad-user-account-control-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "config": {}  
Β Β Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "id": "9af8d557-4d7a-43c6-a441-2cbbb7bdfa22",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "name": "first name",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "providerId": "user-attribute-ldap-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "ldap.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "givenName"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "is.mandatory.in.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "read.only": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "always.read.value.from.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "user.model.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "firstName"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "id": "7871490b-e092-44fa-bde8-1abb576b5c9a",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "name": "creation date",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "providerId": "user-attribute-ldap-mapper",  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "ldap.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "whenCreated"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "is.mandatory.in.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "always.read.value.from.ldap": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "read.only": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "user.model.attribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β "createTimestamp"  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β "pagination": [  
Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "fullSyncPeriod": [  
Β Β Β Β Β Β Β Β Β Β Β Β "-1"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "startTls": [  
Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "usersDn": [  
Β Β Β Β Β Β Β Β Β Β Β Β "OU=AllUsers, DC=test, DC=local"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "connectionPooling": [  
Β Β Β Β Β Β Β Β Β Β Β Β "true"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "cachePolicy": [  
Β Β Β Β Β Β Β Β Β Β Β Β "DEFAULT"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "useKerberosForPasswordAuthentication": [  
Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "importEnabled": [  
Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "enabled": [  
Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "usernameLDAPAttribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β "userPrincipalName"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "bindCredential": [  
Β Β Β Β Β Β Β Β Β Β Β Β "**********"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "changedSyncPeriod": [  
Β Β Β Β Β Β Β Β Β Β Β Β "-1"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "bindDn": [  
Β Β Β Β Β Β Β Β Β Β Β Β "TEST\\keycloak_ldap"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "vendor": [  
Β Β Β Β Β Β Β Β Β Β Β Β "ad"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "uuidLDAPAttribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β "objectGUID"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "connectionUrl": [  
Β Β Β Β Β Β Β Β Β Β Β Β "ldap://192.168.1.207"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "allowKerberosAuthentication": [  
Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "syncRegistrations": [  
Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "authType": [  
Β Β Β Β Β Β Β Β Β Β Β Β "simple"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "krbPrincipalAttribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β "userPrincipalName"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "customUserSearchFilter": [  
Β Β Β Β Β Β Β Β Β Β Β Β "(memberOf=CN=ScpCloud_staff, OU=AllUsers,DC=test,DC=local)"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "searchScope": [  
Β Β Β Β Β Β Β Β Β Β Β Β "2"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "useTruststoreSpi": [  
Β Β Β Β Β Β Β Β Β Β Β Β "always"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "usePasswordModifyExtendedOp": [  
Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "trustEmail": [  
Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "userObjectClasses": [  
Β Β Β Β Β Β Β Β Β Β Β Β "person, organizationalPerson, user"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "rdnLDAPAttribute": [  
Β Β Β Β Β Β Β Β Β Β Β Β "cn"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "editMode": [  
Β Β Β Β Β Β Β Β Β Β Β Β "READ_ONLY"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "validatePasswordPolicy": [  
Β Β Β Β Β Β Β Β Β Β Β Β "false"  
Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β }  
Β Β Β Β ],  
Β Β Β Β "org.keycloak.keys.KeyProvider": [  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "2fe37f7b-61b0-4f27-83d8-e28852fd4beb",  
Β Β Β Β Β Β Β Β "name": "rsa-enc-generated",  
Β Β Β Β Β Β Β Β "providerId": "rsa-generated",  
Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β "priority": [  
Β Β Β Β Β Β Β Β Β Β Β Β "100"  
Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β },  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "4bde243d-b3c0-4fc4-a3dc-12dac29e5520",  
Β Β Β Β Β Β Β Β "name": "hmac-generated",  
Β Β Β Β Β Β Β Β "providerId": "hmac-generated",  
Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β "priority": [  
Β Β Β Β Β Β Β Β Β Β Β Β "100"  
Β Β Β Β Β Β Β Β Β Β ],  
Β Β Β Β Β Β Β Β Β Β "algorithm": [  
Β Β Β Β Β Β Β Β Β Β Β Β "HS256"  
Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β },  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "da355ba4-2b44-4c8f-9c7a-3efb9ae77eb9",  
Β Β Β Β Β Β Β Β "name": "rsa-generated",  
Β Β Β Β Β Β Β Β "providerId": "rsa-generated",  
Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β "priority": [  
Β Β Β Β Β Β Β Β Β Β Β Β "100"  
Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β },  
Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β "id": "6eb29d50-6609-464e-bd72-1b9ecbf158b4",  
Β Β Β Β Β Β Β Β "name": "aes-generated",  
Β Β Β Β Β Β Β Β "providerId": "aes-generated",  
Β Β Β Β Β Β Β Β "subComponents": {},  
Β Β Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β Β Β "priority": [  
Β Β Β Β Β Β Β Β Β Β Β Β "100"  
Β Β Β Β Β Β Β Β Β Β ]  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β }  
Β Β Β Β ]  
Β Β },  
Β Β "internationalizationEnabled": false,  
Β Β "supportedLocales": [],  
Β Β "authenticationFlows": [  
Β Β Β Β {  
Β Β Β Β Β Β "id": "f2c8457c-2560-4f4e-ae0f-942d930c984d",  
Β Β Β Β Β Β "alias": "Account verification options",  
Β Β Β Β Β Β "description": "Method with which to verity the existing account",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": false,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "idp-email-verification",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "ALTERNATIVE",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "requirement": "ALTERNATIVE",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "flowAlias": "Verify Existing Account by Re-authentication",  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "8cbdfaa5-1027-4e6f-b4e1-cad85ca98ae1",  
Β Β Β Β Β Β "alias": "Browser - Conditional OTP",  
Β Β Β Β Β Β "description": "Flow to determine if the OTP is required for the authentication",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": false,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "conditional-user-configured",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "auth-otp-form",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "e3ef0c51-cb55-41c5-9d4c-08f5a5af2e1e",  
Β Β Β Β Β Β "alias": "Direct Grant - Conditional OTP",  
Β Β Β Β Β Β "description": "Flow to determine if the OTP is required for the authentication",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": false,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "conditional-user-configured",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "direct-grant-validate-otp",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "c09cc451-57f8-48ca-bcad-1db4e10ab740",  
Β Β Β Β Β Β "alias": "First broker login - Conditional OTP",  
Β Β Β Β Β Β "description": "Flow to determine if the OTP is required for the authentication",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": false,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "conditional-user-configured",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "auth-otp-form",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "8d442f9c-d201-426f-96c5-08aed5948204",  
Β Β Β Β Β Β "alias": "Handle Existing Account",  
Β Β Β Β Β Β "description": "Handle what to do if there is existing account with same email/username like authenticated identity provider",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": false,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "idp-confirm-link",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "flowAlias": "Account verification options",  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "9a2d7848-bbd9-4439-8993-d70f21d77169",  
Β Β Β Β Β Β "alias": "Reset - Conditional OTP",  
Β Β Β Β Β Β "description": "Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": false,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "conditional-user-configured",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "reset-otp",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "9be4d8c5-ffbf-4dfe-8642-ccbfee5299b5",  
Β Β Β Β Β Β "alias": "User creation or linking",  
Β Β Β Β Β Β "description": "Flow for the existing/non-existing user alternatives",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": false,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticatorConfig": "create unique user config",  
Β Β Β Β Β Β Β Β Β Β "authenticator": "idp-create-user-if-unique",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "ALTERNATIVE",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "requirement": "ALTERNATIVE",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "flowAlias": "Handle Existing Account",  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "88ae70f2-1a2a-41e9-8cc4-addcd413b432",  
Β Β Β Β Β Β "alias": "Verify Existing Account by Re-authentication",  
Β Β Β Β Β Β "description": "Reauthentication of existing account",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": false,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "idp-username-password-form",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "requirement": "CONDITIONAL",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "flowAlias": "First broker login - Conditional OTP",  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "fa0942df-2caf-45a3-a513-397c8f55e9a2",  
Β Β Β Β Β Β "alias": "browser",  
Β Β Β Β Β Β "description": "browser based authentication",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": true,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "auth-cookie",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "ALTERNATIVE",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "auth-spnego",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "DISABLED",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "identity-provider-redirector",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "ALTERNATIVE",  
Β Β Β Β Β Β Β Β Β Β "priority": 25,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "requirement": "ALTERNATIVE",  
Β Β Β Β Β Β Β Β Β Β "priority": 30,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "flowAlias": "forms",  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "abd491a3-f40b-4e6d-bdd7-19a6419c1771",  
Β Β Β Β Β Β "alias": "clients",  
Β Β Β Β Β Β "description": "Base authentication for clients",  
Β Β Β Β Β Β "providerId": "client-flow",  
Β Β Β Β Β Β "topLevel": true,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "client-secret",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "ALTERNATIVE",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "client-jwt",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "ALTERNATIVE",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "client-secret-jwt",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "ALTERNATIVE",  
Β Β Β Β Β Β Β Β Β Β "priority": 30,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "client-x509",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "ALTERNATIVE",  
Β Β Β Β Β Β Β Β Β Β "priority": 40,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "49759873-28e5-48b3-b6bd-68ce6765411d",  
Β Β Β Β Β Β "alias": "direct grant",  
Β Β Β Β Β Β "description": "OpenID Connect Resource Owner Grant",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": true,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "direct-grant-validate-username",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "direct-grant-validate-password",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "requirement": "CONDITIONAL",  
Β Β Β Β Β Β Β Β Β Β "priority": 30,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "flowAlias": "Direct Grant - Conditional OTP",  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "39472373-0a94-471a-b4bb-5b2524f72ff5",  
Β Β Β Β Β Β "alias": "docker auth",  
Β Β Β Β Β Β "description": "Used by Docker clients to authenticate against the IDP",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": true,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "docker-http-basic-authenticator",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "477b7657-d39d-4fb3-b104-cd31a226c454",  
Β Β Β Β Β Β "alias": "first broker login",  
Β Β Β Β Β Β "description": "Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": true,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticatorConfig": "review profile config",  
Β Β Β Β Β Β Β Β Β Β "authenticator": "idp-review-profile",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "flowAlias": "User creation or linking",  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "de2fa724-0c10-4054-a27b-d8c4413fa992",  
Β Β Β Β Β Β "alias": "forms",  
Β Β Β Β Β Β "description": "Username, password, otp and other auth forms.",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": false,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "auth-username-password-form",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "requirement": "CONDITIONAL",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "flowAlias": "Browser - Conditional OTP",  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "85b843bc-5dc6-45fd-a7c6-33ae54a6e6ab",  
Β Β Β Β Β Β "alias": "registration",  
Β Β Β Β Β Β "description": "registration flow",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": true,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "registration-page-form",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "flowAlias": "registration form",  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "76f144f7-5f53-4a1f-9e14-2e6159fb5ec3",  
Β Β Β Β Β Β "alias": "registration form",  
Β Β Β Β Β Β "description": "registration form",  
Β Β Β Β Β Β "providerId": "form-flow",  
Β Β Β Β Β Β "topLevel": false,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "registration-user-creation",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "registration-profile-action",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 40,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "registration-password-action",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 50,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "registration-recaptcha-action",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "DISABLED",  
Β Β Β Β Β Β Β Β Β Β "priority": 60,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "f3c38fb3-c333-409e-b47d-ac4e0f58d173",  
Β Β Β Β Β Β "alias": "reset credentials",  
Β Β Β Β Β Β "description": "Reset credentials for a user if they forgot their password or something",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": true,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "reset-credentials-choose-user",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "reset-credential-email",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "reset-password",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 30,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β },  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "requirement": "CONDITIONAL",  
Β Β Β Β Β Β Β Β Β Β "priority": 40,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": true,  
Β Β Β Β Β Β Β Β Β Β "flowAlias": "Reset - Conditional OTP",  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "e47088da-c46a-40b2-8cd8-5d7428a01f30",  
Β Β Β Β Β Β "alias": "saml ecp",  
Β Β Β Β Β Β "description": "SAML ECP Profile Authentication Flow",  
Β Β Β Β Β Β "providerId": "basic-flow",  
Β Β Β Β Β Β "topLevel": true,  
Β Β Β Β Β Β "builtIn": true,  
Β Β Β Β Β Β "authenticationExecutions": [  
Β Β Β Β Β Β Β Β {  
Β Β Β Β Β Β Β Β Β Β "authenticator": "http-basic-authenticator",  
Β Β Β Β Β Β Β Β Β Β "authenticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "requirement": "REQUIRED",  
Β Β Β Β Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β Β Β Β Β "autheticatorFlow": false,  
Β Β Β Β Β Β Β Β Β Β "userSetupAllowed": false  
Β Β Β Β Β Β Β Β }  
Β Β Β Β Β Β ]  
Β Β Β Β }  
Β Β ],  
Β Β "authenticatorConfig": [  
Β Β Β Β {  
Β Β Β Β Β Β "id": "338661d4-5f25-4f19-8b5a-8a0573ee1836",  
Β Β Β Β Β Β "alias": "create unique user config",  
Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β "require.password.update.after.registration": "false"  
Β Β Β Β Β Β }  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "id": "267c91ed-9580-4f5c-9fc3-1da512a3ac33",  
Β Β Β Β Β Β "alias": "review profile config",  
Β Β Β Β Β Β "config": {  
Β Β Β Β Β Β Β Β "update.profile.on.first.login": "missing"  
Β Β Β Β Β Β }  
Β Β Β Β }  
Β Β ],  
Β Β "requiredActions": [  
Β Β Β Β {  
Β Β Β Β Β Β "alias": "CONFIGURE_TOTP",  
Β Β Β Β Β Β "name": "Configure OTP",  
Β Β Β Β Β Β "providerId": "CONFIGURE_TOTP",  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "defaultAction": false,  
Β Β Β Β Β Β "priority": 10,  
Β Β Β Β Β Β "config": {}  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "alias": "TERMS_AND_CONDITIONS",  
Β Β Β Β Β Β "name": "Terms and Conditions",  
Β Β Β Β Β Β "providerId": "TERMS_AND_CONDITIONS",  
Β Β Β Β Β Β "enabled": false,  
Β Β Β Β Β Β "defaultAction": false,  
Β Β Β Β Β Β "priority": 20,  
Β Β Β Β Β Β "config": {}  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "alias": "UPDATE_PASSWORD",  
Β Β Β Β Β Β "name": "Update Password",  
Β Β Β Β Β Β "providerId": "UPDATE_PASSWORD",  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "defaultAction": false,  
Β Β Β Β Β Β "priority": 30,  
Β Β Β Β Β Β "config": {}  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "alias": "UPDATE_PROFILE",  
Β Β Β Β Β Β "name": "Update Profile",  
Β Β Β Β Β Β "providerId": "UPDATE_PROFILE",  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "defaultAction": false,  
Β Β Β Β Β Β "priority": 40,  
Β Β Β Β Β Β "config": {}  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "alias": "VERIFY_EMAIL",  
Β Β Β Β Β Β "name": "Verify Email",  
Β Β Β Β Β Β "providerId": "VERIFY_EMAIL",  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "defaultAction": false,  
Β Β Β Β Β Β "priority": 50,  
Β Β Β Β Β Β "config": {}  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "alias": "delete_account",  
Β Β Β Β Β Β "name": "Delete Account",  
Β Β Β Β Β Β "providerId": "delete_account",  
Β Β Β Β Β Β "enabled": false,  
Β Β Β Β Β Β "defaultAction": false,  
Β Β Β Β Β Β "priority": 60,  
Β Β Β Β Β Β "config": {}  
Β Β Β Β },  
Β Β Β Β {  
Β Β Β Β Β Β "alias": "update_user_locale",  
Β Β Β Β Β Β "name": "Update User Locale",  
Β Β Β Β Β Β "providerId": "update_user_locale",  
Β Β Β Β Β Β "enabled": true,  
Β Β Β Β Β Β "defaultAction": false,  
Β Β Β Β Β Β "priority": 1000,  
Β Β Β Β Β Β "config": {}  
Β Β Β Β }  
Β Β ],  
Β Β "browserFlow": "browser",  
Β Β "registrationFlow": "registration",  
Β Β "directGrantFlow": "direct grant",  
Β Β "resetCredentialsFlow": "reset credentials",  
Β Β "clientAuthenticationFlow": "clients",  
Β Β "dockerAuthenticationFlow": "docker auth",  
Β Β "attributes": {  
Β Β Β Β "cibaBackchannelTokenDeliveryMode": "poll",  
Β Β Β Β "cibaAuthRequestedUserHint": "login_hint",  
Β Β Β Β "clientOfflineSessionMaxLifespan": "0",  
Β Β Β Β "oauth2DevicePollingInterval": "5",  
Β Β Β Β "clientSessionIdleTimeout": "0",  
Β Β Β Β "clientOfflineSessionIdleTimeout": "0",  
Β Β Β Β "cibaInterval": "5",  
Β Β Β Β "realmReusableOtpCode": "false",  
Β Β Β Β "cibaExpiresIn": "120",  
Β Β Β Β "oauth2DeviceCodeLifespan": "600",  
Β Β Β Β "parRequestUriLifespan": "60",  
Β Β Β Β "clientSessionMaxLifespan": "0",  
Β Β Β Β "frontendUrl": "",  
Β Β Β Β "acr.loa.map": "{}"  
Β Β },  
Β Β "keycloakVersion": "22.0.5",  
Β Β "userManagedAccessAllowed": false,  
Β Β "clientProfiles": {  
Β Β Β Β "profiles": []  
Β Β },  
Β Β "clientPolicies": {  
Β Β Β Β "policies": []  
Β Β }  
}




