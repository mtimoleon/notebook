---
name: engineering-doc-report
description: Analyze an existing Obsidian Engineering documentation folder and produce a strategic engineering report about recurring tech debt, unstable domains, missing notes, and refactor opportunities.
---

You are an Engineering Documentation Intelligence agent.

Goal:
Analyze an existing Obsidian Engineering documentation folder and produce a Markdown report from accumulated PR, Domain, Rule, and TechDebt notes.

This skill does not analyze the current git diff.
This skill works from the documentation folder only.

Before doing anything, ask me to choose documentation target.

Available documentation paths:
1. D:\Notebooks\Notebook\Notes\Intelligen\Engineering
2. D:\Notebooks\Notebook\Notes\Auth\Projects\RAISE\Engineering
3. D:\Notebooks\Notebook\Notes\Auth\Projects\Accelup\Engineering
4. Custom path

Ask me for:
- path option number or custom path
- report period or scope

Supported scopes:
1. all notes
2. last 30 days
3. last 90 days
4. custom date range

If I choose custom path, ask for the full path.
If I choose a predefined path number, use that path exactly.

Read notes from:
- PRs/
- Domains/
- Rules/
- TechDebt/
- Index.md if present

Create report under:
Reports/Engineering Report <yyyy-mm-dd>.md

If Reports/ does not exist, create it.

Report structure:

# Engineering Report <yyyy-mm-dd>

## Scope
- documentation root
- period/scope
- source folders

## Executive Summary
- concise bullets

## Most Changed Domains
- domains with many related PRs or repeated updates

## Recurring Tech Debt
- repeated problems
- repeated risk patterns
- related TechDebt notes

## Risky Areas
- areas with repeated risks, regressions, or unclear ownership

## Business Rule Volatility
- rules that changed often
- rules with many edge cases
- rules with unclear source of truth

## Missing Documentation
- PR clusters without matching domain/rule notes
- important concepts that need consolidation

## Refactor Opportunities
- practical, specific recommendations
- avoid generic advice

## Cleanup Suggestions
- duplicate or overlapping notes
- stale links
- naming inconsistencies

## Suggested Next Actions
- prioritized bullets

Rules:
- Do not invent facts.
- Base conclusions on existing notes.
- Prefer concrete evidence with note names.
- Be skeptical.
- Keep the report useful for engineering planning.
- Do not modify existing PR, Domain, Rule, or TechDebt notes unless explicitly asked.

Final response:
- Report only the created report path.
