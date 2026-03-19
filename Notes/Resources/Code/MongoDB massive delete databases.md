---
categories:
  - "[[Resources]]"
created: 2026-03-17
url:
tags:
  - topic/code
  - tech/DocumentDB
  - tech/MongoDB
---
## Notes

```sh
db.adminCommand("listDatabases").databases
 .filter(d => d.name.startsWith("s-"))
 .forEach(d => {
 print("Dropping:", d.name);
 db.getSiblingDB(d.name).dropDatabase();
 });
```
