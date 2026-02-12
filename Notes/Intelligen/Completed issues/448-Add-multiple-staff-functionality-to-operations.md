---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-09-30T10:18
tags:
  - intelligen
status: completed
product: ScpCloud
---

![|733x333](Exported%20image%2020260209135710-0.png)

![Exported image](Exported%20image%2020260209135712-1.png)

![Exported image](Exported%20image%2020260209135713-2.png)  

- [x] na stelnei kai to sourceStaffId  
- [x] na rename to stafId se destinationStaffId

β”οΈChartService 982  
β”οΈOperationBase UpdateStaff  
β”οΈChartsDto 314  
β”οΈOperationDto 602  
β”οΈOperationEntryDto  
β”οΈMoveStaffOperationEntryCommandHandler  
β”οΈOperationEntry UpdateStaff/ReplaceStaff  
UpdateOperationEntryStaffCommandHandler  
β”οΈUpdate eoc staff pool calculation
 
β”οΈ==planning/25/operation-base/operation/4967/update-staff==  

```
{
  "concurrencyToken": 191544,
  "id": 4967,
  "staffPool": [
    {
      "OperationId": 4967,
      "StaffId": 130
    },
    {
      "OperationId": 4967,
      "StaffId": 131
    },
    {
      "OperationId": 4967,
      "StaffId": 133
    },
    {
      "OperationId": 4967,
      "StaffId": 135
    }
  ],
  "useAllPersons": false
}
```
 
β”οΈ==planning/25/operation-entry/19967/staff-move?returnEocData=true== Ξ’Ξ³Ξ¬Ξ¶Ο‰ Ξ±Ο€Ο Ο„Ξ± staff Ο„ΞΏ id(row) Ο€ΞΏΟ… Ξ®Ο„Ξ±Ξ½ ΞΊΞ±ΞΉ Ξ²Ξ¬Ξ¶Ο‰ Ο„ΞΏ id Ο„ΞΏΟ… staff row Ο€ΞΏΟ… Ο€Ξ®Ξ³Ξµ  
{
"schedulingBoardId": 25,
"schedulingBoardConcurrencyToken": 191440,
"id": 19967,<font color="#ff0000">--\> OperationEntryId</font>
<mark style="background:#d3f8b6">"currentStaffId":</mark>\<int\>
"staffId": 135, <font color="#ff0000">--\> The new staff id that is assigned to operation (the new staff row where the bar is dropped)</font>
"start": "2022-01-01T17:16:14.160Z"
}

 
β”οΈ==planning/25/operation-entry/19934/update-staff==  

```
{
  "schedulingBoardId": 25,
  "schedulingBoardConcurrencyToken": 191577,
  "id": 19934,
  "staffIds": [
    130,
    133,
    134
  ]
}
```
   
![Exported image](Exported%20image%2020260209135714-3.png) ![Exported image](Exported%20image%2020260209135716-4.png)   
- [x] To remove UseAllPersons  
- [ ] Check what happens to production with the introduced operation entry changes




