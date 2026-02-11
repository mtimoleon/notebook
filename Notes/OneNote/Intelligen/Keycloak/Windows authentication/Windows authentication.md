Container for LDAP-Kerberos
```sh
docker run -d --name ldap-kerberos \  
-p 389:389 -p 636:636 -p 88:88/udp -p 464:464/udp -p 749:749 \  
-e DOMAIN=EXAMPLE.COM \  
-e REALM=EXAMPLE.COM \  
-e ADMIN_PASSWORD=admin \  
-e ROOT_PASSWORD=secret \  
nugaon/openldap-with-kerberos:latest\
```
   
```sh
ldapsearch -x -H ldap://localhost -b dc=example,dc=org -D "cn=admin,dc=example,dc=org" -w admin
```
 
By default the admin has the password admin
 
Inside docker container run:

```sh
kdb5_util create -s -r EXAMPLE.COM
```
 
and you will be prompted for master password.
 
Loading random data  
Initializing database '/var/lib/krb5kdc/principal' for realm 'EXAMPLE.COM',  
master key name 'K/M@EXAMPLE.COM'  
You will be prompted for the database Master Password.  
It is important that you NOT FORGET this password.  
Enter KDC database master key: **admin**  
Re-enter KDC database master key to verify:
    
**Για να συνδέσετε το Keycloak με το Active Directory μέσω Kerberos, ακολουθήστε τα παρακάτω βήματα:**
   

## ==Here is a complete guide to setting up Kerberos with OpenLDAP in Docker using nugaon/openldap-with-kerberos image, and automating the initialization of the Kerberos database and the creation of an admin principal.==
 
### **Step-by-Step Guide**  
#### **1. Create a Custom Docker Setup for OpenLDAP with Kerberos**  
We will create a custom Docker setup that initializes the Kerberos database and creates an admin principal automatically every time the container starts.  
**Step 1: Prerequisites**  
Before starting, ensure you have Docker and Docker Compose installed. If not, follow the installation guides for [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/).
 
#### **Step 2: Create the setup.sh Script**  
This script will be responsible for:

- Initializing the Kerberos database.
- Starting the Kerberos KDC and admin daemons.
- Creating the admin/admin principal.

**Create a file called setup.sh:** 
```sh
#!/bin/bash
  
# Initialize the Kerberos database if it doesn't exist
if [ ! -f /var/lib/krb5kdc/principal ]; then
 echo "Initializing Kerberos database..."
 kdb5_util create -s -r EXAMPLE.COM
fi
  
# Create the kadm5.acl file automatically
echo "*/admin@EXAMPLE.COM *" \> /etc/krb5kdc/kadm5.acl
  
# Start the Kerberos KDC and admin daemons
echo "Starting Kerberos KDC and admin services..."
krb5kdc &
kadmind &
  
# Create the admin principal if it doesn't exist
kadmin.local -q "addprinc -pw admin admin/admin" || true
  
# Keep the container running
tail -f /dev/null
```
  
This script will:

1. Check if the Kerberos database exists and create it if necessary.
2. Automatically generate the kadm5.acl file.
3. Start krb5kdc and kadmind services.
4. Add the admin/admin principal.
5. Keep the container running using tail -f /dev/null.
 
#### **Step 3: Update docker-compose.yml**  
Now, modify your Docker Compose configuration to use the custom setup.sh script.  
Create or update a docker-compose.yml file as follows:  
```yaml
version: '3.7'
  
services:
 openldap-kerberos:
 image: nugaon/openldap-with-kerberos:latest
 container_name: openldap-kerberos
 ports:
 - "389:389" # LDAP
 - "636:636" # LDAPS (optional)
 - "88:88/udp" # Kerberos
 - "464:464/udp" # Kerberos password change
 environment:
 LDAP_DOMAIN: "example.com"
 LDAP_ORGANISATION: "Example Corp"
 LDAP_ADMIN_PASSWORD: "admin"
 KRB5_REALM: "EXAMPLE.COM"
 KRB5_KDC_PASSWORD: "kdcadmin"
 KRB5_ADMIN_PRINCIPAL: "admin/admin"
 KRB5_ADMIN_PASSWORD: "admin"
 volumes:
 - openldap_data:/var/lib/ldap
 - openldap_config:/etc/ldap/slapd.d
 - ./setup.sh:/setup.sh # Mount the setup script into the container
 networks:
 - ldapnet
 entrypoint: ["/bin/bash", "/setup.sh"] # Use the setup script as entry point
  
volumes:
 openldap_data:
 openldap_config:
  
networks:
 ldapnet:
 driver: bridge
```
  
**Explanation of Changes in docker-compose.yml:**

- **Mount the setup.sh script**: The `./setup.sh:/setup.sh` line ensures that the script is available inside the container.
- **Set the entrypoint to the setup.sh script**: This runs the setup.sh script automatically when the container starts.
- **Environment Variables**: They configure both OpenLDAP and Kerberos realms and credentials.
 
#### **Step 4: Build and Start the Docker Containers**  
Navigate to the directory where your docker-compose.yml and setup.sh files are located and run the following commands:

1. **Build the Docker containers**:
```
	docker-compose up -d
```

This will:
    - Build the services defined in docker-compose.yml.
    - Automatically execute the setup.sh script to initialize Kerberos and OpenLDAP.
 
#### **Step 5: Verify the Setup**  
Once the containers are running, you can test the Kerberos authentication:

1. **Inside the container**:
Connect to the running container:
```
docker exec -it openldap-kerberos bash
````


Then run:
`kinit admin/admin`

 2. **From outside the container (WSL or your host machine)**:
You can use the kinit command from your local machine:
kinit admin/admin@EXAMPLE.COM

If this succeeds without errors, Kerberos is working correctly.
 
#### **Step 6: Additional Notes**

- **Automating Initialization**: The setup.sh script ensures that the Kerberos database and admin principal are created automatically every time the container starts. This way, you don’t have to manually set up Kerberos each time.
- **Container Restart**: If you stop the container, simply run docker-compose up -d again to restart the container with the configuration.
 
#### **Step 7: Troubleshooting**

- If you encounter issues with Kerberos, check the logs for any error messages:
docker logs openldap-kerberos

- To troubleshoot Kerberos-related issues, you can run the following commands inside the container:
klist # Check the Kerberos ticket cache
kadmin.local # Use to manage Kerberos principals

 
**Conclusion**  
By following these steps, you have successfully created a Docker setup with OpenLDAP and Kerberos that automatically initializes and configures Kerberos every time the container starts. The admin principal admin/admin is created automatically, and the container will always be ready for use with Keycloak or other services that require LDAP and Kerberos integration.  
Let me know if you need any further clarification or help!
 \> Από \<[https://chatgpt.com/c/6819cc44-b254-8012-a054-4eb30108ebf0](https://chatgpt.com/c/6819cc44-b254-8012-a054-4eb30108ebf0)\>      
 
## ==**Create the parent ou=users container.**==  
**✅** **Solution: First create the parent ou=users container.**  
You need to create the organizational unit (OU) users before adding users under it.
 
**🔧** **Step-by-Step Fix:**  
**1. Create ou=users using this LDIF:**  
Create a file named add-ou.ldif:  
`dn: ou=users,dc=example,dc=com`
`objectClass: organizationalUnit`
`ou: users`
  
Copy it into the container:  
`docker cp add-ou.ldif ldap:/add-ou.ldif`
  
Then exec into the container and apply it:  
`docker exec -it ldap /bin/bash`
`ldapadd -x -D "cn=admin,dc=example,dc=com" -W -f /add-ou.ldif`
  
**2. Then retry adding the user**  
If your add-user.ldif is ready (as in the previous message), just re-run:  
`ldapadd -x -D "cn=admin,dc=example,dc=com" -W -f /add-user.ldif`

      

## ==**🧾** **Full Guide: Add LDAP User (testUser1) in Dockerized OpenLDAP with Kerberos**==
 
**🛠** **Prerequisites**

- Docker is installed on your Windows machine.
- The container nugaon/openldap-with-kerberos:latest is running.
- The container is named ldap (adjust in scripts if not).
- You know the LDAP admin DN (typically cn=admin,dc=example,dc=com) and password.
- Your LDAP domain is set correctly (e.g., dc=example,dc=com) and Kerberos realm (EXAMPLE.COM).
 
#### **✅** **Step 1: Create the LDIF File**  
Create a file named add-user-with-ou.ldif on your Windows host with the following contents:  
```
# Create the organizational unit
dn: ou=users,dc=example,dc=com
objectClass: organizationalUnit
ou: users
  
# Create the user
dn: uid=testUser1,ou=users,dc=example,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
objectClass: krbPrincipalAux
objectClass: krbTicketPolicyAux
cn: Test User
sn: User
uid: testUser1
mail: testUser1@example.com
userPassword: password123
krbPrincipalName: testUser1@EXAMPLE.COM
krbCanonicalName: testUser1@EXAMPLE.COM
krbPwdPolicyReference: cn=default,ou=policies,dc=example,dc=com
```
  
✅ **Tip:** Replace dc=example,dc=com and @EXAMPLE.COM with your actual LDAP base and realm.
 
#### **✅** **Step 2: Optional – Generate Hashed Password (Recommended)**  
Open a shell in the container:  
`docker exec -it ldap slappasswd`
  
It will prompt for a password and generate a hash like:  
`{SSHA}FvIgFypLbqZUZF8Ct+9XtxH/oHKDKUF/`
  
Use that in the LDIF:  
`userPassword: {SSHA}FvIgFypLbqZUZF8Ct+9XtxH/oHKDKUF/`

 
#### **✅** **Step 3: Copy and Apply the LDIF to the Container**  
**📁** **Copy LDIF into Container**  
`docker cp add-user-with-ou.ldif ldap:/add-user.ldif`
  
Replace ldap if your container has a different name.  
**🧾** **Apply the LDIF**  
`docker exec -it ldap ldapadd -x -D "cn=admin,dc=example,dc=com" -W -f /add-user.ldif`
  
Enter the admin password when prompted.
 
#### **✅** **Step 4: Verify the User**  
`docker exec -it ldap ldapsearch -x -D "cn=admin,dc=example,dc=com" -W -b "dc=example,dc=com" "(uid=testUser1)"`

 
**⚙️** **Optional: Automate via Bash Script (Linux/macOS/Git Bash on Windows)**  
Create a script file called add_ldap_user.sh: 
```sh
#!/bin/bash
  
# Change these values as needed
LDIF_FILE="add-user-with-ou.ldif"
CONTAINER_NAME="ldap"
LDAP_ADMIN_DN="cn=admin,dc=example,dc=com"
  
echo "🔄 Copying LDIF file to container..."
docker cp "$LDIF_FILE" "$CONTAINER_NAME":/add-user.ldif
  
echo "🚀 Adding user via ldapadd..."
docker exec -it "$CONTAINER_NAME" ldapadd -x -D "$LDAP_ADMIN_DN" -W -f /add-user.ldif
  
echo "✅ Done. Run the following to verify:"
echo "docker exec -it $CONTAINER_NAME ldapsearch -x -D \"$LDAP_ADMIN_DN\" -W -b \"dc=example,dc=com\" \"(uid=testUser1)\""
```
  
Make it executable:  
`chmod +x add_ldap_user.sh`
  
Then run:  
`./add_ldap_user.sh`
  
💡 You can run this in Git Bash or WSL if you're on Windows.
 
Would you like a PowerShell version of the script for native Windows users?
 \> Από \<[https://chatgpt.com/c/6819df4b-c698-8012-88c2-9cbf394cffee](https://chatgpt.com/c/6819df4b-c698-8012-88c2-9cbf394cffee)\>           

Perfect — here's the **fully updated step-by-step guide** to connect your **Keycloak** container (accessible via [http://localhost:28443](http://localhost:28443)) to your **OpenLDAP+Kerberos** container named openldap-kerberos.
 
## ==**🔐** **Guide: Connect Keycloak to openldap-kerberos (LDAP+Kerberos)**==
 
**✅** **Prerequisites**

- Your **Keycloak container** is running and accessible at:
➤ [http://localhost:28443](http://localhost:28443)
- Your **LDAP container** is named: openldap-kerberos
- LDAP Base DN: dc=example,dc=com
- Admin DN: cn=admin,dc=example,dc=com
- Admin password is known
- You have at least one user like testUser1 under: ou=users,dc=example,dc=com
 
#### **✅** **Step 1: Ensure Docker Network Connectivity**  
If both containers are in the same Docker Compose file, they're already networked.  
If **running separately**, connect them manually:  
docker network create ldapnet
  
docker network connect ldapnet openldap-kerberos
docker network connect ldapnet keycloak

 
#### **✅** **Step 2: Open Keycloak Admin Console**

1. Open your browser:
[http://localhost:28443/](http://localhost:28443/)

2. Log in with your **Keycloak admin** credentials.
 
#### **✅** **Step 3: Add LDAP as a User Federation Provider**

1. In the Keycloak admin panel, go to **User Federation** on the left.
2. Click **“Add provider” → “ldap”**.
3. Fill out the form as follows:

|   |   |
|---|---|
|**Field**|**Value**|
|**Edit Mode**|READ_ONLY or WRITABLE|
|**Vendor**|Other|
|**Connection URL**|ldap://openldap-kerberos:389|
|**Users DN**|ou=users,dc=example,dc=com|
|**Bind DN**|cn=admin,dc=example,dc=com|
|**Bind Credential**|_(your LDAP admin password)_|
|**Username LDAP attribute**|uid|
|**RDN LDAP attribute**|uid|
|**UUID LDAP attribute**|entryUUID|
|**User Object Classes**|inetOrgPerson, organizationalPerson|

5. Optional:
    - Enable **Connection pooling**
    - Enable **Pagination**
6. Click **“Test Connection”** and **“Test Authentication”**.
7. If both succeed, click **Save**.
 
#### **✅** **Step 4: Sync Users**

8. After saving the LDAP provider, click on it.
9. Click **“Synchronize all users”**.
10. You should now see LDAP users (like testUser1) in the **Users** section.
 
#### **✅** **Optional: Enable Kerberos Authentication (SPNEGO)**  
If you want **Kerberos login** to work:  
**In the LDAP Provider Settings:**

|   |   |
|---|---|
|**Setting**|**Value**|
|**Use Kerberos for authentication**|✅|
|**Kerberos Realm**|EXAMPLE.COM|

You’ll also need:

1. A proper **krb5.conf** file.
2. A **keytab** file (e.g., /keycloak.keytab) with Keycloak’s service principal.
3. A JAAS login config (/etc/keycloak-jaas.conf) like:
```
com.sun.security.jgss.krb5.initiate {
 com.sun.security.auth.module.Krb5LoginModule required
 useKeyTab=true
 keyTab="/keycloak.keytab"
 storeKey=true
 principal="HTTP/keycloak.example.com@EXAMPLE.COM"
 debug=true;
};
```


1. Pass these Java options to the Keycloak container:

-Djava.security.krb5.conf=/etc/krb5.conf
-Djava.security.auth.login.config=/etc/keycloak-jaas.conf
  
This part requires mounting files and/or building a custom Keycloak image.
 
**✅** **What’s Next?**  
Would you like me to:

- Generate a docker-compose.yml with Keycloak (on port 28443) and openldap-kerberos?
- Help create a keytab + krb5.conf for SPNEGO login?

Let me know how deep you want to go with Kerberos support.
 \> Από \<[https://chatgpt.com/c/6819df4b-c698-8012-88c2-9cbf394cffee](https://chatgpt.com/c/6819df4b-c698-8012-88c2-9cbf394cffee)\>   
    
Great! If you want **Keycloak to authenticate users using Kerberos**, the correct approach is to use **Keycloak's Kerberos provider**, which allows integration with an LDAP + Kerberos backend for **SPNEGO (Kerberos-based) single sign-on (SSO)** or username/password-based authentication via Kerberos.  
Below is a complete guide tailored for your setup where:

- Keycloak is accessible via [http://localhost:28443](http://localhost:28443)
- Your LDAP+Kerberos container is named openldap-kerberos
- Realm is EXAMPLE.COM
- LDAP base DN is dc=example,dc=com
- You want to add a **Kerberos provider** in Keycloak
 
## ==**🎯** **Guide: Add Kerberos Provider in Keycloak (to connect with openldap-kerberos)**==
 
#### **✅** **Step 1: Prerequisites**  
Ensure:

1. The user entries in LDAP include the **krbPrincipalName** attribute (added if you used kadmin or kadmin.local properly).
2. Your openldap-kerberos container has:
    - A working KDC (krb5kdc)
    - A reachable admin service (kadmin or kadmin.local)
3. You have a valid **Kerberos realm**: EXAMPLE.COM
4. Keycloak and openldap-kerberos are on the same Docker network
 
#### **✅** **Step 2: Generate Keytab for Keycloak**  
Inside your openldap-kerberos container, run:  
kadmin.local
  
Then create a service principal for Keycloak (replace hostname as needed):  
addprinc -randkey HTTP/keycloak.example.com@EXAMPLE.COM
ktadd -k /tmp/keycloak.keytab HTTP/keycloak.example.com@EXAMPLE.COM
  
Now, **copy the /tmp/keycloak.keytab** file from the container to your host:  
docker cp openldap-kerberos:/tmp/keycloak.keytab ./keycloak.keytab
  
You'll mount this into the Keycloak container.
 
#### **✅** **Step 3: Provide Kerberos Configs to Keycloak**  
**Create two files on your host:**  
**krb5.conf**:  
```
[libdefaults]
 default_realm = EXAMPLE.COM
 dns_lookup_realm = false
 dns_lookup_kdc = false
  
[realms]
 EXAMPLE.COM = {
 kdc = openldap-kerberos
 admin_server = openldap-kerberos
 }
  
[domain_realm]
 .example.com = EXAMPLE.COM
 example.com = EXAMPLE.COM
```
  
**keycloak-jaas.conf**:  
```
com.sun.security.jgss.krb5.initiate {
 com.sun.security.auth.module.Krb5LoginModule required
 useKeyTab=true
 storeKey=true
 doNotPrompt=true
 keyTab="/etc/krb5.keytab"
 principal="HTTP/keycloak.example.com@EXAMPLE.COM"
 debug=true;
};
```

 
#### **✅** **Step 4: Modify Keycloak Docker Run (or Compose)**  
Mount these three files into the container and pass Java options:  
```
version: '3.9'
  
services:
 keycloak:
 image: quay.io/keycloak/keycloak:latest
 command: start-dev
 ports:
 - "28443:8080"
 environment:
 - KEYCLOAK_ADMIN=admin
 - KEYCLOAK_ADMIN_PASSWORD=admin
 - JAVA_OPTS_APPEND=-Djava.security.krb5.conf=/etc/krb5.conf -Djava.security.auth.login.config=/etc/keycloak-jaas.conf
 volumes:
 - ./krb5.conf:/etc/krb5.conf:ro
 - ./keycloak-jaas.conf:/etc/keycloak-jaas.conf:ro
 - ./keycloak.keytab:/etc/krb5.keytab:ro
 networks:
 - ldapnet
  
openldap-kerberos:
 image: nugaon/openldap-with-kerberos:latest
 container_name: openldap-kerberos
 ports:
 - "389:389"
 - "636:636"
 - "88:88"
 - "464:464"
 networks:
 - ldapnet
  
networks:
 ldapnet:
```

 
#### **✅** **Step 5: Add Kerberos Provider in Keycloak UI**

1. Visit: [http://localhost:28443/](http://localhost:28443/)
2. Log in as admin
3. Go to your Realm → **User Federation**
4. Click **Add provider → Kerberos**

**Fill in the form:**

|   |   |
|---|---|
|**Field**|**Value**|
|**Kerberos Realm**|EXAMPLE.COM|
|**Server Principal**|HTTP/keycloak.example.com@EXAMPLE.COM|
|**KeyTab File**|/etc/krb5.keytab|
|**Debug**|ON|
|**Allow Password Authentication**|✅|
|**Edit Mode**|READ_ONLY or WRITABLE|
|**Import Users**|✅|

You can also enable **SPNEGO** login in your browser authentication flow for true SSO.  
Click **Save**.
 
#### **✅** **Step 6: Test Authentication**  
You can now:

- Log in with Kerberos-authenticated users
- Enable browser-based SPNEGO login (true SSO)
 
Would you like help:

- Enabling SPNEGO SSO in the browser flow?
- Automatically provisioning LDAP users into Keycloak?
- Writing a script to auto-generate this setup?

Let me know how you'd like to proceed.
 \> Από \<[https://chatgpt.com/c/6819df4b-c698-8012-88c2-9cbf394cffee](https://chatgpt.com/c/6819df4b-c698-8012-88c2-9cbf394cffee)\>