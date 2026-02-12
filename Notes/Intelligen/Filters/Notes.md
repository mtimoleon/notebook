---
categories:
  - "[[Work]]"
created: 2022-05-02T19:20
tags:
  - intelligen
---

2 types of information  
- the entity to include in query  
- the entity to apply operator  
- the operator applied on entity, eg `operation.startTime\<timestamp`
    ![Exported image](Exported%20image%2020260209140034-2.png)
 
{parameterExpression =\> (Convert(System.Nullable`1[System.DateTime] Date.GetValue(Convert(parameterExpression, Object)), DateTime) == ToDateTime(value(System.Collections.Generic.List`1[System.String]).get_Item(0)))}

{System.Linq.Expressions.Expression1\<System.Func\<Planning.UnitTests.Api.TestObjectDto, bool\>\>}

{parameterExpression =\> (Convert(value(Planning.Api.Helpers.FilterExtension+\<\>c__DisplayClass1_0`1[Planning.UnitTests.Api.TestObjectDto]).property.GetValue(Convert(parameterExpression, Object)), DateTime) == ToDateTime(value(Planning.Api.Helpers.FilterExtension+\<\>c__DisplayClass1_0`1[Planning.UnitTests.Api.TestObjectDto]).rule.Values.get_Item(0)))}

{param =\> (Convert(value(Planning.Api.Helpers.FilterExtension+\<\>c__DisplayClass1_0`1[Planning.UnitTests.Api.TestObjectDto]).property.GetValue(Convert(param, Object)), DateTime) == ToDateTime(value(Planning.Api.Helpers.FilterExtension+\<\>c__DisplayClass1_0`1[Planning.UnitTests.Api.TestObjectDto]).rule.Values.get_Item(0)))}

{param =\> (Convert(System.Nullable`1[System.DateTime] Date.GetValue(Convert(param, Object)), DateTime) == ToDateTime(value(System.Collections.Generic.List`1[System.String]).get_Item(0)))}

![Date Day D ayOfWeek DayOfYear Hour Kind Millisecon...](Exported%20image%2020260209140033-1.png) ![Date Day Dayorvveek DayOffear Hour Kind Millisecon...](Exported%20image%2020260209140031-0.png)   
637895144731387592  
637895144730000000
 
{((Convert(Param_0.DateTime_Column, DateTime).CompareTo(29/05/2022 13:18:39) \>= 0) And (Convert(Param_0.DateTime_Column, DateTime).CompareTo(30/05/2022 13:18:39) \<= 0))}




