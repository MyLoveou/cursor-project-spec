# Install shared/skills into user-global skill dirs.
# Rules are NOT installed here. They are generated into each business
# project's .cursor/rules by bootstrap-project.ps1 / generate.ps1.
# Global always-apply rules would leak this spec's gates into unrelated repos.
#
# Destinations:
#   %USERPROFILE%\.cursor\skills
#   %USERPROFILE%\.agents\skills
# Overwrites same-named skills only; does not delete others.
#
#   powershell -File scripts/install-global-skills.ps1 -SpecRoot <spec-repo>

param(
    [Parameter(Mandatory = $false)]
    [string]$SpecRoot = ""
)

$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($SpecRoot)) {
    $SpecRoot = Split-Path -Parent $PSScriptRoot
}
$SpecRoot = (Resolve-Path $SpecRoot).Path
$src = Join-Path $SpecRoot "shared\skills"
if (-not (Test-Path $src)) { throw "Missing $src" }

$destRoots = @(
    (Join-Path $env:USERPROFILE ".cursor\skills"),
    (Join-Path $env:USERPROFILE ".agents\skills")
)

$names = Get-ChildItem $src -Directory | ForEach-Object { $_.Name }
foreach ($destRoot in $destRoots) {
    New-Item -ItemType Directory -Force -Path $destRoot | Out-Null
    foreach ($name in $names) {
        $from = Join-Path $src $name
        $to = Join-Path $destRoot $name
        if (Test-Path $to) { Remove-Item -Recurse -Force $to }
        Copy-Item -Recurse -Force $from $to
        Write-Host "[global] $name -> $to"
    }
    Write-Host "[global] $($names.Count) skills -> $destRoot"
}

Write-Host ""
Write-Host "Reload Cursor window to pick up global skills."
