---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-11-11T15:30
tags:
  - intelligen
  - keycloak
status: completed
product: ScpCloud
component: Keycloak
---

**1. Preparations & Backup**

1. **Do all the appropriate realm settings prior to update**
    
    - Open postman and import the **Keycloak β€“ scpCloud-realm-update.postman_collection** collection.
    - After importing switch to the collection variables and set the required values (depicted with red square)
    ![Exported image](Exported%20image%2020260209140351-0.png)
    
    - Now you can run either all scripts in collection or each folder separately. Right click on the desired and choose run.
    ![Exported image](Exported%20image%2020260209140352-1.png)
    
    You will get into a screen where all the requests will be shown:
    
    ![Exported image](Exported%20image%2020260209140353-2.png)
    
    After ther postman run, production keycloak realm will be updated with following cahnges:  
    - scpCloud-client-scope will have mappers  
    - scpCloud client dedicated scope will have no mappers  
    - hovione-integration-api-client mapper organizationId will be replace with tenantId mapper.
    
2. **Backup of keys**:οΏΌdocker cp keycloak:/opt/keycloak/data/ ./data_backup/
3. **Stop Keycloak 22 container****οΏΌ**docker compose stop keycloak
4. **Create a full backup DB**

docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "password" -Q "BACKUP DATABASE [keycloak] TO DISK='/var/opt/mssql/backup/keycloak.bak'"
 
**οΏΌ****2. Deploy & Run**

1. **Deploy and run the application as usual**οΏΌRunning the container it should upgrade the keycloak database gradually and produce logs (similar below) into container console:οΏΌ

```
2025-11-11 12:24:12.947 | 2025-11-11 10:24:12,945 INFO  [org.keycloak.quarkus.runtime.storage.database.liquibase.QuarkusJpaUpdaterProvider] (main) Updating database. Using changelog META-INF/jpa-changelog-master.xml
2025-11-11 12:24:15.666 | 2025-11-11 10:24:15,665 INFO  [org.keycloak.storage.datastore.DefaultMigrationManager] (main) Migrating older model to 23.0.0
2025-11-11 12:24:16.062 | 2025-11-11 10:24:16,062 INFO  [org.infinispan.CONTAINER] (main) Virtual threads support enabled
2025-11-11 12:24:16.219 | 2025-11-11 10:24:16,218 INFO  [org.infinispan.CONTAINER] (main) ISPN000556: Starting user marshaller 'org.infinispan.commons.marshall.ImmutableProtoStreamMarshaller'
2025-11-11 12:24:16.575 | 2025-11-11 10:24:16,575 INFO  [org.keycloak.connections.infinispan.DefaultInfinispanConnectionProviderFactory] (main) Node name: node_812748, Site name: null
2025-11-11 12:24:16.995 | 2025-11-11 10:24:16,994 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm ScpCloud to 23.0.0
2025-11-11 12:24:17.007 | 2025-11-11 10:24:17,007 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm master to 23.0.0
2025-11-11 12:24:17.007 | 2025-11-11 10:24:17,007 INFO  [org.keycloak.storage.datastore.DefaultMigrationManager] (main) Migrating older model to 24.0.0
2025-11-11 12:24:17.143 | 2025-11-11 10:24:17,143 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm ScpCloud to 24.0.0
2025-11-11 12:24:17.193 | 2025-11-11 10:24:17,193 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm master to 24.0.0
2025-11-11 12:24:17.193 | 2025-11-11 10:24:17,193 INFO  [org.keycloak.storage.datastore.DefaultMigrationManager] (main) Migrating older model to 24.0.3
2025-11-11 12:24:17.237 | 2025-11-11 10:24:17,237 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm ScpCloud to 24.0.3
2025-11-11 12:24:17.249 | 2025-11-11 10:24:17,249 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm master to 24.0.3
2025-11-11 12:24:17.249 | 2025-11-11 10:24:17,249 INFO  [org.keycloak.storage.datastore.DefaultMigrationManager] (main) Migrating older model to 25.0.0
2025-11-11 12:24:17.466 | 2025-11-11 10:24:17,465 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm ScpCloud to 25.0.0
2025-11-11 12:24:17.565 | 2025-11-11 10:24:17,565 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm master to 25.0.0
2025-11-11 12:24:17.565 | 2025-11-11 10:24:17,565 INFO  [org.keycloak.storage.datastore.DefaultMigrationManager] (main) Migrating older model to 26.0.0
2025-11-11 12:24:17.604 | 2025-11-11 10:24:17,603 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm ScpCloud to 26.0.0
2025-11-11 12:24:17.633 | 2025-11-11 10:24:17,632 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm master to 26.0.0
2025-11-11 12:24:17.633 | 2025-11-11 10:24:17,633 INFO  [org.keycloak.storage.datastore.DefaultMigrationManager] (main) Migrating older model to 26.1.0
2025-11-11 12:24:17.695 | 2025-11-11 10:24:17,694 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm ScpCloud to 26.1.0
2025-11-11 12:24:17.760 | 2025-11-11 10:24:17,759 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm master to 26.1.0
2025-11-11 12:24:17.760 | 2025-11-11 10:24:17,759 INFO  [org.keycloak.storage.datastore.DefaultMigrationManager] (main) Migrating older model to 26.2.0
2025-11-11 12:24:17.787 | 2025-11-11 10:24:17,786 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm ScpCloud to 26.2.0
2025-11-11 12:24:17.798 | 2025-11-11 10:24:17,797 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm master to 26.2.0
2025-11-11 12:24:17.798 | 2025-11-11 10:24:17,798 INFO  [org.keycloak.storage.datastore.DefaultMigrationManager] (main) Migrating older model to 26.3.0
2025-11-11 12:24:17.821 | 2025-11-11 10:24:17,821 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm ScpCloud to 26.3.0
2025-11-11 12:24:17.838 | 2025-11-11 10:24:17,837 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm master to 26.3.0
2025-11-11 12:24:17.838 | 2025-11-11 10:24:17,838 INFO  [org.keycloak.storage.datastore.DefaultMigrationManager] (main) Migrating older model to 26.4.0
2025-11-11 12:24:17.860 | 2025-11-11 10:24:17,859 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm ScpCloud to 26.4.0
2025-11-11 12:24:17.872 | 2025-11-11 10:24:17,872 INFO  [org.keycloak.migration.migrators.RealmMigration] (main) migrated realm master to 26.4.0
```



