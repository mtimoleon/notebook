---
categories:
  - "[[Work]]"
created: 2026-02-19
product: scpCloud
component: DocumentDB
status: completed
tags:
  - issues/intelligen
  - documentation/intelligen
---
## Context
Explore DocumentDB as alternative to MongoDB

## Notes

### Local installations and measurements
#### Install DocumentDB on Docker
1. Τι είναι το “Azure DocumentDB” σήμερα

* Το Azure DocumentDB είναι managed MongoDB-compatible υπηρεσία που βασίζεται στο open-source DocumentDB engine (πάνω σε PostgreSQL, με MongoDB wire protocol). ([Microsoft for Developers][1])
* Στο PC σου δεν “τρέχεις Azure service”, αλλά μπορείς να τρέξεις το αντίστοιχο open-source local image: **DocumentDB Local**. ([GitHub][2])

2. Local εγκατάσταση σε Docker (DocumentDB Local)
   2.1 Docker run (ο πιο γρήγορος τρόπος)

* Pull + run (με credentials που ορίζεις εσύ):

```bash
docker pull ghcr.io/documentdb/documentdb/documentdb-local:latest
docker tag ghcr.io/documentdb/documentdb/documentdb-local:latest documentdb
docker run -dt -p 10260:10260 --name documentdb-container documentdb --username <USER> --password <PASS>
```

Αυτό είναι το “official” quick start από το repo του DocumentDB. ([GitHub][2])

If you want to do it with compose:
Add this service to a `docker-compose.yml` (or into your existing one under `services:`):

```yaml
services:
  documentdb-container:
    image: documentdb
    container_name: documentdb-container
    ports:
      - "10260:10260"
    command: ["--username", "${DOCUMENTDB_USER}", "--password", "${DOCUMENTDB_PASS}"]
    restart: unless-stopped
```

Run it like:
```
DOCUMENTDB_USER=<USER> DOCUMENTDB_PASS=<PASS> docker compose up -d documentdb-container
```
(Or put `DOCUMENTDB_USER` / `DOCUMENTDB_PASS` in a .env file next to the compose file.)

* Connection string (MongoDB driver):

  * Η local σύνδεση γίνεται με TLS και συνήθως θες να επιτρέψεις invalid certs (local dev):

```text
mongodb://<USER>:<PASS>@localhost:10260/?tls=true&tlsAllowInvalidCertificates=true
```

([GitHub][2])

2.2 Docker Compose (αν θες πιο “μόνιμο” setup)

* `compose.yml`:

```yaml
services:
  documentdb:
    image: ghcr.io/documentdb/documentdb/documentdb-local:latest
    container_name: documentdb
    ports:
      - "10260:10260"
    command: ["--username", "devuser", "--password", "devpass"]
    restart: unless-stopped
```

If `image` is in main compose:

```yaml
services:
  documentdb:
    image: ghcr.io/documentdb/documentdb/documentdb-local:latest
```

and then inside  override:

```yaml
services:
  documentdb:
    container_name: nosqldata-documentdb
    ports:
      - "10260:10260"
    command: ["--skip-init-data"]
    environment:
      - USERNAME=user
      - PASSWORD=pass
    volumes:
      - scp-nosqldata-documentdb:/data
```

* Εκκίνηση:

```bash
docker compose up -d
```

3. Πρακτικές σημειώσεις για αντικατάσταση Mongo

* Πόρτα: τα docs δείχνουν **10260** για να μη συγκρούεται με άλλα (π.χ. Mongo στο 27017). Μπορείς να το αλλάξεις, αλλά τότε αλλάζει και το connection string. ([GitHub][2])
* Συμβατότητα: είναι MongoDB-compatible, αλλά μην το θεωρήσεις 100% drop-in χωρίς smoke tests (aggregation pipeline, indexes, BSON edge cases). Αυτό είναι εμπειρική γνώση από migrations σε “Mongo-compatible” engines.

4. Τι να κάνεις αμέσως μετά

* 1) Σήκωσε container και κάνε ένα απλό CRUD από την εφαρμογή σου με το υπάρχον MongoDB driver.
* 2. Τρέξε τα βασικά σου aggregations/queries (τα “βαριά” endpoints).
* 3. Αν περάσουν, τότε μόνο σκέψου data migration.

Συμπέρασμα

* Για “Azure DocumentDB” εμπειρία σε PC με Docker: **τρέχεις DocumentDB Local container** και συνδέεσαι με τον υπάρχοντα MongoDB driver σου μέσω TLS στο `localhost:10260`. ([GitHub][2])

[1]: https://devblogs.microsoft.com/cosmosdb/azure-documentdb-is-now-generally-available/?utm_source=chatgpt.com "Azure DocumentDB is Now Generally Available"
[2]: https://github.com/documentdb/documentdb "GitHub - documentdb/documentdb: MongoDB-compatible database engine for cloud-native and open-source workloads. Built for scalability, performance, and developer productivity."


#### Connect Compass

1. Connection string για Compass
   Χρησιμοποιείς το ίδιο URI που θα έδινες σε Mongo driver:

```
mongodb://<USER>:<PASS>@localhost:10260/?tls=true&tlsAllowInvalidCertificates=true
```

Παράδειγμα:

```
mongodb://devuser:devpass@localhost:10260/?tls=true&tlsAllowInvalidCertificates=true
```

Αυτό βασίζεται στο official DocumentDB local setup που εκθέτει Mongo wire endpoint στη 10260 με TLS ενεργό. (πηγή: GitHub DocumentDB repo docs)

#### Measure speed

Run on a database with 50000 items the following aggregation:

```
[
  // Find global previous publish
  { $match: { PublishedAt: { $lt: ISODate("2025-10-22T07:43:14.944Z") } } },
  { $group: { _id: null, firstPublish: { $max: "$PublishedAt" } } },
  // FirstBatch = last doc with PublishedAt == firstPublish, per Id
  {
    $lookup: {
      from: "archived-batches",
      let: {
        fp: "$firstPublish"
      },
      pipeline: [
        { $match: { $expr: { $eq: ["$PublishedAt", "$$fp"] } } },
        { $sort: { Id: 1, _id: 1 } },
        { $group: { _id: "$Id", FirstBatch: { $last: "$$ROOT" } } },
        {
          // For efficiency we can do specific batch projection here
          $project: { FirstBatch: 1, LastBatch: { $literal: null } }
        }
      ],
      as: "prevRows"
    }
  },
  { $unwind: { path: "$prevRows", preserveNullAndEmptyArrays: true } },
  { $replaceRoot: { newRoot: "$prevRows" } },

  // LastBatch = first doc with PublishedAt >= lastDate, per Id
  {
    $unionWith: {
      coll: "archived-batches",
      pipeline: [
        {
          $match: {
            PublishedAt: {
              $gte: ISODate(
                "2025-10-22T07:43:15.184Z"
              )
            }
          }
        },
        {
          $sort: {
            Id: 1,
            PublishedAt: 1,
            _id: 1
          }
        },
        {
          $group: {
            _id: "$Id",
            LastBatch: {
              $first: "$$ROOT"
            }
          }
        },

        // For efficiency we can do specific batch projection here
        {
          $project: {
            FirstBatch: {
              $literal: null
            },
            LastBatch: 1
          }
        }
      ]
    }
  },

  {
    $group: {
      _id: "$_id",
      // $max acts as "pick non-null" if there are any null objects in the list
      FirstBatch: { $max: "$FirstBatch" },
      LastBatch: { $max: "$LastBatch" }
    }
  },

  {
    $match: {
      $expr: {
        $or: [ {$ne: ["$FirstBatch", null]}, { $ne: ["$LastBatch", null]} ]
      }
    }
  },
  {
    $sort: {
      _id: 1
    }
  },

  // If there is specific projection before there is no need to project here
  {
    $project: {
      FirstBatchId: "$FirstBatch.Id",
      FirstBatchName: "$FirstBatch.Name",
      FirstBatch: "$FirstBatch.PublishedAt",
      LastBatchId: "$LastBatch.Id",
      LastBatchName: "$LastBatch.Name",
      LastBatch: "$LastBatch.PublishedAt"
    }
  }
]
```

DocumentDb results:
```
{
 "stage": "COLLSCAN",
 "nReturned": 49950,
 "executionTimeMillis": 877,
 "totalKeysExamined": 49950,
 "totalDocsExamined": 49950,
 "totalDocsRemovedByRuntimeFilter": 0,
 "numBlocksFromCache": 182759,
 "numBlocksFromDisk": 34185
}
```
![[536-Replace-MongoDB-with-DocumentDB-20260316.png|300]]


MongoDB results:
```
{
 "stage": "GROUP",
 "planNodeId": 3,
 "nReturned": 1,
 "executionTimeMillisEstimate": 367,
 "opens": 1,
 "closes": 1,
 "saveState": 20,
 "restoreState": 19,
 "isEOF": 1,
 "projections": {
  "8": "newObj(\"_id\", s6, \"firstPublish\", s7) "
 },
 "docsExamined": 0,
 "keysExamined": 0
}
{
 "stage": "COLLSCAN",
 "planNodeId": 1,
 "nReturned": 49950,
 "executionTimeMillisEstimate": 349,
 "opens": 1,
 "closes": 1,
 "saveState": 20,
 "restoreState": 19,
 "isEOF": 1,
 "numTested": 49950,
 "filter": {
  "PublishedAt": {
   "$lt": "2025-10-22T07:43:14.944Z"
  }
 },
 "direction": "forward",
 "docsExamined": 49950,
 "keysExamined": 0
}
```

![[536-Replace-MongoDB-with-DocumentDB-20260316 1.png]]

##### Run sync on big recipe schedule

Recipe used **USP C3P1 2.5d V3** with 1 batch
All measurements made with cold database.

|                                   | DocumentDB                                | MongoDB                   |
| --------------------------------- | ----------------------------------------- | ------------------------- |
| Terminate and delete data         | 5.47s                                     | 4.61s                     |
| Initiate                          | 1.78s                                     | 568ms                     |
| Sync all with empty db            | 10.39s                                    | 9.94s                     |
| Production Eoc fetch/display      | 6.56s (562ms second read)                 | 6.79s (678ms second read) |
| Production Operations read        | 9.78s (6.44 second read, 6.08 third read) | 3.98s (374 second read)   |
| Integration-api/operation-entries | 2.94s (838ms second read)                 | 2.83s (656ms second read) |
|                                   |                                           |                           |

#### Migration με mongodump/mongorestore

1. Dump από MongoDB σε docker container

Για όλη τη βάση σε ένα archive (βολικό για μεταφορά):

```
docker exec nosqldata mongodump --archive="dump.archive" --gzip
```

Αν θέλω σε τοπικό δίσκο έξω από το container:

```
docker exec nosqldata mongodump  --uri="mongodb://user:pass@nosqldata-documentdb:10260/?tls=true&tlsInsecure=true" --db s-1 --collection archived-batches --archive > D:/archived-batches.dump --gzip
```

```
docker exec nosqldata mongodump --archive > D:/dump.archive --gzip
```

1. Restore local
   ```
   docker exec -i nosqldata mongorestore \
  --uri="mongodb://user:pass@nosqldata-documentdb:10260/?tls=true&tlsInsecure=true" \
  --archive --gzip \
  --drop \
  --nsExclude='admin.*' \
  --nsExclude='config.*' \
  --nsExclude='local.*' \
  < /d/dump.archive
   ```

```
docker exec -i nosqldata mongorestore --uri="mongodb://localhost:27017/?replicaSet=rs0&directConnection=true" --archive --gzip --drop --nsExclude='admin.*' ='config.*' --nsExclude='local.*'  < /d/archived-batches.dump
```

2. Restore σε Azure DocumentDB (στόχος)

Αν ο στόχος σου έχει TLS (συνήθως ναι), κάνεις restore με TLS flags/params:

```
docker exec nosqldata \
 mongorestore \
  --uri="mongodb://user:pass@documentdb-container:10260" \
  --ssl --tlsInsecure \
  --archive=/backup/nosqldata_2026-02-19_15-35-49.archive.gz --gzip \
  --drop \
  --nsExclude='admin.*' \
  --nsExclude='config.*' \
  --nsExclude='local.*'
```

Αν τρέξω το command at local containers and do not want to use my local disk for resolving the file, need to add `MSYS2_ARG_CONV_EXCL="*"` before running the command:

```
MSYS2_ARG_CONV_EXCL="*" docker exec -i scp-nosqldata-backup mongorestore \
  --uri="mongodb://user:pass@documentdb-container:10260" \
  --ssl --tlsInsecure \
  --archive="/backup/nosqldata_2026-02-19_15-35-49.archive.gz" --gzip \
  --drop \
  --nsExclude='admin.*' \
  --nsExclude='config.*' \
  --nsExclude='local.*'

```
Σημειώσεις:

In case container cannot see each other, put documentdb container in the same network of nosqldata-backup container using info from [[Docker notes]].

`--drop` σβήνει collections πριν το restore (χρήσιμο για repeatable migrations).


### Code considerations
#### Transactions
Transactions take place like MongoDB. We do not need `replicaSet`, this is handled by Azure.
[Transactions in Azure DocumentDB](https://learn.microsoft.com/en-us/azure/documentdb/how-to-transactions?tabs=javascript)

### Azure migration from MongoDB

[Azure Documentation](https://learn.microsoft.com/en-us/azure/documentdb/migration-options#migration)
Two ways of doing it:
 - [Migration web based utility](https://github.com/AzureCosmosDB/MongoMigrationwebBasedUtility)
 - [Using native MongoDB tools](https://learn.microsoft.com/en-us/azure/documentdb/how-to-migrate-native-tools)

#### Go with MongoDB tools:
##### Prepare
Prior to starting the migration, make sure you have prepared your Azure DocumentDB account and your existing MongoDB instance for migration.
- MongoDB instance (source)
    - Complete the premigration assessment to determine if there are a list of incompatibilities and warnings between your source instance and target account.
    - Ensure that your MongoDB native tools match the same version as the existing (source) MongoDB instance.
        - If your MongoDB instance has a different version than Azure DocumentDB, then install both MongoDB native tool versions and use the appropriate tool version for MongoDB and Azure DocumentDB, respectively.
    - Add a user with `readWrite` permissions, unless one already exists. You eventually use this credential with the _mongoexport_ and _mongodump_ tools.
- Azure DocumentDB (target)
    - Gather the Azure DocumentDB [account's credentials](https://learn.microsoft.com/en-us/azure/documentdb/quickstart-portal#get-cluster-credentials).
    - [Configure Firewall Settings](https://learn.microsoft.com/en-us/azure/documentdb/security#network-security) on Azure DocumentDB

> [!TIP] Tip
> We recommend running these tools within the same network as the MongoDB instance to avoid further firewall issues.

##### Choose the proper MongoDB native tool
There are some high-level considerations when choosing the right MongoDB native tool for your offline migration.
##### Perform the migration
Migrate a collection from the source MongoDB instance to the target Azure DocumentDB account using your preferred native tool. For more information on selecting a tool see [migration options](https://learn.microsoft.com/en-us/azure/documentdb/migration-options).

> [!TIP] Tip
> If you simply have a small JSON file that you want to import into Azure DocumentDB, the _mongoimport_ tool is a quick solution for ingesting the data.

1. To create a data dump of all data in your MongoDB instance, open a terminal and use any of three methods listed here.
      - Specify the `--host`, `--username`, and `--password` arguments to dump the data as native BSON.
	```bash
	mongodump \
		--host <hostname><:port> \
		--username <username> \
		--password <password> \
		--out <dump-directory>
	```

    - Specify the `--db` and `--collection` arguments to narrow the scope of the data you wish to dump:
	```bash
	mongodump \
		--host <hostname><:port> \
		--username <username> \
		--password <password> \
		--db <database-name> \
		--out <dump-directory>
	```

	```bash
	mongodump \
		--host <hostname><:port> \
		--username <username> \
		--password <password> \
		--db <database-name> \
		--collection <collection-name> \
		--out <dump-directory>
	```

    - Create a data dump of all data in your Azure DocumentDB.
	```bash
	mongodump \
		--uri <target-connection-string> \
		--out <dump-directory>
	```
​
2. Observe that the tool created a directory with the native BSON data dumped. The files and folders are organized into a resource hierarchy based on the database and collection names. Each database is a folder and each collection is a `.bson` file.

3. Restore the contents of any specific collection into an Azure DocumentDB account by specifying the collection's specific BSON file. The filename is constructed using this syntax: `<dump-directory>/<database-name>/<collection-name>.bson`.

```bash
mongorestore \
	--ssl \
	--uri <target-connection-string> \
	<dump-directory>/<database-name>/<collection-name>.bson
```

> [!NOTE]  Note
> You can also restore a specific collection or collections from the dump-directory /directory. For example, the following operation restores a single collection from corresponding data files in the dump-directory / directory. `mongorestore --nsInclude=test.purchaseorders <dump-directory>/`

4. Monitor the terminal output from _mongoimport_. The output prints lines of text to the terminal with updates on the restore operation's status.



mongodb://user:pass@localhost:27017/?tls=true&tlsAllowInvalidCertificates=true&tlsAllowInvalidHostnames=true&replicaSet=rs0&directConnection=true

mongodb://user:pass@localhost:10260/?tls=true&tlsInsecure=true&directConnection=true





### Other notes

If we want to access internal PostgreSQL from outside container:

```
  nosqldata-documentdb:
    container_name: nosqldata-documentdb
    ports:
      - "10260:10260"
      #- "15432:9712" Use this to expose internal postgres
    command: ["--skip-init-data"]
    environment:
      - USERNAME=user
      - PASSWORD=pass
      #- ALLOW_EXTERNAL_CONNECTIONS=true , Use this to expose internal postgres
    volumes:
      - scp-nosqldata-documentdb:/data
```

#### Connection string

```
mongodb+srv://scpcloudadmin:<password>@scp-cloud-documentdb-cluster.global.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000
```

Στόχος: το connection string να **μην μπαίνει στο Docker image** (build args), αλλά να δίνεται **στο runtime** από το Azure ως **secret**.
**Γιατί όχι build args**
- `docker build --build-arg ...` μπορεί να καταλήξει σε image layers / build logs / ACR tasks history.
- Όποιος έχει πρόσβαση στο image μπορεί να δει env vars που “ψήθηκαν” στο image.
##### ==Azure Container Apps (ACA)==
1) Δημιούργησε secret στο Container App
- Portal: Container App → **Secrets** → Add
- Όνομα π.χ. `documentdb-conn`
2) Κάνε inject ως env var από secret
- Portal: Container App → **Containers** → Environment variables → Add
- Name: `ProductionDatabaseSettings__ConnectionString`
- Source: **Secret reference**
- Secret: `documentdb-conn`
(Το ίδιο γίνεται και με `az containerapp secret set` + `az containerapp update --set-env-vars ...=secretref:...` αν το δουλεύετε με CLI.)
##### Azure App Service (Web App for Containers)
1) Βάλε το secret ως application setting (είναι “secret-ish”/encrypted at rest)
- Portal: App Service → **Configuration** → Application settings → New
- Name: `ProductionDatabaseSettings__ConnectionString`
- Value: `<connection string>`
- Save (κάνει restart)
2) Αν χρησιμοποιείς Key Vault reference (καλύτερο)
- Δημιούργησε secret στο Key Vault, π.χ. `documentdb-conn`
- Στο App Service setting value βάλε:
  - `@Microsoft.KeyVault(SecretUri=<secret-uri>)`
- Θέλει managed identity + access policy / RBAC στο Key Vault.
##### Kubernetes (AKS)
1) Δημιούργησε K8s Secret
- `kubectl create secret generic documentdb-conn --from-literal=conn='<connection string>'`
2) Κάνε inject στο Deployment
- env:
  - name: `ProductionDatabaseSettings__ConnectionString`
  - valueFrom:
    - secretKeyRef: name `documentdb-conn`, key `conn`
##### Πώς δένει με το repo σου
- Στο `docker-compose.azure.yml:70` ήδη περιμένει runtime env var `ProductionDatabaseSettings__ConnectionString`.
- Στο `Services/Production/Production.Api/Infrastructure/Database/DatabaseContext.cs:31` το app θα το διαβάσει από `ProductionDatabaseSettings__ConnectionString` (ή fallback, αν το αφήσεις).



#### Links
[[Azure DocumentDB Notes]]
[Azure DocumentDB documentation](https://learn.microsoft.com/en-us/azure/documentdb/overview)
​[Comparison by Mongo](https://www.mongodb.com/resources/compare/mongodb-vs-cosmos-db)
