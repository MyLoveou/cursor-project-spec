# Install a self-contained domain pack folder into a project's .cursor/
# Use when you only copied domains/<id>/ (including bundle/) to the business repo.

param(
    [Parameter(Mandatory = $true)]
    [string]$PackRoot,
    [Parameter(Mandatory = $true)]
    [string]$ProjectRoot,
    [Parameter(Mandatory = $false)]
    [switch]$CreateCursorIfMissing
)

$ErrorActionPreference = "Stop"

$PackRoot = (Resolve-Path $PackRoot).Path
$ProjectRoot = (Resolve-Path $ProjectRoot).Path
$CursorDest = Join-Path $ProjectRoot ".cursor"

if (-not (Test-Path (Join-Path $PackRoot "DOMAIN.md")) -and -not (Test-Path (Join-Path $PackRoot "bundle.manifest.json"))) {
    throw "PackRoot does not look like a domain pack (need DOMAIN.md or bundle.manifest.json): $PackRoot"
}

if (-not (Test-Path $CursorDest)) {
    if (-not $CreateCursorIfMissing) {
        throw "Missing .cursor at $CursorDest (pass -CreateCursorIfMissing to create empty runtime dirs)"
    }
    New-Item -ItemType Directory -Force -Path $CursorDest | Out-Null
    foreach ($d in @("rules", "skills", "agents", "hooks", "workflows", "evals")) {
        New-Item -ItemType Directory -Force -Path (Join-Path $CursorDest $d) | Out-Null
    }
    "# constraints`r`n" | Set-Content (Join-Path $CursorDest "constraints.md") -Encoding utf8
    Write-Host "Created minimal .cursor at $CursorDest"
}

# Reuse apply-domain-pack by staging pack as domains/<id> under a temp SpecRoot
$domainId = $null
$manifestPath = Join-Path $PackRoot "bundle.manifest.json"
if (Test-Path $manifestPath) {
    $domainId = (Get-Content -Raw -Encoding utf8 $manifestPath | ConvertFrom-Json).domainId
}
if (-not $domainId) {
    $domainId = Split-Path $PackRoot -Leaf
}
if ($domainId -notmatch '^[a-z][a-z0-9-]*$') {
    throw "Cannot infer domain id from pack; set domainId in bundle.manifest.json"
}

$stage = Join-Path $env:TEMP ("domain-pack-stage-" + [guid]::NewGuid().ToString("n"))
$stageDomains = Join-Path $stage "domains"
New-Item -ItemType Directory -Force -Path (Join-Path $stageDomains $domainId) | Out-Null
Copy-Item -Recurse -Force "$PackRoot\*" (Join-Path $stageDomains $domainId)

try {
    & (Join-Path $PSScriptRoot "apply-domain-pack.ps1") `
        -SpecRoot $stage `
        -ProjectRoot $ProjectRoot `
        -Domain $domainId
}
finally {
    Remove-Item -Recurse -Force $stage -ErrorAction SilentlyContinue
}
