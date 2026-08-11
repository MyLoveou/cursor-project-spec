# bootstrap-project.ps1 — Bootstrap project with unified rules
#
# Auto-detects platform(s) or accepts explicit -Target.
# Calls generate.ps1 for rule generation, then copies shared + platform files.
#
# Usage:
#   bootstrap-project.ps1 -SpecRoot <spec> -ProjectRoot <project>
#   bootstrap-project.ps1 -SpecRoot <spec> -ProjectRoot <project> -Target all
#   bootstrap-project.ps1 -SpecRoot <spec> -ProjectRoot <project> -Domain enterprise-cert

param(
    [Parameter(Mandatory = $true)]
    [string]$SpecRoot,
    [Parameter(Mandatory = $true)]
    [string]$ProjectRoot,
    [Parameter(Mandatory = $false)]
    [Alias("Domains")]
    [string[]]$Domain = @(),
    [Parameter(Mandatory = $false)]
    [string]$Target = "auto"
)

$ErrorActionPreference = "Stop"
$SpecRoot = (Resolve-Path $SpecRoot).Path
$ProjectRoot = (Resolve-Path $ProjectRoot).Path

# ── Auto-detect platforms ──────────────────────────────────
function Detect-Platforms($projectRoot) {
    $detected = @()
    if (Test-Path (Join-Path $projectRoot ".cursor")) {
        $detected += "cursor"
        Write-Host "[detect] .cursor/ found"
    }
    if (Test-Path (Join-Path $projectRoot "opencode.json")) {
        $detected += "opencode"
        Write-Host "[detect] opencode.json found"
    }
    if (Test-Path (Join-Path $projectRoot ".hermes")) {
        $detected += "hermes"
        Write-Host "[detect] .hermes/ found"
    }
    # Also check global Hermes config
    $hermesGlobal = Join-Path $env:USERPROFILE ".hermes\config.yaml"
    if ((Test-Path $hermesGlobal) -and ($detected -notcontains "hermes")) {
        $detected += "hermes"
        Write-Host "[detect] ~/.hermes/config.yaml found"
    }
    return $detected
}

function Deploy-Platform($target, $specRoot, $projectRoot) {
    Write-Host "`n=== Deploying: $target ==="
    $generatorScript = Join-Path $specRoot "scripts\generate.ps1"
    if (-not (Test-Path $generatorScript)) {
        throw "generate.ps1 not found: $generatorScript"
    }

    # 1. Generate platform-specific rules
    Write-Host "[$target] generating rules..."
    & $generatorScript -SpecRoot $specRoot -OutputDir $projectRoot -Target $target

    # 2. Copy shared resources (skills, workflows, evals)
    Write-Host "[$target] copying shared resources..."
    switch ($target) {
        "cursor" {
            $cursorDest = Join-Path $projectRoot ".cursor"
            # Skills
            $skillsSrc = Join-Path $specRoot "shared\skills"
            if (Test-Path $skillsSrc) {
                $skillsDest = Join-Path $cursorDest "skills"
                if (Test-Path $skillsDest) { Remove-Item -Recurse -Force $skillsDest -ErrorAction SilentlyContinue }
                Copy-Item -Recurse -Force $skillsSrc $skillsDest
            }
            # Workflows
            $wfSrc = Join-Path $specRoot "shared\workflows"
            if (Test-Path $wfSrc) {
                $wfDest = Join-Path $cursorDest "workflows"
                if (Test-Path $wfDest) { Remove-Item -Recurse -Force $wfDest -ErrorAction SilentlyContinue }
                Copy-Item -Recurse -Force $wfSrc $wfDest
            }
            # Evals
            $evalsSrc = Join-Path $specRoot "shared\evals"
            if (Test-Path $evalsSrc) {
                $evalsDest = Join-Path $cursorDest "evals"
                if (Test-Path $evalsDest) { Remove-Item -Recurse -Force $evalsDest -ErrorAction SilentlyContinue }
                Copy-Item -Recurse -Force $evalsSrc $evalsDest
            }
            # Hooks
            $hooksSrc = Join-Path $specRoot "platforms\cursor\hooks"
            if (Test-Path $hooksSrc) {
                $hooksDest = Join-Path $cursorDest "hooks"
                if (Test-Path $hooksDest) { Remove-Item -Recurse -Force $hooksDest -ErrorAction SilentlyContinue }
                Copy-Item -Recurse -Force $hooksSrc $hooksDest
            }
            # Constraints template
            $constraintsTpl = Join-Path $specRoot "constraints.md.template"
            if (Test-Path $constraintsTpl) {
                Copy-Item $constraintsTpl (Join-Path $cursorDest "constraints.md")
            }
            # AGENTS.md template
            $agentsTpl = Join-Path $specRoot "templates\AGENTS.md.template"
            if (Test-Path $agentsTpl) {
                Copy-Item $agentsTpl (Join-Path $projectRoot "AGENTS.md")
            }
            # Docs directories
            $docsDirs = @("docs/requirements/features", "docs/design/features", "docs/design/adr", "docs/product", "docs/standards")
            foreach ($d in $docsDirs) {
                New-Item -ItemType Directory -Force -Path (Join-Path $projectRoot $d) | Out-Null
            }
            # Standards templates
            $stdTpl = Join-Path $specRoot "templates\docs-standards"
            if (Test-Path $stdTpl) {
                Get-ChildItem $stdTpl -Filter "*.md.template" | ForEach-Object {
                    $destName = $_.BaseName + ".md"
                    Copy-Item $_.FullName (Join-Path $projectRoot "docs\standards\$destName")
                }
            }
        }
        "opencode" {
            # opencode.json
            $jsonSrc = Join-Path $specRoot "platforms\opencode\opencode.json"
            $jsonDest = Join-Path $projectRoot "opencode.json"
            if (Test-Path $jsonSrc) {
                if (Test-Path $jsonDest) {
                    Write-Host "[opencode] opencode.json exists — merge manually if needed"
                } else {
                    Copy-Item $jsonSrc $jsonDest
                }
            }
            # Platform-only agents (e.g., build.txt — primary agent)
            $agentsSrc = Join-Path $specRoot "platforms\opencode\agents"
            if (Test-Path $agentsSrc) {
                $agentsDest = Join-Path $projectRoot "opencode\agents"
                if (Test-Path $agentsDest) { Remove-Item -Recurse -Force $agentsDest -ErrorAction SilentlyContinue }
                New-Item -ItemType Directory -Force -Path (Split-Path $agentsDest -Parent) | Out-Null
                Copy-Item -Recurse -Force $agentsSrc $agentsDest
            }
            # Commands
            $cmdsSrc = Join-Path $specRoot "platforms\opencode\commands"
            if (Test-Path $cmdsSrc) {
                $cmdsDest = Join-Path $projectRoot "opencode\commands"
                if (Test-Path $cmdsDest) { Remove-Item -Recurse -Force $cmdsDest -ErrorAction SilentlyContinue }
                Copy-Item -Recurse -Force $cmdsSrc $cmdsDest
            }
            # Shared skills
            $skillsSrc = Join-Path $specRoot "shared\skills"
            if (Test-Path $skillsSrc) {
                $skillsDest = Join-Path $projectRoot "shared\skills"
                if (Test-Path $skillsDest) { Remove-Item -Recurse -Force $skillsDest -ErrorAction SilentlyContinue }
                New-Item -ItemType Directory -Force -Path (Split-Path $skillsDest -Parent) | Out-Null
                Copy-Item -Recurse -Force $skillsSrc $skillsDest
            }
            # Shared workflows
            $wfSrc = Join-Path $specRoot "shared\workflows"
            if (Test-Path $wfSrc) {
                $wfDest = Join-Path $projectRoot "shared\workflows"
                if (Test-Path $wfDest) { Remove-Item -Recurse -Force $wfDest -ErrorAction SilentlyContinue }
                Copy-Item -Recurse -Force $wfSrc $wfDest
            }
        }
        "hermes" {
            $hermesHome = Join-Path $env:USERPROFILE ".hermes"
            # Skills (into ecc-imports)
            $skillsSrc = Join-Path $specRoot "shared\skills"
            if (Test-Path $skillsSrc) {
                $skillsDest = Join-Path $hermesHome "skills\ecc-imports"
                if (Test-Path $skillsDest) { Remove-Item -Recurse -Force $skillsDest -ErrorAction SilentlyContinue }
                New-Item -ItemType Directory -Force -Path $skillsDest | Out-Null
                Copy-Item -Recurse -Force (Join-Path $skillsSrc "*") $skillsDest
            }
            # AGENTS.md (generated by generate.ps1)
            $genAgents = Join-Path $projectRoot "hermes\AGENTS.md"
            if (Test-Path $genAgents) {
                Copy-Item -Force $genAgents (Join-Path $hermesHome "AGENTS.md")
                Remove-Item -Force $genAgents
                Remove-Item -Force (Join-Path $projectRoot "hermes") -ErrorAction SilentlyContinue
            }
            # Rules (generated by generate.ps1 to $projectRoot/rules/ecc/)
            # Copy them to ~/.hermes/rules/ecc/
            $genRules = Join-Path $projectRoot "rules\ecc"
            if (Test-Path $genRules) {
                $hermesRulesDest = Join-Path $hermesHome "rules\ecc"
                if (Test-Path $hermesRulesDest) { Remove-Item -Recurse -Force $hermesRulesDest -ErrorAction SilentlyContinue }
                New-Item -ItemType Directory -Force -Path $hermesRulesDest | Out-Null
                Copy-Item -Recurse -Force (Join-Path $genRules "*") $hermesRulesDest
                # Clean up temporary generated rules in project
                Remove-Item -Recurse -Force (Join-Path $projectRoot "rules") -ErrorAction SilentlyContinue
            }
        }
    }
    Write-Host "[$target] done."
}

# ── Main ───────────────────────────────────────────────────
Write-Host "Spec root:   $SpecRoot"
Write-Host "Project root: $ProjectRoot"
Write-Host "Target:      $Target`n"

# Resolve target(s)
$targets = @()
if ($Target -eq "auto") {
    $targets = Detect-Platforms -projectRoot $ProjectRoot
    if ($targets.Count -eq 0) {
        Write-Host "[warn] No platform detected. Defaulting to 'cursor'."
        $targets = @("cursor")
    }
    Write-Host "[auto] deploying to: $($targets -join ', ')"
} elseif ($Target -eq "all") {
    $targets = @("cursor", "opencode", "hermes")
} else {
    $valid = @("cursor", "opencode", "hermes")
    if ($valid -notcontains $Target) {
        throw "Unknown target: $Target (use cursor, opencode, hermes, all, or auto)"
    }
    $targets = @($Target)
}

foreach ($t in $targets) {
    Deploy-Platform -target $t -specRoot $SpecRoot -projectRoot $ProjectRoot
}

# Apply domain packs
$domainIds = @($Domain | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() })
if ($domainIds.Count -gt 0) {
    $applyScript = Join-Path $SpecRoot "scripts\apply-domain-pack.ps1"
    if (-not (Test-Path $applyScript)) {
        Write-Host "[warn] apply-domain-pack.ps1 not found, skipping domain packs"
    } else {
        foreach ($d in $domainIds) {
            Write-Host "`n--- Applying domain pack: $d ---"
            & $applyScript -SpecRoot $SpecRoot -ProjectRoot $ProjectRoot -Domain $d -Target $targets[0]
        }
    }
}

Write-Host "`nDone! Bootstrapped $($targets.Count) platform(s): $($targets -join ', ')"
if ($targets -contains "cursor") {
    Write-Host "  Edit .cursor/constraints.md and AGENTS.md placeholders."
}
