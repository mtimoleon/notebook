---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2024-01-25T10:05
tags:
  - intelligen
product: ScpCloud
---

Backup
 
|                     |               |
| ------------------- | ------------- |
| Value objects       | shallow copy  |
| Primitive types     | new           |
| Lists (IManyToMany) | new items     |
| ==Lists (Other)==   | ==new items== |
| Other classes       | copy ref      |
 
Copy From
 
|   |   |
|---|---|
|Value objects|shallow copy|
|Primitive types|new|
|Lists (IManyToMany)|new items|
|==Lists (Other)==|==copyFrom==|
|Other classes|copy ref|




