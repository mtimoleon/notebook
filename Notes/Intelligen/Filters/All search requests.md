---
categories:
  - "[[Work]]"
created: 2022-06-03T22:18
tags:
  - intelligen
---

RequestFilterOrderDto  
public FilterOrderDto FilterOrderDto { get; set; }  
public int? Offset { get; set; }  
public int? Limit { get; set; }
 
RequestByIdFilterOrderDto  
public int ParentId { get; set; }  
public FilterOrderDto FilterOrderDto { get; set; }  
public int? Offset { get; set; }  
public int? Limit { get; set; }
 
RequestByIdParentChildDto  
public int ParentId { get; set; }  
public int ChildId { get; set; }  
public ulong ChildConcurrencyToken { get; set; }
 
RequestByIdDto  
public int Id { get; set; }  
public ulong ConcurrencyToken { get; set; }
   

EquipmentSearchRequest  
public string SearchString { get; set; }  
public List\<int\> ExcludeIds { get; set; } = new();  
public int? Offset { get; set; }  
public int? Limit { get; set; }
 
EquipmentTypeSearchRequestDto  
public string SearchString { get; set; }  
public int? Offset { get; set; }  
public int? Limit { get; set; }  
public List\<int\> ExcludeIds { get; set; } = new();
 
FacilitySearchRequest  
public string SearchString { get; set; }  
public int? Offset { get; set; }  
public int? Limit { get; set; }
 
StaffSearchRequest  
public int FacilityId { get; set; }
 
SuiteSearchRequest  
public int FacilityId { get; set; }  
public string SearchString { get; set; }  
public int? Offset { get; set; }  
public int? Limit { get; set; }




