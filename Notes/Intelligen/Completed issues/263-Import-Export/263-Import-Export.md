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

β€Ά By default, all public properties are serialized. You can specify properties to ignore. You can also include private members.
β€Ά The default encoder escapes non-ASCII characters, HTML-sensitive characters within the ASCII-range, and characters that must be escaped according to the RFC 8259 JSON spec.
β€Ά By default, JSON is minified. You can pretty-print the JSON.
β€Ά By default, casing of JSON names matches the .NET names. You can customize JSON name casing.
β€Ά By default, circular references are detected and exceptions thrown. You can preserve references and handle circular references.
β€Ά By default, fields are ignored. You can include fields.

Ξ‘Ο€Ο <https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/how-to#serialization-behavior>




Export will be available for Facility, Materials, Recipe
Have a Dto with recipe and the accompanieng resources (recipe relations)
A relation for equipment will be <facilityName, equipmentName>
ΞΞ±Ο„Ξ¬ Ο„ΞΏ import Ξ½Ξ± ΞΊΞ¬Ξ½ΞµΞΉ merge, Ξ΄Ξ·Ξ»Ξ±Ξ΄Ξ® Ξ±Ξ½ Ο…Ο€Ξ¬ΟΟ‡ΞµΞΉ Ξ΄ΞµΞ½ Ο„ΞΏ Ο€ΞµΞΉΟΞ¬Ξ¶ΞµΞΉ ΞΊΞΉ Ξ±Ξ½ Ξ΄ΞµΞ½ Ο…Ο€Ξ¬ΟΟ‡ΞµΞΉ Ο„ΟΟ„Ξµ Ο„ΞΏ Ξ²Ξ¬Ξ¶ΞµΞΉ. Ξ Ο‡ ΟƒΟ„ΞΏ facility Ξ±Ξ½ Ο…Ο€Ξ¬ΟΟ‡ΞµΞΉ Ο„ΞΏ equipment Ξ΄ΞµΞ½ Ο„ΞΏ Ξ±ΞΊΞΏΟ…ΞΌΟ€Ξ¬Ο‚


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

β€Ά Batch
β€Ά Branch
β€Ά Campaign
	β€Ά CampaignOperation
	β€Ά CampaignOperationEntry

List<OperationStaff> ----> List<ReferenceStaffPath>

ReferenceStaffPath ---------> Staff -------> ReferenceOperationStaff -----> OperationStaf

![[image-1 1.png]]






