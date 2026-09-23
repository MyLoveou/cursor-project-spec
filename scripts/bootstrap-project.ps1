# bootstrap-project.ps1 — Deploy Cursor runtime from this spec repo.
#
# Usage:
#   bootstrap-project.ps1 -SpecRoot <spec> -ProjectRoot <project>
#   bootstrap-project.ps1 -SpecRoot <spec> -ProjectRoot <project> -Domain enterprise-cert

param(
    [Parameter(Mandatory = $true)]
    [string]$SpecRoot,
    [Parameter(Mandatory = $true)]
    [string]$ProjectRoot,
    [Parameter(Mandatory = $false)]
    [Alias("Domains")]
    [string[]]$Domain = @()
)

$ErrorActionPreference = "Stop"
$SpecRoot = (Resolve-Path $SpecRoot).Path
$ProjectRoot = (Resolve-Path $ProjectRoot).Path

Write-Host "Spec root:    $SpecRoot"
Write-Host "Project root: $ProjectRoot"
Write-Host "Target:       cursor`n"

$generatorScript = Join-Path $specRoot "scripts\generate.ps1"
if (-not (Test-Path $generatorScript)) {
    throw "generate.ps1 not found: $generatorScript"
}

Write-Host "[cursor] generating rules + agents..."
& $generatorScript -SpecRoot $SpecRoot -OutputDir $ProjectRoot -Target cursor

$cursorDest = Join-Path $ProjectRoot ".cursor"

Write-Host "[cursor] copying shared resources..."
$skillsSrc = Join-Path $SpecRoot "shared\skills"
if (Test-Path $skillsSrc) {
    $skillsDest = Join-Path $cursorDest "skills"
    if (Test-Path $skillsDest) { Remove-Item -Recurse -Force $skillsDest -ErrorAction SilentlyContinue }
    Copy-Item -Recurse -Force $skillsSrc $skillsDest
}
$wfSrc = Join-Path $SpecRoot "shared\workflows"
if (Test-Path $wfSrc) {
    $wfDest = Join-Path $cursorDest "workflows"
    if (Test-Path $wfDest) { Remove-Item -Recurse -Force $wfDest -ErrorAction SilentlyContinue }
    Copy-Item -Recurse -Force $wfSrc $wfDest
}
$evalsSrc = Join-Path $SpecRoot "shared\evals"
if (Test-Path $evalsSrc) {
    $evalsDest = Join-Path $cursorDest "evals"
    if (Test-Path $evalsDest) { Remove-Item -Recurse -Force $evalsDest -ErrorAction SilentlyContinue }
    Copy-Item -Recurse -Force $evalsSrc $evalsDest
}
$hooksSrc = Join-Path $SpecRoot "platforms\cursor\hooks"
if (Test-Path $hooksSrc) {
    $hooksDest = Join-Path $cursorDest "hooks"
    if (Test-Path $hooksDest) { Remove-Item -Recurse -Force $hooksDest -ErrorAction SilentlyContinue }
    Copy-Item -Recurse -Force $hooksSrc $hooksDest
}
$mcpSrc = Join-Path $SpecRoot "mcp"
if (Test-Path $mcpSrc) {
    $mcpDocDest = Join-Path $cursorDest "mcp"
    New-Item -ItemType Directory -Force -Path $mcpDocDest | Out-Null
    Get-ChildItem $mcpSrc -File | Where-Object { $_.Name -ne "mcp.json" -and $_.Name -ne ".gitignore" } | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $mcpDocDest $_.Name) -Force
    }
    $mcpJsonDest = Join-Path $cursorDest "mcp.json"
    $mcpJsonSrc = Join-Path $mcpSrc "mcp.json"
    if ((Test-Path $mcpJsonSrc) -and -not (Test-Path $mcpJsonDest)) {
        Copy-Item $mcpJsonSrc $mcpJsonDest
        Write-Host "[cursor] wrote .cursor/mcp.json (fill REPLACE_* for ssh; install codegraph + uvx)"
    } elseif (Test-Path $mcpJsonDest) {
        Write-Host "[cursor] keep existing .cursor/mcp.json (merge git/ssh/codegraph from spec mcp/mcp.json if needed)"
    }
}
$constraintsTpl = Join-Path $SpecRoot "constraints.md.template"
if (Test-Path $constraintsTpl) {
    Copy-Item $constraintsTpl (Join-Path $cursorDest "constraints.md")
}
$agentsTpl = Join-Path $SpecRoot "templates\AGENTS.md.template"
if (Test-Path $agentsTpl) {
    Copy-Item $agentsTpl (Join-Path $ProjectRoot "AGENTS.md")
}
$docsDirs = @("docs/requirements/features", "docs/design/features", "docs/design/adr", "docs/product", "docs/standards")
foreach ($d in $docsDirs) {
    New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot $d) | Out-Null
}
$tplDir = Join-Path $SpecRoot "shared\skills\project-spec\templates"
$productCopies = @{
    "baseline.md"  = "docs\product\baseline.md"
    "facts.md"     = "docs\product\facts.md"
    "decisions.md" = "docs\product\decisions.md"
}
foreach ($pair in $productCopies.GetEnumerator()) {
    $src = Join-Path $tplDir $pair.Name
    $dest = Join-Path $ProjectRoot $pair.Value
    if ((Test-Path $src) -and -not (Test-Path $dest)) {
        Copy-Item $src $dest
        Write-Host "[cursor] wrote $($pair.Value)"
    }
}
$stdTpl = Join-Path $SpecRoot "templates\docs-standards"
if (Test-Path $stdTpl) {
    Get-ChildItem $stdTpl -Filter "*.md.template" | ForEach-Object {
        $destName = $_.BaseName + ".md"
        Copy-Item $_.FullName (Join-Path $ProjectRoot "docs\standards\$destName")
    }
}

$domainIds = @($Domain | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() })
if ($domainIds.Count -gt 0) {
    $applyScript = Join-Path $SpecRoot "scripts\apply-domain-pack.ps1"
    if (-not (Test-Path $applyScript)) {
        Write-Host "[warn] apply-domain-pack.ps1 not found, skipping domain packs"
    } else {
        foreach ($d in $domainIds) {
            Write-Host "`n--- Applying domain pack: $d ---"
            & $applyScript -SpecRoot $SpecRoot -ProjectRoot $ProjectRoot -Domain $d
        }
    }
}

Write-Host "`nDone. Edit .cursor/constraints.md and AGENTS.md placeholders."
