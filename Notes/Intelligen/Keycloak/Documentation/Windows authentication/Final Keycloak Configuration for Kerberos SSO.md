---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
tags:
  - intelligen
  - keycloak
---

### In Active directory server

- First add a keycloaksvc user under users group.
- Use command prompt (this is needed for the kerberos connection only):

	`setspn -A HTTP/keycloak.test.local test\keycloaksvc`

	Checking domain DC=test,DC=local
	Registering ServicePrincipalNames for CN=keycloaksvc,CN=Users,DC=test,DC=local
	HTTP/keycloak.test.local
	Updated object

	**setspn** is used to register a **Service Principal Name (SPN)** in Active Directory (AD)

	```
		ktpass -princ HTTP/keycloak.test.local@TEST.LOCAL -mapuser test\keycloaksvc -pass ComplexPassword123!
		-ptype KRBS_NT_PRINCIPAL -out C:\keycloak.keytab
	```

	Targeting domain controller: WIN-UF83AI5P4N7.test.local
	Using legacy password setting method
	Successfully mapped HTTP/keycloak.test.local to keycloaksvc.
	Key created.
	Output keytab to C:\keycloak.keytab:
	Keytab version: 0x502
	keysize 70 HTTP/keycloak.test.local@TEST.LOCAL ptype 1 (KRBS_NT_PRINCIPAL) vno 3 etype 0x17 (RC4-HMAC) keylength 16 (0x5fdca9e14c180e10b13532331f9b9)


	**ktpass** is used to create a **Kerberos keytab file** for a service that will use **Kerberos authentication**, and associate it with a specific **Active Directory (AD) service account**.

	![Exported image|875x328](Exported%20image%2020260209140242-0.png)
	![Exported image](Exported%20image%2020260209140243-1.png)

### Final Keycloak Configuration for Kerberos SSO
Here’s how to enable Kerberos authentication in the Keycloak UI.

#### Step 1: Create/Update the LDAP User Federation

1. Open Keycloak admin at: https://keycloak.test.local:28443
2. Go to User Federation → LDAP → click Add provider.

3. Fill these:
	• Vendor: Active Directory
	• Connection URL: ldap://192.168.1.206:389
	• Users DN: something like CN=Users,DC=test,DC=local
	• Bind DN: TEST\keycloaksvc
	• Bind Credential: YourKeycloakSvcPassword
	• ✅ Enable StartTLS if desired
4. Then scroll down to:
	• ✅ Enable Allow Kerberos authentication
	• Kerberos Realm: TEST.LOCAL
	• Server Principal: HTTP/keycloak.test.local@TEST.LOCAL
	• KeyTab: /opt/keycloak/conf/keycloak.keytab
	
5. Click Test authentication → It should say success.
6. Save.

#### Step 2: Modify the Authentication Flow

1. Go to Authentication → Flows.
2. Click Browser → Duplicate it → call it Browser with Kerberos.
3. In the duplicated flow:
	○ Click Add execution → choose Kerberos → Add
	○ Set the Kerberos execution to ALTERNATIVE or REQUIRED.
	○ Make sure Username Password Form is still in the flow in case Kerberos fails.
4. Set this new flow as the default:
	○ Go to Bindings tab → Browser Flow: Browser with Kerberos

#### Step 3: Browser + Client Configuration

Browser
	• Access site using domain-joined machine.
	• Use Chrome/Edge/Firefox.
	• Ensure https://keycloak.test.local is in the Intranet Zone (Windows → Internet Options → Security).
	• Enable automatic login:
		○ Internet Options > Security > Intranet Zone > Custom Level > User Authentication > Logon: Automatic logon with current user name and password

Keycloak Client
	• Your ASP.NET Core app should be a Keycloak client.
	• SSO will work when you redirect to the Keycloak login page.

### Test SSO

1. From domain-joined Windows machine:
		○ Go to https://keycloak.test.local:28443/realms/{realm-name}/account
		○ You should auto-login with your AD credentials (SPNEGO handshake).
2. Watch logs:
		○ Docker logs should show something like:
		[org.keycloak.authentication.authenticators.browser.SpnegoAuthenticator] 
		Authenticated user with Kerberos: username@TEST.LOCAL

Would you like a checklist for integrating ASP.NET Core with this Keycloak realm using OpenID Connect next?

Από <https://chatgpt.com/c/681b3fe6-2a8c-8012-a5d3-7e6210614009>
