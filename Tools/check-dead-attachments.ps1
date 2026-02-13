param(
  [Parameter(Mandatory = $false)]
  [string]$Root = ".",

  [Parameter(Mandatory = $false)]
  [string]$ReportPath = "Tools/dead-attachment-links.csv"
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
  # Ignore config parse errors; fall back to default.
}

$customAttachmentPattern = $null
try {
  $customAttachJsonPath = Join-Path $vaultRoot ".obsidian\\plugins\\obsidian-custom-attachment-location\\data.json"
  if (Test-Path -LiteralPath $customAttachJsonPath) {
    $custom = Get-Content -LiteralPath $customAttachJsonPath -Raw | ConvertFrom-Json
    if ($null -ne $custom.attachmentFolderPath -and -not [string]::IsNullOrWhiteSpace([string]$custom.attachmentFolderPath)) {
      $customAttachmentPattern = [string]$custom.attachmentFolderPath
    }
  }
} catch {
  # Ignore plugin config parse errors.
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

function Decode-UrlLike([string]$s) {
  try { return [System.Uri]::UnescapeDataString($s) } catch { return $s }
}

function Unquote-IfWrapped([string]$s) {
  $t = $s.Trim()
  if ($t.Length -ge 2 -and $t[0] -eq [char]34 -and $t[$t.Length - 1] -eq [char]34) { return $t.Substring(1, $t.Length - 2).Trim() }
  if ($t.Length -ge 2 -and $t[0] -eq [char]39 -and $t[$t.Length - 1] -eq [char]39) { return $t.Substring(1, $t.Length - 2).Trim() }
  return $t
}

$mdLink = [regex]::new('!?\[[^\]]*\]\((?<t>[^)]+)\)')
$wikiLink = [regex]::new('!?\[\[(?<t>[^\]|#]+)(?:#[^\]|]+)?(?:\|[^\]]+)?\]\]')

$mdFiles =
  Get-ChildItem -Recurse -File -Path $vaultRoot -Filter *.md |
  Where-Object { $_.FullName -notmatch "\\\.git\\" }

$dead = New-Object System.Collections.Generic.List[object]

foreach ($file in $mdFiles) {
  $text = [System.IO.File]::ReadAllText($file.FullName)
  $noteRelPath =
    if ($file.FullName.StartsWith($vaultRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
      $file.FullName.Substring($vaultRoot.Length).TrimStart('\')
    } else {
      $file.Name
    }
  $noteRelDir = Split-Path $noteRelPath -Parent
  $noteRelPathNoExt =
    if ($noteRelPath -match '(?i)\.md$') { $noteRelPath.Substring(0, $noteRelPath.Length - 3) } else { $noteRelPath }
  $noteLeaf = Split-Path $noteRelPath -Leaf
  $noteLeafNoExt =
    if ($noteLeaf -match '(?i)\.md$') { $noteLeaf.Substring(0, $noteLeaf.Length - 3) } else { $noteLeaf }

  $targets = New-Object System.Collections.Generic.List[string]
  foreach ($m in $mdLink.Matches($text)) { $targets.Add($m.Groups['t'].Value) }
  foreach ($m in $wikiLink.Matches($text)) { $targets.Add($m.Groups['t'].Value) }
  if ($targets.Count -eq 0) { continue }

  foreach ($raw in $targets) {
    $t0 = Unquote-IfWrapped $raw
    if ([string]::IsNullOrWhiteSpace($t0)) { continue }
    if ($t0 -match "^(?i)(https?|mailto):") { continue }

    # Strip query/fragment for markdown-style URLs
    $t1 = ($t0 -split "[#?]", 2)[0]
    $t1 = Decode-UrlLike $t1

    # Only consider likely file links
    if ($t1 -notmatch "(?i)\.($extRegex)$") { continue }

    $candidates = New-Object System.Collections.Generic.List[string]

    if ($t1 -match '^[A-Za-z]:\\') {
      $candidates.Add($t1)
    } else {
      $rel = $t1.Replace('/', '\')
      $candidates.Add((Join-Path $file.Directory.FullName $rel))
      $candidates.Add((Join-Path $vaultRoot $rel))
      if (-not [string]::IsNullOrWhiteSpace($attachmentRootAbs)) {
        if (-not ($attachmentRootRelNorm) -or -not ($rel.StartsWith($attachmentRootRelNorm + '\', [System.StringComparison]::OrdinalIgnoreCase))) {
          $candidates.Add((Join-Path $attachmentRootAbs $rel))
        }
      }

      # Obsidian attachment folder conventions:
      # - app.json: "Attachments"
      if ($rel -notmatch '[\\/]' -and -not [string]::IsNullOrWhiteSpace($attachmentRootAbs)) {
        # Common patterns: Attachments/<noteFilePath>/file.ext and Attachments/<noteFilePathNoExt>/file.ext
        $candidates.Add((Join-Path $attachmentRootAbs (Join-Path $noteRelPath $rel)))
        $candidates.Add((Join-Path $attachmentRootAbs (Join-Path $noteRelPathNoExt $rel)))

        if (-not [string]::IsNullOrWhiteSpace($noteRelDir)) {
          $candidates.Add((Join-Path $attachmentRootAbs (Join-Path $noteRelDir $rel)))
          $candidates.Add((Join-Path $attachmentRootAbs (Join-Path (Join-Path $noteRelDir $noteLeaf) $rel)))
          $candidates.Add((Join-Path $attachmentRootAbs (Join-Path (Join-Path $noteRelDir $noteLeafNoExt) $rel)))
        }
      }
    }

    $exists = $false
    foreach ($c in $candidates) {
      if (Test-Path -LiteralPath $c) { $exists = $true; break }
    }

    if (-not $exists) {
      $dead.Add([pscustomobject]@{
        note = $file.FullName
        target = $t0
        resolved1 = $candidates[0]
        resolved2 = if ($candidates.Count -gt 1) { $candidates[1] } else { $null }
      })
    }
  }
}

$outPath =
  if ([System.IO.Path]::IsPathRooted($ReportPath)) {
    $ReportPath
  } else {
    Join-Path $vaultRoot ($ReportPath.Replace('/', '\'))
  }

$outDir = Split-Path -Parent $outPath
if (-not [string]::IsNullOrWhiteSpace($outDir)) {
  New-Item -ItemType Directory -Force -Path $outDir | Out-Null
}

$dead | Sort-Object note, target | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $outPath

Write-Host ("dead_count={0}" -f $dead.Count)
Write-Host ("report={0}" -f $outPath)
