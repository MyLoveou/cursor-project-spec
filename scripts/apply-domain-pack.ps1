# Merge one or more domain packs into an existing project's .cursor/

param(
    [Parameter(Mandatory = $true)]
    [string]$SpecRoot,
    [Parameter(Mandatory = $true)]
    [string]$ProjectRoot,
    [Parameter(Mandatory = $true)]
    [Alias("Domains")]
    [string[]]$Domain
)

$ErrorActionPreference = "Stop"

$SpecRoot = (Resolve-Path $SpecRoot).Path
$ProjectRoot = (Resolve-Path $ProjectRoot).Path
$CursorDest = Join-Path $ProjectRoot ".cursor"

if (-not (Test-Path $CursorDest)) {
    throw "Missing .cursor at $CursorDest — run bootstrap-project.ps1 first, or pass -Domain to bootstrap."
}

$MergeDirs = @("rules", "skills", "agents", "workflows", "evals")

function Assert-InstallableDomainId {
    param([string]$Id)
    if ([string]::IsNullOrWhiteSpace($Id)) {
        throw "Domain id is empty"
    }
    if ($Id.StartsWith("_")) {
        throw "Domain '$Id' is a scaffold (starts with _) and cannot be installed"
    }
    if ($Id -notmatch '^[a-z][a-z0-9-]*$') {
        throw "Domain id '$Id' must be kebab-case (e.g. notes, trade-ops)"
    }
}

function Merge-DomainTree {
    param(
        [string]$SourceRoot,
        [string]$DestRoot,
        [string]$DomainId
    )

    if (-not (Test-Path $DestRoot)) {
        New-Item -ItemType Directory -Force -Path $DestRoot | Out-Null
    }

    Get-ChildItem -Path $SourceRoot -Force | ForEach-Object {
        if ($_.Name -eq ".gitkeep") { return }
        $dest = Join-Path $DestRoot $_.Name
        if ($_.PSIsContainer) {
            Merge-DomainTree -SourceRoot $_.FullName -DestRoot $dest -DomainId $DomainId
            return
        }
        if (Test-Path $dest) {
            Write-Warning "[domain:$DomainId] overwrite $($_.Name) -> $dest"
        }
        Copy-Item -Force $_.FullName $dest
    }
}

function Install-DomainPack {
    param(
        [string]$SpecRoot,
        [string]$CursorDest,
        [string]$DomainId
    )

    Assert-InstallableDomainId -Id $DomainId
    $pack = Join-Path $SpecRoot "domains\$DomainId"
    if (-not (Test-Path $pack)) {
        throw "Domain pack not found: $pack (see domains/README.md)"
    }

    $meta = Join-Path $pack "DOMAIN.md"
    if (-not (Test-Path $meta)) {
        Write-Warning "[domain:$DomainId] missing DOMAIN.md"
    }

    $bundle = Join-Path $pack "bundle"
    $manifestPath = Join-Path $pack "bundle.manifest.json"
    if ((Test-Path $manifestPath) -and -not (Test-Path $bundle)) {
        Write-Warning "[domain:$DomainId] bundle.manifest.json present but bundle/ missing — run sync-domain-bundle.ps1 before solo install"
    }

    # 1) Vendored root runtime (bundle/) then 2) domain-native (domain wins on same path)
    foreach ($layer in @($bundle, $pack)) {
        if (-not (Test-Path $layer)) { continue }
        $label = if ($layer -eq $bundle) { "bundle" } else { "native" }
        foreach ($d in $MergeDirs) {
            $src = Join-Path $layer $d
            if (-not (Test-Path $src)) { continue }
            $dest = Join-Path $CursorDest $d
            Merge-DomainTree -SourceRoot $src -DestRoot $dest -DomainId $DomainId
            Write-Host "[domain:$DomainId] merged $label/$d/"
        }
    }

    $hooks = Join-Path $pack "hooks"
    if (Test-Path $hooks) {
        Write-Warning "[domain:$DomainId] hooks/ is ignored — keep hooks in repo root hooks/ only"
    }

    # Domain docs + templates → .cursor/domain-packs/<id>/ (not Cursor-scanned; Skills link here)
    $stampDir = Join-Path $CursorDest "domain-packs"
    $packDocsDest = Join-Path $stampDir $DomainId
    New-Item -ItemType Directory -Force -Path $packDocsDest | Out-Null

    $docNames = @("DOMAIN.md", "glossary.md", "taboos.md", "business-rules.md", "ui-interactions.md", "pending-decisions.md", "RETROSPECTIVE.md", "README.md", "bundle.manifest.json")
    foreach ($name in $docNames) {
        $docSrc = Join-Path $pack $name
        if (Test-Path $docSrc) {
            Copy-Item -Force $docSrc (Join-Path $packDocsDest $name)
            Write-Host "[domain:$DomainId] docs $($name)"
        }
    }

    $tplSrc = Join-Path $pack "templates"
    if (Test-Path $tplSrc) {
        $tplDest = Join-Path $packDocsDest "templates"
        if (Test-Path $tplDest) {
            Remove-Item -Recurse -Force $tplDest
        }
        Copy-Item -Recurse -Force $tplSrc $tplDest
        Write-Host "[domain:$DomainId] merged templates/ -> domain-packs/$DomainId/templates/"
    }

    $rootTplSrc = Join-Path $bundle "root-templates"
    if (Test-Path $rootTplSrc) {
        $rootTplDest = Join-Path $packDocsDest "root-templates"
        if (Test-Path $rootTplDest) {
            Remove-Item -Recurse -Force $rootTplDest
        }
        Copy-Item -Recurse -Force $rootTplSrc $rootTplDest
        Write-Host "[domain:$DomainId] merged bundle/root-templates/"
    }

    if (Test-Path (Join-Path $bundle "SYNC-STAMP.md")) {
        Copy-Item -Force (Join-Path $bundle "SYNC-STAMP.md") (Join-Path $packDocsDest "BUNDLE-SYNC-STAMP.md")
    }

    $overlay = Join-Path $pack "constraints.overlay.md"
    if (Test-Path $overlay) {
        $constraints = Join-Path $CursorDest "constraints.md"
        if (-not (Test-Path $constraints)) {
            throw "Missing $constraints — cannot append constraints.overlay.md"
        }
        $marker = "<!-- domain-pack:$DomainId -->"
        $existing = Get-Content -Raw -Path $constraints
        if ($existing -like "*$marker*") {
            Write-Warning "[domain:$DomainId] constraints.overlay already applied (marker present); skip append"
        }
        else {
            $block = "`r`n`r`n$marker`r`n" + (Get-Content -Raw -Path $overlay).TrimEnd() + "`r`n"
            Add-Content -Path $constraints -Value $block -Encoding utf8
            Write-Host "[domain:$DomainId] appended constraints.overlay.md"
        }
    }

    $stamp = Join-Path $stampDir "$DomainId.md"
    $when = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $hasBundle = Test-Path $bundle
    @"
# domain-pack: $DomainId

- Applied: $when
- Source: domains/$DomainId
- Bundle: $(if ($hasBundle) { "yes (vendored root skills/rules/agents)" } else { "no" })
- Meta: $(if (Test-Path $meta) { "DOMAIN.md" } else { "(missing)" })
- Docs: domain-packs/$DomainId/
"@ | Set-Content -Path $stamp -Encoding utf8
}

$unique = $Domain | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() } | Select-Object -Unique
if (-not $unique -or $unique.Count -eq 0) {
    throw "No domain ids provided"
}

foreach ($id in $unique) {
    Install-DomainPack -SpecRoot $SpecRoot -CursorDest $CursorDest -DomainId $id
}

Write-Host "Done: domain pack(s) [$($unique -join ', ')] -> $CursorDest"
