#!/usr/bin/env bash
set -euo pipefail

#
# Find orphan attachments in an Obsidian vault.
# "Orphan" = a file under Attachments/ that is not referenced by any note/template.
#
# Requirements: bash + find + rg (ripgrep) + sort + uniq + grep + sed + awk
#
# Quick runs:
#   1) Dry-run (safe): prints summary + writes report, no file changes
#      bash Tools/find-orphan-attachments.sh --whatif
#
#   2) Report only: same as --whatif (no changes), writes report file
#      bash Tools/find-orphan-attachments.sh
#
#   3) Move (recommended): moves orphans to Attachments/_orphaned/YYYY-MM-DD/... (keeps structure)
#      bash Tools/find-orphan-attachments.sh --move
#

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

find_vault_root() {
  local start="$1"
  local cur="$start"
  local i=0
  while [[ $i -lt 10 ]]; do
    if [[ -d "$cur/Attachments" && -d "$cur/.obsidian" ]]; then
      printf '%s' "$cur"
      return 0
    fi
    local parent
    parent="$(cd "$cur/.." && pwd)"
    [[ "$parent" == "$cur" ]] && break
    cur="$parent"
    i=$((i+1))
  done
  return 1
}

default_vault_root="$(cd "$script_dir/.." && pwd)"
if vault_detected="$(find_vault_root "$default_vault_root" 2>/dev/null)"; then
  default_vault_root="$vault_detected"
fi

vault_root="${VAULT_ROOT:-$default_vault_root}"
attachments_root="${ATTACHMENTS_ROOT:-Attachments}"
move_to="${MOVE_TO:-Attachments/_orphaned}"

action="report" # report | move | delete
whatif="false"
verbose="false"

usage() {
  cat <<'EOF'
Usage:
  bash Tools/find-orphan-attachments.sh [--whatif] [--move|--delete] [--verbose]

Env vars:
  VAULT_ROOT         Default: current directory
  ATTACHMENTS_ROOT   Default: Attachments
  MOVE_TO            Default: Attachments/_orphaned
EOF
}

log() {
  if [[ "$verbose" == "true" ]]; then
    printf '[%(%H:%M:%S)T] %s\n' -1 "$1"
  fi
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing dependency: $cmd" >&2
    exit 127
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --whatif) whatif="true"; shift ;;
    --move) action="move"; shift ;;
    --delete) action="delete"; shift ;;
    --verbose) verbose="true"; shift ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

attachments_abs="${vault_root%/}/${attachments_root}"
if [[ ! -d "$attachments_abs" ]]; then
  echo "Attachments root not found: $attachments_abs" >&2
  exit 1
fi

require_cmd find
require_cmd sed
require_cmd sort
require_cmd uniq
require_cmd grep
require_cmd awk

tmp_dir="$(mktemp -d)"
cleanup() { rm -rf "$tmp_dir"; }
trap cleanup EXIT

norm_path() {
  # normalize to forward slashes + lower (ASCII)
  printf '%s' "$1" | sed 's|\\|/|g' | tr '[:upper:]' '[:lower:]'
}

base_name() {
  # basename without depending on OS path rules
  local p="$1"
  p="${p##*/}"
  p="${p##*\\}"
  printf '%s' "$p"
}

decode_common() {
  # minimal URL decode for common Obsidian exports
  # (keeps it simple; mainly handles spaces)
  printf '%s' "$1" | sed -e 's/%20/ /g'
}

scan_roots=(
  "${vault_root%/}/Notes"
  "${vault_root%/}/Current"
  "${vault_root%/}/Categories"
  "${vault_root%/}/Clippings"
  "${vault_root%/}/Templates"
)

scan_globs=(-g'*.md' -g'*.canvas' -g'*.json' -g'*.base')

attachment_list="$tmp_dir/attachments.txt"
attachment_base_norm="$tmp_dir/attachment_base_norm.txt"

log "Collecting attachment file list..."
find "$attachments_abs" -type f > "$attachment_list"

while IFS= read -r f; do
  base_norm="$(printf '%s' "$(base_name "$f")" | tr '[:upper:]' '[:lower:]')"
  printf '%s\n' "$base_norm" >> "$attachment_base_norm"
done < "$attachment_list"
sort -u -o "$attachment_base_norm" "$attachment_base_norm"

ref_targets="$tmp_dir/ref_targets.txt"
ref_paths_norm="$tmp_dir/ref_paths_norm.txt"
ref_bases_norm="$tmp_dir/ref_bases_norm.txt"

# Ensure expected temp files exist (important under `set -e`)
: > "$ref_targets"
: > "$ref_paths_norm"
: > "$ref_bases_norm"

collect_ref_targets_fallback() {
  # Fallback when ripgrep (rg) is not available (Git Bash often).
  # Extracts:
  #  - wikilinks: [[...]] (strips after | or #)
  #  - markdown links: ](...) (ignores protocol targets, strips query/fragment)
  local find_expr=()
  for root in "${scan_roots[@]}"; do
    [[ -d "$root" ]] || continue
    find_expr+=("$root")
  done
  [[ ${#find_expr[@]} -eq 0 ]] && return 0

  log "Scanning vault text (fallback: find+awk)..."
  # shellcheck disable=SC2016
  find "${find_expr[@]}" -type f \( \
    -name '*.md' -o -name '*.canvas' -o -name '*.json' -o -name '*.base' \
  \) -print0 2>/dev/null \
    | while IFS= read -r -d '' f; do
        awk '
          function trim(s) { sub(/^[ \t\r\n]+/, "", s); sub(/[ \t\r\n]+$/, "", s); return s }
          {
            line = $0
            # wikilinks
            while (match(line, /\[\[[^]]+\]\]/)) {
              tok = substr(line, RSTART+2, RLENGTH-4)
              sub(/[|#].*$/, "", tok)
              tok = trim(tok)
              if (length(tok) > 0) print tok
              line = substr(line, RSTART+RLENGTH)
            }

            line = $0
            # markdown links
            while (match(line, /\]\([^)]+\)/)) {
              tok = substr(line, RSTART+2, RLENGTH-3) # drop ]( and )
              tok = trim(tok)
              sub(/[?#].*$/, "", tok)
              if (tok ~ /^[A-Za-z][A-Za-z0-9+.-]*:\/\//) { line = substr(line, RSTART+RLENGTH); continue }
              if (tok ~ /^[A-Za-z][A-Za-z0-9+.-]*:/) { line = substr(line, RSTART+RLENGTH); continue }
              if (length(tok) > 0) print tok
              line = substr(line, RSTART+RLENGTH)
            }
          }
        ' "$f" 2>/dev/null || true
      done
}

collect_ref_targets_rg() {
  # Faster extraction using ripgrep if available.
  log "Scanning vault text for wikilinks (rg)..."
  rg -o --no-messages '\[\[[^]]+\]\]' "${scan_globs[@]}" "${scan_roots[@]}" 2>/dev/null \
    | sed -e 's/^\[\[//' -e 's/\]\]$//' -e 's/[|#].*$//' \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' || true

  log "Scanning vault text for markdown links (rg)..."
  rg -o --no-messages '\]\([^)]+\)' "${scan_globs[@]}" "${scan_roots[@]}" 2>/dev/null \
    | sed -e 's/^\](//' -e 's/)$//' \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
    | grep -Ev '^[a-zA-Z][a-zA-Z0-9+.-]*://' \
    | grep -Ev '^[a-zA-Z][a-zA-Z0-9+.-]*:' \
    | sed 's/[#?].*$//' || true
}

if command -v rg >/dev/null 2>&1; then
  collect_ref_targets_rg >> "$ref_targets" || true
else
  collect_ref_targets_fallback >> "$ref_targets" || true
fi

sort -u -o "$ref_targets" "$ref_targets" 2>/dev/null || true

log "Normalizing references into lookup lists..."
while IFS= read -r t; do
  t="$(decode_common "$t")"
  # drop surrounding <...>
  t="${t#<}"; t="${t%>}"
  [[ -z "$t" ]] && continue

  b="$(base_name "$t")"
  if [[ "$b" == *.* ]]; then
    printf '%s\n' "$(printf '%s' "$b" | tr '[:upper:]' '[:lower:]')" >> "$ref_bases_norm"
  fi

  if [[ "$t" == *"/"* || "$t" == *"\\"* ]]; then
    printf '%s\n' "$(norm_path "$t")" >> "$ref_paths_norm"
  fi
done < "$ref_targets"

sort -u -o "$ref_bases_norm" "$ref_bases_norm" 2>/dev/null || true
sort -u -o "$ref_paths_norm" "$ref_paths_norm" 2>/dev/null || true

log "Loading references into in-memory sets..."
declare -A ref_base_set
declare -A ref_path_set
if [[ -s "$ref_bases_norm" ]]; then
  while IFS= read -r b; do
    [[ -z "$b" ]] && continue
    ref_base_set["$b"]=1
  done < "$ref_bases_norm"
fi
if [[ -s "$ref_paths_norm" ]]; then
  while IFS= read -r p; do
    [[ -z "$p" ]] && continue
    ref_path_set["$p"]=1
  done < "$ref_paths_norm"
fi

orphans_rel="$tmp_dir/orphans_rel.txt"
> "$orphans_rel"

log "Computing orphan attachments (this is the slowest step)..."
while IFS= read -r f; do
  rel="${f#"$vault_root"/}"
  rel_norm="$(norm_path "$rel")"
  base_norm="$(printf '%s' "$(base_name "$f")" | tr '[:upper:]' '[:lower:]')"

  if [[ -n "${ref_path_set[$rel_norm]+x}" ]]; then
    continue
  fi
  if [[ -n "${ref_base_set[$base_norm]+x}" ]]; then
    continue
  fi
  printf '%s\n' "$rel" >> "$orphans_rel"
done < "$attachment_list"

sort -u -o "$orphans_rel" "$orphans_rel" 2>/dev/null || true

stamp="$(date +%Y%m%d-%H%M%S)"
report_path="${vault_root%/}/orphan-attachments-report-${stamp}.txt"
cp "$orphans_rel" "$report_path"

attachments_count="$(wc -l < "$attachment_list" | awk '{print $1}')"
orphans_count="$(wc -l < "$orphans_rel" | awk '{print $1}')"
ref_bases_count="$(wc -l < "$ref_bases_norm" 2>/dev/null | awk '{print $1}')"
ref_paths_count="$(wc -l < "$ref_paths_norm" 2>/dev/null | awk '{print $1}')"
ref_targets_count="$(wc -l < "$ref_targets" 2>/dev/null | awk '{print $1}')"

echo "VaultRoot: $vault_root"
echo "AttachmentsRoot: $attachments_abs"
echo "Attachment files found: $attachments_count"
echo "Reference targets: $ref_targets_count"
echo "Referenced basenames: $ref_bases_count"
echo "Referenced paths: $ref_paths_count"
echo "Orphan attachments: $orphans_count"
echo "Report: $report_path"

if [[ "$orphans_count" == "$attachments_count" && "$ref_bases_count" -lt 10 && "$action" != "report" ]]; then
  echo "Safety stop: 0 references detected, would treat EVERYTHING as orphan. Run with --verbose and verify rg output." >&2
  exit 3
fi

if [[ "$action" == "report" || "$whatif" == "true" ]]; then
  echo "No action taken (use --move or --delete)."
  exit 0
fi

if [[ "$action" == "move" ]]; then
  dated_root="${vault_root%/}/${move_to}/$(date +%F)"
  while IFS= read -r rel; do
    [[ -z "$rel" ]] && continue
    src="${vault_root%/}/$rel"
    sub_rel="${src#"$attachments_abs"/}"
    dest="${dated_root%/}/$sub_rel"
    dest_dir="$(dirname "$dest")"
    if [[ "$whatif" == "true" ]]; then
      echo "Would move: $src -> $dest"
    else
      mkdir -p "$dest_dir"
      mv -f "$src" "$dest"
    fi
  done < "$orphans_rel"
  echo "Moved $orphans_count files under $dated_root"
  exit 0
fi

if [[ "$action" == "delete" ]]; then
  while IFS= read -r rel; do
    [[ -z "$rel" ]] && continue
    src="${vault_root%/}/$rel"
    if [[ "$whatif" == "true" ]]; then
      echo "Would delete: $src"
    else
      rm -f "$src"
    fi
  done < "$orphans_rel"
  echo "Deleted $orphans_count files"
  exit 0
fi

echo "Unexpected action: $action" >&2
exit 1
