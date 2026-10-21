# init_feature.ps1 — scaffold a Markdown feature tracker dir from bundled assets.
#
# Usage:
#   pwsh -File init_feature.ps1 -Root <trackers-root> -Slug <feature-slug> `
#                              -Title "Feature Title" -Branch "<branch-name>" `
#                              [-Repos "RepoA,RepoB"]
#
# Idempotent: if any file already exists it is left untouched (so re-runs
# don't trample edits). Ensures _shared/ exists too.

param(
  [Parameter(Mandatory=$true)][string]$Root,
  [Parameter(Mandatory=$true)][string]$Slug,
  [Parameter(Mandatory=$true)][string]$Title,
  [Parameter(Mandatory=$true)][string]$Branch,
  [string]$Repos = ""
)

$ErrorActionPreference = 'Stop'

$skillDir  = Split-Path -Parent $PSScriptRoot
$assetsDir = Join-Path $skillDir 'assets'
$today     = Get-Date -Format 'yyyy-MM-dd'

$repoArray = if ($Repos) { $Repos -split '[,;]\s*' } else { @('repo') }
$repoList  = ($repoArray | ForEach-Object { "``$_``" }) -join ', '
$repoSections = ($repoArray | ForEach-Object { "## $_`n" }) -join "`n"

# UTF-8 NO BOM — PS 5.1's Set-Content -Encoding utf8 writes BOM, and round-tripping
# through Get-Content (default CP1252 on PS 5.1) mangles non-ASCII to mojibake.
$utf8 = [System.Text.UTF8Encoding]::new($false)

function Read-Template {
  param([string]$Name, [string]$PageTitle = "", [string]$PageLede = "")
  $content = [System.IO.File]::ReadAllText((Join-Path $assetsDir $Name), $utf8)
  # Literal string replacement, so a '$' in a title is not read as a regex group.
  return $content.
    Replace('{{FEATURE_TITLE}}', $Title).
    Replace('{{SLUG}}',          $Slug).
    Replace('{{BRANCH_NAME}}',   $Branch).
    Replace('{{REPOS}}',         $repoList).
    Replace('{{REPO_SECTIONS}}', $repoSections).
    Replace('{{TODAY}}',         $today).
    Replace('{{PAGE_TITLE}}',    $PageTitle).
    Replace('{{PAGE_LEDE}}',     $PageLede)
}

function Write-IfMissing {
  param([string]$Path, [string]$Content)
  if (Test-Path $Path) {
    Write-Host "  skip (exists)  $Path"
    return
  }
  $dir = Split-Path -Parent $Path
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  [System.IO.File]::WriteAllText($Path, $Content, $utf8)
  Write-Host "  created        $Path"
}

# ── Ensure _shared/ exists ────────────────────────────────────────────
$sharedDir = Join-Path $Root '_shared'
Write-Host "Ensuring shared dir at $sharedDir"

Write-IfMissing (Join-Path $sharedDir 'decisions.md') `
  (Read-Template 'decisions-template.md' 'Cross-cutting decisions' `
    'Decisions every feature has to respect; read before starting a new feature.')

Write-IfMissing (Join-Path $sharedDir 'tech-debt.md') `
  (Read-Template 'tech-debt-template.md' 'Project-wide tech debt' `
    'Debt parked on purpose that will still matter after the current feature ships.')

# ── Scaffold the feature dir ──────────────────────────────────────────
$featureDir = Join-Path $Root $Slug
Write-Host "Scaffolding feature dir at $featureDir"

Write-IfMissing (Join-Path $featureDir 'map.md') (Read-Template 'map-template.md')

Write-IfMissing (Join-Path $featureDir 'state.md') `
  (Read-Template 'state-template.md' "Environment state: $Title")

Write-IfMissing (Join-Path $featureDir 'stage.md') `
  (Read-Template 'stage-template.md' "Implementation stage: $Title")

Write-IfMissing (Join-Path $featureDir 'decisions.md') `
  (Read-Template 'decisions-template.md' "Decisions: $Title" `
    'Feature-scoped decisions and nuances that shape how future tasks in this feature must be done.')

Write-IfMissing (Join-Path $featureDir 'tech-debt.md') `
  (Read-Template 'tech-debt-template.md' "Tech debt: $Title" `
    'Problems parked on purpose, scoped to this feature only; anything that will outlive it belongs in ../_shared/tech-debt.md.')

Write-IfMissing (Join-Path $featureDir 'runbook.md') `
  (Read-Template 'runbook-template.md' "Runbook: $Title")

Write-Host ""
Write-Host "Done. Start at:  $(Join-Path $featureDir 'map.md')"
