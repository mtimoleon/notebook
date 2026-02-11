[https://www.keycloak.org/server/importExport](https://www.keycloak.org/server/importExport)  
[https://www.keycloak.org/docs/latest/upgrading/index.html](https://www.keycloak.org/docs/latest/upgrading/index.html)
   

./kc.sh export --dir /tmp/export
 - **Full export** **από το** **Keycloak cli****￼**`/opt/keycloak/bin/kc.sh export --realm ScpCloud --dir /opt/keycloak/data/export --users realm_file`
- **Restore**
    
    ```
    ￼/opt/keycloak/bin/kc.sh import --realm ScpCloud --dir /opt/keycloak/data/export --strategy OVERWRITE_EXISTING
    ```
        
1. - [x] Προετοιμασία
    - Διάβασε τα **Upgrading/Migration Guides** της 26 για αλλαγές σε config, θέματα, adapters. [Keycloak+1](https://www.keycloak.org/docs/latest/upgrading/index.html?utm_source=chatgpt.com)
    - Αν έχεις custom theme, έλεγξε/προσάρμοσέ το (συχνά θέλει μικρές αλλαγές σε templates/CSS). [Keycloak](https://www.keycloak.org/docs/latest/upgrading/index.html?utm_source=chatgpt.com)
2. - [x] Backup & Σημαντικές προειδοποιήσεις
    - Πάρε **full DB backup** + αντίγραφα realm keys. Μετά την αναβάθμιση, η DB **δεν είναι συμβατή προς τα πίσω**—για rollback θα χρειαστείς restore της **παλιάς** DB με τα **παλιά** binaries. [docs.redhat.com](https://docs.redhat.com/en/documentation/red_hat_build_of_keycloak/24.0/html/upgrading_guide/upgrading?utm_source=chatgpt.com)
    - Θα **χαθούν ενεργές συνεδρίες** (οι χρήστες θα ξανακάνουν login). Offline sessions εξαιρούνται. [docs.redhat.com](https://docs.redhat.com/en/documentation/red_hat_build_of_keycloak/24.0/html/upgrading_guide/upgrading?utm_source=chatgpt.com)
3. - [x] Δοκιμή σε staging
    - Κάνε restore το DB backup σε **clone** και σήκωσε Keycloak **26.x** να «πατάει» εκεί.
    - Έλεγξε: login στο Admin Console, clients, mappers, User Federation, tokens, flows. [docs.redhat.com](https://docs.redhat.com/it/documentation/red_hat_build_of_keycloak/26.0/pdf/upgrading_guide/index?utm_source=chatgpt.com)
4. Cut-over σε production (με μικρό downtime)
    - Σβήσε τον 22, πάρε **τελικό** DB backup.
    - Ξεκίνα τον **26.x** να «πατήσει» στην **ίδια** βάση. Το schema migration τρέχει αυτόματα στην εκκίνηση. [docs.redhat.com](https://docs.redhat.com/it/documentation/red_hat_build_of_keycloak/26.0/pdf/upgrading_guide/index?utm_source=chatgpt.com)
    - Έλεγξε health, admin login, βασικά flows.
    - Αν χρειάζεται να περάσεις **επιπλέον ρυθμίσεις**, προτίμησε **Admin REST partialImport** αντί για startup import. [Keycloak](https://www.keycloak.org/server/importExport?utm_source=chatgpt.com)
5. Rollback plan
    - Αν κάτι πάει στραβά: σταμάτα τον 26, επανέφερε **DB backup** και ξανασήκωσε τον 22 (μην επιχειρήσεις να ξεκινήσεις 22 πάνω σε migrated DB). [docs.redhat.com](https://docs.redhat.com/en/documentation/red_hat_build_of_keycloak/24.0/html/upgrading_guide/upgrading?utm_source=chatgpt.com)
 
- **Hostname / relative paths** έχουν βελτιωθεί· επιβεβαίωσε τα --hostname, --http-relative-path (π.χ. /auth) και mgmt paths. [Keycloak](https://www.keycloak.org/2024/10/keycloak-2600-released?utm_source=chatgpt.com)
    - New default login theme
    - Hostname v1 feature removed
        - [https://www.keycloak.org/server/hostname](https://www.keycloak.org/server/hostname)
        - [https://www.keycloak.org/docs/latest/upgrading/#new-hostname-options](https://www.keycloak.org/docs/latest/upgrading/#new-hostname-options)
- **Caches / Infinispan**: σε άλματα εκδόσεων αλλάζει το marshalling· αναμένεις άδειασμα caches/νέα sessions. Για zero-downtime θες προσοχή σε cache/state. [Keycloak+2groups.google.com+2](https://www.keycloak.org/2025/07/keycloak-2630-released?utm_source=chatgpt.com)
- Αν στο παρελθόν στηριζόσουν σε **startup import** για clients με **static secrets**, απόφυγε συγκεκριμένα την 25.0.0 (γνωστό issue στο import secrets εκεί—έχει λυθεί σε μεταγενέστερα 25.x/26.x). [GitHub](https://github.com/keycloak/keycloak/issues/30543?utm_source=chatgpt.com)

- Με **ίδια DB**, **όλοι οι χρήστες/credentials/groups/roles** παραμένουν. Δεν χρειάζεται καμία εξαγωγή/επαναεισαγωγή. Μόνο οι live συνεδρίες θα αναγκαστούν να επανεκκινήσουν. [docs.redhat.com](https://docs.redhat.com/en/documentation/red_hat_build_of_keycloak/24.0/html/upgrading_guide/upgrading?utm_source=chatgpt.com)

- Admin login OK, realms ορατά.
- Clients: redirects, credentials, mappers (ιδίως user/role mappers) δουλεύουν.
- User Federation (LDAP/AD): test login + attribute mappers.
- Flows: Browser/Direct grant/Service account.
- Θέματα (themes): σελίδες login/account ανοίγουν χωρίς template errors. [Keycloak](https://www.keycloak.org/docs/latest/upgrading/index.html?utm_source=chatgpt.com)
   

[https://chatgpt.com/g/g-p-68e613dfa3c881918ff50ba72148e5ba-keycloak/c/68e6b3a9-9844-8330-bc06-aa569af1599a](https://chatgpt.com/g/g-p-68e613dfa3c881918ff50ba72148e5ba-keycloak/c/68e6b3a9-9844-8330-bc06-aa569af1599a)  
**RUNBOOK – Upgrade Keycloak 22 → 26 (ίδια DB)**

1. - [x] **Πάρε backup των keys**:￼docker cp keycloak:/opt/keycloak/data/ ./data_backup/
2. - [x] **Σταμάτα το container του Keycloak 22****￼**docker compose stop keycloak
3. - [x] **Πάρε πλήρες backup DB**
    - Αν είναι SQL Server:￼docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "password" -Q "BACKUP DATABASE [keycloak] TO DISK='/var/opt/mssql/backup/keycloak.bak'"
 
1. - [x] Αντικατάστησε τη βάση στο Dockerfile:￼￼FROM quay.io/keycloak/keycloak:26.4.0 AS builder￼WORKDIR /opt/keycloak￼RUN /opt/keycloak/bin/kc.sh build￼FROM quay.io/keycloak/keycloak:26.4.0￼COPY --from=builder /opt/keycloak/ /opt/keycloak/￼COPY ["volumes/keycloak/import", "/opt/keycloak/data/import"]￼COPY ["volumes/keycloak/keycloak-theme", "/opt/keycloak/themes"]￼USER root￼RUN chown -R keycloak:keycloak /opt/keycloak￼USER keycloak
2. - [x] **Δεν αλλάζεις τη βάση** — παραμένει η ίδια (KC_DB_URL, KC_DB_USERNAME, KC_DB_PASSWORD).
3. - [x] Αν θες να διατηρήσεις startup import για dev, κράτα:￼￼environment:￼ - KC_DB=postgres￼ - KC_DB_URL=jdbc:postgresql://db/keycloak￼ - KC_DB_USERNAME=keycloak￼ - KC_DB_PASSWORD=secret￼ - KC_IMPORT=/opt/keycloak/data/import/ScpCloud-realm.json￼ - KEYCLOAK_ADMIN=admin￼ - KEYCLOAK_ADMIN_PASSWORD=admin￼￼αλλά στο production **μην** βάζεις KC_IMPORT, γιατί θα κάνει overwrite configuration.
 
1. - [x] Εκτέλεσε:￼￼docker compose up -d --build keycloak
2. - [x] Στην πρώτη εκκίνηση, θα δεις log:￼￼KC-SERVICES0050: Initializing database schema￼￼Αυτό είναι το Liquibase migration — ενημερώνει τη DB από 22 → 26.
3. - [ ] Remember to check the logs in general
4. - [x] Μετά το migration, Keycloak θα κάνει restart αυτόματα και θα ανέβει.
 
**4. Έλεγχοι**

- Μπες στο [https://localhost:28443/realms/ScpCloud](https://localhost:28443/realms/ScpCloud)
- Έλεγξε:
    - Admin login (admin2, sadmin)
    - Users → υπάρχουν όλοι
    - Clients (scpCloud, scp-admin-service) → έχουν σωστά secrets
    - Themes → άνοιξε τη σελίδα login για να δεις ότι φορτώνεται scpCloud
    - LDAP settings → αν είναι enabled:false, δεν αλλάζει τίποτα
 
1. Σταμάτα τον Keycloak 26:￼￼docker compose stop keycloak
2. Κάνε restore το backup DB (βλ. εντολές από το Βήμα 1).
3. Ξανασήκωσε τον Keycloak 22:￼￼docker compose up -d keycloak￼￼Μην βάλεις ποτέ τον 22 να τρέξει πάνω στη migrated DB.
 
- Λίστα realms:￼￼docker exec -it keycloak /opt/keycloak/bin/kcadm.sh get realms -r ScpCloud
- Έλεγχος clients:￼￼docker exec -it keycloak /opt/keycloak/bin/kcadm.sh get clients -r ScpCloud | jq '.[].clientId'
- Token test:￼￼curl -X POST " [https://localhost:28443/realms/ScpCloud/protocol/openid-connect/token](https://localhost:28443/realms/ScpCloud/protocol/openid-connect/token)" \￼-d "client_id=scp-admin-service" -d "grant_type=client_credentials" \￼-d "client_secret=RgkvaNa1FJJXhY6GPlvqK3Ed8nPUcOCr"
    
**docker-compose.override.yml (Keycloak 26 • ίδια DB)**
 
```
services:￼  keycloak:￼    image: quay.io/keycloak/keycloak:26.0.0￼    container_name: keycloak￼    restart: unless-stopped￼    environment:￼      # Admin￼      KEYCLOAK_ADMIN: ${KEYCLOAK_ADMIN:-admin}￼      KEYCLOAK_ADMIN_PASSWORD: ${KEYCLOAK_ADMIN_PASSWORD:-admin}￼
# Database (ΒΑΖΕΙΣ αυτά που ήδη χρησιμοποιείς στην 22)￼      # Επιλογή A – PostgreSQL￼      KC_DB: postgres￼      KC_DB_URL: ${KC_DB_URL:-jdbc:postgresql://db:5432/keycloak}￼      KC_DB_USERNAME: ${KC_DB_USERNAME:-keycloak}￼      KC_DB_PASSWORD: ${KC_DB_PASSWORD:-secret}￼
# Επιλογή B – SQL Server (αν ισχύει στο δικό σου)￼      # KC_DB: mssql￼      # KC_DB_URL: ${KC_DB_URL:-jdbc:sqlserver://sqlserver:1433;databaseName=keycloak;encrypt=false}￼      # KC_DB_USERNAME: ${KC_DB_USERNAME:-sa}￼      # KC_DB_PASSWORD: ${KC_DB_PASSWORD:-YourStrong!Passw0rd}￼
# Runtime/health￼      KC_HEALTH_ENABLED: "true"￼      KC_METRICS_ENABLED: "true"￼      KC_LOG_LEVEL: info￼      # Αν έχεις reverse proxy μπροστά (συνήθως):￼      KC_PROXY: edge￼      # Βάλε το public hostname σου (π.χ. KC_HOSTNAME=https://auth.example.com)￼      # KC_HOSTNAME: ${KC_HOSTNAME}￼
# Μνήμη JVM – προσαρμόζεις￼      JAVA_OPTS: "-Xms512m -Xmx1024m"￼
# ΠΡΟΣΟΧΗ: ΜΗ βάλεις KC_IMPORT στο production (θα κάνει overwrite configs)￼      # Για dev smoke test μπορείς προσωρινά:￼      # KC_IMPORT: /opt/keycloak/data/import/ScpCloud-realm.json￼
# Αν έχεις custom theme, κράτα το volume όπως στο 22￼    volumes:￼      - ./volumes/keycloak/keycloak-theme:/opt/keycloak/themes:ro￼      # ΜΟΝΟ για dev, αν θες να υπάρχει διαθέσιμο το realm.json μέσα στο container:￼      - ./volumes/keycloak/import:/opt/keycloak/data/import:ro￼
# Συνήθως πίσω από reverse proxy (Nginx/Traefik) κρατάς http:8080￼    # Αν θες άμεση πρόσβαση σε dev:￼    ports:￼      - "8080:8080"￼
command: \>￼      start --optimized￼      --http-enabled=true￼      --http-port=8080￼      # Αν έχεις TLS απευθείας στο Keycloak, αντί αυτών βάλε --https-* flags και μην κάνεις publish το 8080.￼
healthcheck:￼      test: ["CMD", "curl", "-fsS", "http://localhost:8080/health/ready"]￼      interval: 15s￼      timeout: 5s￼      retries: 20￼
```

1. Backup DB + keys (όπως ήδη συζητήσαμε).
2. docker compose down keycloak (ή stop).
3. docker compose up -d --build keycloak με το παραπάνω override.
4. Παρακολούθησε τα logs μέχρι να ολοκληρωθεί το Liquibase migration.
5. Smoke tests:
    - Admin Console login.
    - Clients (scpCloud, scp-admin-service) και tokens.
    - Theme φόρτωση (login page).
6. Αν χρειαστείς να περάσεις επιμέρους αλλαγές config, χρησιμοποίησε **Admin REST partialImport** ή kcadm.sh (όχι KC_IMPORT στο production).

- docker compose down keycloak
- Restore DB backup
- Ξανασήκωσε την 22 με το παλιό image/tag.
       
`"clientId"`: `"admi-cli"`,

```
"fullScopeAllowed": true,
"clientId": "security-admin-console", "fullScopeAllowed": true,
```
   

```
  "organizationsEnabled": false,
  "verifiableCredentialsEnabled": false,
  "adminPermissionsEnabled": false,
```
   
         

**Πλάνο αναβάθμισης (ίδια DB)**
 
**Σημεία προσοχής από 22 → 26**  
**Τι γίνεται με τους users**  
**Ελάχιστο operational checklist μετά το upgrade**
   

**1. Προετοιμασία και Backup**
 
**2. Προετοιμασία νέου Image**
 
- [ ] **3. Εκκίνηση και Migration**
 
Αφού ανέβει:
 
**5. Rollback (αν χρειαστεί)**
 
**6. Optional Verification Commands**
      

**Βήματα εκτέλεσης**  
**Rollback**