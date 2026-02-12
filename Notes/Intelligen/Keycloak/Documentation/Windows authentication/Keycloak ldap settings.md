---
component: Keycloak
tags:
  - intelligen
---
ο»Ώ---
created: 2025-05-08T10:04
tags:
  - keycloak
  - intelligen
categories:
  - "[[Work]]"
  - "[[Documentation]]"
---

**Keycloak documentation**  
[https://www.keycloak.org/docs/latest/server_admin/index.html#_user-storage-federation](https://www.keycloak.org/docs/latest/server_admin/index.html#_user-storage-federation)  
[https://www.keycloak.org/docs/latest/server_admin/index.html#_ldap](https://www.keycloak.org/docs/latest/server_admin/index.html#_ldap)

- **In Active directory server**
- **Disable "Email Verified" and related Required Actions**
    - Go to **Realm Settings** Ξ²β€ β€™ **Login**
    - Uncheck:
        - Ξ²Ββ€ Verify email on login

- **Add LDAP provider with the following settings:**
  User federation/ldap_card_click/settings
  ![[image-23.png]]
---
> **==connection URL is the AD url, the above is from the test environment==**
> **==keycloak_ldap password in development tests = ComplexPassword123!==**	

---
![[image-24.png|897x202]]

---
> ΞΒ **DN (Distinguished Name)** Ξβ€ΞΞΞβ€¦ LDAP admin ΞΒµΞβ€•ΞΒ½ΞΒ±ΞΞ‰ ΞΒ· Ξβ‚¬ΞΒ»ΞΒ®ΞΒΞΒ·Ξβ€ Ξ’Β«ΞΞ„ΞΞ‰ΞΒµΞΒΞΞΞβ€¦ΞΒ½ΞΖ’ΞΒ·Ξ’Β» Ξβ€ΞΒ·Ξβ€ ΞΒµΞΒ³ΞΒ³ΞΒΞΒ±Ξβ€ ΞΒ®Ξβ€ Ξβ€ΞΞΞβ€¦ Ξβ€΅ΞΒΞΒ®ΞΖ’Ξβ€ΞΒ· ΞΖ’Ξβ€ΞΞΞΒ½ LDAP directory Ξβ‚¬ΞΞΞβ€¦ ΞΞΞΒ± Ξβ€΅ΞΒΞΒ·ΞΖ’ΞΞ‰ΞΞΞΞΞβ‚¬ΞΞΞΞ‰ΞΒ·ΞΞΞΒµΞβ€• ΞΒ±Ξβ‚¬ΞΒ Ξβ€ΞΞ Keycloak ΞΒ³ΞΞ‰ΞΒ± ΞΒ½ΞΒ± ΞΖ’Ξβ€¦ΞΒ½ΞΞ„ΞΒµΞΞΞΒµΞβ€• ΞΞΞΒ±ΞΞ‰ ΞΒ½ΞΒ± ΞΒµΞΞΞβ€ΞΒµΞΒ»ΞΒµΞβ€• ΞΒ»ΞΒµΞΞ‰Ξβ€ΞΞΞβ€¦ΞΒΞΒ³Ξβ€•ΞΒµΞβ€ (bind) ΞΖ’Ξβ€ΞΞΞΒ½ LDAP server.

---
![[image-25.png]]

![[image-26.png]]

If using **userPrincipalName** the the log username in should be like user1@test.local
The **sAMAccountName** is for only the user name like user1 

- **Map objectGUID of the AD user to a claim "userId" in user token**
    - **Add ldap mapper first:**
      
    ![Exported image](Exported%20image%2020260209140220-0.png)  
    - **Next add a client scope mapper protocol: (Client scopes, scpCloud-client-scope)**
      
    ![Exported image](Exported%20image%2020260209140221-1.png)
    - **Map AD user gropus to a claim "groups" in user token**
	    - **Add a goup mapper in ldap:**
      
    -![Exported image](Exported%20image%2020260209140226-2.png)
	![[image-29.png]]
    
    - **Next add a client scope mapper protocol:**
      
    ![Exported image](Exported%20image%2020260209140229-4.png) 
- **Add user in Active directory and use it to login**
	After user creation optionaly create admins group and add the user:
	Create an AD Group
	In Active Directory:
		Ξ²β€”β€Ή Open Active Directory Users and Computers
		Ξ²β€”β€Ή Create a new group:
			 - Name: ScpCloudAdmins
			 - Scope: Global
			 - Type: Security
			 - Goto user memberof and add the group
	
	Token Results:
	```
		{
		  "exp": 1747317567,
		  "iat": 1747315767,
		  "auth_time": 1747315766,
		  "jti": "34945d27-fa2c-4929-8070-de24b9fdbd79",
		  "iss": " https://localhost:28443/realms/ScpCloud",
		  "aud": "scpCloud",
		  "sub": "f:591e353f-455d-4272-8cf7-0fc37e7f5578:adminUser@test.local",
		  "typ": "Bearer",
		  "azp": "scpCloud",
		  "nonce": "d6816cd5-3397-4d9a-83e3-d47e07398c57",
		  "session_state": "71212ae8-c51d-45f7-9633-858d3e0655f0",
		  "allowed-origins": [
		    "*"
		  ],
		  "scope": "openid",
		  "sid": "71212ae8-c51d-45f7-9633-858d3e0655f0",
		  "groups": [
		    "ScpCloudAdmins"
		  ],
		  "userId": "61ee043e-3ba8-4036-99d7-52fdb75b3e7a"
		}
	```
	
	while the current jwt claims are:
	```
		{
		  "exp": 1747316367,
		  "iat": 1747229969,
		  "auth_time": 1747229967,
		  "jti": "e45e3218-e18f-4630-a70b-db628ef40553",
		  "iss": " https://localhost:28443/realms/ScpCloud",
		  "aud": "scpCloud",
		  "sub": "250819c2-20b0-4968-add1-6da32726bee3",
		  "typ": "Bearer",
		  "azp": "scpCloud",
		  "nonce": "e696c0a0-615a-4bc5-82c3-f10df68aa9ee",
		  "session_state": "8ffcae33-a274-43e3-b360-4928b12e7e74",
		  "allowed-origins": [
		    "*"
		  ],
		  "scope": "openid",
		  "sid": "8ffcae33-a274-43e3-b360-4928b12e7e74",
		  "isAdmin": "true"
		}
	```

- **Alternative to expose groups the user belongs in the Keycloak tokens for LDAP/Active Directory users:**
  	==Since Group Membership mappers in recent Keycloak versions no longer allow setting a true/false claim directly,== 
	==you can use a Script Mapper, which is fully customizable.==
	
		Create Script Mapper
		Field	Value
		Name	isAdminScriptMapper
		Mapper Type	Script Mapper
	
	Script:
	Paste this in the script box:
	```
	// Check if user is in the ScpCloudAdmins group
	if (user && user.getGroups().stream().anyMatch(g => g.getName().equals("ScpCloudAdmins"))) {
	  token.setOtherClaim("isAdmin", true);
	}
	```
	
	Also check the following:
		Ξ²β€”β€Ή Add to ID token: Ξ²Ββ€¦
		Ξ²β€”β€Ή Add to Access token: Ξ²Ββ€¦
		Ξ²β€”β€Ή Add to userinfo: Ξ²Ββ€¦
	
	==The above is disabled for security reasons that is why we ended to have groups instead.==

- **Active directory account for keycloak service considerations**
  	Keycloak requires Bind DN and Bind Credentials to authenticate with the LDAP server and perform user synchronization or authentication tasks. Here's a breakdown of their roles and requirements:
	Why These Fields Are Required
		**1. Bind Type**
			Ξ²β€”β€Ή Defines the authentication method for the LDAP connection.
			Ξ²β€”β€Ή Simple is the most common choice, using a username/password (Bind DN + Credentials) to authenticate Keycloak to the LDAP server369.
		**2. Bind DN**
			Ξ²β€”β€Ή The Distinguished Name (DN) of a service account with read access to the LDAP directory.
			Ξ²β€”β€Ή Example: cn=service-account,ou=users,dc=example,dc=com138.
			Ξ²β€”β€Ή Keycloak uses this account to search for users, validate credentials, and sync data59.
		**3. Bind Credentials**
			Ξ²β€”β€Ή The password for the service account specified in Bind DN.
			Ξ²β€”β€Ή Without this, Keycloak cannot authenticate to the LDAP server368.
	**Account Requirements for "Simple" Bind Type**
	The account linked to the Bind DN must:
		Ξ²β‚¬Ξ† Have read access to the LDAP directory subtree where users/groups are stored359.
		Ξ²β‚¬Ξ† Be a dedicated service account (not a regular user account) to avoid permission issues68.
		Ξ²β‚¬Ξ† Use a non-expiring password to prevent authentication failures6.
	**Security Considerations**
		Ξ²β‚¬Ξ† Avoid hardcoding credentials: Use environment variables or secrets management tools (e.g., Kubernetes Secrets) to inject credentials at runtime2.
		Ξ²β‚¬Ξ† Restrict LDAP permissions: Ensure the service account has minimal privileges (e.g., read-only access)38.
		Ξ²β‚¬Ξ† Encrypt connections: Use ldaps:// instead of ldap:// to protect credentials in transit35.
	Example Configuration
		
		```text
		Bind Type: Simple  
		Bind DN: cn=keycloak-ldap,ou=service-accounts,dc=example,dc=com  
		Bind Credentials: (secured via environment variable)  
		Connection URL: ldaps://ldap.example.com:636  
		Users DN: ou=users,dc=example,dc=com  
		```
	
	This setup allows Keycloak to securely query and authenticate users from the LDAP directory357.
	
	Citations:
		1. https://www.olvid.io/keycloak/ldap-federation/
		2. https://stackoverflow.com/questions/62681411/keycloak-docker-import-ldap-bind-credentials-without-exposing-them
		3. https://docs.hitachivantara.com/r/en-us/content-intelligence/3.0.x/mk-hci000/security/adding-an-ldap-provider-with-keycloak
		4. https://www.keycloak.org/docs/latest/server_admin/index.html
		5. https://dmc.datical.com/administer/configure-keycloak-ldap.htm
		6. https://community.ataccama.com/master-data-management-reference-data-management-92/ldap-integration-with-keycloak-194
		7. https://docs.hitachivantara.com/r/en-us/content-intelligence/3.0.x/mk-hci000/security/adding-an-ldap-provider-with-keycloak?contentId=ykkUijfVtz8ujTpyDyUW8Q
		8. https://doc.castsoftware.com/export/AIPCONSOLE/Keycloak+-+LDAP
		9. https://www.ibm.com/docs/en/z-anomaly-analytics/5.1.0?topic=authentication-defining-ldap-based-user-federation-in-keycloak
		10. https://help.hcl-software.com/hcllink/1.1.6/administration/keycloak/tasks/t_keycloak_required_setting_for_connecton_to_ldap.html
		11. https://documentation.avaya.com/bundle/AdministeringAvayaDeviceServices_R10.2.x/page/Configuring_LDAPS_in_Keycloak.html
		12. https://stackoverflow.com/questions/73343766/keycloak-connection-url-ldap-with-bind-type-none
		13. https://github.com/please-openit/LDAP-Bind-Proxy
		14. https://www.keycloak.org/docs/latest/server_admin/index.html
		15. https://www.keycloak.org
		16. https://inero-software.com/exporting-accounts-to-federated-realms/
		17. https://www.olvid.io/keycloak/ldap-federation/
	
	**Why the keycloaksvc account works with a domain created by default**
	To check whether a simple user in your Active Directory domain can see other users by default, you need to verify the effective permissions that user has on the relevant AD containers or objects (such as the Users container or organizational units).
	How to Check if a User Can See Other Users in AD
		**1. Use Active Directory Users and Computers (ADUC)**
			Ξ²β€”β€Ή Open ADUC on a machine with the appropriate admin tools installed.
			Ξ²β€”β€Ή Navigate to the container or OU where user accounts reside (e.g., Users or a specific OU).
			Ξ²β€”β€Ή Right-click the container and select Properties.
			Ξ²β€”β€Ή Go to the Security tab, then click Advanced.
			Ξ²β€”β€Ή Switch to the Effective Access (or Effective Permissions) tab.
			Ξ²β€”β€Ή Enter the username of the simple user account you want to check.
			Ξ²β€”β€Ή Click View effective access to see what permissions this user has on that container or object.
			This will show you if the user has permissions such as "List contents" or "Read all properties," which would allow them to see other users57.
		**2. Test Directly with LDAP Queries or Commands**
			Ξ²β€”β€Ή You can log in as the simple user and try to list users using commands like:
				Ξ’Β§ net user /domain (on Windows command prompt)
				Ξ’Β§ LDAP query tools (e.g., ldapsearch) targeting the user container.
			Ξ²β€”β€Ή If the user can retrieve a list of users, they have read/list permissions in AD3.
		**3. Use Third-Party Tools for Permission Auditing**
			Ξ²β€”β€Ή Tools like Active Directory ACL Scanner or SolarWinds Permissions Analyzer can scan your domain and report who has what permissions on AD objects, including delegated read rights68.
			Ξ²β€”β€Ή These tools provide user-friendly reports and can help identify if the default permissions allow user enumeration.
	**Why This Happens**
		Ξ²β‚¬Ξ† ==By default, Active Directory grants Authenticated Users the ability to read most user attributes and list user objects in the directory to support common network and application functions.==
		Ξ²β‚¬Ξ† This means a normal user often can see other users' basic information unless the domain has been hardened or permissions explicitly restricted3.
	Summary
		Ξ²β‚¬Ξ† To confirm if your simple user can see other users, check Effective Access on the user container in ADUC for that user account57.
		Ξ²β‚¬Ξ† Testing with LDAP queries or commands as that user can also verify visibility3.
		Ξ²β‚¬Ξ† Use permission auditing tools for a comprehensive view if needed68.
	This approach will give you a clear picture of the actual permissions and visibility your users have in your AD domain.
	Citations:
		1. https://docs.delinea.com/online-help/server-suite/eval/nix-eval/preparing-hardware-and-software-for-an-evaluation/verifying-you-have-active-directory-permissions.htm
		2. https://serverfault.com/questions/611850/how-can-i-check-my-permissions-in-active-directory
		3. https://www.reddit.com/r/activedirectory/comments/p1kg21/users_can_see_the_list_of_users_in_active/
		4. https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage-user-accounts-in-windows-server
		5. https://www.youtube.com/watch?v=GlQAPCTcV9o
		6. https://www.youtube.com/watch?v=iud4yGt1IPE
		7. https://www.tenfold-security.com/en/active-directory-permissions-management/
		8. https://www.youtube.com/watch?v=dIINvjb-WOQ
		9. https://www.lepide.com/lepideauditor/active-directory-permission-auditing.html
	
	
	```
		DC=test,DC=local
		Ξ²β€ΒΞ²β€β‚¬Ξ²β€β‚¬ OU=AllUsers
		Ξ²β€β€   Ξ²β€ΒΞ²β€β‚¬Ξ²β€β‚¬ adminUser
		Ξ²β€β€   Ξ²β€ΒΞ²β€β‚¬Ξ²β€β‚¬ anotherUser
		Ξ²β€β€   Ξ²β€ΒΞ²β€β‚¬Ξ²β€β‚¬ user1
		Ξ²β€β€   Ξ²β€ΒΞ²β€β‚¬Ξ²β€β‚¬ user2
		Ξ²β€β€   Ξ²β€ΒΞ²β€β‚¬Ξ²β€β‚¬ jane.doe
		Ξ²β€β€   Ξ²β€ΒΞ²β€β‚¬Ξ²β€β‚¬ Group: ScpCloud_staff (members from AllUsers)
		Ξ²β€β€   Ξ²β€β€   Ξ²β€β€Ξ²β€β‚¬Ξ²β€β‚¬ adminUser
		Ξ²β€β€   Ξ²β€β€   Ξ²β€β€Ξ²β€β‚¬Ξ²β€β‚¬ user1
		Ξ²β€β€   Ξ²β€β€   Ξ²β€β€Ξ²β€β‚¬Ξ²β€β‚¬ Group: ScpCloudAdmins (members users from AllUsers)
		Ξ²β€β€   Ξ²β€β€       Ξ²β€β€Ξ²β€β‚¬Ξ²β€β‚¬ adminUser
		Ξ²β€β€   Ξ²β€β€       Ξ²β€β€Ξ²β€β‚¬Ξ²β€β‚¬ keycloaksvc
		Ξ²β€β€   Ξ²β€β€Ξ²β€β‚¬Ξ²β€β‚¬ Group: ScpCloudOther (members users from AllUsers)
		Ξ²β€β€Ξ²β€β‚¬Ξ²β€β‚¬ OU=Keycloak
		    Ξ²β€β€Ξ²β€β‚¬Ξ²β€β‚¬ keycloaksvc
		    Ξ²β€β€Ξ²β€β‚¬Ξ²β€β‚¬ keycloak
		
	```
	
	
	`ldapsearch -x -D "CN=johndoe,CN=Users,DC=example,DC=com" -w "UserPassword123" -H ldap://your-ad-server.example.com -b "DC=example,DC=com"`
	
	
	
	2025-05-20 08:35:54,065 INFO [org.keycloak.storage.ldap.LDAPIdentityStoreRegistry] (executor-thread-2) 
	Creating new LDAP Store for the LDAP storage provider: 'ldap', LDAP Configuration: {fullSyncPeriod=[-1], pagination=[false], startTls=[false], connectionPooling=[true], usersDn=[OU=AllUsers, DC=test, DC=local], cachePolicy=[DEFAULT], useKerberosForPasswordAuthentication=[false], importEnabled=[false], enabled=[true], bindDn=[TEST\keycloak_ldap], usernameLDAPAttribute=[userPrincipalName], changedSyncPeriod=[-1], vendor=[ad], uuidLDAPAttribute=[objectGUID], allowKerberosAuthentication=[false], connectionUrl=[ldap://192.168.1.207], syncRegistrations=[false], authType=[simple], krbPrincipalAttribute=[userPrincipalName], customUserSearchFilter=[(memberOf=CN=ScpCloud_staff, OU=AllUsers,DC=test,DC=local)], searchScope=[2], useTruststoreSpi=[always], usePasswordModifyExtendedOp=[false], trustEmail=[false], userObjectClasses=[person, organizationalPerson, user], rdnLDAPAttribute=[cn], editMode=[READ_ONLY], validatePasswordPolicy=[false]}, binaryAttributes: []

 




