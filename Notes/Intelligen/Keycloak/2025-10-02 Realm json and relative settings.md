---
categories:
  - "[[Work]]"
tags:
  - intelligen
  - keycloak
---

Export 2025-10-02
 
{  
  "id": "ScpCloud",  
  "realm": "ScpCloud",  
  "displayName": "Schedule Pro Cloud",  
  "displayNameHtml": "Schedule Pro Cloud",  
  "notBefore": 0,  
  "defaultSignatureAlgorithm": "RS256",  
  "revokeRefreshToken": true,  
  "refreshTokenMaxReuse": 1,  
  "accessTokenLifespan": 1800,  
  "accessTokenLifespanForImplicitFlow": 900,  
  "ssoSessionIdleTimeout": 86400,  
  "ssoSessionMaxLifespan": 86400,  
  "ssoSessionIdleTimeoutRememberMe": 0,  
  "ssoSessionMaxLifespanRememberMe": 0,  
  "offlineSessionIdleTimeout": 2592000,  
  "offlineSessionMaxLifespanEnabled": false,  
  "offlineSessionMaxLifespan": 5184000,  
  "clientSessionIdleTimeout": 0,  
  "clientSessionMaxLifespan": 0,  
  "clientOfflineSessionIdleTimeout": 0,  
  "clientOfflineSessionMaxLifespan": 0,  
  "accessCodeLifespan": 60,  
  "accessCodeLifespanUserAction": 300,  
  "accessCodeLifespanLogin": 1800,  
  "actionTokenGeneratedByAdminLifespan": 604800,  
  "actionTokenGeneratedByUserLifespan": 300,  
  "oauth2DeviceCodeLifespan": 600,  
  "oauth2DevicePollingInterval": 5,  
  "enabled": true,  
  "sslRequired": "none",  
  "registrationAllowed": true,  
  "registrationEmailAsUsername": false,  
  "rememberMe": true,  
  "verifyEmail": true,  
  "loginWithEmailAllowed": true,  
  "duplicateEmailsAllowed": false,  
  "resetPasswordAllowed": true,  
  "editUsernameAllowed": false,  
  "bruteForceProtected": false,  
  "permanentLockout": false,  
  "maxFailureWaitSeconds": 900,  
  "minimumQuickLoginWaitSeconds": 60,  
  "waitIncrementSeconds": 60,  
  "quickLoginCheckMilliSeconds": 1000,  
  "maxDeltaTimeSeconds": 43200,  
  "failureFactor": 30,  
  "roles": {  
    "realm": [  
      {  
        "id": "2720c15c-8bee-4781-b963-35a71ee21152",  
        "name": "offline_access",  
        "description": "${role_offline-access}",  
        "composite": false,  
        "clientRole": false,  
        "containerId": "ScpCloud",  
        "attributes": {}  
      },  
      {  
        "id": "3582d016-58d9-4555-9621-24bbe50ba746",  
        "name": "default-roles-scpcloud",  
        "description": "${role_default-roles}",  
        "composite": true,  
        "composites": {  
          "realm": [  
            "offline_access",  
            "uma_authorization"  
          ],  
          "client": {  
            "account": [  
              "view-profile",  
              "manage-account"  
            ]  
          }  
        },  
        "clientRole": false,  
        "containerId": "ScpCloud",  
        "attributes": {}  
      },  
      {  
        "id": "535008dc-832e-4700-97d8-cc15cea545ff",  
        "name": "uma_authorization",  
        "description": "${role_uma_authorization}",  
        "composite": false,  
        "clientRole": false,  
        "containerId": "ScpCloud",  
        "attributes": {}  
      }  
    ],  
    "client": {  
      "realm-management": [  
        {  
          "id": "bbf8f7e7-2d52-43e2-a466-3d8f84deb00f",  
          "name": "view-clients",  
          "description": "${role_view-clients}",  
          "composite": true,  
          "composites": {  
            "client": {  
              "realm-management": [  
                "query-clients"  
              ]  
            }  
          },  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "00c16927-47f4-4802-a7fc-65a3ab1c8638",  
          "name": "query-clients",  
          "description": "${role_query-clients}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "1cdaacca-7cfe-40b2-9695-51b051d6932b",  
          "name": "view-users",  
          "description": "${role_view-users}",  
          "composite": true,  
          "composites": {  
            "client": {  
              "realm-management": [  
                "query-groups",  
                "query-users"  
              ]  
            }  
          },  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "4cbd241f-a043-4deb-aba1-ca0d3b1d3a8c",  
          "name": "manage-authorization",  
          "description": "${role_manage-authorization}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "c6433ffa-9c54-4c66-bdf7-ce3026796a1d",  
          "name": "view-realm",  
          "description": "${role_view-realm}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "25d39955-6bb7-4a33-ad89-bc886f422b4e",  
          "name": "query-users",  
          "description": "${role_query-users}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "ec6cd771-3599-47a7-8f15-093b498cd23b",  
          "name": "create-client",  
          "description": "${role_create-client}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "f9ec89c5-7be6-4d75-a850-aa8928cb4c4f",  
          "name": "manage-clients",  
          "description": "${role_manage-clients}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "431881eb-764b-4474-949a-daf2ca5dccc2",  
          "name": "query-groups",  
          "description": "${role_query-groups}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "2dd2871d-5807-4c60-bd54-7d1b33cecdef",  
          "name": "view-authorization",  
          "description": "${role_view-authorization}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "752dc232-21e0-45f9-9022-0f920328560a",  
          "name": "view-identity-providers",  
          "description": "${role_view-identity-providers}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "308d44c1-7cf0-4916-aaa6-d0fffebcbb4e",  
          "name": "view-events",  
          "description": "${role_view-events}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "095812f1-7186-4ce9-9ca2-254dc17f8df6",  
          "name": "manage-events",  
          "description": "${role_manage-events}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "2f903b91-4ce6-4651-bb94-7d8eaaab6f90",  
          "name": "manage-users",  
          "description": "${role_manage-users}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "28dc2c91-a30c-43e3-9b1f-ffbd8287dd74",  
          "name": "impersonation",  
          "description": "${role_impersonation}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "a206d136-9816-4450-8bd6-c55dc6e78aa6",  
          "name": "manage-realm",  
          "description": "${role_manage-realm}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "01160ec0-0ee6-4b6b-8a41-a31635de631a",  
          "name": "realm-admin",  
          "description": "${role_realm-admin}",  
          "composite": true,  
          "composites": {  
            "client": {  
              "realm-management": [  
                "view-clients",  
                "query-clients",  
                "view-users",  
                "manage-authorization",  
                "view-realm",  
                "query-users",  
                "create-client",  
                "manage-clients",  
                "query-groups",  
                "view-authorization",  
                "view-identity-providers",  
                "view-events",  
                "manage-events",  
                "manage-users",  
                "impersonation",  
                "manage-realm",  
                "query-realms",  
                "manage-identity-providers"  
              ]  
            }  
          },  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "88b4fdf1-0794-474f-9f79-7f6f07780479",  
          "name": "query-realms",  
          "description": "${role_query-realms}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        },  
        {  
          "id": "2d2f7337-2041-42d4-ad97-afe691015d47",  
          "name": "manage-identity-providers",  
          "description": "${role_manage-identity-providers}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
          "attributes": {}  
        }  
      ],  
      "scpCloud": [],  
      "scp-admin-service": [],  
      "security-admin-console": [],  
      "admin-cli": [],  
      "account-console": [],  
      "broker": [  
        {  
          "id": "8628877a-a20c-4311-a4bb-eba1bda55373",  
          "name": "read-token",  
          "description": "${role_read-token}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "36017054-cfa8-4acc-a2a2-743768d969f1",  
          "attributes": {}  
        }  
      ],  
      "account": [  
        {  
          "id": "928d10a4-7b97-4658-95bb-fc1673b9abcf",  
          "name": "view-consent",  
          "description": "${role_view-consent}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
          "attributes": {}  
        },  
        {  
          "id": "513e5d77-63cd-48d3-9f7a-dcb986d37210",  
          "name": "delete-account",  
          "description": "${role_delete-account}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
          "attributes": {}  
        },  
        {  
          "id": "95ce849f-7509-4cfb-9c08-a1af5d35841c",  
          "name": "manage-consent",  
          "description": "${role_manage-consent}",  
          "composite": true,  
          "composites": {  
            "client": {  
              "account": [  
                "view-consent"  
              ]  
            }  
          },  
          "clientRole": true,  
          "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
          "attributes": {}  
        },  
        {  
          "id": "926a32c9-e618-49a5-9ae9-580997a1c8d6",  
          "name": "view-profile",  
          "description": "${role_view-profile}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
          "attributes": {}  
        },  
        {  
          "id": "c70d50ca-70e8-4a93-b9a9-8627b3e4b7b0",  
          "name": "manage-account",  
          "description": "${role_manage-account}",  
          "composite": true,  
          "composites": {  
            "client": {  
              "account": [  
                "manage-account-links"  
              ]  
            }  
          },  
          "clientRole": true,  
          "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
          "attributes": {}  
        },  
        {  
          "id": "70939c91-dff4-426a-bcbb-1d836ced65ac",  
          "name": "manage-account-links",  
          "description": "${role_manage-account-links}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
          "attributes": {}  
        },  
        {  
          "id": "1cb015bc-b8b6-4b43-9435-9254569d0f0a",  
          "name": "view-applications",  
          "description": "${role_view-applications}",  
          "composite": false,  
          "clientRole": true,  
          "containerId": "99857312-8203-4b2e-ba45-7c9346898d5f",  
          "attributes": {}  
        }  
      ]  
    }  
  },  
  "groups": [],  
  "defaultRole": {  
    "id": "3582d016-58d9-4555-9621-24bbe50ba746",  
    "name": "default-roles-scpcloud",  
    "description": "${role_default-roles}",  
    "composite": true,  
    "clientRole": false,  
    "containerId": "ScpCloud"  
  },  
  "requiredCredentials": [  
    "password"  
  ],  
  "otpPolicyType": "totp",  
  "otpPolicyAlgorithm": "HmacSHA1",  
  "otpPolicyInitialCounter": 0,  
  "otpPolicyDigits": 6,  
  "otpPolicyLookAheadWindow": 1,  
  "otpPolicyPeriod": 30,  
  "otpPolicyCodeReusable": false,  
  "otpSupportedApplications": [  
    "totpAppGoogleName",  
    "totpAppFreeOTPName",  
    "totpAppMicrosoftAuthenticatorName"  
  ],  
  "webAuthnPolicyRpEntityName": "keycloak",  
  "webAuthnPolicySignatureAlgorithms": [  
    "ES256"  
  ],  
  "webAuthnPolicyRpId": "",  
  "webAuthnPolicyAttestationConveyancePreference": "not specified",  
  "webAuthnPolicyAuthenticatorAttachment": "not specified",  
  "webAuthnPolicyRequireResidentKey": "not specified",  
  "webAuthnPolicyUserVerificationRequirement": "not specified",  
  "webAuthnPolicyCreateTimeout": 0,  
  "webAuthnPolicyAvoidSameAuthenticatorRegister": false,  
  "webAuthnPolicyAcceptableAaguids": [],  
  "webAuthnPolicyPasswordlessRpEntityName": "keycloak",  
  "webAuthnPolicyPasswordlessSignatureAlgorithms": [  
    "ES256"  
  ],  
  "webAuthnPolicyPasswordlessRpId": "",  
  "webAuthnPolicyPasswordlessAttestationConveyancePreference": "not specified",  
  "webAuthnPolicyPasswordlessAuthenticatorAttachment": "not specified",  
  "webAuthnPolicyPasswordlessRequireResidentKey": "not specified",  
  "webAuthnPolicyPasswordlessUserVerificationRequirement": "not specified",  
  "webAuthnPolicyPasswordlessCreateTimeout": 0,  
  "webAuthnPolicyPasswordlessAvoidSameAuthenticatorRegister": false,  
  "webAuthnPolicyPasswordlessAcceptableAaguids": [],  
  "users": [  
    {  
      "id": "3df22a99-7760-41b3-97fa-3318a75a8e92",  
      "createdTimestamp": 1759320156624,  
      "username": "service-account-scp-admin-service",  
      "enabled": true,  
      "totp": false,  
      "emailVerified": false,  
      "serviceAccountClientId": "scp-admin-service",  
      "disableableCredentialTypes": [],  
      "requiredActions": [],  
      "realmRoles": [  
        "default-roles-scpcloud"  
      ],  
      "notBefore": 0,  
      "groups": []  
    }  
  ],  
  "scopeMappings": [  
    {  
      "clientScope": "offline_access",  
      "roles": [  
        "offline_access"  
      ]  
    }  
  ],  
  "clients": [  
    {  
      "id": "99857312-8203-4b2e-ba45-7c9346898d5f",  
      "clientId": "account",  
      "name": "${client_account}",  
      "rootUrl": "${authBaseUrl}",  
      "baseUrl": "/realms/ScpCloud/account/",  
      "surrogateAuthRequired": false,  
      "enabled": true,  
      "alwaysDisplayInConsole": false,  
      "clientAuthenticatorType": "client-secret",  
      "redirectUris": [  
        "/realms/ScpCloud/account/*"  
      ],  
      "webOrigins": [],  
      "notBefore": 0,  
      "bearerOnly": false,  
      "consentRequired": false,  
      "standardFlowEnabled": true,  
      "implicitFlowEnabled": false,  
      "directAccessGrantsEnabled": false,  
      "serviceAccountsEnabled": false,  
      "publicClient": true,  
      "frontchannelLogout": false,  
      "protocol": "openid-connect",  
      "attributes": {  
        "post.logout.redirect.uris": "+"  
      },  
      "authenticationFlowBindingOverrides": {},  
      "fullScopeAllowed": false,  
      "nodeReRegistrationTimeout": 0,  
      "defaultClientScopes": [  
        "web-origins",  
        "profile",  
        "roles",  
        "email"  
      ],  
      "optionalClientScopes": [  
        "address",  
        "phone",  
        "offline_access",  
        "microprofile-jwt"  
      ]  
    },  
    {  
      "id": "b15de58e-7862-4c14-aad3-8c9e765f8b6b",  
      "clientId": "account-console",  
      "name": "${client_account-console}",  
      "rootUrl": "${authBaseUrl}",  
      "baseUrl": "/realms/ScpCloud/account/",  
      "surrogateAuthRequired": false,  
      "enabled": true,  
      "alwaysDisplayInConsole": false,  
      "clientAuthenticatorType": "client-secret",  
      "redirectUris": [  
        "/realms/ScpCloud/account/*"  
      ],  
      "webOrigins": [],  
      "notBefore": 0,  
      "bearerOnly": false,  
      "consentRequired": false,  
      "standardFlowEnabled": true,  
      "implicitFlowEnabled": false,  
      "directAccessGrantsEnabled": false,  
      "serviceAccountsEnabled": false,  
      "publicClient": true,  
      "frontchannelLogout": false,  
      "protocol": "openid-connect",  
      "attributes": {  
        "post.logout.redirect.uris": "+",  
        "pkce.code.challenge.method": "S256"  
      },  
      "authenticationFlowBindingOverrides": {},  
      "fullScopeAllowed": false,  
      "nodeReRegistrationTimeout": 0,  
      "protocolMappers": [  
        {  
          "id": "e849bacd-9110-45c6-83fd-0c090fad2c36",  
          "name": "audience resolve",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-audience-resolve-mapper",  
          "consentRequired": false,  
          "config": {}  
        }  
      ],  
      "defaultClientScopes": [  
        "web-origins",  
        "profile",  
        "roles",  
        "email"  
      ],  
      "optionalClientScopes": [  
        "address",  
        "phone",  
        "offline_access",  
        "microprofile-jwt"  
      ]  
    },  
    {  
      "id": "0cdbb35c-0471-46b7-bf35-8a01d9407081",  
      "clientId": "admin-cli",  
      "name": "${client_admin-cli}",  
      "surrogateAuthRequired": false,  
      "enabled": true,  
      "alwaysDisplayInConsole": false,  
      "clientAuthenticatorType": "client-secret",  
      "redirectUris": [],  
      "webOrigins": [],  
      "notBefore": 0,  
      "bearerOnly": false,  
      "consentRequired": false,  
      "standardFlowEnabled": false,  
      "implicitFlowEnabled": false,  
      "directAccessGrantsEnabled": true,  
      "serviceAccountsEnabled": false,  
      "publicClient": true,  
      "frontchannelLogout": false,  
      "protocol": "openid-connect",  
      "attributes": {  
        "post.logout.redirect.uris": "+"  
      },  
      "authenticationFlowBindingOverrides": {},  
      "fullScopeAllowed": false,  
      "nodeReRegistrationTimeout": 0,  
      "defaultClientScopes": [  
        "web-origins",  
        "profile",  
        "roles",  
        "email"  
      ],  
      "optionalClientScopes": [  
        "address",  
        "phone",  
        "offline_access",  
        "microprofile-jwt"  
      ]  
    },  
    {  
      "id": "36017054-cfa8-4acc-a2a2-743768d969f1",  
      "clientId": "broker",  
      "name": "${client_broker}",  
      "surrogateAuthRequired": false,  
      "enabled": true,  
      "alwaysDisplayInConsole": false,  
      "clientAuthenticatorType": "client-secret",  
      "redirectUris": [],  
      "webOrigins": [],  
      "notBefore": 0,  
      "bearerOnly": true,  
      "consentRequired": false,  
      "standardFlowEnabled": true,  
      "implicitFlowEnabled": false,  
      "directAccessGrantsEnabled": false,  
      "serviceAccountsEnabled": false,  
      "publicClient": false,  
      "frontchannelLogout": false,  
      "protocol": "openid-connect",  
      "attributes": {  
        "post.logout.redirect.uris": "+"  
      },  
      "authenticationFlowBindingOverrides": {},  
      "fullScopeAllowed": false,  
      "nodeReRegistrationTimeout": 0,  
      "defaultClientScopes": [  
        "web-origins",  
        "profile",  
        "roles",  
        "email"  
      ],  
      "optionalClientScopes": [  
        "address",  
        "phone",  
        "offline_access",  
        "microprofile-jwt"  
      ]  
    },  
    {  
      "id": "fd3761ef-5ddf-4481-abec-6ddd7e58a041",  
      "clientId": "realm-management",  
      "name": "${client_realm-management}",  
      "surrogateAuthRequired": false,  
      "enabled": true,  
      "alwaysDisplayInConsole": false,  
      "clientAuthenticatorType": "client-secret",  
      "redirectUris": [],  
      "webOrigins": [],  
      "notBefore": 0,  
      "bearerOnly": true,  
      "consentRequired": false,  
      "standardFlowEnabled": true,  
      "implicitFlowEnabled": false,  
      "directAccessGrantsEnabled": false,  
      "serviceAccountsEnabled": false,  
      "publicClient": false,  
      "frontchannelLogout": false,  
      "protocol": "openid-connect",  
      "attributes": {  
        "post.logout.redirect.uris": "+"  
      },  
      "authenticationFlowBindingOverrides": {},  
      "fullScopeAllowed": false,  
      "nodeReRegistrationTimeout": 0,  
      "defaultClientScopes": [  
        "web-origins",  
        "profile",  
        "roles",  
        "email"  
      ],  
      "optionalClientScopes": [  
        "address",  
        "phone",  
        "offline_access",  
        "microprofile-jwt"  
      ]  
    },  
    {  
      "id": "fb1f9c97-61cf-4c63-9908-348b3983b8c0",  
      "clientId": "scp-admin-service",  
      "name": "${client_scp-admin-service}",  
      "description": "",  
      "rootUrl": "",  
      "adminUrl": "",  
      "baseUrl": "",  
      "surrogateAuthRequired": false,  
      "enabled": true,  
      "alwaysDisplayInConsole": true,  
      "clientAuthenticatorType": "client-secret",  
      "secret": "**********",  
      "redirectUris": [  
        "/*"  
      ],  
      "webOrigins": [  
        "/*"  
      ],  
      "notBefore": 0,  
      "bearerOnly": false,  
      "consentRequired": false,  
      "standardFlowEnabled": true,  
      "implicitFlowEnabled": false,  
      "directAccessGrantsEnabled": false,  
      "serviceAccountsEnabled": true,  
      "publicClient": false,  
      "frontchannelLogout": true,  
      "protocol": "openid-connect",  
      "attributes": {  
        "oidc.ciba.grant.enabled": "false",  
        "client.secret.creation.time": "1693898402",  
        "backchannel.logout.session.required": "true",  
        "post.logout.redirect.uris": "+",  
        "oauth2.device.authorization.grant.enabled": "false",  
        "backchannel.logout.revoke.offline.tokens": "false"  
      },  
      "authenticationFlowBindingOverrides": {},  
      "fullScopeAllowed": true,  
      "nodeReRegistrationTimeout": -1,  
      "protocolMappers": [  
        {  
          "id": "3f6a23ad-86d0-4013-9e3f-dc2871a4f189",  
          "name": "Client Host",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usersessionmodel-note-mapper",  
          "consentRequired": false,  
          "config": {  
            "user.session.note": "clientHost",  
            "userinfo.token.claim": "true",  
            "id.token.claim": "true",  
            "access.token.claim": "true",  
            "claim.name": "clientHost",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "c85eaf7a-82ec-438b-93b7-ab22b25098ea",  
          "name": "Client IP Address",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usersessionmodel-note-mapper",  
          "consentRequired": false,  
          "config": {  
            "user.session.note": "clientAddress",  
            "userinfo.token.claim": "true",  
            "id.token.claim": "true",  
            "access.token.claim": "true",  
            "claim.name": "clientAddress",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "29cd1180-8dec-4f58-b142-9f58c03b58ec",  
          "name": "Client ID",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usersessionmodel-note-mapper",  
          "consentRequired": false,  
          "config": {  
            "user.session.note": "client_id",  
            "userinfo.token.claim": "true",  
            "id.token.claim": "true",  
            "access.token.claim": "true",  
            "claim.name": "client_id",  
            "jsonType.label": "String"  
          }  
        }  
      ],  
      "defaultClientScopes": [  
        "web-origins",  
        "profile",  
        "roles",  
        "email"  
      ],  
      "optionalClientScopes": [  
        "address",  
        "phone",  
        "offline_access",  
        "microprofile-jwt"  
      ]  
    },  
    {  
      "id": "5624a877-0ee6-4f02-bba3-6657aa062db2",  
      "clientId": "scpCloud",  
      "name": "",  
      "description": "",  
      "rootUrl": "",  
      "adminUrl": "",  
      "baseUrl": "",  
      "surrogateAuthRequired": false,  
      "enabled": true,  
      "alwaysDisplayInConsole": false,  
      "clientAuthenticatorType": "client-secret",  
      "redirectUris": [  
        "*"  
      ],  
      "webOrigins": [  
        "*"  
      ],  
      "notBefore": 0,  
      "bearerOnly": false,  
      "consentRequired": false,  
      "standardFlowEnabled": true,  
      "implicitFlowEnabled": false,  
      "directAccessGrantsEnabled": false,  
      "serviceAccountsEnabled": false,  
      "publicClient": true,  
      "frontchannelLogout": false,  
      "protocol": "openid-connect",  
      "attributes": {  
        "saml.force.post.binding": "false",  
        "saml.multivalued.roles": "false",  
        "post.logout.redirect.uris": "+",  
        "oauth2.device.authorization.grant.enabled": "false",  
        "backchannel.logout.revoke.offline.tokens": "false",  
        "saml.server.signature.keyinfo.ext": "false",  
        "use.refresh.tokens": "true",  
        "oidc.ciba.grant.enabled": "false",  
        "backchannel.logout.session.required": "true",  
        "client_credentials.use_refresh_token": "false",  
        "require.pushed.authorization.requests": "false",  
        "saml.client.signature": "false",  
        "pkce.code.challenge.method": "S256",  
        "id.token.as.detached.signature": "false",  
        "saml.assertion.signature": "false",  
        "saml.encrypt": "false",  
        "saml.server.signature": "false",  
        "exclude.session.state.from.auth.response": "false",  
        "saml.artifact.binding": "false",  
        "saml_force_name_id_format": "false",  
        "tls.client.certificate.bound.access.tokens": "false",  
        "saml.authnstatement": "false",  
        "display.on.consent.screen": "false",  
        "saml.onetimeuse.condition": "false"  
      },  
      "authenticationFlowBindingOverrides": {},  
      "fullScopeAllowed": false,  
      "nodeReRegistrationTimeout": -1,  
      "protocolMappers": [  
        {  
          "id": "cf6ef27a-ac36-43ad-9618-420beaecf857",  
          "name": "organizationName",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "organizationName",  
            "id.token.claim": "false",  
            "access.token.claim": "true",  
            "claim.name": "organizationName",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "9b0071ae-6813-4406-b898-cd3c651b83b9",  
          "name": "family name",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "aggregate.attrs": "false",  
            "multivalued": "false",  
            "userinfo.token.claim": "true",  
            "user.attribute": "lastName",  
            "id.token.claim": "false",  
            "access.token.claim": "true",  
            "claim.name": "lastName",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "16333f32-af7a-4f22-8ceb-467a9996433b",  
          "name": "jobTitle",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "aggregate.attrs": "false",  
            "multivalued": "false",  
            "userinfo.token.claim": "true",  
            "user.attribute": "jobTitle",  
            "id.token.claim": "false",  
            "access.token.claim": "true",  
            "claim.name": "jobTitle",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "46d373bb-93a9-447f-b8b3-79295c554914",  
          "name": "preferred_username",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-property-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "username",  
            "id.token.claim": "true",  
            "access.token.claim": "true",  
            "claim.name": "username",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "fe6e431d-d4bf-44ac-8584-3b845553118b",  
          "name": "given name",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "aggregate.attrs": "false",  
            "multivalued": "false",  
            "userinfo.token.claim": "true",  
            "user.attribute": "firstName",  
            "id.token.claim": "false",  
            "access.token.claim": "true",  
            "claim.name": "firstName",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "f57feba2-8bcd-4ec7-8b63-ca8ef7efc83d",  
          "name": "isAdmin",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "isAdmin",  
            "id.token.claim": "false",  
            "access.token.claim": "true",  
            "claim.name": "isAdmin",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "c2b63249-7106-4caf-8c02-b85f9aabe764",  
          "name": "email",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "email",  
            "id.token.claim": "true",  
            "access.token.claim": "true",  
            "claim.name": "email",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "c20e9135-5d2d-4921-a969-cd0d4e0737bb",  
          "name": "country",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "aggregate.attrs": "false",  
            "multivalued": "false",  
            "userinfo.token.claim": "true",  
            "user.attribute": "country",  
            "id.token.claim": "false",  
            "access.token.claim": "true",  
            "claim.name": "country",  
            "jsonType.label": "String"  
          }  
        }  
      ],  
      "defaultClientScopes": [  
        "web-origins",  
        "scpCloud-client-scope",  
        "profile",  
        "roles",  
        "email"  
      ],  
      "optionalClientScopes": [  
        "address",  
        "phone",  
        "offline_access",  
        "microprofile-jwt"  
      ]  
    },  
    {  
      "id": "8c926e37-bb78-42f7-870c-5341730427a2",  
      "clientId": "security-admin-console",  
      "name": "${client_security-admin-console}",  
      "rootUrl": "${authAdminUrl}",  
      "baseUrl": "/admin/ScpCloud/console/",  
      "surrogateAuthRequired": false,  
      "enabled": true,  
      "alwaysDisplayInConsole": false,  
      "clientAuthenticatorType": "client-secret",  
      "redirectUris": [  
        "/admin/ScpCloud/console/*"  
      ],  
      "webOrigins": [  
        "+"  
      ],  
      "notBefore": 0,  
      "bearerOnly": false,  
      "consentRequired": false,  
      "standardFlowEnabled": true,  
      "implicitFlowEnabled": false,  
      "directAccessGrantsEnabled": false,  
      "serviceAccountsEnabled": false,  
      "publicClient": true,  
      "frontchannelLogout": false,  
      "protocol": "openid-connect",  
      "attributes": {  
        "post.logout.redirect.uris": "+",  
        "pkce.code.challenge.method": "S256"  
      },  
      "authenticationFlowBindingOverrides": {},  
      "fullScopeAllowed": false,  
      "nodeReRegistrationTimeout": 0,  
      "protocolMappers": [  
        {  
          "id": "e6b5a475-d7c8-4ca7-8b3d-9feb4c56a5be",  
          "name": "locale",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "locale",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "locale",  
            "jsonType.label": "String"  
          }  
        }  
      ],  
      "defaultClientScopes": [  
        "web-origins",  
        "profile",  
        "roles",  
        "email"  
      ],  
      "optionalClientScopes": [  
        "address",  
        "phone",  
        "offline_access",  
        "microprofile-jwt"  
      ]  
    }  
  ],  
  "clientScopes": [  
    {  
      "id": "4d5891b2-4e28-4d54-9035-5c1ab92bf2bd",  
      "name": "profile",  
      "description": "OpenID Connect built-in scope: profile",  
      "protocol": "openid-connect",  
      "attributes": {  
        "include.in.token.scope": "false",  
        "display.on.consent.screen": "true",  
        "consent.screen.text": "${profileScopeConsentText}"  
      },  
      "protocolMappers": [  
        {  
          "id": "1c3e74cb-7498-4d88-9f97-c804aa3d7286",  
          "name": "profile",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "profile",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "profile",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "6e8b07df-459d-414a-95be-e4a4d48bc0c0",  
          "name": "zoneinfo",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "zoneinfo",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "zoneinfo",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "923ffd9a-567c-4f20-82b1-2ed2d1080165",  
          "name": "gender",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "gender",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "gender",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "0a293c18-c85c-4b28-9ac1-3071a06188e8",  
          "name": "locale",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "locale",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "locale",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "71dd6414-77a0-4748-bdbe-02616ca52351",  
          "name": "picture",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "picture",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "picture",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "8d8568be-27a4-49db-833b-c5a4588aa97c",  
          "name": "given name",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-property-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "firstName",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "given_name",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "547d0476-3441-4511-8b83-0804018d952e",  
          "name": "nickname",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "nickname",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "nickname",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "473f9dc2-6ad8-477c-b8a3-4abdc4991e60",  
          "name": "family name",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-property-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "lastName",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "family_name",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "acfe2bd5-11bb-4c0d-83b5-3327445bf33e",  
          "name": "full name",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-full-name-mapper",  
          "consentRequired": false,  
          "config": {  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "userinfo.token.claim": "true"  
          }  
        },  
        {  
          "id": "9587f889-360e-430f-b716-7bf9786efd2a",  
          "name": "birthdate",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "birthdate",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "birthdate",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "24275dee-5206-48b8-8f2d-ea16b66c478d",  
          "name": "username",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-property-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "username",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "preferred_username",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "55d994a7-2503-44e5-a385-4e7b7a0b0a58",  
          "name": "website",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "website",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "website",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "4f3a00a7-40be-4dbb-a25e-64b5bf849a80",  
          "name": "middle name",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "middleName",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "middle_name",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "c4bf400f-a66d-484a-b8b4-0078f7fe11cf",  
          "name": "updated at",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "updatedAt",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "updated_at",  
            "jsonType.label": "String"  
          }  
        }  
      ]  
    },  
    {  
      "id": "353e8b94-c3d5-4a50-82e1-dc3f1a0b61c6",  
      "name": "scpCloud-client-scope",  
      "protocol": "openid-connect",  
      "attributes": {  
        "include.in.token.scope": "false",  
        "display.on.consent.screen": "true"  
      },  
      "protocolMappers": [  
        {  
          "id": "72f0ab18-3ed1-4d0f-bbf1-17aac1eddb6d",  
          "name": "audience",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-audience-mapper",  
          "consentRequired": false,  
          "config": {  
            "included.client.audience": "scpCloud",  
            "id.token.claim": "false",  
            "access.token.claim": "true",  
            "userinfo.token.claim": "false"  
          }  
        },  
        {  
          "id": "097fe1b3-8aa1-4355-bcc0-99012dd53652",  
          "name": "User_ID",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "aggregate.attrs": "false",  
            "multivalued": "false",  
            "userinfo.token.claim": "true",  
            "user.attribute": "LDAP_ID",  
            "id.token.claim": "true",  
            "access.token.claim": "true",  
            "claim.name": "userId",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "298af755-eadf-4401-866d-195db312083e",  
          "name": "User_groups",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-group-membership-mapper",  
          "consentRequired": false,  
          "config": {  
            "full.path": "false",  
            "multivalued": "true",  
            "userinfo.token.claim": "true",  
            "id.token.claim": "true",  
            "access.token.claim": "true",  
            "claim.name": "groups"  
          }  
        }  
      ]  
    },  
    {  
      "id": "c38c2232-7962-4df7-b476-0fe1932305f8",  
      "name": "web-origins",  
      "description": "OpenID Connect scope for add allowed web origins to the access token",  
      "protocol": "openid-connect",  
      "attributes": {  
        "include.in.token.scope": "false",  
        "display.on.consent.screen": "false",  
        "consent.screen.text": ""  
      },  
      "protocolMappers": [  
        {  
          "id": "6906b64d-1ef6-4637-96f7-8a8c35142af2",  
          "name": "allowed web origins",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-allowed-origins-mapper",  
          "consentRequired": false,  
          "config": {}  
        }  
      ]  
    },  
    {  
      "id": "5016c776-4e4e-40ec-9685-927a03d5d5c2",  
      "name": "offline_access",  
      "description": "OpenID Connect built-in scope: offline_access",  
      "protocol": "openid-connect",  
      "attributes": {  
        "consent.screen.text": "${offlineAccessScopeConsentText}",  
        "display.on.consent.screen": "true"  
      }  
    },  
    {  
      "id": "bad369f7-5367-45d1-aa26-9a777b782672",  
      "name": "roles",  
      "description": "OpenID Connect scope for add user roles to the access token",  
      "protocol": "openid-connect",  
      "attributes": {  
        "include.in.token.scope": "false",  
        "display.on.consent.screen": "true",  
        "gui.order": "",  
        "consent.screen.text": "${rolesScopeConsentText}"  
      },  
      "protocolMappers": [  
        {  
          "id": "5b29ac40-2f85-400b-ae7b-6567da4ebaea",  
          "name": "audience resolve",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-audience-resolve-mapper",  
          "consentRequired": false,  
          "config": {}  
        },  
        {  
          "id": "72df4f7b-5e2e-40af-8623-f8253838ef04",  
          "name": "client roles",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-client-role-mapper",  
          "consentRequired": false,  
          "config": {  
            "multivalued": "true",  
            "userinfo.token.claim": "false",  
            "user.attribute": "foo",  
            "id.token.claim": "false",  
            "access.token.claim": "true",  
            "claim.name": "resource_access.${client_id}.roles",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "08b23f06-a039-4315-8db5-735207c033c0",  
          "name": "realm roles",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-realm-role-mapper",  
          "consentRequired": false,  
          "config": {  
            "multivalued": "true",  
            "userinfo.token.claim": "false",  
            "user.attribute": "foo",  
            "id.token.claim": "false",  
            "access.token.claim": "false",  
            "claim.name": "realm_access.roles",  
            "jsonType.label": "String"  
          }  
        }  
      ]  
    },  
    {  
      "id": "04edf013-73c5-40b2-a4f3-a53978be74c7",  
      "name": "phone",  
      "description": "OpenID Connect built-in scope: phone",  
      "protocol": "openid-connect",  
      "attributes": {  
        "include.in.token.scope": "false",  
        "display.on.consent.screen": "true",  
        "consent.screen.text": "${phoneScopeConsentText}"  
      },  
      "protocolMappers": [  
        {  
          "id": "13ee797a-f312-42f5-8223-220e5becd745",  
          "name": "phone number verified",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "phoneNumberVerified",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "phone_number_verified",  
            "jsonType.label": "boolean"  
          }  
        },  
        {  
          "id": "bd9550e5-613d-4691-a17a-8ae8f6f6e4b4",  
          "name": "phone number",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-attribute-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "phoneNumber",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "phone_number",  
            "jsonType.label": "String"  
          }  
        }  
      ]  
    },  
    {  
      "id": "d42d5ff8-74b4-49b4-8342-6ad4df4b1b4f",  
      "name": "role_list",  
      "description": "SAML role list",  
      "protocol": "saml",  
      "attributes": {  
        "consent.screen.text": "${samlRoleListScopeConsentText}",  
        "display.on.consent.screen": "true"  
      },  
      "protocolMappers": [  
        {  
          "id": "e43e30f8-8b98-43a3-8946-4c1b573eb6cf",  
          "name": "role list",  
          "protocol": "saml",  
          "protocolMapper": "saml-role-list-mapper",  
          "consentRequired": false,  
          "config": {  
            "single": "false",  
            "attribute.nameformat": "Basic",  
            "attribute.name": "Role"  
          }  
        }  
      ]  
    },  
    {  
      "id": "edf2dc67-df58-4f9c-8401-77031cc7f340",  
      "name": "email",  
      "description": "OpenID Connect built-in scope: email",  
      "protocol": "openid-connect",  
      "attributes": {  
        "include.in.token.scope": "false",  
        "display.on.consent.screen": "true",  
        "consent.screen.text": "${emailScopeConsentText}"  
      },  
      "protocolMappers": [  
        {  
          "id": "07b40387-335f-4b02-bb1a-dd11ac56bd32",  
          "name": "email verified",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-property-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "emailVerified",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "email_verified",  
            "jsonType.label": "boolean"  
          }  
        },  
        {  
          "id": "ffe8a165-fdb4-48d8-b259-8f3e770755ee",  
          "name": "email",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-property-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "email",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "email",  
            "jsonType.label": "String"  
          }  
        }  
      ]  
    },  
    {  
      "id": "e9137f0a-edc4-4896-be5e-1c742ac5107e",  
      "name": "address",  
      "description": "OpenID Connect built-in scope: address",  
      "protocol": "openid-connect",  
      "attributes": {  
        "include.in.token.scope": "false",  
        "display.on.consent.screen": "true",  
        "consent.screen.text": "${addressScopeConsentText}"  
      },  
      "protocolMappers": [  
        {  
          "id": "3d193e7a-0d9b-4ac4-a894-5e2aed2df7ca",  
          "name": "address",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-address-mapper",  
          "consentRequired": false,  
          "config": {  
            "user.attribute.formatted": "formatted",  
            "user.attribute.country": "country",  
            "user.attribute.postal_code": "postal_code",  
            "userinfo.token.claim": "true",  
            "user.attribute.street": "street",  
            "id.token.claim": "true",  
            "user.attribute.region": "region",  
            "access.token.claim": "false",  
            "user.attribute.locality": "locality"  
          }  
        }  
      ]  
    },  
    {  
      "id": "30f8384b-8c6c-4397-8278-d34010b9ed73",  
      "name": "microprofile-jwt",  
      "description": "Microprofile - JWT built-in scope",  
      "protocol": "openid-connect",  
      "attributes": {  
        "include.in.token.scope": "false",  
        "display.on.consent.screen": "false"  
      },  
      "protocolMappers": [  
        {  
          "id": "c46917f9-180c-4563-a683-0aada80950b1",  
          "name": "groups",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-realm-role-mapper",  
          "consentRequired": false,  
          "config": {  
            "multivalued": "true",  
            "userinfo.token.claim": "true",  
            "user.attribute": "foo",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "groups",  
            "jsonType.label": "String"  
          }  
        },  
        {  
          "id": "8c191e6d-a85c-40e6-8c48-93a69fa5ecbb",  
          "name": "upn",  
          "protocol": "openid-connect",  
          "protocolMapper": "oidc-usermodel-property-mapper",  
          "consentRequired": false,  
          "config": {  
            "userinfo.token.claim": "true",  
            "user.attribute": "username",  
            "id.token.claim": "true",  
            "access.token.claim": "false",  
            "claim.name": "upn",  
            "jsonType.label": "String"  
          }  
        }  
      ]  
    }  
  ],  
  "defaultDefaultClientScopes": [  
    "profile",  
    "roles",  
    "web-origins",  
    "role_list",  
    "email"  
  ],  
  "defaultOptionalClientScopes": [  
    "phone",  
    "microprofile-jwt",  
    "offline_access",  
    "address"  
  ],  
  "browserSecurityHeaders": {  
    "contentSecurityPolicyReportOnly": "",  
    "xContentTypeOptions": "nosniff",  
    "referrerPolicy": "no-referrer",  
    "xRobotsTag": "none",  
    "xFrameOptions": "SAMEORIGIN",  
    "contentSecurityPolicy": "frame-src 'self'; frame-ancestors 'self'; object-src 'none';",  
    "xXSSProtection": "1; mode=block",  
    "strictTransportSecurity": ""  
  },  
  "smtpServer": {  
    "replyToDisplayName": "scp-cloud@intelligen.com",  
    "starttls": "true",  
    "auth": "true",  
    "envelopeFrom": "scp-cloud@intelligen.com",  
    "ssl": "false",  
    "password": "**********",  
    "port": "587",  
    "host": "smtp.mail.yahoo.com",  
    "replyTo": "scp-cloud@intelligen.com",  
    "from": "scp-cloud@intelligen.com",  
    "fromDisplayName": "Scp Cloud App",  
    "user": "scp-cloud@intelligen.com"  
  },  
  "loginTheme": "scpCloud",  
  "accountTheme": "",  
  "adminTheme": "",  
  "emailTheme": "scpCloud",  
  "eventsEnabled": false,  
  "eventsListeners": [  
    "jboss-logging"  
  ],  
  "enabledEventTypes": [],  
  "adminEventsEnabled": false,  
  "adminEventsDetailsEnabled": false,  
  "identityProviders": [],  
  "identityProviderMappers": [],  
  "components": {  
    "org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy": [  
      {  
        "id": "3cee9da5-89ac-4da1-aa41-711c69e3f71b",  
        "name": "Full Scope Disabled",  
        "providerId": "scope",  
        "subType": "anonymous",  
        "subComponents": {},  
        "config": {}  
      },  
      {  
        "id": "ae350135-ef8f-4ac3-95ca-d7a2ee11d13b",  
        "name": "Consent Required",  
        "providerId": "consent-required",  
        "subType": "anonymous",  
        "subComponents": {},  
        "config": {}  
      },  
      {  
        "id": "f17eabf3-3815-488b-b832-2963912afe29",  
        "name": "Allowed Client Scopes",  
        "providerId": "allowed-client-templates",  
        "subType": "anonymous",  
        "subComponents": {},  
        "config": {  
          "allow-default-scopes": [  
            "true"  
          ]  
        }  
      },  
      {  
        "id": "ae6f7177-3195-466b-a785-1b8803f37f92",  
        "name": "Allowed Protocol Mapper Types",  
        "providerId": "allowed-protocol-mappers",  
        "subType": "authenticated",  
        "subComponents": {},  
        "config": {  
          "allowed-protocol-mapper-types": [  
            "oidc-sha256-pairwise-sub-mapper",  
            "oidc-address-mapper",  
            "saml-user-attribute-mapper",  
            "oidc-usermodel-property-mapper",  
            "saml-role-list-mapper",  
            "saml-user-property-mapper",  
            "oidc-usermodel-attribute-mapper",  
            "oidc-full-name-mapper"  
          ]  
        }  
      },  
      {  
        "id": "c6d55cc5-d105-4ac5-afb7-dbd18b28a825",  
        "name": "Trusted Hosts",  
        "providerId": "trusted-hosts",  
        "subType": "anonymous",  
        "subComponents": {},  
        "config": {  
          "host-sending-registration-request-must-match": [  
            "true"  
          ],  
          "client-uris-must-match": [  
            "true"  
          ]  
        }  
      },  
      {  
        "id": "a84dabca-c335-449c-8775-b75ac420a60a",  
        "name": "Allowed Protocol Mapper Types",  
        "providerId": "allowed-protocol-mappers",  
        "subType": "anonymous",  
        "subComponents": {},  
        "config": {  
          "allowed-protocol-mapper-types": [  
            "saml-user-attribute-mapper",  
            "saml-role-list-mapper",  
            "oidc-usermodel-attribute-mapper",  
            "oidc-sha256-pairwise-sub-mapper",  
            "saml-user-property-mapper",  
            "oidc-usermodel-property-mapper",  
            "oidc-full-name-mapper",  
            "oidc-address-mapper"  
          ]  
        }  
      },  
      {  
        "id": "fb7f494f-b0e5-4b95-bd9b-72a5e3aa76fc",  
        "name": "Max Clients Limit",  
        "providerId": "max-clients",  
        "subType": "anonymous",  
        "subComponents": {},  
        "config": {  
          "max-clients": [  
            "200"  
          ]  
        }  
      },  
      {  
        "id": "a62dcdbc-fed1-4ba0-8876-b1c97738e9c5",  
        "name": "Allowed Client Scopes",  
        "providerId": "allowed-client-templates",  
        "subType": "authenticated",  
        "subComponents": {},  
        "config": {  
          "allow-default-scopes": [  
            "true"  
          ]  
        }  
      }  
    ],  
    "org.keycloak.storage.UserStorageProvider": [  
      {  
        "id": "591e353f-455d-4272-8cf7-0fc37e7f5578",  
        "name": "ldap",  
        "providerId": "ldap",  
        "subComponents": {  
          "org.keycloak.storage.ldap.mappers.LDAPStorageMapper": [  
            {  
              "id": "e8b6d47e-c17c-4105-91ee-304a03e73c53",  
              "name": "LDAP_ID",  
              "providerId": "user-attribute-ldap-mapper",  
              "subComponents": {},  
              "config": {  
                "ldap.attribute": [  
                  "objectGUID"  
                ],  
                "attribute.force.default": [  
                  "false"  
                ],  
                "is.mandatory.in.ldap": [  
                  "false"  
                ],  
                "is.binary.attribute": [  
                  "false"  
                ],  
                "read.only": [  
                  "true"  
                ],  
                "user.model.attribute": [  
                  "LDAP_ID"  
                ]  
              }  
            },  
            {  
              "id": "534b28bd-fc9c-458f-84ee-8c3e86592cdf",  
              "name": "Read-only Group Mapper",  
              "providerId": "group-ldap-mapper",  
              "subComponents": {},  
              "config": {  
                "membership.attribute.type": [  
                  "DN"  
                ],  
                "group.name.ldap.attribute": [  
                  "cn"  
                ],  
                "preserve.group.inheritance": [  
                  "false"  
                ],  
                "membership.user.ldap.attribute": [  
                  "userPrincipalName"  
                ],  
                "groups.dn": [  
                  "OU=AllUsers,DC=test,DC=local"  
                ],  
                "mode": [  
                  "READ_ONLY"  
                ],  
                "user.roles.retrieve.strategy": [  
                  "LOAD_GROUPS_BY_MEMBER_ATTRIBUTE"  
                ],  
                "ignore.missing.groups": [  
                  "false"  
                ],  
                "membership.ldap.attribute": [  
                  "member"  
                ],  
                "group.object.classes": [  
                  "group"  
                ],  
                "memberof.ldap.attribute": [  
                  "memberOf"  
                ],  
                "groups.path": [  
                  "/"  
                ],  
                "drop.non.existing.groups.during.sync": [  
                  "false"  
                ]  
              }  
            },  
            {  
              "id": "3ccd7971-4e88-4884-9138-f742fe04d053",  
              "name": "modify date",  
              "providerId": "user-attribute-ldap-mapper",  
              "subComponents": {},  
              "config": {  
                "ldap.attribute": [  
                  "whenChanged"  
                ],  
                "is.mandatory.in.ldap": [  
                  "false"  
                ],  
                "read.only": [  
                  "true"  
                ],  
                "always.read.value.from.ldap": [  
                  "true"  
                ],  
                "user.model.attribute": [  
                  "modifyTimestamp"  
                ]  
              }  
            },  
            {  
              "id": "5f63b9f8-d96c-4d62-bdeb-16e6f36189bb",  
              "name": "last name",  
              "providerId": "user-attribute-ldap-mapper",  
              "subComponents": {},  
              "config": {  
                "ldap.attribute": [  
                  "sn"  
                ],  
                "is.mandatory.in.ldap": [  
                  "true"  
                ],  
                "read.only": [  
                  "true"  
                ],  
                "always.read.value.from.ldap": [  
                  "true"  
                ],  
                "user.model.attribute": [  
                  "lastName"  
                ]  
              }  
            },  
            {  
              "id": "86aa7539-1a87-4c05-a052-4af4cdc07394",  
              "name": "username",  
              "providerId": "user-attribute-ldap-mapper",  
              "subComponents": {},  
              "config": {  
                "ldap.attribute": [  
                  "cn"  
                ],  
                "is.mandatory.in.ldap": [  
                  "true"  
                ],  
                "read.only": [  
                  "true"  
                ],  
                "always.read.value.from.ldap": [  
                  "false"  
                ],  
                "user.model.attribute": [  
                  "username"  
                ]  
              }  
            },  
            {  
              "id": "262339e9-03d5-4234-a886-732466b1e4de",  
              "name": "email",  
              "providerId": "user-attribute-ldap-mapper",  
              "subComponents": {},  
              "config": {  
                "ldap.attribute": [  
                  "mail"  
                ],  
                "is.mandatory.in.ldap": [  
                  "false"  
                ],  
                "read.only": [  
                  "true"  
                ],  
                "always.read.value.from.ldap": [  
                  "false"  
                ],  
                "user.model.attribute": [  
                  "email"  
                ]  
              }  
            },  
            {  
              "id": "e8507e27-57ec-442c-bb34-11fbc7750a45",  
              "name": "MSAD account controls",  
              "providerId": "msad-user-account-control-mapper",  
              "subComponents": {},  
              "config": {}  
            },  
            {  
              "id": "9af8d557-4d7a-43c6-a441-2cbbb7bdfa22",  
              "name": "first name",  
              "providerId": "user-attribute-ldap-mapper",  
              "subComponents": {},  
              "config": {  
                "ldap.attribute": [  
                  "givenName"  
                ],  
                "is.mandatory.in.ldap": [  
                  "true"  
                ],  
                "read.only": [  
                  "true"  
                ],  
                "always.read.value.from.ldap": [  
                  "true"  
                ],  
                "user.model.attribute": [  
                  "firstName"  
                ]  
              }  
            },  
            {  
              "id": "7871490b-e092-44fa-bde8-1abb576b5c9a",  
              "name": "creation date",  
              "providerId": "user-attribute-ldap-mapper",  
              "subComponents": {},  
              "config": {  
                "ldap.attribute": [  
                  "whenCreated"  
                ],  
                "is.mandatory.in.ldap": [  
                  "false"  
                ],  
                "always.read.value.from.ldap": [  
                  "true"  
                ],  
                "read.only": [  
                  "true"  
                ],  
                "user.model.attribute": [  
                  "createTimestamp"  
                ]  
              }  
            }  
          ]  
        },  
        "config": {  
          "pagination": [  
            "false"  
          ],  
          "fullSyncPeriod": [  
            "-1"  
          ],  
          "startTls": [  
            "false"  
          ],  
          "usersDn": [  
            "OU=AllUsers, DC=test, DC=local"  
          ],  
          "connectionPooling": [  
            "true"  
          ],  
          "cachePolicy": [  
            "DEFAULT"  
          ],  
          "useKerberosForPasswordAuthentication": [  
            "false"  
          ],  
          "importEnabled": [  
            "false"  
          ],  
          "enabled": [  
            "false"  
          ],  
          "usernameLDAPAttribute": [  
            "userPrincipalName"  
          ],  
          "bindCredential": [  
            "**********"  
          ],  
          "changedSyncPeriod": [  
            "-1"  
          ],  
          "bindDn": [  
            "TEST\\keycloak_ldap"  
          ],  
          "vendor": [  
            "ad"  
          ],  
          "uuidLDAPAttribute": [  
            "objectGUID"  
          ],  
          "connectionUrl": [  
            "ldap://192.168.1.207"  
          ],  
          "allowKerberosAuthentication": [  
            "false"  
          ],  
          "syncRegistrations": [  
            "false"  
          ],  
          "authType": [  
            "simple"  
          ],  
          "krbPrincipalAttribute": [  
            "userPrincipalName"  
          ],  
          "customUserSearchFilter": [  
            "(memberOf=CN=ScpCloud_staff, OU=AllUsers,DC=test,DC=local)"  
          ],  
          "searchScope": [  
            "2"  
          ],  
          "useTruststoreSpi": [  
            "always"  
          ],  
          "usePasswordModifyExtendedOp": [  
            "false"  
          ],  
          "trustEmail": [  
            "false"  
          ],  
          "userObjectClasses": [  
            "person, organizationalPerson, user"  
          ],  
          "rdnLDAPAttribute": [  
            "cn"  
          ],  
          "editMode": [  
            "READ_ONLY"  
          ],  
          "validatePasswordPolicy": [  
            "false"  
          ]  
        }  
      }  
    ],  
    "org.keycloak.keys.KeyProvider": [  
      {  
        "id": "2fe37f7b-61b0-4f27-83d8-e28852fd4beb",  
        "name": "rsa-enc-generated",  
        "providerId": "rsa-generated",  
        "subComponents": {},  
        "config": {  
          "priority": [  
            "100"  
          ]  
        }  
      },  
      {  
        "id": "4bde243d-b3c0-4fc4-a3dc-12dac29e5520",  
        "name": "hmac-generated",  
        "providerId": "hmac-generated",  
        "subComponents": {},  
        "config": {  
          "priority": [  
            "100"  
          ],  
          "algorithm": [  
            "HS256"  
          ]  
        }  
      },  
      {  
        "id": "da355ba4-2b44-4c8f-9c7a-3efb9ae77eb9",  
        "name": "rsa-generated",  
        "providerId": "rsa-generated",  
        "subComponents": {},  
        "config": {  
          "priority": [  
            "100"  
          ]  
        }  
      },  
      {  
        "id": "6eb29d50-6609-464e-bd72-1b9ecbf158b4",  
        "name": "aes-generated",  
        "providerId": "aes-generated",  
        "subComponents": {},  
        "config": {  
          "priority": [  
            "100"  
          ]  
        }  
      }  
    ]  
  },  
  "internationalizationEnabled": false,  
  "supportedLocales": [],  
  "authenticationFlows": [  
    {  
      "id": "f2c8457c-2560-4f4e-ae0f-942d930c984d",  
      "alias": "Account verification options",  
      "description": "Method with which to verity the existing account",  
      "providerId": "basic-flow",  
      "topLevel": false,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "idp-email-verification",  
          "authenticatorFlow": false,  
          "requirement": "ALTERNATIVE",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticatorFlow": true,  
          "requirement": "ALTERNATIVE",  
          "priority": 20,  
          "autheticatorFlow": true,  
          "flowAlias": "Verify Existing Account by Re-authentication",  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "8cbdfaa5-1027-4e6f-b4e1-cad85ca98ae1",  
      "alias": "Browser - Conditional OTP",  
      "description": "Flow to determine if the OTP is required for the authentication",  
      "providerId": "basic-flow",  
      "topLevel": false,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "conditional-user-configured",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "auth-otp-form",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 20,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "e3ef0c51-cb55-41c5-9d4c-08f5a5af2e1e",  
      "alias": "Direct Grant - Conditional OTP",  
      "description": "Flow to determine if the OTP is required for the authentication",  
      "providerId": "basic-flow",  
      "topLevel": false,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "conditional-user-configured",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "direct-grant-validate-otp",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 20,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "c09cc451-57f8-48ca-bcad-1db4e10ab740",  
      "alias": "First broker login - Conditional OTP",  
      "description": "Flow to determine if the OTP is required for the authentication",  
      "providerId": "basic-flow",  
      "topLevel": false,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "conditional-user-configured",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "auth-otp-form",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 20,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "8d442f9c-d201-426f-96c5-08aed5948204",  
      "alias": "Handle Existing Account",  
      "description": "Handle what to do if there is existing account with same email/username like authenticated identity provider",  
      "providerId": "basic-flow",  
      "topLevel": false,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "idp-confirm-link",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticatorFlow": true,  
          "requirement": "REQUIRED",  
          "priority": 20,  
          "autheticatorFlow": true,  
          "flowAlias": "Account verification options",  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "9a2d7848-bbd9-4439-8993-d70f21d77169",  
      "alias": "Reset - Conditional OTP",  
      "description": "Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.",  
      "providerId": "basic-flow",  
      "topLevel": false,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "conditional-user-configured",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "reset-otp",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 20,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "9be4d8c5-ffbf-4dfe-8642-ccbfee5299b5",  
      "alias": "User creation or linking",  
      "description": "Flow for the existing/non-existing user alternatives",  
      "providerId": "basic-flow",  
      "topLevel": false,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticatorConfig": "create unique user config",  
          "authenticator": "idp-create-user-if-unique",  
          "authenticatorFlow": false,  
          "requirement": "ALTERNATIVE",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticatorFlow": true,  
          "requirement": "ALTERNATIVE",  
          "priority": 20,  
          "autheticatorFlow": true,  
          "flowAlias": "Handle Existing Account",  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "88ae70f2-1a2a-41e9-8cc4-addcd413b432",  
      "alias": "Verify Existing Account by Re-authentication",  
      "description": "Reauthentication of existing account",  
      "providerId": "basic-flow",  
      "topLevel": false,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "idp-username-password-form",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticatorFlow": true,  
          "requirement": "CONDITIONAL",  
          "priority": 20,  
          "autheticatorFlow": true,  
          "flowAlias": "First broker login - Conditional OTP",  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "fa0942df-2caf-45a3-a513-397c8f55e9a2",  
      "alias": "browser",  
      "description": "browser based authentication",  
      "providerId": "basic-flow",  
      "topLevel": true,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "auth-cookie",  
          "authenticatorFlow": false,  
          "requirement": "ALTERNATIVE",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "auth-spnego",  
          "authenticatorFlow": false,  
          "requirement": "DISABLED",  
          "priority": 20,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "identity-provider-redirector",  
          "authenticatorFlow": false,  
          "requirement": "ALTERNATIVE",  
          "priority": 25,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticatorFlow": true,  
          "requirement": "ALTERNATIVE",  
          "priority": 30,  
          "autheticatorFlow": true,  
          "flowAlias": "forms",  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "abd491a3-f40b-4e6d-bdd7-19a6419c1771",  
      "alias": "clients",  
      "description": "Base authentication for clients",  
      "providerId": "client-flow",  
      "topLevel": true,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "client-secret",  
          "authenticatorFlow": false,  
          "requirement": "ALTERNATIVE",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "client-jwt",  
          "authenticatorFlow": false,  
          "requirement": "ALTERNATIVE",  
          "priority": 20,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "client-secret-jwt",  
          "authenticatorFlow": false,  
          "requirement": "ALTERNATIVE",  
          "priority": 30,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "client-x509",  
          "authenticatorFlow": false,  
          "requirement": "ALTERNATIVE",  
          "priority": 40,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "49759873-28e5-48b3-b6bd-68ce6765411d",  
      "alias": "direct grant",  
      "description": "OpenID Connect Resource Owner Grant",  
      "providerId": "basic-flow",  
      "topLevel": true,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "direct-grant-validate-username",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "direct-grant-validate-password",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 20,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticatorFlow": true,  
          "requirement": "CONDITIONAL",  
          "priority": 30,  
          "autheticatorFlow": true,  
          "flowAlias": "Direct Grant - Conditional OTP",  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "39472373-0a94-471a-b4bb-5b2524f72ff5",  
      "alias": "docker auth",  
      "description": "Used by Docker clients to authenticate against the IDP",  
      "providerId": "basic-flow",  
      "topLevel": true,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "docker-http-basic-authenticator",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "477b7657-d39d-4fb3-b104-cd31a226c454",  
      "alias": "first broker login",  
      "description": "Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account",  
      "providerId": "basic-flow",  
      "topLevel": true,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticatorConfig": "review profile config",  
          "authenticator": "idp-review-profile",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticatorFlow": true,  
          "requirement": "REQUIRED",  
          "priority": 20,  
          "autheticatorFlow": true,  
          "flowAlias": "User creation or linking",  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "de2fa724-0c10-4054-a27b-d8c4413fa992",  
      "alias": "forms",  
      "description": "Username, password, otp and other auth forms.",  
      "providerId": "basic-flow",  
      "topLevel": false,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "auth-username-password-form",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticatorFlow": true,  
          "requirement": "CONDITIONAL",  
          "priority": 20,  
          "autheticatorFlow": true,  
          "flowAlias": "Browser - Conditional OTP",  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "85b843bc-5dc6-45fd-a7c6-33ae54a6e6ab",  
      "alias": "registration",  
      "description": "registration flow",  
      "providerId": "basic-flow",  
      "topLevel": true,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "registration-page-form",  
          "authenticatorFlow": true,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": true,  
          "flowAlias": "registration form",  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "76f144f7-5f53-4a1f-9e14-2e6159fb5ec3",  
      "alias": "registration form",  
      "description": "registration form",  
      "providerId": "form-flow",  
      "topLevel": false,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "registration-user-creation",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 20,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "registration-profile-action",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 40,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "registration-password-action",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 50,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "registration-recaptcha-action",  
          "authenticatorFlow": false,  
          "requirement": "DISABLED",  
          "priority": 60,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "f3c38fb3-c333-409e-b47d-ac4e0f58d173",  
      "alias": "reset credentials",  
      "description": "Reset credentials for a user if they forgot their password or something",  
      "providerId": "basic-flow",  
      "topLevel": true,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "reset-credentials-choose-user",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "reset-credential-email",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 20,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticator": "reset-password",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 30,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        },  
        {  
          "authenticatorFlow": true,  
          "requirement": "CONDITIONAL",  
          "priority": 40,  
          "autheticatorFlow": true,  
          "flowAlias": "Reset - Conditional OTP",  
          "userSetupAllowed": false  
        }  
      ]  
    },  
    {  
      "id": "e47088da-c46a-40b2-8cd8-5d7428a01f30",  
      "alias": "saml ecp",  
      "description": "SAML ECP Profile Authentication Flow",  
      "providerId": "basic-flow",  
      "topLevel": true,  
      "builtIn": true,  
      "authenticationExecutions": [  
        {  
          "authenticator": "http-basic-authenticator",  
          "authenticatorFlow": false,  
          "requirement": "REQUIRED",  
          "priority": 10,  
          "autheticatorFlow": false,  
          "userSetupAllowed": false  
        }  
      ]  
    }  
  ],  
  "authenticatorConfig": [  
    {  
      "id": "338661d4-5f25-4f19-8b5a-8a0573ee1836",  
      "alias": "create unique user config",  
      "config": {  
        "require.password.update.after.registration": "false"  
      }  
    },  
    {  
      "id": "267c91ed-9580-4f5c-9fc3-1da512a3ac33",  
      "alias": "review profile config",  
      "config": {  
        "update.profile.on.first.login": "missing"  
      }  
    }  
  ],  
  "requiredActions": [  
    {  
      "alias": "CONFIGURE_TOTP",  
      "name": "Configure OTP",  
      "providerId": "CONFIGURE_TOTP",  
      "enabled": true,  
      "defaultAction": false,  
      "priority": 10,  
      "config": {}  
    },  
    {  
      "alias": "TERMS_AND_CONDITIONS",  
      "name": "Terms and Conditions",  
      "providerId": "TERMS_AND_CONDITIONS",  
      "enabled": false,  
      "defaultAction": false,  
      "priority": 20,  
      "config": {}  
    },  
    {  
      "alias": "UPDATE_PASSWORD",  
      "name": "Update Password",  
      "providerId": "UPDATE_PASSWORD",  
      "enabled": true,  
      "defaultAction": false,  
      "priority": 30,  
      "config": {}  
    },  
    {  
      "alias": "UPDATE_PROFILE",  
      "name": "Update Profile",  
      "providerId": "UPDATE_PROFILE",  
      "enabled": true,  
      "defaultAction": false,  
      "priority": 40,  
      "config": {}  
    },  
    {  
      "alias": "VERIFY_EMAIL",  
      "name": "Verify Email",  
      "providerId": "VERIFY_EMAIL",  
      "enabled": true,  
      "defaultAction": false,  
      "priority": 50,  
      "config": {}  
    },  
    {  
      "alias": "delete_account",  
      "name": "Delete Account",  
      "providerId": "delete_account",  
      "enabled": false,  
      "defaultAction": false,  
      "priority": 60,  
      "config": {}  
    },  
    {  
      "alias": "update_user_locale",  
      "name": "Update User Locale",  
      "providerId": "update_user_locale",  
      "enabled": true,  
      "defaultAction": false,  
      "priority": 1000,  
      "config": {}  
    }  
  ],  
  "browserFlow": "browser",  
  "registrationFlow": "registration",  
  "directGrantFlow": "direct grant",  
  "resetCredentialsFlow": "reset credentials",  
  "clientAuthenticationFlow": "clients",  
  "dockerAuthenticationFlow": "docker auth",  
  "attributes": {  
    "cibaBackchannelTokenDeliveryMode": "poll",  
    "cibaAuthRequestedUserHint": "login_hint",  
    "clientOfflineSessionMaxLifespan": "0",  
    "oauth2DevicePollingInterval": "5",  
    "clientSessionIdleTimeout": "0",  
    "clientOfflineSessionIdleTimeout": "0",  
    "cibaInterval": "5",  
    "realmReusableOtpCode": "false",  
    "cibaExpiresIn": "120",  
    "oauth2DeviceCodeLifespan": "600",  
    "parRequestUriLifespan": "60",  
    "clientSessionMaxLifespan": "0",  
    "frontendUrl": "",  
    "acr.loa.map": "{}"  
  },  
  "keycloakVersion": "22.0.5",  
  "userManagedAccessAllowed": false,  
  "clientProfiles": {  
    "profiles": []  
  },  
  "clientPolicies": {  
    "policies": []  
  }  
}