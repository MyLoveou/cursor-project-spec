# Bootstrap: copy flat runtime dirs from spec repo -> target .cursor/

param(
    [Parameter(Mandatory = $true)]
    [string]$SpecRoot,
    [Parameter(Mandatory = $true)]
    [string]$ProjectRoot
)

$ErrorActionPreference = "Stop"

$SpecRoot = (Resolve-Path $SpecRoot).Path
$ProjectRoot = (Resolve-Path $ProjectRoot).Path
$CursorDest = Join-Path $ProjectRoot ".cursor"

$RuntimeDirs = @("rules", "skills", "agents", "hooks", "workflows", "evals")

if (Test-Path $CursorDest) {
    throw "Target already has .cursor: $CursorDest (remove or backup first)"
}

New-Item -ItemType Directory -Force -Path $CursorDest | Out-Null

foreach ($d in $RuntimeDirs) {
    $src = Join-Path $SpecRoot $d
    if (-not (Test-Path $src)) {
        throw "Missing runtime dir in spec repo: $src"
    }
    Copy-Item -Recurse -Force $src (Join-Path $CursorDest $d)
}

$template = Join-Path $SpecRoot "constraints.md.template"
if (-not (Test-Path $template)) {
    throw "Missing constraints.md.template: $template"
}
Copy-Item $template (Join-Path $CursorDest "constraints.md")

Copy-Item (Join-Path $SpecRoot "templates\AGENTS.md.template") (Join-Path $ProjectRoot "AGENTS.md")

$docsDirs = @(
    "docs/requirements/features",
    "docs/design/features",
    "docs/design/adr",
    "docs/product",
    "docs/standards"
)
foreach ($d in $docsDirs) {
    New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot $d) | Out-Null
}

$standardsTpl = Join-Path $SpecRoot "templates\docs-standards"
if (Test-Path $standardsTpl) {
    Get-ChildItem $standardsTpl -Filter "*.md.template" | ForEach-Object {
        $destName = $_.BaseName + ".md"
        Copy-Item $_.FullName (Join-Path $ProjectRoot "docs\standards\$destName")
    }
}

Write-Host "Done: runtime dirs -> $CursorDest + AGENTS.md + docs skeleton"
Write-Host "Edit .cursor/constraints.md and AGENTS.md placeholders."
