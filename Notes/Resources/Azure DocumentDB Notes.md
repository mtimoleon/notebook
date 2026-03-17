---
title: Quickstart - C# driver - Azure DocumentDB
categories:
  - "[[Resources]]"
created: 2026-03-02
published:
source: https://learn.microsoft.com/en-us/azure/documentdb/quickstart-dotnet
author:
  - "[[seesharprun]]"
description: This page provides a comprehensive guide to understanding and implementing API authentication using OAuth 2.0, covering various grant types, best practices, and common pitfalls for secure integration.
tags:
  - tech/DocumentDB
  - type/Guide
  - topic/databases
  - tech/Azure
---
## How to: Use Azure DocumentDB with MongoDB driver for C#

In this quickstart, you create a basic Azure DocumentDB application using C#. Azure DocumentDB is a NoSQL data store that allows applications to store documents in the cloud and access them using official MongoDB drivers. This guide shows how to create documents and perform basic tasks in your Azure DocumentDB cluster using C#.

[API reference](https://www.mongodb.com/docs/drivers/csharp/current/) | [Source code](https://github.com/mongodb/mongo-csharp-driver) | [Package (NuGet)](https://www.nuget.org/packages/MongoDB.Driver)

### Prerequisites

- An Azure subscription
	- If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn)
- .NET 10.0 or later

To get started, you first need to create an Azure DocumentDB cluster, which serves as the foundation for storing and managing your NoSQL data.

1. Sign in to the **Azure portal** ([https://portal.azure.com](https://portal.azure.com/)).
2. From the Azure portal menu or the **Home page**, select **Create a resource**.
3. On the **New** page, search for and select **Azure DocumentDB**.
   ![Screenshot showing search for Azure DocumentDB.](https://learn.microsoft.com/en-us/azure/documentdb/includes/media/quickstart-portal/select-azure-documentdb.png)
	Screenshot showing search for Azure DocumentDB.
4. On the **Create Azure DocumentDB cluster** page and within the **Basics** section, select the **Configure** option within the **Cluster tier** section.
	![Screenshot showing Configure cluster option.](https://learn.microsoft.com/en-us/azure/documentdb/includes/media/quickstart-portal/select-configure-option.png)
	Screenshot showing Configure cluster option.
5. On the **Scale** page, configure these options and then select **Save** to persist your changes to the cluster tier.
   	
|                   | Value                          |
| ----------------- | ------------------------------ |
| Cluster tier      | `M30 tier, 2 vCore, 8-GiB RAM` |
| Storage per shard | `128 GiB`                      |
|                   |                                |

![Screenshot of configuration options for compute and storage for a new Azure DocumentDB cluster.](https://learn.microsoft.com/en-us/azure/documentdb/includes/media/quickstart-portal/configure-compute-and-storage.png)
	Screenshot of configuration options for compute and storage for a new Azure DocumentDB cluster.
6. Back in the **Basics** section, configure the following options:
   
|     | Value |
| --- | ----- |
| Subscription | Select your Azure subscription |
| Resource group | Create a new resource group or select an existing resource group |
| Cluster name | Provide a globally unique name |
| Location | Select a supported Azure region for your subscription |
| MongoDB version | Select `8.0` |
| Admin username | Create a username to access the cluster as a user administrator |
| Password | Use a unique password associated with the username |	
	
![Screenshot showing cluster parameters.](https://learn.microsoft.com/en-us/azure/documentdb/includes/media/quickstart-portal/enter-cluster-configurations.png)
	Screenshot showing cluster parameters.
	
7.  Select **Next: Networking**.
8. In the **Firewall rules** section on the **Networking** tab, configure these options:
   
|                                                                                    | Value           |
| ---------------------------------------------------------------------------------- | --------------- |
| **Connectivity method**                                                                | `Public access` |
| **Allow public access from Azure services and resources within Azure to this cluster** | *Enabled*       |
	
9. Add a firewall rule for your current client device to grant access to the cluster by selecting **\+ Add current client IP address**.
	![Screenshot showing network configurations.](https://learn.microsoft.com/en-us/azure/documentdb/includes/media/quickstart-portal/select-networking.png)
	Screenshot showing network configurations.
10. Select **Review + create**.
11. Review the settings you provide, and then select **Create**. It takes a few minutes to create the cluster. Wait for the resource deployment is complete.
12. Finally, select **Go to resource** to navigate to the Azure DocumentDB cluster in the portal.

![Screenshot showing goto resource options.](https://learn.microsoft.com/en-us/azure/documentdb/includes/media/quickstart-portal/go-to-resource.png)

Screenshot showing goto resource options.

Get the credentials you use to connect to the cluster.

1. On the cluster page, select the **Connection strings** option in the resource menu.
2. In the **Connection strings** section, copy or record the value from the **Connection string** field.

![Screenshot showing connection strings option.](https://learn.microsoft.com/en-us/azure/documentdb/includes/media/quickstart-portal/get-cluster-credentials.png)

Screenshot showing connection strings option.

Create a new.NET console application project in your current directory.

1. Start in an empty directory.
2. Open a terminal in the current directory.
3. Create a new.NET console application.
	```dotnetcli
	dotnet new console
	```
4. Build the project to ensure it was created successfully.
	```dotnetcli
	dotnet build
	```

The client library is available through NuGet, as the `MongoDB.Driver` package.

1. Install the MongoDB.NET driver using the NuGet package manager.
	```dotnetcli
	dotnet add package MongoDB.Driver
	```
2. Open and review the **azure-documentdb-dotnet-quickstart.csproj** file to validate that the package reference exists.
3. Import the required namespaces into your application code:
	```csharp
	using System;
	using System.Collections.Generic;
	using System.Threading.Tasks;
	using MongoDB.Bson;
	using MongoDB.Bson.Serialization.Attributes;
	using MongoDB.Driver;
	```

### Object model


| Name | Description |
| --- | --- |
| `MongoClient` | Type used to connect to MongoDB. |
| `IMongoDatabase` | Represents a database in the cluster. |
| `IMongoCollection<T>` | Represents a collection within a database in the cluster. |


### Code examples

- [Authenticate the client](https://learn.microsoft.com/en-us/azure/documentdb/#authenticate-the-client)
- [Get a collection](https://learn.microsoft.com/en-us/azure/documentdb/#get-a-collection)
- [Create a document](https://learn.microsoft.com/en-us/azure/documentdb/#create-a-document)
- [Retrieve a document](https://learn.microsoft.com/en-us/azure/documentdb/#retrieve-a-document)
- [Query documents](https://learn.microsoft.com/en-us/azure/documentdb/#query-documents)

The code in this application connects to a database named `adventureworks` and a collection named `products`. The `products` collection contains details such as name, category, quantity, a unique identifier, and a sale flag for each product. The code samples here perform the most common operations when working with a collection.

First, connect to the client using a basic connection string.

1. Create the main method and set up the connection string. Replace `<your-cluster-name>`, `<your-username>`, and `<your-password>` with your actual cluster information.
	```csharp
	class Program
	{
	    static async Task Main(string[] args)
	    {
	        // Connection string for Azure DocumentDB cluster
	        string connectionString = "mongodb+srv://<your-username>:<your-password>@<your-cluster-name>.global.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000";
	        // Create MongoDB client settings
	        var settings = MongoClientSettings.FromConnectionString(connectionString);
	```
2. Create the MongoDB client and verify the connection.
	```csharp
	// Create a new client and connect to the server
	        var client = new MongoClient(settings);
	        // Ping the server to verify connection
	        var database = client.GetDatabase("admin");
	        var pingCommand = new BsonDocument("ping", 1);
	        await database.RunCommandAsync<BsonDocument>(pingCommand);
	        Console.WriteLine("Successfully connected and pinged Azure DocumentDB");
	```

Now, get your database and collection. If the database and collection doesn't already exist, use the driver to create it for you automatically.

1. Get a reference to the database.
	```csharp
	// Get database reference
	        var adventureWorksDatabase = client.GetDatabase("adventureworks");
	        Console.WriteLine($"Connected to database: {adventureWorksDatabase.DatabaseNamespace.DatabaseName}");
	```
2. Get a reference to the collection within the database.
	```csharp
	// Get collection reference
	        var productsCollection = adventureWorksDatabase.GetCollection<Product>("products");
	        Console.WriteLine($"Connected to collection: products");
	```

Then, create a couple of new documents within your collection. Upsert the documents to ensure that it replaces any existing documents if they already exist with the same unique identifier.

1. Define a Product class and create sample product documents.
	```csharp
	// Create sample products
	        var products = new List<Product>
	        {
	            new Product
	            {
	                Id = "00000000-0000-0000-0000-000000004018",
	                Name = "Windry Mittens",
	                Category = "apparel-accessories-gloves-and-mittens",
	                Quantity = 121,
	                Price = 35.00m,
	                Sale = false
	            },
	            new Product
	            {
	                Id = "00000000-0000-0000-0000-000000004318",
	                Name = "Niborio Tent",
	                Category = "gear-camp-tents",
	                Quantity = 140,
	                Price = 420.00m,
	                Sale = true
	            }
	        };
	```
2. Insert the documents using upsert operations.
	```csharp
	// Insert documents with upsert
	        foreach (var product in products)
	        {
	            var filter = Builders<Product>.Filter.Eq(p => p.Id, product.Id);
	            var options = new ReplaceOptions { IsUpsert = true };
	            await productsCollection.ReplaceOneAsync(filter, product, options);
	            Console.WriteLine($"Upserted product: {product.Name}");
	        }
	```
3. Add the Product class definition at the end of your Program.cs file.
	```csharp
	public class Product
	{
	    [BsonId]
	    [BsonElement("_id")]
	    public string Id { get; set; }
	    [BsonElement("name")]
	    public string Name { get; set; }
	    [BsonElement("category")]
	    public string Category { get; set; }
	    [BsonElement("quantity")]
	    public int Quantity { get; set; }
	    [BsonElement("price")]
	    public decimal Price { get; set; }
	    [BsonElement("sale")]
	    public bool Sale { get; set; }
	}
	```

Next, perform a point read operation to retrieve a specific document from your collection.

1. Define the filter to find a specific document by ID.
	```csharp
	// Retrieve a specific document by ID
	        var filter = Builders<Product>.Filter.Eq(p => p.Id, "00000000-0000-0000-0000-000000004018");
	```
2. Execute the query and retrieve the result.
	```csharp
	var retrievedProduct = await productsCollection.Find(filter).FirstOrDefaultAsync();
	        if (retrievedProduct != null)
	        {
	            Console.WriteLine($"Retrieved product: {retrievedProduct.Name} - ${retrievedProduct.Price}");
	        }
	        else
	        {
	            Console.WriteLine("Product not found");
	        }
	```

### Query documents

Finally, query multiple documents using the MongoDB Query Language (MQL).

1. Define a query to find documents matching specific criteria.
	```csharp
	// Query for products on sale
	        var saleFilter = Builders<Product>.Filter.Eq(p => p.Sale, true);
	        var saleProducts = await productsCollection.Find(saleFilter).ToListAsync();
	```
2. Iterate through the results to display the matching documents.
	```csharp
	Console.WriteLine("Products on sale:");
	        foreach (var product in saleProducts)
	        {
	            Console.WriteLine($"- {product.Name}: ${product.Price:F2} (Category: {product.Category})");
	        }
	    }
	}
	```

Use the **DocumentDB** extension in Visual Studio Code to perform core database operations, including querying, inserting, updating, and deleting data.

1. Open **Visual Studio Code**.
2. Navigate to the **Extensions** view and search for the term `DocumentDB`. Locate the **DocumentDB for VS Code** extension.
3. Select the **Install** button for the extension. Wait for the installation to complete. Reload Visual Studio Code if prompted.
4. Navigate to the **DocumentDB** extension by selecting the corresponding icon in the Activity Bar.
5. In the **DocumentDB Connections** pane, select **\+ New Connection...**.
6. In the dialog, select **Service Discovery** and then **Azure DocumentDB - Azure Service Discovery**.
7. Select your Azure subscription and your newly created Azure DocumentDB cluster.
8. Back in the **DocumentDB Connections** pane, expand the node for your cluster and navigate to your existing document and collection nodes.
9. Open the context menu for the collection and then select **DocumentDB Scrapbook > New DocumentDB Scrapbook**.
10. Enter the following MongoDB Query Language (MQL) commands and then select **Run All**. Observe the output from the commands.
	```mongo
	db.products.find({
	  price: { $gt: 200 },
	  sale: true
	})
	.sort({ price: -1 })
	.limit(3)
	```

When you're done with the Azure DocumentDB cluster, you can delete the Azure resources you created so you don't incur more charges.

1. In the Azure portal search bar, search for and select **Resource groups**.
	![Screenshot showing option for searching resource groups.](https://learn.microsoft.com/en-us/azure/documentdb/includes/media/quickstart-portal/search-resource-group-for-deletion.png)
	Screenshot showing option for searching resource groups.
2. In the list, select the resource group you used for this quickstart.
	![Screenshot showing resource group.](https://learn.microsoft.com/en-us/azure/documentdb/includes/media/quickstart-portal/click-delete-resource-group.png)
	Screenshot showing resource group.
3. On the resource group page, select **Delete resource group**.
4. In the deletion confirmation dialog, enter the name of the resource group to confirm that you intend to delete it. Finally, select **Delete** to permanently delete the resource group.
	![Screenshot showing delete resource group confirmation button.](https://learn.microsoft.com/en-us/azure/documentdb/includes/media/quickstart-portal/confirm-delete-resource-group.png)
	Screenshot showing delete resource group confirmation button.


Αναθεωρημένη ανάλυση σημείων 5 και 6 με αναφορά **σελίδας PDF** από το αρχείο

---


### Azure deployment

![[Intelligen-Notes-1772635195888.png|784]]

![[Intelligen-Notes-1772635875048.png|924]]

## Performance & throughput
1. Scaling μοντέλο
    - Vertical scaling (CPU/RAM/storage) και horizontal scaling (sharding) — σελ. 418
    - Compute και storage scale ανεξάρτητα — σελ. 13
    - Horizontal scaling προτείνεται για μεγάλα datasets (>2-4 TiB) — σελ. 418
2. Partitioning
    - Partition keys κατανέμουν δεδομένα σε physical partitions — σελ. 13
    - Απαιτείται υψηλή cardinality και ομοιόμορφη κατανομή — σελ. 13
3. Storage performance
    - Premium SSD v2 storage για predictable IOPS και χαμηλό latency — σελ. 389
    - Απόδοση εξαρτάται από compute tier + storage size — σελ. 389
4. Query optimization
    - Queries χωρίς index κάνουν document scan → ακριβό — σελ. 534
    - Index μόνο στα queryable fields — σελ. 534
    - Bulk load → indexes μετά ingestion — σελ. 534
5. Execution limits που επηρεάζουν performance
    - Transaction lifetime = 30 s — σελ. 483
    - Default query timeout = 120 s — σελ. 483
    - Cursor lifetime = 10 min — σελ. 483
    - Cross-node query data limit = 1 GB — σελ. 483
6. Hardware sizing
    - Working set πρέπει να χωρά σε RAM — σελ. 418
    - CPU >70 % για μεγάλο διάστημα → scale up — σελ. 418
7. Monitoring
    - Diagnostics και metrics για slow queries — σελ. 13

Τα links παρακάτω αντιστοιχούν στα επίσημα άρθρα τεκμηρίωσης.

---
##### 1. Compute & Storage Configuration — performance vs cost
Τεκμηρίωση για compute/storage setup:
​
[https://learn.microsoft.com/en-us/azure/documentdb/compute-storage](https://learn.microsoft.com/en-us/azure/documentdb/compute-storage) ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/compute-storage?utm_source=chatgpt.com "Compute and Storage Configurations - Azure DocumentDB"))
Ό,τι ρυθμίζεις στο compute ή storage **επηρεάζει ακριβώς το performance και το κόστος**:
1. Compute tier και αριθμός vCores καθορίζουν το πόσο γρήγορα εκτελούνται read και write operations (CPU/RAM). Αν είναι υπερβολικά μεγάλα, πληρώνεις χωρίς λόγο. Αν είναι πολύ μικρά, έχεις latency. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/compute-storage?utm_source=chatgpt.com "Compute and Storage Configurations - Azure DocumentDB"))
2. Storage size ορίζει τον **max IOPS** (δείτε πίνακα storage → maximum IOPS). Με μεγαλύτερο storage slot ανά shard → περισσότερη throughput capacity. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/compute-storage?utm_source=chatgpt.com "Compute and Storage Configurations - Azure DocumentDB"))
3. Ιδανικά ταιριάζεις τον compute με το storage ώστε να **μην έχεις σπατάλη** capacity που ποτέ δεν χρησιμοποιείς. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/compute-storage?utm_source=chatgpt.com "Compute and Storage Configurations - Azure DocumentDB"))
4. Παρακολούθησε την κατανάλωση CPU/IOPS και αντίστοιχα προσαρμόζεις tier/μέγεθος δίσκου — αυτό _ενισχύει_ και την απόδοση και _μειώνει_ τις περιττές χρεώσεις. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/compute-storage?utm_source=chatgpt.com "Compute and Storage Configurations - Azure DocumentDB"))

---
##### 2. Autoscale — performance spikes με λιγότερο κόστος
Τεκμηρίωση για Autoscale:
​
[https://learn.microsoft.com/en-us/azure/documentdb/autoscale](https://learn.microsoft.com/en-us/azure/documentdb/autoscale) ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/autoscale?utm_source=chatgpt.com "Autoscale on Azure DocumentDB"))
Autoscaling επιτρέπει:
1. Ο compute να αυξομειώνεται δυναμικά ανάλογα με το workload. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/autoscale?utm_source=chatgpt.com "Autoscale on Azure DocumentDB"))
2. Πληρώνεις μόνο για αυτό που _χρειάζεται_ εκείνη την ώρα (μην έχεις συνεχώς oversized cluster). ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/autoscale?utm_source=chatgpt.com "Autoscale on Azure DocumentDB"))
3. Υπάρχει επιβάρυνση (autoscale tier cost premium) αλλά η εξοικονόμηση σε βάθος χρόνου είναι σημαντική αν το workload είναι **σποραδικό/peaky**. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/autoscale?utm_source=chatgpt.com "Autoscale on Azure DocumentDB"))
Συνεπώς:
- Σταθερό workload → σταθερό tier πιθανώς φθηνότερο.
- Ασταθές/με spikes → autoscale μπορεί να μειώσει το συνολικό κόστος χωρίς να θυσιάσει throughput.

---
##### 3. Partitioning & schema design — performance _και_ cost
Επίσημη doc λίστα (FAQ):
​
[https://learn.microsoft.com/en-us/azure/documentdb/faq](https://learn.microsoft.com/en-us/azure/documentdb/faq) ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/faq?utm_source=chatgpt.com "Frequently asked questions - Azure DocumentDB"))
Τα βασικά:
1. Κακή partition key επιλογή → hotspot & throttling → χρειάζεσαι παραπάνω capacity για να «αντέξεις» την ανισοκατανομή των requests. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/faq?utm_source=chatgpt.com "Frequently asked questions - Azure DocumentDB"))
2. Ομοιόμορφη κατανομή data στο shard level → λιγότερο throttling → χρειάζεσαι λιγότερο throughput provisioning για ίδιο performance. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/faq?utm_source=chatgpt.com "Frequently asked questions - Azure DocumentDB"))
Συνεπώς το σωστό partition design:
- βελτιώνει performance
- μειώνει ανάγκες σε throughput provisioning → μικρότερο κόστος

---
##### 4. Monitoring metrics και tuning
Official metrics doc:
​
[https://docs.azure.cn/en-us/documentdb/monitor-metrics](https://docs.azure.cn/en-us/documentdb/monitor-metrics) ([Azure Docs](https://docs.azure.cn/en-us/documentdb/monitor-metrics?utm_source=chatgpt.com "Monitor metrics in Azure DocumentDB | Azure Docs"))
Για καλή βελτιστοποίηση:
1. Παρακολούθηση CPU/RAM/IOPS/storage % usage → γνωρίζεις πού «πονάνε» οι bottlenecks. ([Azure Docs](https://docs.azure.cn/en-us/documentdb/monitor-metrics?utm_source=chatgpt.com "Monitor metrics in Azure DocumentDB | Azure Docs"))
2. Αν CPU είναι χαμηλή αλλά storage IO είναι bottleneck → scale storage, όχι compute. ([Azure Docs](https://docs.azure.cn/en-us/documentdb/monitor-metrics?utm_source=chatgpt.com "Monitor metrics in Azure DocumentDB | Azure Docs"))
3. Αν αντίθετα CPU είναι bottleneck → scale compute tier. ([Azure Docs](https://docs.azure.cn/en-us/documentdb/monitor-metrics?utm_source=chatgpt.com "Monitor metrics in Azure DocumentDB | Azure Docs"))
Αυτό:
- αποφεύγει υπερβολικό provisioning (cost saving)
- επιτρέπει target optimization για συγκεκριμένο workload

---
##### 5. Indexing & query optimization
Τεκμηρίωση index advisor (preview):
​
[https://learn.microsoft.com/en-us/azure/documentdb/index-advisor](https://learn.microsoft.com/en-us/azure/documentdb/index-advisor) ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/index-advisor?utm_source=chatgpt.com "Tune Query Performance with Index Advisor (Preview)"))
Indexing affects cost/performance πως:
1. Περισσότεροι/dynamic indexes → καλύτερες query latencies αλλά περισσότερα writes (κάθε write πρέπει να indexαριστεί). ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/index-advisor?utm_source=chatgpt.com "Tune Query Performance with Index Advisor (Preview)"))
2. Βελτιστοποίηση index με Index Advisor → προτείνει _ποια index πρέπει να κρατήσεις_ → μειώνει unnecessary index overhead και άρα RUs συνολικά. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/index-advisor?utm_source=chatgpt.com "Tune Query Performance with Index Advisor (Preview)"))
3. Καλύτερες indexes → λιγότερα request units ανά query → μειώνει το throughput που πρέπει να provisionεις. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/index-advisor?utm_source=chatgpt.com "Tune Query Performance with Index Advisor (Preview)"))

---
##### 6. Workload-specific tuning
Γενικές στρατηγικές που επηρεάζουν both performance & cost:
1. Κράτα το working set (δηλαδή hot data + indexes) μέσα στη μνήμη που έχεις διαθέσιμη. Αν μεγάλο working set → disk I/O αυξάνει → throughput/latency χειροτερεύουν → πρέπει να provisionεις περισσότερους πόρους. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/compute-storage?utm_source=chatgpt.com "Compute and Storage Configurations - Azure DocumentDB"))
2. Shadow load testing / controlled benchmarking → επιτρέπει να βλέπεις σε ποια configuration ο workload είναι «sweet spot» performance / cost. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/documentdb/compute-storage?utm_source=chatgpt.com "Compute and Storage Configurations - Azure DocumentDB"))
3. Projecting/λεπτόφιλτρα σε queries αντί για μεγάλες aggregation → λιγότερα IOPS/RUs. (γενική πρακτική, αλλά ισχύει και εδώ). «Rate limiting» docs για Cosmos παρόμοια ιδέα: match client traffic με provisioning. ([Azure Docs](https://docs.azure.cn/en-us/cosmos-db/rate-limiting-requests?utm_source=chatgpt.com "Optimize Your Application Using Rate Limiting"))

---
##### Συμπύκνωση στρατηγικών optimize performance + cost
1. **Right-size compute & storage** ώστε να μην πληρώνεις που δεν χρησιμοποιείς.
2. **Use autoscale** όταν workload έχει spikes για λιγότερο cost & ίδια απόδοση.
3. **Partition design** → lower throttling → less throughput provisioning.
4. **Monitor & tune** → scale only where bottleneck actually υπάρχει.
5. **Index sparingly** → καλύτερο query latency χωρίς overly expensive writes.
6. **Workload tuning** → reduce request units & I/O pressure.

---
## Data model & capabilities
1. Document constraints
    - Max BSON document = 16 MB — σελ. 431
    - Δεν υπάρχει fixed nesting limit — σελ. 431
    - Deep nesting → performance + maintainability issues — σελ. 431
2. Batch writes
    - Max 25 000 writes ανά batch — σελ. 431
    - Αν ξεπεραστεί → batch fails — σελ. 431
3. Index types
    ​
    Υποστηρίζονται — σελ. 1843
    - single field
    - compound
    - multi-key
    - text
    - geospatial
    - vector
4. Index limits
    - max compound fields = 32 — σελ. 484
    - max indexes per collection = 64 default / 300 configurable — σελ. 484
    - μόνο 1 text index per collection — σελ. 485
5. Index build behavior
    - Background indexing async — σελ. 532
    - Unique index build = foreground blocking — σελ. 533
6. Query execution characteristics
    - Sorting γίνεται in-memory — σελ. 484
    - Query memory limit εξαρτάται από tier — σελ. 483
7. Data modeling philosophy
    - Schema-agnostic design για evolving schemas — σελ. 7
    - Designed για unstructured data — σελ. 7
    - Optimized για transactional + analytics + AI workloads — σελ. 9

---

- [What is Azure DocumentDB?](https://learn.microsoft.com/en-us/azure/documentdb/overview)
[[Azure DocumentDB Notes-20260316.pdf]]