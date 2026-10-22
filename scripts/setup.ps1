# Claude Environment Setup Script
# Deploys skills, dotfiles, and hooks from this repo to ~/.claude/
#
# Usage: powershell -ExecutionPolicy Bypass -File setup.ps1
# Run from the repo root (D:\claude-env\)

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

# Deploy dotfiles (now at repo root)
Write-Host ""
Write-Host "Config:" -ForegroundColor Cyan
$dotfiles = @("CLAUDE.md", "config.json", "package.json", "settings.json", "settings.local.json", "statusline.mjs")

foreach ($filename in $dotfiles) {
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

# Deploy hooks
$HooksSource = Join-Path $RepoRoot "hooks"
$HooksTarget = Join-Path $ClaudeDir "hooks"

if (Test-Path $HooksSource) {
    Write-Host ""
    Write-Host "Hooks:" -ForegroundColor Cyan
    if (-not (Test-Path $HooksTarget)) {
        if (-not $DryRun) { New-Item -ItemType Directory -Path $HooksTarget -Force | Out-Null }
    }
    $hooks = Get-ChildItem -Path $HooksSource -File
    foreach ($hook in $hooks) {
        $dest = Join-Path $HooksTarget $hook.Name
        if ((Test-Path $dest) -and -not $Force) {
            Write-Host "  SKIP  hooks/$($hook.Name) (exists, use -Force to overwrite)" -ForegroundColor Yellow
        } else {
            Write-Host "  COPY  hooks/$($hook.Name)" -ForegroundColor Green
            if (-not $DryRun) { Copy-Item -Path $hook.FullName -Destination $dest -Force }
        }
    }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
if ($DryRun) { Write-Host "(Dry run - no files were changed)" -ForegroundColor Yellow }
