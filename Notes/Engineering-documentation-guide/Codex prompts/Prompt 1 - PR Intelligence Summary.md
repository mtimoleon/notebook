
```
Analyze the current PR/diff and produce a concise Obsidian([developers.openai.com](https://developers.openai.com/codex/integrations/github?utm_source=chatgpt.com)) only Markdown using this structure:
​
### PR-<number> <short-title>
​
#### Summary
- 3-5 bullets explaining what changed and why.
​
#### Files Changed
- Group files by area/module.
- Mention only files that matter for understanding the change.
​
#### Domain Impact
- Which domain/module/use case is affected?
- What behavior changed?
​
#### Business Logic Impact
- List actual rule/flow/validation changes.
- If no business logic changed, write: None.
​
#### Risks
- Runtime risks.
- Data consistency risks.
- Performance risks.
- Security/auth risks.
- Edge cases.
​
#### Follow-up
- Tests needed.
- Refactor candidates.
- Documentation updates.
​
#### Suggested Links
- Domain notes to update.
- Rule notes to update.
- TechDebt notes to create.
​
Keep it short. Do not invent information not visible in the diff.

```