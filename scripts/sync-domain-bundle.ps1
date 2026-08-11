# Domain pack runtime bundle sync
# Copies root skills/rules/agents/workflows (+ selected templates) into
# domains/<id>/bundle/ so the domain pack can be moved alone to a business repo.
#
# Updated for unified structure: skills/ → shared/skills/, workflows/ → shared/workflows/

param(
    [Parameter(Mandatory = $true)]
    [string]$SpecRoot,
    [Parameter(Mandatory = $true)]
    [string]$Domain
)

$ErrorActionPreference = "Stop"
$SpecRoot = (Resolve-Path $SpecRoot).Path
if ($Domain.StartsWith("_")) { throw "Cannot sync scaffold domain '$Domain'" }
if ($Domain -notmatch '^[a-z][a-z0-9-]*$') { throw "Domain id must be kebab-case" }

$pack = Join-Path $SpecRoot "domains\$Domain"
$manifestPath = Join-Path $pack "bundle.manifest.json"
if (-not (Test-Path $manifestPath)) { throw "Missing manifest: $manifestPath" }

$manifest = Get-Content -Raw -Encoding utf8 -Path $manifestPath | ConvertFrom-Json
$bundleRoot = Join-Path $pack "bundle"
if (Test-Path $bundleRoot) { Remove-Item -Recurse -Force $bundleRoot }
New-Item -ItemType Directory -Force -Path $bundleRoot | Out-Null

function Copy-Listed {
    param([string]$SourceDir, [string]$DestDir, [string[]]$Names, [string]$Kind)
    if (-not $Names -or $Names.Count -eq 0) { return }
    if (-not (Test-Path $SourceDir)) { throw "Missing source dir for ${Kind}: $SourceDir" }
    New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
    foreach ($name in $Names) {
        $src = Join-Path $SourceDir $name
        if (-not (Test-Path $src)) { throw "Missing $Kind '$name' at $src" }
        $dest = Join-Path $DestDir $name
        $destParent = Split-Path -Parent $dest
        if ($destParent -and -not (Test-Path $destParent)) { New-Item -ItemType Directory -Force -Path $destParent | Out-Null }
        if (Test-Path $src -PathType Container) { Copy-Item -Recurse -Force $src $dest } else { Copy-Item -Force $src $dest }
        Write-Host "[bundle:$Domain] $Kind $name"
    }
}

# Updated paths for unified structure
Copy-Listed -SourceDir (Join-Path $SpecRoot "shared\skills") -DestDir (Join-Path $bundleRoot "skills") -Names @($manifest.skills) -Kind "skill"
Copy-Listed -SourceDir (Join-Path $SpecRoot "rules") -DestDir (Join-Path $bundleRoot "rules") -Names @($manifest.rules) -Kind "rule"
Copy-Listed -SourceDir (Join-Path $SpecRoot "agents") -DestDir (Join-Path $bundleRoot "agents") -Names @($manifest.agents) -Kind "agent"
Copy-Listed -SourceDir (Join-Path $SpecRoot "shared\workflows") -DestDir (Join-Path $bundleRoot "workflows") -Names @($manifest.workflows) -Kind "workflow"

$rootTpl = @($manifest.rootTemplates)
if ($rootTpl.Count -gt 0) {
    Copy-Listed -SourceDir (Join-Path $SpecRoot "templates") -DestDir (Join-Path $bundleRoot "root-templates") -Names $rootTpl -Kind "root-template"
}

$when = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
@"
# bundle sync stamp

- Domain: $Domain
- Synced: $when
- SpecRoot: $SpecRoot
- Manifest: bundle.manifest.json

> **Do not hand-edit files under bundle/**. Change manifest and re-run:
> ``powershell -File scripts/sync-domain-bundle.ps1 -SpecRoot <spec> -Domain $Domain``
"@ | Set-Content -Path (Join-Path $bundleRoot "SYNC-STAMP.md") -Encoding utf8

Write-Host "Done: domains/$Domain/bundle/ refreshed"
