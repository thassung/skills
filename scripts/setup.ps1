# Claude Environment Setup Script
# Deploys skills and CLAUDE.md from this repo to ~/.claude/
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
$repoSkills = @($groups | ForEach-Object { Get-ChildItem -Path $_.FullName -Directory } | ForEach-Object { $_.Name })

# Remove skills an earlier run deployed that are no longer in the repo. Only names in the marker are touched,
# so skills you installed by other means stay.
$marker = Join-Path $SkillsTarget ".claude-env-deployed"
if (Test-Path $marker) {
    foreach ($name in Get-Content $marker) {
        if ($name -and ($repoSkills -notcontains $name)) {
            $stale = Join-Path $SkillsTarget $name
            if (Test-Path $stale) {
                Write-Host "  PRUNE $name (no longer in repo)" -ForegroundColor Magenta
                if (-not $DryRun) { Remove-Item -Path $stale -Recurse -Force }
            }
        }
    }
}

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
if (-not $DryRun) { Set-Content -Path $marker -Value $repoSkills -Encoding utf8 }

# Deploy CLAUDE.md
Write-Host ""
Write-Host "Config:" -ForegroundColor Cyan
$claudeMd = Join-Path $RepoRoot "CLAUDE.md"
if (Test-Path $claudeMd) {
    $dest = Join-Path $ClaudeDir "CLAUDE.md"
    if ((Test-Path $dest) -and -not $Force) {
        Write-Host "  SKIP  CLAUDE.md (exists, use -Force to overwrite)" -ForegroundColor Yellow
    } else {
        Write-Host "  COPY  CLAUDE.md" -ForegroundColor Green
        if (-not $DryRun) { Copy-Item -Path $claudeMd -Destination $dest -Force }
    }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
if ($DryRun) { Write-Host "(Dry run - no files were changed)" -ForegroundColor Yellow }

Write-Host ""
Write-Host "Recommended plugins (install separately):" -ForegroundColor Cyan
Write-Host "  claude plugin add context-mode        # context window protection"
Write-Host "  claude plugin add frontend-design     # frontend/UI design guidance (optional)"
Write-Host "  claude plugin add asana               # Asana integration (optional)"
Write-Host ""
Write-Host "See docs/plugins.md for details." -ForegroundColor DarkGray
