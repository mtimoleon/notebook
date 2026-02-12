---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2026-02-11T23:37
tags:
  - intelligen
status: completed
product: ScpCloud
---


Use Cases
	1. Export from Desktop -> Import to Cloud - create new
	2. Export from Cloud -> Import to Cloud - create new
	3. Export from Cloud -> Import to Cloud - update current

Entities to export/import
	1. Facility with suites, equipment, labor, staff, storage units
	2. Recipe with RecipeTypes, Branches, 

Serialization behavior
https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/how-to#serialization-behavior

Ξ²β‚¬Ξ† By default, all public properties are serialized. You can specify properties to ignore. You can also include private members.
Ξ²β‚¬Ξ† The default encoder escapes non-ASCII characters, HTML-sensitive characters within the ASCII-range, and characters that must be escaped according to the RFC 8259 JSON spec.
Ξ²β‚¬Ξ† By default, JSON is minified. You can pretty-print the JSON.
Ξ²β‚¬Ξ† By default, casing of JSON names matches the .NET names. You can customize JSON name casing.
Ξ²β‚¬Ξ† By default, circular references are detected and exceptions thrown. You can preserve references and handle circular references.
Ξ²β‚¬Ξ† By default, fields are ignored. You can include fields.

Ξβ€Ξβ‚¬ΞΒ <https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/how-to#serialization-behavior> 


Export will be available for Facility, Materials, Recipe
Have a Dto with recipe and the accompanieng resources (recipe relations)
A relation for equipment will be <facilityName, equipmentName>
ΞΒΞΒ±Ξβ€ΞΒ¬ Ξβ€ΞΞ import ΞΒ½ΞΒ± ΞΞΞΒ¬ΞΒ½ΞΒµΞΞ‰ merge, ΞΞ„ΞΒ·ΞΒ»ΞΒ±ΞΞ„ΞΒ® ΞΒ±ΞΒ½ Ξβ€¦Ξβ‚¬ΞΒ¬ΞΒΞβ€΅ΞΒµΞΞ‰ ΞΞ„ΞΒµΞΒ½ Ξβ€ΞΞ Ξβ‚¬ΞΒµΞΞ‰ΞΒΞΒ¬ΞΒ¶ΞΒµΞΞ‰ ΞΞΞΞ‰ ΞΒ±ΞΒ½ ΞΞ„ΞΒµΞΒ½ Ξβ€¦Ξβ‚¬ΞΒ¬ΞΒΞβ€΅ΞΒµΞΞ‰ Ξβ€ΞΒΞβ€ΞΒµ Ξβ€ΞΞ ΞΒ²ΞΒ¬ΞΒ¶ΞΒµΞΞ‰. ΞΒ Ξβ€΅ ΞΖ’Ξβ€ΞΞ facility ΞΒ±ΞΒ½ Ξβ€¦Ξβ‚¬ΞΒ¬ΞΒΞβ€΅ΞΒµΞΞ‰ Ξβ€ΞΞ equipment ΞΞ„ΞΒµΞΒ½ Ξβ€ΞΞ ΞΒ±ΞΞΞΞΞβ€¦ΞΞΞβ‚¬ΞΒ¬Ξβ€

Things to consider

	1. How to export enumerations

{
"Operations": [
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
	}
]}

Ξ²β‚¬Ξ† Batch
Ξ²β‚¬Ξ† Branch
Ξ²β‚¬Ξ† Campaign
	Ξ²β‚¬Ξ† CampaignOperation
	Ξ²β‚¬Ξ† CampaignOperationEntry

List<OperationStaff> ----> List<ReferenceStaffPath>

ReferenceStaffPath ---------> Staff -------> ReferenceOperationStaff -----> OperationStaf

![[Attachments/Notes/Intelligen/Completed issues/263-Import-Export/263-Import-Export.md/image-1.png]]



