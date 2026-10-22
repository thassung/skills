# Claude Environment Setup Script
# Deploys skills and portable config from this repo to ~/.claude/
#
# Usage: powershell -ExecutionPolicy Bypass -File setup.ps1
# Run from the repo root

param(
    [switch]$DryRun,
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$RepoRoot = $PSScriptRoot | Split-Path -Parent
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"

Write-Host "Claude Environment Setup" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host "Source:  $RepoRoot"
Write-Host "Target:  $ClaudeDir"
Write-Host ""

if ($DryRun) { Write-Host "(Dry run - no files will be changed)" -ForegroundColor Yellow; Write-Host "" }

if (-not (Test-Path $ClaudeDir)) {
    Write-Host "Creating $ClaudeDir..." -ForegroundColor Yellow
    if (-not $DryRun) { New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null }
}

# Deploy skills (flatten source-group folders)
$SkillsSource = Join-Path $RepoRoot "skills"
$SkillsTarget = Join-Path $ClaudeDir "skills"

if (-not (Test-Path $SkillsTarget)) {
    if (-not $DryRun) { New-Item -ItemType Directory -Path $SkillsTarget -Force | Out-Null }
}

Write-Host "Skills:" -ForegroundColor Cyan
$groups = Get-ChildItem -Path $SkillsSource -Directory
foreach ($group in $groups) {
    $skills = Get-ChildItem -Path $group.FullName -Directory
    foreach ($skill in $skills) {
        $dest = Join-Path $SkillsTarget $skill.Name
        if ((Test-Path $dest) -and -not $Force) {
            Write-Host "  SKIP  $($skill.Name) (exists, use -Force to overwrite)" -ForegroundColor Yellow
        } else {
            Write-Host "  COPY  $($group.Name)/$($skill.Name)" -ForegroundColor Green
            if (-not $DryRun) {
                if (Test-Path $dest) { Remove-Item -Path $dest -Recurse -Force }
                Copy-Item -Path $skill.FullName -Destination $dest -Recurse
            }
        }
    }
}

# Deploy portable config (CLAUDE.md, statusline, package.json)
# settings.json is a REFERENCE -- review and merge manually on new machines
# hooks/ and settings.local.json are machine-specific, not deployed
Write-Host ""
Write-Host "Config:" -ForegroundColor Cyan
$configFiles = @("CLAUDE.md", "package.json", "statusline.mjs")

foreach ($filename in $configFiles) {
    $src = Join-Path $RepoRoot $filename
    if (-not (Test-Path $src)) { continue }
    $dest = Join-Path $ClaudeDir $filename
    if ((Test-Path $dest) -and -not $Force) {
        Write-Host "  SKIP  $filename (exists, use -Force to overwrite)" -ForegroundColor Yellow
    } else {
        Write-Host "  COPY  $filename" -ForegroundColor Green
        if (-not $DryRun) { Copy-Item -Path $src -Destination $dest -Force }
    }
}

# Remind about settings.json
$settingsSrc = Join-Path $RepoRoot "settings.json"
if (Test-Path $settingsSrc) {
    Write-Host ""
    Write-Host "Note: settings.json is included as a reference." -ForegroundColor DarkYellow
    Write-Host "  Review and merge hooks/plugins config manually:" -ForegroundColor DarkYellow
    Write-Host "  $settingsSrc" -ForegroundColor DarkYellow
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
if ($DryRun) { Write-Host "(Dry run - no files were changed)" -ForegroundColor Yellow }
