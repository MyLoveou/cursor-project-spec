# Bootstrap target project (copy .cursor only)

param(
    [Parameter(Mandatory = $true)]
    [string]$SpecRoot,
    [Parameter(Mandatory = $true)]
    [string]$ProjectRoot
)

$ErrorActionPreference = "Stop"

$SpecRoot = (Resolve-Path $SpecRoot).Path
$ProjectRoot = (Resolve-Path $ProjectRoot).Path
$CursorSrc = Join-Path $SpecRoot ".cursor"
$CursorDest = Join-Path $ProjectRoot ".cursor"

if (-not (Test-Path $CursorSrc)) {
    throw "Missing .cursor in spec repo: $CursorSrc"
}

if (Test-Path $CursorDest) {
    throw "Target already has .cursor: $CursorDest (remove or backup first)"
}

Copy-Item -Recurse -Force $CursorSrc $CursorDest

Copy-Item (Join-Path $SpecRoot ".cursor\constraints.md.template") (Join-Path $CursorDest "constraints.md")
Copy-Item (Join-Path $SpecRoot "templates\AGENTS.md.template") (Join-Path $ProjectRoot "AGENTS.md")

$docsDirs = @(
    "docs/requirements/features",
    "docs/design/adr",
    "docs/product"
)
foreach ($d in $docsDirs) {
    New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot $d) | Out-Null
}

Write-Host "Done: .cursor + AGENTS.md + docs skeleton -> $ProjectRoot"
Write-Host "Edit .cursor/constraints.md and AGENTS.md placeholders."
