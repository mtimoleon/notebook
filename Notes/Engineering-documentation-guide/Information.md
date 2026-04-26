# Sub Obsidian PR Vault (Lean Version)
​
## Folder Structure
​
```text
Engineering/
  PRs/
  Domains/
  Rules/
  TechDebt/
  Templates/
```
​

---
​
## Template - PR Note
​
```md
# PR-{{number}} {{title}}
​
## Metadata
- Date:
- Author:
- Repo:
- Branch:
- Status:
- Tags: #pr
​
## Summary
​
## Files Changed
​
## Domain Impact
-
​
## Business Logic Impact
-
​
## Risks
-
​
## Tests Needed
-
​
## Follow-up
-
​
## Links
- PR URL:
```
​

---
​
## Template - Domain Note
​
```md
# {{DomainName}}
​
## Description
​
## Related PRs
- [[PR-XXXX]]
​
## Core Rules
-
​
## Pain Points
-
​
## Refactor Ideas
-
```
​

---
​
## Template - Business Rule Note
​
```md
# {{RuleName}}
​
## Current Rule
​
## Introduced By
- [[PR-XXXX]]
​
## Modified By
- [[PR-YYYY]]
​
## Edge Cases
-
```
​

---
​
## Suggested Tags
​
```text
#domain/campaigns
#domain/batches
#domain/general
#risk/concurrency
#risk/performance
#logic/business-rule
#techdebt
#refactor
#breaking-change
```
​

---
​
## Dataview Examples
​
```dataview
TABLE file.name AS PR
FROM "Engineering/PRs"
WHERE contains(file.tags, "#risk/concurrency")
SORT file.name desc
```
​
```dataview
LIST
FROM "Engineering/PRs"
WHERE contains(file.tags, "#techdebt")
```
​
​
​
## Usage Flow
​
### Step 1 - After PR Is Ready
​
Run Prompt 1 on the PR/diff.
​
Create a note only if the PR includes at least one of:
- business logic change
- domain behavior change
- architectural/structural change
- tricky bug fix
- data/concurrency/security risk
- useful future learning
​
Skip notes for cosmetic, formatting, dependency-only, or trivial changes.
​
### Step 2 - Create PR Note
​
Save the result under:
​
```text
Engineering/PRs/PR-<number> <short-title>.md
```
​
### Step 3 - Check Domain Updates
​
Run Prompt 2.
​
If needed, update the relevant note under:
​
```text
Engineering/Domains/<DomainName>.md
```
​
### Step 4 - Check Business Rules
​
Run Prompt 3.
​
If a durable rule changed, create or update:
​
```text
Engineering/Rules/<RuleName>.md
```
​
### Step 5 - Check Tech Debt
​
Run Prompt 4 only for non-trivial PRs.
​
If the issue is worth remembering, create:
​
```text
Engineering/TechDebt/<short-problem-title>.md
```
​
### Step 6 - Cleanup
​
Run Prompt 5 before saving notes if the Codex output is verbose.
​
### Step 7 - Link Everything
​
From the PR note, link to:
- domain notes
- rule notes
- tech debt notes
​
From domain/rule/tech debt notes, link back to the PR note.
​

---
​
## Operating Model
​
- One note per important PR.
- Update domain notes when logic changes.
- Update rule notes when business behavior changes.
- Add tech debt notes when recurring issues appear.
- Keep notes concise and useful.
​
​