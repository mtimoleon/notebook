---
categories:
  - "[[Work]]"
created: 2026-03-17
product: scpCloud
component: DocumentDB
status: completed
tags:
  - issues/intelligen
---
## Context
After model rename we need to update previous documents fields names in archived-batches and latest-batches collections.
## Notes

Fields that need to change name:
- EocResourceData ChartOperationEntryTask
- EocResourceData ChartProcedureEntryTask
- OperationEntry
- ProcedureEntry

OrderNo -> OrderNumber

```
latest-batches.BatchContentsPlanning.ProcedureEntries.$[].OperationEntries.$[].OrderNo
latest-batches.BatchContentsTracking.ProcedureEntries.$[].OperationEntries.$[].OrderNo
archived-batches.BatchContentsPlanning.ProcedureEntries.$[].OperationEntries.$[].OrderNo
archived-batches.BatchContentsTracking.ProcedureEntries.$[].OperationEntries.$[].OrderNo
```

Για τα παρακάτω 4 renames:

TimingStatusId -> CompletionStatusId
​TimingStatusName -> CompletionStatusName
​InferredTimingStatusId -> InferredCompletionStatusId
​InferredTimingStatusName -> InferredCompletionStatusName

```
{latest-batches|archived-batches}.BatchContentsPlanning.ProcedureEntries.$[].TimingStatusId
{latest-batches|archived-batches}.BatchContentsTracking.ProcedureEntries.$[].TimingStatusId
{latest-batches|archived-batches}.BatchContentsPlanning.ProcedureEntries.$[].OperationEntries.$[].TimingStatusId
{latest-batches|archived-batches}.BatchContentsTracking.ProcedureEntries.$[].OperationEntries.$[].TimingStatusId
{latest-batches|archived-batches}.EocResourceDataPlanning.Equipment.$[].OpEntryTasks.$[].TimingStatusId
{latest-batches|archived-batches}.EocResourceDataTracking.Equipment.$[].OpEntryTasks.$[].TimingStatusId
{latest-batches|archived-batches}.EocResourceDataPlanning.Staff.$[].OpEntryTasks.$[].TimingStatusId
{latest-batches|archived-batches}.EocResourceDataTracking.Staff.$[].OpEntryTasks.$[].TimingStatusId
{latest-batches|archived-batches}.EocResourceDataPlanning.Equipment.$[].ProcEntryTasks.$[].TimingStatusId
{latest-batches|archived-batches}.EocResourceDataTracking.Equipment.$[].ProcEntryTasks.$[].TimingStatusId
{latest-batches|archived-batches}.EocResourceDataPlanning.Equipment.$[].ProcEntryTasks.$[].OpEntryTasks.$[].TimingStatusId
{latest-batches|archived-batches}.EocResourceDataTracking.Equipment.$[].ProcEntryTasks.$[].OpEntryTasks.$[].TimingStatusId
```


`mongosh "<connection-string>" --file "d:\develop-tasks\544-Rename-TimingStatus-to-CompletionStatus\rename-fields.js"`

```js
function runRenameFields(options = {}) {
  function hasOwnProperty(obj, key) {
    return Object.prototype.hasOwnProperty.call(obj, key);
  }
  function isObject(value) {
    return value !== null && typeof value === "object" && !Array.isArray(value);
  }
  function getDryRunOption(value) {
    if (!isObject(value)) {
      throw new Error("runRenameFields expects an object: runRenameFields({ dryRun: true | false })");
    }
    if (!hasOwnProperty(value, "dryRun")) {
      return true;
    }
    if (typeof value.dryRun !== "boolean") {
      throw new Error("dryRun must be a boolean");
    }
    return value.dryRun;
  }
  const dryRun = getDryRunOption(options);
  const excludedDatabases = ["admin", "config", "local"];
  const targetCollections = ["archived-batches", "latest-batches"];
  const commonRenames = {
    TimingStatusId: "CompletionStatusId",
    TimingStatusName: "CompletionStatusName",
    InferredTimingStatusId: "InferredCompletionStatusId",
    InferredTimingStatusName: "InferredCompletionStatusName"
  };
  const renamePaths = [
    "BatchContentsPlanning.ProcedureEntries[].OperationEntries[]",
    "BatchContentsTracking.ProcedureEntries[].OperationEntries[]",
    "BatchContentsPlanning.ProcedureEntries[]",
    "BatchContentsTracking.ProcedureEntries[]",
    "EocResourceDataPlanning.Equipment[].OpEntryTasks[]",
    "EocResourceDataTracking.Equipment[].OpEntryTasks[]",
    "EocResourceDataPlanning.Staff[].OpEntryTasks[]",
    "EocResourceDataTracking.Staff[].OpEntryTasks[]",
    "EocResourceDataPlanning.Equipment[].ProcEntryTasks[]",
    "EocResourceDataTracking.Equipment[].ProcEntryTasks[]",
    "EocResourceDataPlanning.Equipment[].ProcEntryTasks[].OpEntryTasks[]",
    "EocResourceDataTracking.Equipment[].ProcEntryTasks[].OpEntryTasks[]"
  ];
  function renameFields(node, renames) {
    if (!isObject(node)) {
      return false;
    }
    let changed = false;
    for (const [oldName, newName] of Object.entries(renames)) {
      if (!hasOwnProperty(node, oldName)) {
        continue;
      }
      if (!hasOwnProperty(node, newName)) {
        node[newName] = node[oldName];
      }
      delete node[oldName];
      changed = true;
    }
    return changed;
  }
  function renameFieldsAtPath(currentValue, remainingSegments, renames) {
    if (remainingSegments.length === 0) {
      return renameFields(currentValue, renames);
    }
    if (!isObject(currentValue)) {
      return false;
    }
    const [currentSegment, ...nextSegments] = remainingSegments;
    const segmentPointsToArray = currentSegment.endsWith("[]");
    const propertyName = segmentPointsToArray ? currentSegment.slice(0, -2) : currentSegment;
    if (!hasOwnProperty(currentValue, propertyName)) {
      return false;
    }
    const nextValue = currentValue[propertyName];
    if (!segmentPointsToArray) {
      return renameFieldsAtPath(nextValue, nextSegments, renames);
    }
    if (!Array.isArray(nextValue)) {
      return false;
    }
    let changed = false;
    for (const item of nextValue) {
      changed = renameFieldsAtPath(item, nextSegments, renames) || changed;
    }
    return changed;
  }
  function buildFilter(paths, renames) {
    const orFilters = [];
    for (const path of paths) {
      const basePath = path.replaceAll("[]", "");
      for (const oldName of Object.keys(renames)) {
        orFilters.push({
          [`${basePath}.${oldName}`]: { $exists: true }
        });
      }
    }
    return { $or: orFilters };
  }
  const filter = buildFilter(renamePaths, commonRenames);
  const databases = db.adminCommand({ listDatabases: 1, nameOnly: true }).databases;
  const summary = [];
  print(`dryRun: ${dryRun}`);
  for (const databaseInfo of databases) {
    const dbName = databaseInfo.name;
    if (excludedDatabases.includes(dbName)) {
      print(`Skipping database: ${dbName}`);
      continue;
    }
    const targetDb = db.getSiblingDB(dbName);
    print(`\nDatabase: ${dbName}`);
    for (const collectionName of targetCollections) {
      if (!targetDb.getCollectionNames().includes(collectionName)) {
        print(`  Collection: ${collectionName} -> not found`);
        continue;
      }
      const collection = targetDb.getCollection(collectionName);
      const matched = collection.countDocuments(filter);
      if (matched === 0) {
        print(`  Collection: ${collectionName} -> no matching documents`);
        continue;
      }
      print(`  Collection: ${collectionName} -> matched: ${matched}`);
      let processed = 0;
      let modified = 0;
      collection.find(filter).forEach(doc => {
        processed += 1;
        let changed = false;
        for (const path of renamePaths) {
          changed = renameFieldsAtPath(doc, path.split("."), commonRenames) || changed;
        }
        if (!changed) {
          return;
        }
        modified += 1;
        if (!dryRun) {
          collection.replaceOne({ _id: doc._id }, doc);
        }
      });
      summary.push({ dbName, collectionName, matched, processed, modified });
      if (dryRun) {
        print(`    dryRun enabled, documents that would change: ${modified}/${processed}`);
        continue;
      }
      print(`    modified: ${modified}`);
    }
  }
  return summary;
}
print("runRenameFields loaded. Example: runRenameFields({ dryRun: true })");
​
```

Cannot use $rename function because it does not support array elements.
Check ==important notice== in the following article:
[Rename a filed in Azure DocumentDB](https://learn.microsoft.com/en-us/azure/documentdb/operators/field-update/%24rename)

## Links

[[Update DocumentDB documents from shell]]
