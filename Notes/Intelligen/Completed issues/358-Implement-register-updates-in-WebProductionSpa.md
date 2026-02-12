---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-05-14T10:22
tags:
  - intelligen
status: completed
product: ScpCloud
---

- [x] ΞΞ± Ξ΄Ο‰ Ο„ΞΏ ct Ξ³ΞΉΞ± Ο„ΞΏ operation entry ΞΊΞ±ΞΉ batch , trackingupdate ct, se ΞΊΞ±Ο€ΞΏΞΉΞ± Ξ΄Ο„ΞΏ Ο€ΟΞ­Ο€ΞµΞΉ Ξ½Ξ± ΞΊΞ±Ο„Ξ±ΟΞ³Ξ·ΞΈΞΏΟΞ½  
	- [x] ConcurrencyToken in EocBatchDto in EocDataTrackingDto from GetSchedulingBoardEoctDataTracking  
	- [x] ConcurrencyToken in TrackingOperationEntryDto from GetTrackingOperationEntryPanelById  
	- [x] BatchConcurrencyToken in TrackingOperationEntryDto from GetTrackingOperationEntryPanelById
 
- [x] Ξ‘Ξ»Ξ»Ξ¬Ξ¶Ο‰ Ξ­Ξ½Ξ± operation entry Ξ±Ο€Ο Ο„ΞΏ production Ξ±Ξ»Ξ»Ξ±Ξ¶ΞµΞΉ ΟƒΟ„ΞΏ Ο€Ξ»Ξ±Ξ½Ξ½ΞΉΞ³ΞΊ Ξ±Ξ»Ξ»Ξ¬ den kanei sync sto production.
 
- [x]

```
varΒ metadataΒ =Β newΒ Metadata
{
Β Β Β Β Β Β Β Β newΒ Metadata.Entry("schedulingboardid",Β schedulingBoardId.ToString())
};
varΒ callOptionsΒ =Β newΒ CallOptions(metadata);
varΒ callContextΒ =Β newΒ CallContext(callOptions);
```
 
- [x] Rename, remove tracking from url

![Exported image](Exported%20image%2020260209135807-0.png)  

- [x] TrackingUpdateConcurrencyToken Ξ½Ξ± Ξ³Ξ―Ξ½ΞµΞΉ ConcurrencyToken







