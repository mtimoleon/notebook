#### Use Cases

	1. Export from Desktop ->; Import to Cloud - create new  
    2. Export from Cloud ->; Import to Cloud - create new  
    3. Export from Cloud ->; Import to Cloud - update current
1. 
#### Entities to export/import  
    1. Facility with suites, equipment, labor, staff, storage units  
    2. Recipe with RecipeTypes, Branches,
1. 
#### Serialization behavior
[https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/how-to#serialization-behavior](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/how-to#serialization-behavior)

- By default, all public properties are serialized. You can [specify properties to ignore](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/ignore-properties). You can also include <a href="https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/immutability#non-public-members-and-property-accessors">private members</a>.
- The [default encoder](https://learn.microsoft.com/en-us/dotnet/api/system.text.encodings.web.javascriptencoder.default#system-text-encodings-web-javascriptencoder-default) escapes non-ASCII characters, HTML-sensitive characters within the ASCII-range, and characters that must be escaped according to <a href="https://tools.ietf.org/html/rfc8259#section-7">the RFC 8259 JSON spec</a>.- By default, JSON is minified. You can [pretty-print the JSON](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/how-to#serialize-to-formatted-json).
- By default, casing of JSON names matches the .NET names. You can [customize JSON name casing](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/customize-properties).- By default, circular references are detected and exceptions thrown. You can [preserve references and handle circular references](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/preserve-references).- By default, [fields](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/fields) are ignored. You can <a href="https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/fields">include fields</a>.*Από \<[https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/how-to#serialization-behavior](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/how-to#serialization-behavior)&gt;*[x] Export will be available for Facility, Materials, Recipe[x] Have a Dto with recipe and the accompanieng resources (recipe relations)[x] A relation for equipment will be \<facilityName, equipmentName&gt;[x] Κατά το import να κάνει merge, δηλαδή αν υπάρχει δεν το πειράζει κι αν δεν υπάρχει τότε το βάζει. Πχ στο facility αν υπάρχει το equipment δεν το ακουμπάςThings to consider  
    1. How to export enumerations{"Operations": \[  
    {  
        "SchedulingMode" : "\"1 Planning.Domain.Enumerations.OperationSchedulingMode\"",  
        "DurationMode" : "\"1 Planning.Domain.Enumerations.OperationDurationMode\"",  
        "DurationUnit" : "\"2 Planning.Domain.Enumerations.TimeUnit\"",  
        "ConstantDuration" : "{\"Unit\":\"2 Planning.Domain.Enumerations.TimeUnit\",\"ReferenceUnitValue\":1800}",  
        "FlowBasis" : "{\"Basis\":\"7 Planning.Domain.Enumerations.PhysicalQuantity\"}",  
        "AmountProcessed" : "{\"Unit\":\"3 Planning.Domain.Enumerations.MassUnit\",\"ReferenceUnitValue\":0}",  
        "ProcessingRate" : "{\"Unit\":\"7 Planning.Domain.Enumerations.MassFlowUnit\",\"ReferenceUnitValue\":0}",  
        "RateType" : "\"1 Planning.Domain.Enumerations.OperationRateType\"",  
        "FixedTimeShift" : "{\"Unit\":\"3 Planning.Domain.Enumerations.TimeUnit\",\"ReferenceUnitValue\":0}"  
    }]}- Batch- Branch- Campaign  
    - CampaignOperation  
    - CampaignOperationEntryList\<OperationStaff&gt; ----&gt; List\<ReferenceStaffPath&gt;ReferenceStaffPath ---------&gt; Staff -------&gt; ReferenceOperationStaff -----&gt; OperationStaf
