---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
tags:
  - intelligen
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