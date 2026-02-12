---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-02-11T16:39
tags:
  - intelligen
status: completed
product: ScpCloud
---

- [x] Add authentication/authorization  
- [x] Create grpc infrastructure in production api  
- [x] Create endpoint in planning bff to export a list of campaigns to production  
	- [x] Create UI functionality  
	- [x] procedure entry main equipment, export not only path but additional info for production  
	- [x] Check how to test this  
- [x] Write exported campaigns to mongo  
	Use 2 collections, one for archiving and the other for production  
	Consider using a time stamp for archiving versions
   
	![Exported image](Exported%20image%2020260209135834-0.png)  

- [x] Add mediator  
- [x] Add transaction behavior  
- [x] From campaign export  
		Batches id, name, ProcedureEntries  
		ProcedureEntries: id, name, main equipment pool, OperationEntries  
		OperationEntries: id, name, aux equipment pool, staff  
- [x] Move command status to common project  
- [x] Production automapper to map dto to models
 
- [x] Move Request info provider interface to common
 
- [x] Consider multi tenancy  
		database per workspace  
		what if tenants \> 100  
- [x] Remove where scheduled campaigns from query to get campaigns to publish  
- [x] CreatedAt =\> PublishedAt  
- [ ] Grpc error "Status(StatusCode=\"ResourceExhausted\", Detail=\"Received message exceeds the maximum configured message size.\")"
 
- [x] CrossService.FunctionalTests, move publishing tests there  
- [x] Add EOC data into published campaign  
- [x] In chartdto conflict check suite name removal in **EocChartEquipmentDto** and **ChartAuxEquipmentDto**
 
- [x] Move ChartDto back where it was, keep the changes of ctors  
- [x] Publish batches not campaigns (latest-batches, archived-batches)  
- [ ] Find a way to have eoc data per batch but have equipment total conflicts and outages in root level somehow

![[294-Export-campaign-to-production - Ink.svg|788x1142]]


![Exported image](Exported%20image%2020260209135838-1.png)








