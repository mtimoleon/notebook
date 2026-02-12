---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-03-26T12:38
tags:
  - intelligen
status: completed
product: ScpCloud
---

- From planning spa we publish scheduling board 

- [x] ProductionGrpc.GetLatestBatchesInfo kai to production epistrefei ta batches toy scheduling board.
	- id, start, end, concurrency token
- [x] Planning prepares data to publish to production  
	Gia concurrency token poy den yparxei sto scheduling board ta svino sto production  
	Gia concurrencty token poy allaxe vgazo olo  
	Gia ta concurrency token poy den exoyn allaxei stelnei mono ta eocdata gia batches poy exoyn lower priority (precedence)  
- [x] planning api calls production grpc and passes the publish dto (partialy done)  
	the publish dto contains 2 properties  
			a: the batch ids to be deleted  
			b: the batches which contains data and eoc chart data  
				some batches may have only data and eocChartData and some only eocChartData  
		- [x] Prepei na allaxo ta publish data  
			Lista me id ton batches poy prepei na svistoyn  
			Lista me batches poy prepei na ginoyn updated (replace)  
		- [x] Then in production kano update i replace analoga
      

The planning data change when we press the sync button in planning application

![[321-Sync planning scheduling board with production - Ink.svg|454x264]]

![[image-11.png]]


- [x] Sync enforceEocDataUpdate sto SyncSchedulingBoardAsync(RequestByIdDto requestByIdDto, CallContext context = default)  
- [x] Dyo listes loop ti mia prota pernao ta batches  
- [x] Unify batchesToAdd with batchesToReplace as batchesToPublish

![[image-12.png]]

- [x] Na to pao schedulingboard commands

![Exported image](Exported%20image%2020260209135827-0.png)







