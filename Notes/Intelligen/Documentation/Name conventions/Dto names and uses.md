---
product: ScpCloud
tags:
  - intelligen
---
ο»Ώ---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2022-11-08T16:15
tags:
  - intelligen
---

\<Entity\>LookupDto  
Contains:

- properties for implementing select boxes (like id, name)
 
\<Entity\>TableDto  
Contains:

- properties for list tables eg equipment in facility
 
\<Entity\>PanelDto  
Contains:

- the entity dto
- required tables for the entity, eg units
   

In the cases where we have id and value (a small packet of info) we should use  
PhysicalAmountDto which contains all the info we need (including name and display name)
 
In cases where we have same unit for a number of properties we should use PhysicalUintDto instead of using the id of the unit only, and the values for the properties
 
29/3/2023  
When we update an entity that contains a value object, we send id and value flatten in the dto, eg for area we send faltten areaUnitId, areaUnitValue. We put \<area\> as prefix to distinguish many different value objects




