param(
  [Parameter(Mandatory = $false)]
  [string]$Root = ".",

  [Parameter(Mandatory = $false)]
  [string]$ReportPath = "Tools/misplaced-attachments.csv"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-VaultRoot {
  param(
    [Parameter(Mandatory = $true)]
    [string]$StartPath
  )

  $p = $StartPath
  if (Test-Path -LiteralPath $p -PathType Leaf) {
    $p = Split-Path -Parent $p
  }
  $dir = Get-Item -LiteralPath $p -ErrorAction Stop
  while ($true) {
    if (Test-Path -LiteralPath (Join-Path $dir.FullName ".obsidian") -PathType Container) {
      return $dir.FullName
    }
    if ($null -eq $dir.Parent) { break }
    $dir = $dir.Parent
  }
  return $p
}

function Decode-UrlLike([string]$s) {
  try { return [System.Uri]::UnescapeDataString($s) } catch { return $s }
}

function Unquote-IfWrapped([string]$s) {
  $t = $s.Trim()
  if ($t.Length -ge 2 -and $t[0] -eq [char]34 -and $t[$t.Length - 1] -eq [char]34) { return $t.Substring(1, $t.Length - 2).Trim() }
  if ($t.Length -ge 2 -and $t[0] -eq [char]39 -and $t[$t.Length - 1] -eq [char]39) { return $t.Substring(1, $t.Length - 2).Trim() }
  return $t
}

$startPath =
  if ([string]::IsNullOrWhiteSpace($Root) -or $Root -eq ".") {
    Split-Path -Parent $PSScriptRoot
  } else {
    (Resolve-Path -LiteralPath $Root).Path
  }

$vaultRoot = Resolve-VaultRoot -StartPath $startPath

$attachmentRootRel = "Attachments"
try {
  $appJsonPath = Join-Path $vaultRoot ".obsidian\\app.json"
  if (Test-Path -LiteralPath $appJsonPath) {
    $app = Get-Content -LiteralPath $appJsonPath -Raw | ConvertFrom-Json
    if ($null -ne $app.attachmentFolderPath -and -not [string]::IsNullOrWhiteSpace([string]$app.attachmentFolderPath)) {
      $attachmentRootRel = [string]$app.attachmentFolderPath
    }
  }
} catch {
  # ignore
}

$attachmentRootAbs = Join-Path $vaultRoot ($attachmentRootRel.Replace('/', '\'))
$attachmentRootRelNorm = ($attachmentRootRel.Replace('/', '\')).TrimEnd('\')

$attachmentExts = @(
  'png','jpg','jpeg','gif','svg','webp',
  'pdf','zip','7z','rar',
  'json','csv','tsv',
  'xlsx','xls','docx','doc','pptx','ppt',
  'mp4','mov','m4v','mp3','wav','ogg','webm','mkv'
)
$extRegex = ($attachmentExts | ForEach-Object { [regex]::Escape($_) }) -join '|'

$mdLink = [regex]::new('!?\[[^\]]*\]\((?<t>[^)]+)\)')
$wikiLink = [regex]::new('!?\[\[(?<t>[^\]|#]+)(?:#[^\]|]+)?(?:\|[^\]]+)?\]\]')

function Get-NoteContext {
  param([Parameter(Mandatory = $true)][System.IO.FileInfo]$File)

  $noteRelPath =
    if ($File.FullName.StartsWith($vaultRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
      $File.FullName.Substring($vaultRoot.Length).TrimStart('\')
    } else {
      $File.Name
    }
  $noteRelDir = Split-Path $noteRelPath -Parent
  $noteLeaf = Split-Path $noteRelPath -Leaf
  $noteLeafNoExt =
    if ($noteLeaf -match '(?i)\.md$') { $noteLeaf.Substring(0, $noteLeaf.Length - 3) } else { $noteLeaf }
  $noteRelPathNoExt =
    if ($noteRelPath -match '(?i)\.md$') { $noteRelPath.Substring(0, $noteRelPath.Length - 3) } else { $noteRelPath }

  $expectedAttachmentDir = Join-Path $attachmentRootAbs $noteRelPathNoExt

  return [pscustomobject]@{
    NoteRelPath = $noteRelPath
    NoteRelDir = $noteRelDir
    NoteLeaf = $noteLeaf
    NoteLeafNoExt = $noteLeafNoExt
    NoteRelPathNoExt = $noteRelPathNoExt
    ExpectedAttachmentDir = $expectedAttachmentDir
  }
}

function Resolve-AttachmentPath {
  param(
    [Parameter(Mandatory = $true)][System.IO.FileInfo]$NoteFile,
    [Parameter(Mandatory = $true)][pscustomobject]$Ctx,
    [Parameter(Mandatory = $true)][string]$Target
  )

  $t0 = Unquote-IfWrapped $Target
  if ([string]::IsNullOrWhiteSpace($t0)) { return $null }
  if ($t0 -match "^(?i)(https?|mailto):") { return $null }

  $t1 = ($t0 -split "[#?]", 2)[0]
  $t1 = Decode-UrlLike $t1
  if ($t1 -notmatch "(?i)\.($extRegex)$") { return $null }

  $candidates = New-Object System.Collections.Generic.List[string]

  if ($t1 -match '^[A-Za-z]:\\') {
    $candidates.Add($t1)
  } else {
    $rel = $t1.Replace('/', '\')
    $candidates.Add((Join-Path $NoteFile.Directory.FullName $rel))
    $candidates.Add((Join-Path $vaultRoot $rel))
    if (-not [string]::IsNullOrWhiteSpace($attachmentRootAbs)) {
      if (-not ($attachmentRootRelNorm) -or -not ($rel.StartsWith($attachmentRootRelNorm + '\', [System.StringComparison]::OrdinalIgnoreCase))) {
        $candidates.Add((Join-Path $attachmentRootAbs $rel))
      }
    }

    # Common vault patterns when link is just the filename:
    if ($rel -notmatch '[\\/]' -and -not [string]::IsNullOrWhiteSpace($attachmentRootAbs)) {
      $candidates.Add((Join-Path $attachmentRootAbs (Join-Path $Ctx.NoteRelPath $rel)))
      $candidates.Add((Join-Path $attachmentRootAbs (Join-Path $Ctx.NoteRelPathNoExt $rel)))
      if (-not [string]::IsNullOrWhiteSpace($Ctx.NoteRelDir)) {
        $candidates.Add((Join-Path $attachmentRootAbs (Join-Path $Ctx.NoteRelDir $rel)))
        $candidates.Add((Join-Path $attachmentRootAbs (Join-Path (Join-Path $Ctx.NoteRelDir $Ctx.NoteLeaf) $rel)))
        $candidates.Add((Join-Path $attachmentRootAbs (Join-Path (Join-Path $Ctx.NoteRelDir $Ctx.NoteLeafNoExt) $rel)))
      }
    }
  }

  foreach ($c in $candidates) {
    if (Test-Path -LiteralPath $c) { return $c }
  }

  return $null
}

$notes =
  Get-ChildItem -Recurse -File -Path $vaultRoot -Filter *.md |
  Where-Object {
    $_.FullName -notmatch "\\\.git\\" -and
    $_.FullName -notmatch "\\\\Attachments\\\\" -and
    $_.FullName -notmatch "\\\\\.obsidian\\\\"
  }

$ownership = @{} # attachmentFullPathLower -> list of owners (note + expected dir + resolved path)

foreach ($note in $notes) {
  $ctx = Get-NoteContext -File $note
  $text = [System.IO.File]::ReadAllText($note.FullName)

  $targets = New-Object System.Collections.Generic.List[string]
  foreach ($m in $mdLink.Matches($text)) { $targets.Add($m.Groups['t'].Value) }
  foreach ($m in $wikiLink.Matches($text)) { $targets.Add($m.Groups['t'].Value) }
  if ($targets.Count -eq 0) { continue }

  foreach ($raw in $targets) {
    $resolved = Resolve-AttachmentPath -NoteFile $note -Ctx $ctx -Target $raw
    if ($null -eq $resolved) { continue }

    $k = $resolved.ToLowerInvariant()
    if (-not $ownership.ContainsKey($k)) { $ownership[$k] = @() }
    $ownership[$k] += [pscustomobject]@{
      note = $note.FullName
      expectedDir = $ctx.ExpectedAttachmentDir
      attachment = $resolved
    }
  }
}

$misplaced = New-Object System.Collections.Generic.List[object]

foreach ($kv in $ownership.GetEnumerator()) {
  $owners = $kv.Value

  $expectedDirs = @($owners | Select-Object -ExpandProperty expectedDir | Sort-Object -Unique)
  if ($expectedDirs.Count -ne 1) {
    continue # shared/conflicting ownership; skip for now
  }

  $expected = $expectedDirs[0]
  $actualPath = $owners[0].attachment
  $actualDir = Split-Path -Parent $actualPath

  if (-not $actualDir.StartsWith($expected, [System.StringComparison]::OrdinalIgnoreCase)) {
    foreach ($o in $owners) {
      $misplaced.Add([pscustomobject]@{
        attachment = $actualPath
        note = $o.note
        expectedDir = $expected
        actualDir = $actualDir
      })
    }
  }
}

$outPath =
  if ([System.IO.Path]::IsPathRooted($ReportPath)) { $ReportPath }
  else { Join-Path $vaultRoot ($ReportPath.Replace('/', '\')) }

$outDir = Split-Path -Parent $outPath
if (-not [string]::IsNullOrWhiteSpace($outDir)) {
  New-Item -ItemType Directory -Force -Path $outDir | Out-Null
}

$misplaced | Sort-Object note, attachment | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $outPath

Write-Host ("misplaced_count={0}" -f $misplaced.Count)
Write-Host ("report={0}" -f $outPath)
