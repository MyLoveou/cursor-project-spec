# Refresh vendored third-party skills: npx skills add -> .agents/skills -> skills/
# Usage: powershell -File scripts/sync-vendor-skills.ps1

param(
    [string]$SpecRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"
Set-Location $SpecRoot

$entries = @(
    @{ Name = "agent-browser"; Source = "https://github.com/vercel-labs/agent-browser" },
    @{ Name = "frontend-design"; Source = "https://github.com/anthropics/skills"; Skill = "frontend-design" },
    @{ Name = "ui-ux-pro-max"; Source = "https://github.com/nextlevelbuilder/ui-ux-pro-max-skill"; Skill = "ui-ux-pro-max" },
    @{ Name = "web-design-guidelines"; Source = "https://github.com/vercel-labs/agent-skills"; Skill = "web-design-guidelines" }
)

foreach ($entry in $entries) {
    $skillArg = if ($entry.Skill) { $entry.Skill } else { $entry.Name }
    Write-Host "Adding $skillArg from $($entry.Source) ..."
    npx --yes skills add $entry.Source --skill $skillArg | Out-Host

    $srcDir = Join-Path $SpecRoot ".agents\skills\$skillArg"
    $destDir = Join-Path $SpecRoot "skills\$skillArg"
    if (-not (Test-Path $srcDir)) {
        throw "Skill dir not found after install: $srcDir"
    }
    if (Test-Path $destDir) {
        Remove-Item -Recurse -Force $destDir
    }
    Copy-Item -Recurse -Force $srcDir $destDir
    Write-Host "Vendored -> skills/$skillArg/"
}

Write-Host "Done. skills-lock.json updated by npx skills CLI."
