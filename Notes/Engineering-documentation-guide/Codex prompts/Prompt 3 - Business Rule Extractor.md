
​
```text
Inspect this PR/diff and extract business rules only.
​
Return only Markdown using this structure:
​
## Business Rules
​
### <RuleName>
​
## Rule
- State the current rule clearly.
​
## Introduced Or Changed By
- [[PR-<number> <title>]]
​
## Evidence
- Mention the files/classes/functions where the rule appears.
​
## Edge Cases
-
​
## Suggested Rule Note
- Create new rule note: Yes/No
- Update existing rule note: Yes/No
​
If no business rule changed, return:
​No business rule change detected.
​Do not include technical implementation details unless they affect the rule.

```
