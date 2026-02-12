# Add a new category (Prompt template)

Purpose: Add a new Obsidian category by creating a category dashboard note, a matching Bases (`.base`) file, and an item template; infer paths and defaults when optional inputs are blank.

---

## INPUT (required)

- Category name: ""
- Item type (singular, for the template name): ""  
  Example: category "Books" → item type "Book" → template `Templates/Book Template.md`
- Properties for items (frontmatter keys you want on each item note):  
  List as `name: type` (one per line). Example:
  - `author: multitext`
  - `year: number`
  - `rating: number`
  - `created: date`
- Base views you want on the category dashboard (one per line):  
  Format: `View name | type: table/cards | sort: <prop> ASC/DESC | columns: a, b, c`

---

## INPUT (optional — leave blank to infer)

- Category index note path (default: `Categories/<Category name>.md`): ""
- Base filename (default: `Templates/Bases/<Category name>.base`): ""
- Embed base in category note? (default: yes): yes/no
- Add `tags: [categories]` to category note? (default: yes): yes/no
- Exclude templates from the base results? (default: yes): yes/no
- Template filename (default: `Templates/<Item type> Template.md`): ""
- Where new item notes should be stored (default: `References/` if it exists, else `Notes/`, else vault root): ""
- Default tags for new items (default: none): ""
- Create a sample item note? (default: no): yes/no  
  If yes: sample note name (default: `<Item type> Example`): ""
- Update `.obsidian/types.json`? (default: yes if you introduced new properties): yes/no
- Similar existing category to copy conventions from (default: none): ""

---

## ASSISTANT INSTRUCTIONS (follow these exactly)

You are implementing a new category in an Obsidian vault that uses:
- `Categories/<Category>.md` as category “dashboard” notes.
- `Templates/<Thing> Template.md` as note templates that set frontmatter properties.
- `Templates/Bases/<Name>.base` as “Bases” definitions used via embeds like `![[Name.base]]`.

### 0) Validate vault conventions (read first, don’t guess)

Before editing, read these files if present and adapt paths accordingly:
- `.obsidian/templates.json` (Templates plugin folder path).
- `.obsidian/core-plugins.json` (confirm `bases` and `templates` are enabled; if not, still create files but note it).
- `.obsidian/types.json` (property type mappings; if missing, skip the TYPES step).

If the vault does not have `Categories/`, `Templates/`, or `Templates/Bases/`, ask the user whether to create them or to use the vault’s existing folders.

### Default inference rules (use these when optional input is blank)

- `Category link target` is `[[<Category name>]]`.
- Category index note path: `Categories/<Category name>.md`
- Base filename: `Templates/Bases/<Category name>.base`
- Template filename: `Templates/<Item type> Template.md`
- Category note settings:
  - Embed base: **yes**
  - Add tag `categories`: **yes**
- Base filter settings:
  - Require: `categories.contains(link("<Category name>"))`
  - Exclude templates by name containing `Template`: **yes**
- New item note folder preference:
  1) `References/` if it exists
  2) else `Notes/` if it exists
  3) else vault root
- Update `.obsidian/types.json`: **yes** if there are new properties not already typed; otherwise **no** changes.

If `Item type (singular)` is missing, infer it as:
- If category ends with `s`, use category name without the trailing `s` (e.g., `Books` → `Book`).
- Otherwise, use the category name as-is.

### 1) Create the category dashboard note

Create `Categories/<CategoryName>.md` with:
- Frontmatter:
  - If enabled: `tags: [categories]`
- Body:
  - If enabled: embed the base exactly as `![[<BaseName>.base]]`

Rules:
- The wiki link name in the filter must match the category link target. If the category is `[[Books]]`, the base filter must use `link("Books")`.
- Keep the file minimal (match existing category note style if a similar category was provided).

### 2) Create the Base file in `Templates/Bases/`

Create `Templates/Bases/<BaseName>.base` with:
- A top-level `filters:` section implementing the user’s chosen patterns, typically:
  - `categories.contains(link("<CategoryName>"))`
  - And optionally: `!file.name.contains("Template")`
- `properties:` mappings (optional but recommended) to set `displayName` for columns used in views.
- `views:` list implementing the views the user specified.

Rules:
- Use the same conventions as existing `.base` files in the repo (YAML-like structure).
- Prefer `note.<property>` in `properties:` when the column refers to a frontmatter property, and `file.<field>` for file metadata.
- If you add a view that filters by the current page (facet), use `list(<property>).contains(this)` when appropriate.

### 3) Create the Template for new items

Create `Templates/<Category> Template.md` that includes YAML frontmatter with:
- `categories: ["[[<CategoryName>]]"]` (or the same style used by existing templates in the vault).
- Any additional properties the user specified, with sensible empty defaults:
  - lists as `[]`, strings as empty, numbers blank, dates blank or `{{date}}` if the user wants creation timestamps.
- Any default tags the user specified.

Rules:
- Match the style of existing templates in the vault (frontmatter key casing, list formatting, quoting).
- Do not invent properties the user didn’t request.

### 4) Update `.obsidian/types.json` (only if requested)

If the user answered “yes”:
- Add new property type entries under `.types` for any new properties introduced by the template/base that are not already present.
- Use Obsidian types used by the vault: `text`, `number`, `date`, `multitext`, `tags`.

Rules:
- Do not remove or rename existing types.
- Keep JSON formatting consistent with the file.

### 5) Optional: create a sample note (only if requested)

If the user asked for a sample note:
- Create it in the folder they specified (e.g., `References/` or `Notes/`).
- Use the new template’s frontmatter as a starting point and fill only the minimum needed to validate the Base filter (at least `categories: [[<CategoryName>]]`).

### 6) Output requirements

At the end, report:
- Which files were created/modified (paths only).
- Any assumptions made (e.g., missing plugins config files).
- Any follow-up the user must do in Obsidian UI (e.g., ensure Bases plugin enabled).
