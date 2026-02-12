---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-10-08T22:09
tags:
  - intelligen
  - keycloak
status: completed
product: ScpCloud
component: Keycloak
---

[https://www.keycloak.org/server/importExport](https://www.keycloak.org/server/importExport)  
[https://www.keycloak.org/docs/latest/upgrading/index.html](https://www.keycloak.org/docs/latest/upgrading/index.html)
   

./kc.sh export --dir /tmp/export
 - **Full export** **Ξ±Ο€Ο Ο„ΞΏ** **Keycloak cli****οΏΌ**`/opt/keycloak/bin/kc.sh export --realm ScpCloud --dir /opt/keycloak/data/export --users realm_file`
- **Restore**
    
    ```
    οΏΌ/opt/keycloak/bin/kc.sh import --realm ScpCloud --dir /opt/keycloak/data/export --strategy OVERWRITE_EXISTING
    ```
        
1. - [x] Ξ ΟΞΏΞµΟ„ΞΏΞΉΞΌΞ±ΟƒΞ―Ξ±
    - Ξ”ΞΉΞ¬Ξ²Ξ±ΟƒΞµ Ο„Ξ± **Upgrading/Migration Guides** Ο„Ξ·Ο‚ 26 Ξ³ΞΉΞ± Ξ±Ξ»Ξ»Ξ±Ξ³Ξ­Ο‚ ΟƒΞµ config, ΞΈΞ­ΞΌΞ±Ο„Ξ±, adapters. [Keycloak+1](https://www.keycloak.org/docs/latest/upgrading/index.html?utm_source=chatgpt.com)
    - Ξ‘Ξ½ Ξ­Ο‡ΞµΞΉΟ‚ custom theme, Ξ­Ξ»ΞµΞ³ΞΎΞµ/Ο€ΟΞΏΟƒΞ¬ΟΞΌΞΏΟƒΞ­ Ο„ΞΏ (ΟƒΟ…Ο‡Ξ½Ξ¬ ΞΈΞ­Ξ»ΞµΞΉ ΞΌΞΉΞΊΟΞ­Ο‚ Ξ±Ξ»Ξ»Ξ±Ξ³Ξ­Ο‚ ΟƒΞµ templates/CSS). [Keycloak](https://www.keycloak.org/docs/latest/upgrading/index.html?utm_source=chatgpt.com)
2. - [x] Backup & Ξ£Ξ·ΞΌΞ±Ξ½Ο„ΞΉΞΊΞ­Ο‚ Ο€ΟΞΏΞµΞΉΞ΄ΞΏΟ€ΞΏΞΉΞ®ΟƒΞµΞΉΟ‚
    - Ξ Ξ¬ΟΞµ **full DB backup** + Ξ±Ξ½Ο„Ξ―Ξ³ΟΞ±Ο†Ξ± realm keys. ΞΞµΟ„Ξ¬ Ο„Ξ·Ξ½ Ξ±Ξ½Ξ±Ξ²Ξ¬ΞΈΞΌΞΉΟƒΞ·, Ξ· DB **Ξ΄ΞµΞ½ ΞµΞ―Ξ½Ξ±ΞΉ ΟƒΟ…ΞΌΞ²Ξ±Ο„Ξ® Ο€ΟΞΏΟ‚ Ο„Ξ± Ο€Ξ―ΟƒΟ‰**β€”Ξ³ΞΉΞ± rollback ΞΈΞ± Ο‡ΟΞµΞΉΞ±ΟƒΟ„ΞµΞ―Ο‚ restore Ο„Ξ·Ο‚ **Ο€Ξ±Ξ»ΞΉΞ¬Ο‚** DB ΞΌΞµ Ο„Ξ± **Ο€Ξ±Ξ»ΞΉΞ¬** binaries. [docs.redhat.com](https://docs.redhat.com/en/documentation/red_hat_build_of_keycloak/24.0/html/upgrading_guide/upgrading?utm_source=chatgpt.com)
    - ΞΞ± **Ο‡Ξ±ΞΈΞΏΟΞ½ ΞµΞ½ΞµΟΞ³Ξ­Ο‚ ΟƒΟ…Ξ½ΞµΞ΄ΟΞ―ΞµΟ‚** (ΞΏΞΉ Ο‡ΟΞ®ΟƒΟ„ΞµΟ‚ ΞΈΞ± ΞΎΞ±Ξ½Ξ±ΞΊΞ¬Ξ½ΞΏΟ…Ξ½ login). Offline sessions ΞµΞΎΞ±ΞΉΟΞΏΟΞ½Ο„Ξ±ΞΉ. [docs.redhat.com](https://docs.redhat.com/en/documentation/red_hat_build_of_keycloak/24.0/html/upgrading_guide/upgrading?utm_source=chatgpt.com)
3. - [x] Ξ”ΞΏΞΊΞΉΞΌΞ® ΟƒΞµ staging
    - ΞΞ¬Ξ½Ξµ restore Ο„ΞΏ DB backup ΟƒΞµ **clone** ΞΊΞ±ΞΉ ΟƒΞ®ΞΊΟ‰ΟƒΞµ Keycloak **26.x** Ξ½Ξ± Β«Ο€Ξ±Ο„Ξ¬ΞµΞΉΒ» ΞµΞΊΞµΞ―.
    - ΞΞ»ΞµΞ³ΞΎΞµ: login ΟƒΟ„ΞΏ Admin Console, clients, mappers, User Federation, tokens, flows. [docs.redhat.com](https://docs.redhat.com/it/documentation/red_hat_build_of_keycloak/26.0/pdf/upgrading_guide/index?utm_source=chatgpt.com)
4. Cut-over ΟƒΞµ production (ΞΌΞµ ΞΌΞΉΞΊΟΟ downtime)
    - Ξ£Ξ²Ξ®ΟƒΞµ Ο„ΞΏΞ½ 22, Ο€Ξ¬ΟΞµ **Ο„ΞµΞ»ΞΉΞΊΟ** DB backup.
    - ΞΞµΞΊΞ―Ξ½Ξ± Ο„ΞΏΞ½ **26.x** Ξ½Ξ± Β«Ο€Ξ±Ο„Ξ®ΟƒΞµΞΉΒ» ΟƒΟ„Ξ·Ξ½ **Ξ―Ξ΄ΞΉΞ±** Ξ²Ξ¬ΟƒΞ·. Ξ¤ΞΏ schema migration Ο„ΟΞ­Ο‡ΞµΞΉ Ξ±Ο…Ο„ΟΞΌΞ±Ο„Ξ± ΟƒΟ„Ξ·Ξ½ ΞµΞΊΞΊΞ―Ξ½Ξ·ΟƒΞ·. [docs.redhat.com](https://docs.redhat.com/it/documentation/red_hat_build_of_keycloak/26.0/pdf/upgrading_guide/index?utm_source=chatgpt.com)
    - ΞΞ»ΞµΞ³ΞΎΞµ health, admin login, Ξ²Ξ±ΟƒΞΉΞΊΞ¬ flows.
    - Ξ‘Ξ½ Ο‡ΟΞµΞΉΞ¬Ξ¶ΞµΟ„Ξ±ΞΉ Ξ½Ξ± Ο€ΞµΟΞ¬ΟƒΞµΞΉΟ‚ **ΞµΟ€ΞΉΟ€Ξ»Ξ­ΞΏΞ½ ΟΟ…ΞΈΞΌΞ―ΟƒΞµΞΉΟ‚**, Ο€ΟΞΏΟ„Ξ―ΞΌΞ·ΟƒΞµ **Admin REST partialImport** Ξ±Ξ½Ο„Ξ― Ξ³ΞΉΞ± startup import. [Keycloak](https://www.keycloak.org/server/importExport?utm_source=chatgpt.com)
5. Rollback plan
    - Ξ‘Ξ½ ΞΊΞ¬Ο„ΞΉ Ο€Ξ¬ΞµΞΉ ΟƒΟ„ΟΞ±Ξ²Ξ¬: ΟƒΟ„Ξ±ΞΌΞ¬Ο„Ξ± Ο„ΞΏΞ½ 26, ΞµΟ€Ξ±Ξ½Ξ­Ο†ΞµΟΞµ **DB backup** ΞΊΞ±ΞΉ ΞΎΞ±Ξ½Ξ±ΟƒΞ®ΞΊΟ‰ΟƒΞµ Ο„ΞΏΞ½ 22 (ΞΌΞ·Ξ½ ΞµΟ€ΞΉΟ‡ΞµΞΉΟΞ®ΟƒΞµΞΉΟ‚ Ξ½Ξ± ΞΎΞµΞΊΞΉΞ½Ξ®ΟƒΞµΞΉΟ‚ 22 Ο€Ξ¬Ξ½Ο‰ ΟƒΞµ migrated DB). [docs.redhat.com](https://docs.redhat.com/en/documentation/red_hat_build_of_keycloak/24.0/html/upgrading_guide/upgrading?utm_source=chatgpt.com)
 
- **Hostname / relative paths** Ξ­Ο‡ΞΏΟ…Ξ½ Ξ²ΞµΞ»Ο„ΞΉΟ‰ΞΈΞµΞ―Β· ΞµΟ€ΞΉΞ²ΞµΞ²Ξ±Ξ―Ο‰ΟƒΞµ Ο„Ξ± --hostname, --http-relative-path (Ο€.Ο‡. /auth) ΞΊΞ±ΞΉ mgmt paths. [Keycloak](https://www.keycloak.org/2024/10/keycloak-2600-released?utm_source=chatgpt.com)
    - New default login theme
    - Hostname v1 feature removed
        - [https://www.keycloak.org/server/hostname](https://www.keycloak.org/server/hostname)
        - [https://www.keycloak.org/docs/latest/upgrading/#new-hostname-options](https://www.keycloak.org/docs/latest/upgrading/#new-hostname-options)
- **Caches / Infinispan**: ΟƒΞµ Ξ¬Ξ»ΞΌΞ±Ο„Ξ± ΞµΞΊΞ΄ΟΟƒΞµΟ‰Ξ½ Ξ±Ξ»Ξ»Ξ¬Ξ¶ΞµΞΉ Ο„ΞΏ marshallingΒ· Ξ±Ξ½Ξ±ΞΌΞ­Ξ½ΞµΞΉΟ‚ Ξ¬Ξ΄ΞµΞΉΞ±ΟƒΞΌΞ± caches/Ξ½Ξ­Ξ± sessions. Ξ“ΞΉΞ± zero-downtime ΞΈΞµΟ‚ Ο€ΟΞΏΟƒΞΏΟ‡Ξ® ΟƒΞµ cache/state. [Keycloak+2groups.google.com+2](https://www.keycloak.org/2025/07/keycloak-2630-released?utm_source=chatgpt.com)
- Ξ‘Ξ½ ΟƒΟ„ΞΏ Ο€Ξ±ΟΞµΞ»ΞΈΟΞ½ ΟƒΟ„Ξ·ΟΞΉΞ¶ΟΟƒΞΏΟ…Ξ½ ΟƒΞµ **startup import** Ξ³ΞΉΞ± clients ΞΌΞµ **static secrets**, Ξ±Ο€ΟΟ†Ο…Ξ³Ξµ ΟƒΟ…Ξ³ΞΊΞµΞΊΟΞΉΞΌΞ­Ξ½Ξ± Ο„Ξ·Ξ½ 25.0.0 (Ξ³Ξ½Ο‰ΟƒΟ„Ο issue ΟƒΟ„ΞΏ import secrets ΞµΞΊΞµΞ―β€”Ξ­Ο‡ΞµΞΉ Ξ»Ο…ΞΈΞµΞ― ΟƒΞµ ΞΌΞµΟ„Ξ±Ξ³ΞµΞ½Ξ­ΟƒΟ„ΞµΟΞ± 25.x/26.x). [GitHub](https://github.com/keycloak/keycloak/issues/30543?utm_source=chatgpt.com)

- ΞΞµ **Ξ―Ξ΄ΞΉΞ± DB**, **ΟΞ»ΞΏΞΉ ΞΏΞΉ Ο‡ΟΞ®ΟƒΟ„ΞµΟ‚/credentials/groups/roles** Ο€Ξ±ΟΞ±ΞΌΞ­Ξ½ΞΏΟ…Ξ½. Ξ”ΞµΞ½ Ο‡ΟΞµΞΉΞ¬Ξ¶ΞµΟ„Ξ±ΞΉ ΞΊΞ±ΞΌΞ―Ξ± ΞµΞΎΞ±Ξ³Ο‰Ξ³Ξ®/ΞµΟ€Ξ±Ξ½Ξ±ΞµΞΉΟƒΞ±Ξ³Ο‰Ξ³Ξ®. ΞΟΞ½ΞΏ ΞΏΞΉ live ΟƒΟ…Ξ½ΞµΞ΄ΟΞ―ΞµΟ‚ ΞΈΞ± Ξ±Ξ½Ξ±Ξ³ΞΊΞ±ΟƒΟ„ΞΏΟΞ½ Ξ½Ξ± ΞµΟ€Ξ±Ξ½ΞµΞΊΞΊΞΉΞ½Ξ®ΟƒΞΏΟ…Ξ½. [docs.redhat.com](https://docs.redhat.com/en/documentation/red_hat_build_of_keycloak/24.0/html/upgrading_guide/upgrading?utm_source=chatgpt.com)

- Admin login OK, realms ΞΏΟΞ±Ο„Ξ¬.
- Clients: redirects, credentials, mappers (ΞΉΞ΄Ξ―Ο‰Ο‚ user/role mappers) Ξ΄ΞΏΟ…Ξ»ΞµΟΞΏΟ…Ξ½.
- User Federation (LDAP/AD): test login + attribute mappers.
- Flows: Browser/Direct grant/Service account.
- ΞΞ­ΞΌΞ±Ο„Ξ± (themes): ΟƒΞµΞ»Ξ―Ξ΄ΞµΟ‚ login/account Ξ±Ξ½ΞΏΞ―Ξ³ΞΏΟ…Ξ½ Ο‡Ο‰ΟΞ―Ο‚ template errors. [Keycloak](https://www.keycloak.org/docs/latest/upgrading/index.html?utm_source=chatgpt.com)
   

[https://chatgpt.com/g/g-p-68e613dfa3c881918ff50ba72148e5ba-keycloak/c/68e6b3a9-9844-8330-bc06-aa569af1599a](https://chatgpt.com/g/g-p-68e613dfa3c881918ff50ba72148e5ba-keycloak/c/68e6b3a9-9844-8330-bc06-aa569af1599a)  
**RUNBOOK β€“ Upgrade Keycloak 22 β†’ 26 (Ξ―Ξ΄ΞΉΞ± DB)**

1. - [x] **Ξ Ξ¬ΟΞµ backup Ο„Ο‰Ξ½ keys**:οΏΌdocker cp keycloak:/opt/keycloak/data/ ./data_backup/
2. - [x] **Ξ£Ο„Ξ±ΞΌΞ¬Ο„Ξ± Ο„ΞΏ container Ο„ΞΏΟ… Keycloak 22****οΏΌ**docker compose stop keycloak
3. - [x] **Ξ Ξ¬ΟΞµ Ο€Ξ»Ξ®ΟΞµΟ‚ backup DB**
    - Ξ‘Ξ½ ΞµΞ―Ξ½Ξ±ΞΉ SQL Server:οΏΌdocker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "password" -Q "BACKUP DATABASE [keycloak] TO DISK='/var/opt/mssql/backup/keycloak.bak'"
 
1. - [x] Ξ‘Ξ½Ο„ΞΉΞΊΞ±Ο„Ξ¬ΟƒΟ„Ξ·ΟƒΞµ Ο„Ξ· Ξ²Ξ¬ΟƒΞ· ΟƒΟ„ΞΏ Dockerfile:οΏΌοΏΌFROM quay.io/keycloak/keycloak:26.4.0 AS builderοΏΌWORKDIR /opt/keycloakοΏΌRUN /opt/keycloak/bin/kc.sh buildοΏΌFROM quay.io/keycloak/keycloak:26.4.0οΏΌCOPY --from=builder /opt/keycloak/ /opt/keycloak/οΏΌCOPY ["volumes/keycloak/import", "/opt/keycloak/data/import"]οΏΌCOPY ["volumes/keycloak/keycloak-theme", "/opt/keycloak/themes"]οΏΌUSER rootοΏΌRUN chown -R keycloak:keycloak /opt/keycloakοΏΌUSER keycloak
2. - [x] **Ξ”ΞµΞ½ Ξ±Ξ»Ξ»Ξ¬Ξ¶ΞµΞΉΟ‚ Ο„Ξ· Ξ²Ξ¬ΟƒΞ·** β€” Ο€Ξ±ΟΞ±ΞΌΞ­Ξ½ΞµΞΉ Ξ· Ξ―Ξ΄ΞΉΞ± (KC_DB_URL, KC_DB_USERNAME, KC_DB_PASSWORD).
3. - [x] Ξ‘Ξ½ ΞΈΞµΟ‚ Ξ½Ξ± Ξ΄ΞΉΞ±Ο„Ξ·ΟΞ®ΟƒΞµΞΉΟ‚ startup import Ξ³ΞΉΞ± dev, ΞΊΟΞ¬Ο„Ξ±:οΏΌοΏΌenvironment:οΏΌ - KC_DB=postgresοΏΌ - KC_DB_URL=jdbc:postgresql://db/keycloakοΏΌ - KC_DB_USERNAME=keycloakοΏΌ - KC_DB_PASSWORD=secretοΏΌ - KC_IMPORT=/opt/keycloak/data/import/ScpCloud-realm.jsonοΏΌ - KEYCLOAK_ADMIN=adminοΏΌ - KEYCLOAK_ADMIN_PASSWORD=adminοΏΌοΏΌΞ±Ξ»Ξ»Ξ¬ ΟƒΟ„ΞΏ production **ΞΌΞ·Ξ½** Ξ²Ξ¬Ξ¶ΞµΞΉΟ‚ KC_IMPORT, Ξ³ΞΉΞ±Ο„Ξ― ΞΈΞ± ΞΊΞ¬Ξ½ΞµΞΉ overwrite configuration.
 
1. - [x] Ξ•ΞΊΟ„Ξ­Ξ»ΞµΟƒΞµ:οΏΌοΏΌdocker compose up -d --build keycloak
2. - [x] Ξ£Ο„Ξ·Ξ½ Ο€ΟΟΟ„Ξ· ΞµΞΊΞΊΞ―Ξ½Ξ·ΟƒΞ·, ΞΈΞ± Ξ΄ΞµΞΉΟ‚ log:οΏΌοΏΌKC-SERVICES0050: Initializing database schemaοΏΌοΏΌΞ‘Ο…Ο„Ο ΞµΞ―Ξ½Ξ±ΞΉ Ο„ΞΏ Liquibase migration β€” ΞµΞ½Ξ·ΞΌΞµΟΟΞ½ΞµΞΉ Ο„Ξ· DB Ξ±Ο€Ο 22 β†’ 26.
3. - [ ] Remember to check the logs in general
4. - [x] ΞΞµΟ„Ξ¬ Ο„ΞΏ migration, Keycloak ΞΈΞ± ΞΊΞ¬Ξ½ΞµΞΉ restart Ξ±Ο…Ο„ΟΞΌΞ±Ο„Ξ± ΞΊΞ±ΞΉ ΞΈΞ± Ξ±Ξ½Ξ­Ξ²ΞµΞΉ.
 
**4. ΞΞ»ΞµΞ³Ο‡ΞΏΞΉ**

- ΞΟ€ΞµΟ‚ ΟƒΟ„ΞΏ [https://localhost:28443/realms/ScpCloud](https://localhost:28443/realms/ScpCloud)
- ΞΞ»ΞµΞ³ΞΎΞµ:
    - Admin login (admin2, sadmin)
    - Users β†’ Ο…Ο€Ξ¬ΟΟ‡ΞΏΟ…Ξ½ ΟΞ»ΞΏΞΉ
    - Clients (scpCloud, scp-admin-service) β†’ Ξ­Ο‡ΞΏΟ…Ξ½ ΟƒΟ‰ΟƒΟ„Ξ¬ secrets
    - Themes β†’ Ξ¬Ξ½ΞΏΞΉΞΎΞµ Ο„Ξ· ΟƒΞµΞ»Ξ―Ξ΄Ξ± login Ξ³ΞΉΞ± Ξ½Ξ± Ξ΄ΞµΞΉΟ‚ ΟΟ„ΞΉ Ο†ΞΏΟΟ„ΟΞ½ΞµΟ„Ξ±ΞΉ scpCloud
    - LDAP settings β†’ Ξ±Ξ½ ΞµΞ―Ξ½Ξ±ΞΉ enabled:false, Ξ΄ΞµΞ½ Ξ±Ξ»Ξ»Ξ¬Ξ¶ΞµΞΉ Ο„Ξ―Ο€ΞΏΟ„Ξ±
 
1. Ξ£Ο„Ξ±ΞΌΞ¬Ο„Ξ± Ο„ΞΏΞ½ Keycloak 26:οΏΌοΏΌdocker compose stop keycloak
2. ΞΞ¬Ξ½Ξµ restore Ο„ΞΏ backup DB (Ξ²Ξ». ΞµΞ½Ο„ΞΏΞ»Ξ­Ο‚ Ξ±Ο€Ο Ο„ΞΏ Ξ’Ξ®ΞΌΞ± 1).
3. ΞΞ±Ξ½Ξ±ΟƒΞ®ΞΊΟ‰ΟƒΞµ Ο„ΞΏΞ½ Keycloak 22:οΏΌοΏΌdocker compose up -d keycloakοΏΌοΏΌΞΞ·Ξ½ Ξ²Ξ¬Ξ»ΞµΞΉΟ‚ Ο€ΞΏΟ„Ξ­ Ο„ΞΏΞ½ 22 Ξ½Ξ± Ο„ΟΞ­ΞΎΞµΞΉ Ο€Ξ¬Ξ½Ο‰ ΟƒΟ„Ξ· migrated DB.
 
- Ξ›Ξ―ΟƒΟ„Ξ± realms:οΏΌοΏΌdocker exec -it keycloak /opt/keycloak/bin/kcadm.sh get realms -r ScpCloud
- ΞΞ»ΞµΞ³Ο‡ΞΏΟ‚ clients:οΏΌοΏΌdocker exec -it keycloak /opt/keycloak/bin/kcadm.sh get clients -r ScpCloud | jq '.[].clientId'
- Token test:οΏΌοΏΌcurl -X POST " [https://localhost:28443/realms/ScpCloud/protocol/openid-connect/token](https://localhost:28443/realms/ScpCloud/protocol/openid-connect/token)" \οΏΌ-d "client_id=scp-admin-service" -d "grant_type=client_credentials" \οΏΌ-d "client_secret=RgkvaNa1FJJXhY6GPlvqK3Ed8nPUcOCr"
    
**docker-compose.override.yml (Keycloak 26 β€Ά Ξ―Ξ΄ΞΉΞ± DB)**
 
```
services:οΏΌ  keycloak:οΏΌ    image: quay.io/keycloak/keycloak:26.0.0οΏΌ    container_name: keycloakοΏΌ    restart: unless-stoppedοΏΌ    environment:οΏΌ      # AdminοΏΌ      KEYCLOAK_ADMIN: ${KEYCLOAK_ADMIN:-admin}οΏΌ      KEYCLOAK_ADMIN_PASSWORD: ${KEYCLOAK_ADMIN_PASSWORD:-admin}οΏΌ
# Database (Ξ’Ξ‘Ξ–Ξ•Ξ™Ξ£ Ξ±Ο…Ο„Ξ¬ Ο€ΞΏΟ… Ξ®Ξ΄Ξ· Ο‡ΟΞ·ΟƒΞΉΞΌΞΏΟ€ΞΏΞΉΞµΞ―Ο‚ ΟƒΟ„Ξ·Ξ½ 22)οΏΌ      # Ξ•Ο€ΞΉΞ»ΞΏΞ³Ξ® A β€“ PostgreSQLοΏΌ      KC_DB: postgresοΏΌ      KC_DB_URL: ${KC_DB_URL:-jdbc:postgresql://db:5432/keycloak}οΏΌ      KC_DB_USERNAME: ${KC_DB_USERNAME:-keycloak}οΏΌ      KC_DB_PASSWORD: ${KC_DB_PASSWORD:-secret}οΏΌ
# Ξ•Ο€ΞΉΞ»ΞΏΞ³Ξ® B β€“ SQL Server (Ξ±Ξ½ ΞΉΟƒΟ‡ΟΞµΞΉ ΟƒΟ„ΞΏ Ξ΄ΞΉΞΊΟ ΟƒΞΏΟ…)οΏΌ      # KC_DB: mssqlοΏΌ      # KC_DB_URL: ${KC_DB_URL:-jdbc:sqlserver://sqlserver:1433;databaseName=keycloak;encrypt=false}οΏΌ      # KC_DB_USERNAME: ${KC_DB_USERNAME:-sa}οΏΌ      # KC_DB_PASSWORD: ${KC_DB_PASSWORD:-YourStrong!Passw0rd}οΏΌ
# Runtime/healthοΏΌ      KC_HEALTH_ENABLED: "true"οΏΌ      KC_METRICS_ENABLED: "true"οΏΌ      KC_LOG_LEVEL: infoοΏΌ      # Ξ‘Ξ½ Ξ­Ο‡ΞµΞΉΟ‚ reverse proxy ΞΌΟ€ΟΞΏΟƒΟ„Ξ¬ (ΟƒΟ…Ξ½Ξ®ΞΈΟ‰Ο‚):οΏΌ      KC_PROXY: edgeοΏΌ      # Ξ’Ξ¬Ξ»Ξµ Ο„ΞΏ public hostname ΟƒΞΏΟ… (Ο€.Ο‡. KC_HOSTNAME=https://auth.example.com)οΏΌ      # KC_HOSTNAME: ${KC_HOSTNAME}οΏΌ
# ΞΞ½Ξ®ΞΌΞ· JVM β€“ Ο€ΟΞΏΟƒΞ±ΟΞΌΟΞ¶ΞµΞΉΟ‚οΏΌ      JAVA_OPTS: "-Xms512m -Xmx1024m"οΏΌ
# Ξ Ξ΅ΞΞ£ΞΞ§Ξ—: ΞΞ— Ξ²Ξ¬Ξ»ΞµΞΉΟ‚ KC_IMPORT ΟƒΟ„ΞΏ production (ΞΈΞ± ΞΊΞ¬Ξ½ΞµΞΉ overwrite configs)οΏΌ      # Ξ“ΞΉΞ± dev smoke test ΞΌΟ€ΞΏΟΞµΞ―Ο‚ Ο€ΟΞΏΟƒΟ‰ΟΞΉΞ½Ξ¬:οΏΌ      # KC_IMPORT: /opt/keycloak/data/import/ScpCloud-realm.jsonοΏΌ
# Ξ‘Ξ½ Ξ­Ο‡ΞµΞΉΟ‚ custom theme, ΞΊΟΞ¬Ο„Ξ± Ο„ΞΏ volume ΟΟ€Ο‰Ο‚ ΟƒΟ„ΞΏ 22οΏΌ    volumes:οΏΌ      - ./volumes/keycloak/keycloak-theme:/opt/keycloak/themes:roοΏΌ      # ΞΞΞΞ Ξ³ΞΉΞ± dev, Ξ±Ξ½ ΞΈΞµΟ‚ Ξ½Ξ± Ο…Ο€Ξ¬ΟΟ‡ΞµΞΉ Ξ΄ΞΉΞ±ΞΈΞ­ΟƒΞΉΞΌΞΏ Ο„ΞΏ realm.json ΞΌΞ­ΟƒΞ± ΟƒΟ„ΞΏ container:οΏΌ      - ./volumes/keycloak/import:/opt/keycloak/data/import:roοΏΌ
# Ξ£Ο…Ξ½Ξ®ΞΈΟ‰Ο‚ Ο€Ξ―ΟƒΟ‰ Ξ±Ο€Ο reverse proxy (Nginx/Traefik) ΞΊΟΞ±Ο„Ξ¬Ο‚ http:8080οΏΌ    # Ξ‘Ξ½ ΞΈΞµΟ‚ Ξ¬ΞΌΞµΟƒΞ· Ο€ΟΟΟƒΞ²Ξ±ΟƒΞ· ΟƒΞµ dev:οΏΌ    ports:οΏΌ      - "8080:8080"οΏΌ
command: \>οΏΌ      start --optimizedοΏΌ      --http-enabled=trueοΏΌ      --http-port=8080οΏΌ      # Ξ‘Ξ½ Ξ­Ο‡ΞµΞΉΟ‚ TLS Ξ±Ο€ΞµΟ…ΞΈΞµΞ―Ξ±Ο‚ ΟƒΟ„ΞΏ Keycloak, Ξ±Ξ½Ο„Ξ― Ξ±Ο…Ο„ΟΞ½ Ξ²Ξ¬Ξ»Ξµ --https-* flags ΞΊΞ±ΞΉ ΞΌΞ·Ξ½ ΞΊΞ¬Ξ½ΞµΞΉΟ‚ publish Ο„ΞΏ 8080.οΏΌ
healthcheck:οΏΌ      test: ["CMD", "curl", "-fsS", "http://localhost:8080/health/ready"]οΏΌ      interval: 15sοΏΌ      timeout: 5sοΏΌ      retries: 20οΏΌ
```

1. Backup DB + keys (ΟΟ€Ο‰Ο‚ Ξ®Ξ΄Ξ· ΟƒΟ…Ξ¶Ξ·Ο„Ξ®ΟƒΞ±ΞΌΞµ).
2. docker compose down keycloak (Ξ® stop).
3. docker compose up -d --build keycloak ΞΌΞµ Ο„ΞΏ Ο€Ξ±ΟΞ±Ο€Ξ¬Ξ½Ο‰ override.
4. Ξ Ξ±ΟΞ±ΞΊΞΏΞ»ΞΏΟΞΈΞ·ΟƒΞµ Ο„Ξ± logs ΞΌΞ­Ο‡ΟΞΉ Ξ½Ξ± ΞΏΞ»ΞΏΞΊΞ»Ξ·ΟΟ‰ΞΈΞµΞ― Ο„ΞΏ Liquibase migration.
5. Smoke tests:
    - Admin Console login.
    - Clients (scpCloud, scp-admin-service) ΞΊΞ±ΞΉ tokens.
    - Theme Ο†ΟΟΟ„Ο‰ΟƒΞ· (login page).
6. Ξ‘Ξ½ Ο‡ΟΞµΞΉΞ±ΟƒΟ„ΞµΞ―Ο‚ Ξ½Ξ± Ο€ΞµΟΞ¬ΟƒΞµΞΉΟ‚ ΞµΟ€ΞΉΞΌΞ­ΟΞΏΟ…Ο‚ Ξ±Ξ»Ξ»Ξ±Ξ³Ξ­Ο‚ config, Ο‡ΟΞ·ΟƒΞΉΞΌΞΏΟ€ΞΏΞ―Ξ·ΟƒΞµ **Admin REST partialImport** Ξ® kcadm.sh (ΟΟ‡ΞΉ KC_IMPORT ΟƒΟ„ΞΏ production).

- docker compose down keycloak
- Restore DB backup
- ΞΞ±Ξ½Ξ±ΟƒΞ®ΞΊΟ‰ΟƒΞµ Ο„Ξ·Ξ½ 22 ΞΌΞµ Ο„ΞΏ Ο€Ξ±Ξ»ΞΉΟ image/tag.
       
`"clientId"`: `"admi-cli"`,

```
"fullScopeAllowed": true,
"clientId": "security-admin-console", "fullScopeAllowed": true,
```
   

```
Β  "organizationsEnabled": false,
Β  "verifiableCredentialsEnabled": false,
Β  "adminPermissionsEnabled": false,
```
   
         

**Ξ Ξ»Ξ¬Ξ½ΞΏ Ξ±Ξ½Ξ±Ξ²Ξ¬ΞΈΞΌΞΉΟƒΞ·Ο‚ (Ξ―Ξ΄ΞΉΞ± DB)**
 
**Ξ£Ξ·ΞΌΞµΞ―Ξ± Ο€ΟΞΏΟƒΞΏΟ‡Ξ®Ο‚ Ξ±Ο€Ο 22 β†’ 26**  
**Ξ¤ΞΉ Ξ³Ξ―Ξ½ΞµΟ„Ξ±ΞΉ ΞΌΞµ Ο„ΞΏΟ…Ο‚ users**  
**Ξ•Ξ»Ξ¬Ο‡ΞΉΟƒΟ„ΞΏ operational checklist ΞΌΞµΟ„Ξ¬ Ο„ΞΏ upgrade**
   

**1. Ξ ΟΞΏΞµΟ„ΞΏΞΉΞΌΞ±ΟƒΞ―Ξ± ΞΊΞ±ΞΉ Backup**
 
**2. Ξ ΟΞΏΞµΟ„ΞΏΞΉΞΌΞ±ΟƒΞ―Ξ± Ξ½Ξ­ΞΏΟ… Image**
 
- [ ] **3. Ξ•ΞΊΞΊΞ―Ξ½Ξ·ΟƒΞ· ΞΊΞ±ΞΉ Migration**
 
Ξ‘Ο†ΞΏΟ Ξ±Ξ½Ξ­Ξ²ΞµΞΉ:
 
**5. Rollback (Ξ±Ξ½ Ο‡ΟΞµΞΉΞ±ΟƒΟ„ΞµΞ―)**
 
**6. Optional Verification Commands**
      

**Ξ’Ξ®ΞΌΞ±Ο„Ξ± ΞµΞΊΟ„Ξ­Ξ»ΞµΟƒΞ·Ο‚**  
**Rollback**



