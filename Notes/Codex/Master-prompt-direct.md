```text
You are maintaining PR-based engineering documentation for this repository.

Goal:
Analyze the current branch/PR/diff and automatically create or update Obsidian Markdown documentation in the same style as the existing Engineering documentation folder.

Before doing anything, ask me to choose documentation target.

Available documentation paths:
1. D:\Notebooks\Notebook\Notes\Intelligen\Engineering
2. D:\Notebooks\Notebook\Notes\Auth\Projects\RAISE\Engineering
3. D:\Notebooks\Notebook\Notes\Auth\Projects\Accelup\Engineering
4. Custom path

Available documentation tags:
1. documentation/intelligen
2. documentation/raise
3. documentation/accelup
4. Custom tag

Ask me for:
- path option number or custom path
- tag option number or custom tag

If I choose custom path, ask for the full path.
If I choose custom tag, ask for the exact tag.
If I choose a predefined path number, use that path exactly.
If I choose a predefined tag number, use that tag exactly.

Do not assume that path and tag must match.
For example, allow Intelligen path with documentation/raise tag if I explicitly choose that.

Use the provided tag in every created or updated note frontmatter.
Do not hardcode documentation/intelligen.

After I provide the path and tag:

1. Validate the documentation root folder.
2. If it does not exist, ask whether to create it.
3. Ensure this folder structure exists:

PRs/
Domains/
Rules/
TechDebt/

4. Inspect the current git branch / PR / diff using available repository context and git commands.

Use commands if useful:
- git status
- git branch --show-current
- git diff --cached
- git diff
- git log --oneline -n 10

Prefer this diff order:
1. staged changes (git diff --cached)
2. unstaged changes (git diff)
3. current branch vs main/master if no local diff exists

5. Decide whether documentation is needed.

Create or update documentation only if the change includes at least one of:
- business logic change
- domain behavior change
- architectural or structural change
- tricky bug fix
- data consistency risk
- concurrency risk
- security/auth risk
- performance risk
- useful future learning

Skip documentation for:
- formatting-only changes
- cosmetic changes
- trivial renames
- dependency-only updates without behavior impact
- generated files only

6. Use this Obsidian frontmatter style for every created note except PR notes.

For updated notes:
- preserve existing frontmatter
- preserve existing created date
- only set created date for new notes
- ensure the selected documentation tag exists
- ensure the correct topic tag exists
- add updated: <yyyy-mm-dd>

---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: <yyyy-mm-dd>
updated: <yyyy-mm-dd>
product:
component:
tags:
  - <documentation-tag>
  - <topic-tag>
---

Allowed topic tags:
- topic/pr
- topic/domain
- topic/business-logic
- topic/technical-debt

For PR notes only use the following Obsidian frontmatter style:
---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: <yyyy-mm-dd>
source: Codex analysis
pr: <number of PR>
task: <number of task>
tags:
  - topic/pr
  - topic/business-logic
  - topic/domain
---

7. PR note

Create or update:

PRs/PR-<number-or-branch> <short-title>.md

Sanitize filenames:
- replace / \ : * ? " < > | with -
- trim repeated spaces
- keep names Windows-safe


Use this structure:

# PR-<number-or-branch> <short-title>

## Summary
- concise bullets

## Domain Impact
- [[Domain Note]]

## Business Logic Impact
- concise bullets

## Risks
- concise bullets

## Follow-up
- tests
- fixes
- documentation updates

## Diagrams
- link to domain notes that contain diagrams, if any

## Tech Debt
- [[TechDebt Note]]

## Raw Analysis
- optional link, only if raw analysis exists

Before creating any new Domain, Rule, or TechDebt note:

Inspect the existing notes in the corresponding folder.

Match existing notes by:
- exact title
- close semantic match
- singular/plural variants
- acronym/full-name variants
- common naming variations

Examples:
- BOM = Bill of Materials
- Auth = Authentication
- SKU Context = Product Context

Rules:
- prefer updating an existing matching note
- create a new note only when the concept is genuinely new
- avoid duplicate notes with slightly different names
- if uncertain, ask before creating a potentially duplicate note

8. Domain notes

Create or update files under:

Domains/<DomainName>.md

Use this structure:

# <DomainName>

## Overview
Short durable explanation.

## Current Behavior
- concise bullets

## Business Meaning
- only when useful

## Rules
- [[Rule Note]]

## Risks
- [[TechDebt Note]]

## Related PRs
- [[PR-...]]

Add Mermaid diagrams only when they make the behavior easier to understand.
Keep diagram text in English.
Do not create diagrams for trivial changes.

9. Business rule notes

Create or update files under:

Rules/<RuleName>.md

Use this structure:

# <RuleName>

## Current Rule
Clear durable rule.

## Introduced By
- [[PR-...]]

## Modified By
- [[PR-...]] only if updating an existing rule

## Evidence
- files/classes/functions where the rule appears

## Edge Cases
- visible edge cases only

10. Tech debt notes

Create or update files under:

TechDebt/<short-problem-title>.md

Use this structure:

# <Problem Title>

## Found In
- [[PR-...]]

## Problem
Short explanation.

## Risk Level
Low / Medium / High

## Fix Direction
Practical recommendation.

Be skeptical.
Do not create tech debt notes for every imperfection.

11. Index

If Index.md exists in the documentation root, update it.

Keep this structure:

# Engineering Index

## PRs
- [[PR-...]]

## Domains
- [[Domain]]

## Rules
- [[Rule]]

## Tech Debt
- [[TechDebt]]

Rules:
- preserve existing links
- append new links only if missing
- do not duplicate links
- keep links unique
- keep alphabetically sorted where practical

12. Linking rules

From PR notes, link to:
- domain notes
- rule notes
- tech debt notes

From domain/rule/tech debt notes, link back to the PR note.

Use Obsidian wiki links.

Prefer local links like:
[[Materials]]

Avoid absolute vault paths unless the existing folder already uses them.

13. Update rules

When updating existing files:
- preserve existing useful content
- append or adjust only relevant sections
- do not rewrite the whole file unless necessary
- do not delete existing facts unless clearly obsolete
- do not invent facts not visible in the diff
- keep Markdown concise
- keep headings stable

14. Final response

After writing files, report only:

Documentation root:
<path>

Documentation tag:
<tag>

Created:
- ...

Updated:
- ...

Skipped:
- ...

Reason:
- short reason if no documentation was created
```