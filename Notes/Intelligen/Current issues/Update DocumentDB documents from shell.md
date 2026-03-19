---
categories:
  - "[[Resources]]"
created: 2026-03-17
url:
tags:
  - developer
  - topic/databases
  - tech/DocumentDB
  - tech/MongoDB
  - topic/code
---
## Notes

[Microsoft connect from MongoDB Shell](https://learn.microsoft.com/en-us/azure/documentdb/how-to-connect-mongo-shell)

MongoDB Shell (`mongosh`) is a JavaScript and Node.js environment for interacting with MongoDB deployments. It's a popular community tool to test queries and interact with the data in your Azure DocumentDB cluster. This article explains how to connect to an Azure DocumentDB cluster using MongoDB Shell.

### Prerequisites
- An Azure subscription
    - If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn)
- An existing Azure DocumentDB cluster
    - If you don't have a cluster, create a [new cluster](https://learn.microsoft.com/en-us/azure/documentdb/quickstart-portal)
- MongoDB Shell. For more information, see [install MongoDB shell](https://www.mongodb.com/try/download/shell)
- Firewall rules that allow your client to connect to the cluster. For more information, see [configure firewall](https://learn.microsoft.com/en-us/azure/documentdb/how-to-configure-firewall).

### Get cluster credentials
Get the connection string you need to connect to this cluster.
1. Sign in to the **Azure portal** ([https://portal.azure.com](https://portal.azure.com/)).
2. Navigate to the existing Azure DocumentDB cluster.
Get the credentials you use to connect to the cluster.
3. On the cluster page, select the **Connection strings** option in the resource menu.
4. In the **Connection strings** section, copy or record the value from the **Connection string** field.
![Screenshot showing connection strings option.](https://learn.microsoft.com/en-us/azure/documentdb/includes/media/quickstart-portal/get-cluster-credentials.png)

> [!info] Important
> The connection string in the portal doesn't include the password value. You must replace the `<password>` placeholder with the credentials you entered when you created the cluster or enter the password interactively.

### Connect with interactive password authentication
Connect to your cluster by using the MongoDB Shell with a connection string that doesn't include a password. Use the interactive password prompt to enter your password as part of the connection steps.
1. Open a terminal.
2. Connect by entering the password in the MongoDB Shell prompt. For this step, use a connection string without the password.
    Console
    ```
    mongosh "mongodb+srv://<username>@<cluster-name>.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"
    ```
3. After you provide the password and are successfully authenticated, observe the warning that appears
    Output
    ```
    This server or service appears to be an emulation of MongoDB.
    ```
     Tip
    You can safely ignore this warning. This warning is generated because the connection string contains `cosmos.azure`. Azure DocumentDB is a native Azure platform as a service (PaaS) offering.
4. **Exit** the shell context.
[](https://learn.microsoft.com/en-us/azure/documentdb/how-to-connect-mongo-shell#connect-with-connection-string-and-password)
### Connect with connection string and password
Now, connect to your cluster from the MongoDB Shell with a connection string and parameters that includes a password.
1. Connect by using a connection string and the `--username` and `--password` arguments.
    Console
    ```
    mongosh "mongodb+srv://<cluster-name>.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000" --username "<username>" -password "<password>"
    ```
2. After you provide the password and are successfully authenticated, observe the warning that appears.
    Output
    ```
    ------
       Warning: Non-Genuine MongoDB Detected
       This server or service appears to be an emulation of MongoDB rather than an official MongoDB product.
    ------
    ```
     Tip
    You can safely ignore this warning. This warning is generated because the connection string contains `cosmos.azure`. Azure DocumentDB is a native Azure platform as a service (PaaS) offering.
[](https://learn.microsoft.com/en-us/azure/documentdb/how-to-connect-mongo-shell#perform-test-queries)
### Perform test queries
Verify that you're successfully connected to your cluster by performing a series of test commands and queries.
1. Check your connection status by running the `connectionStatus` command.
    MongoDB Query Language (MQL)
    ```
    db.runCommand({connectionStatus: 1})
    ```
    Output
    ```
    {
      ...
      ok: 1
    }
    ```
2. List the databases in your cluster.
    MongoDB Query Language (MQL)
    ```
    show dbs
    ```
3. Switch to a specific database. Replace the `<database-name>` placeholder with the name of any database in your cluster.
    MongoDB Query Language (MQL)
    ```
    use <database-name>
    ```
     Tip
    For example, if the database name is `inventory`, then the command would be `use inventory`.
4. List the collections within the database.
    MongoDB Query Language (MQL)
    ```
    show collections
    ```
5. Find the first five items within a specific collection. Replace the `<collection-name>` placeholder with the name of any collection in your cluster.
    MongoDB Query Language (MQL)
    ```
    db.<collection-name>.find().limit(5)
    ```
     Tip
    For example, if the collection name is `equipment`, then the command would be `db.equipment.find().limit(5)`.
[](https://learn.microsoft.com/en-us/azure/documentdb/how-to-connect-mongo-shell#related-content)
### Related content
- [Connect using Azure Cloud Shell](https://learn.microsoft.com/en-us/azure/documentdb/how-to-connect-cloud-shell)
- [Configure firewall](https://learn.microsoft.com/en-us/azure/documentdb/how-to-configure-firewall)
- [Migration options](https://learn.microsoft.com/en-us/azure/documentdb/migration-options)