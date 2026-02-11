Add
 
```
"SchedulingMode":"FS",
"SchedulingRelation":"AnotherOperation",
"SchedulingReferenceEquipmentName":"Equipment 1",
"SchedulingReferenceProcedureName":"p-1",
"SchedulingReferenceOperationName":"op-1",
"SchedulingReferenceOperationId":"op-1"
```
 
at the end of operation to get the reference another equipment-procedure-operation
    
1. Create custom arrow component
2. Introduce operation id in data json
3. Fix data mapping for arrow creation

FS

SS

SF

FF

SS: always from left 2HL  
FF: always from right 2HL  
FS: dx\>0 2HL else 3HL ---\> rightToLeft  
SF: dx\>0 3HL else 2HL ---\> leftToRight
 
uni

![[Arrows on operations rows - Ink.svg]]
