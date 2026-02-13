param(
  [Parameter(Mandatory = $false)]
  [string]$Root = ".",

  [Parameter(Mandatory = $false)]
  [string]$ReportPath = "Tools/attachments-without-note.csv"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-VaultRoot {
  param([Parameter(Mandatory = $true)][string]$StartPath)

  $p = $StartPath
  if (Test-Path -LiteralPath $p -PathType Leaf) { $p = Split-Path -Parent $p }
  $dir = Get-Item -LiteralPath $p -ErrorAction Stop
  while ($true) {
    if (Test-Path -LiteralPath (Join-Path $dir.FullName ".obsidian") -PathType Container) { return $dir.FullName }
    if ($null -eq $dir.Parent) { break }
    $dir = $dir.Parent
  }
  return $p
}

$startPath =
  if ([string]::IsNullOrWhiteSpace($Root) -or $Root -eq ".") { Split-Path -Parent $PSScriptRoot }
  else { (Resolve-Path -LiteralPath $Root).Path }

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

if (-not (Test-Path -LiteralPath $attachmentRootAbs -PathType Container)) {
  throw "Attachment root not found: $attachmentRootAbs"
}

function Find-OwnerNote {
  param(
    [Parameter(Mandatory = $true)][string]$AttachmentFullPath
  )

  $dir = Split-Path -Parent $AttachmentFullPath
  while ($true) {
    if ($dir.Length -le $attachmentRootAbs.Length) { break }
    if (-not $dir.StartsWith($attachmentRootAbs, [System.StringComparison]::OrdinalIgnoreCase)) { break }

    $rel = $dir.Substring($attachmentRootAbs.Length).TrimStart('\')
    if (-not [string]::IsNullOrWhiteSpace($rel)) {
      $candidate1 = Join-Path $vaultRoot $rel
      if (Test-Path -LiteralPath $candidate1 -PathType Leaf) { return $candidate1 }

      $candidate2 = $candidate1 + ".md"
      if (Test-Path -LiteralPath $candidate2 -PathType Leaf) { return $candidate2 }
    }

    $parent = Split-Path -Parent $dir
    if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $dir) { break }
    $dir = $parent
  }

  return $null
}

$attachments = Get-ChildItem -Recurse -File -Path $attachmentRootAbs

$unowned = New-Object System.Collections.Generic.List[object]
foreach ($a in $attachments) {
  $owner = Find-OwnerNote -AttachmentFullPath $a.FullName
  if ($null -eq $owner) {
    $unowned.Add([pscustomobject]@{
      attachment = $a.FullName
      relative = $a.FullName.Substring($attachmentRootAbs.Length).TrimStart('\')
    })
  }
}

$outPath =
  if ([System.IO.Path]::IsPathRooted($ReportPath)) { $ReportPath }
  else { Join-Path $vaultRoot ($ReportPath.Replace('/', '\')) }

$outDir = Split-Path -Parent $outPath
if (-not [string]::IsNullOrWhiteSpace($outDir)) {
  New-Item -ItemType Directory -Force -Path $outDir | Out-Null
}

$unowned | Sort-Object relative | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $outPath

Write-Host ("unowned_count={0}" -f $unowned.Count)
Write-Host ("report={0}" -f $outPath)
