# Sync ECC agents/rules/skills into spec repo (flat layout)
# Primary: clone sparse from GitHub ECC; fallback: ~/.cursor
# Usage:
#   powershell -File scripts/sync-ecc-bundle.ps1
#   powershell -File scripts/sync-ecc-bundle.ps1 -FromGitHub

param(
    [string]$EccRoot = (Join-Path $env:USERPROFILE ".cursor"),
    [string]$BundleRoot = (Split-Path $PSScriptRoot -Parent),
    [switch]$FromGitHub
)

$ErrorActionPreference = "Stop"

$DestAgents = Join-Path $BundleRoot "agents"
$DestRules = Join-Path $BundleRoot "rules"
$DestSkills = Join-Path $BundleRoot "skills"

$AgentNames = @(
    "java-reviewer", "java-build-resolver",
    "react-reviewer", "react-build-resolver", "typescript-reviewer",
    "security-reviewer", "database-reviewer",
    "code-explorer", "code-architect", "architect", "planner", "doc-updater",
    "code-reviewer", "build-error-resolver", "code-simplifier", "tdd-guide",
    "e2e-runner", "pr-test-analyzer", "refactor-cleaner",
    "marketing-agent", "a11y-architect"
)

$RulePrefixes = @("common-", "java-", "react-", "typescript-", "vue-", "react-native-", "web-")

# Skills maintained from ECC (P0–P2 + existing product/design)
$SkillNames = @(
    "market-research", "deep-research", "research-ops",
    "product-capability", "blueprint",
    "frontend-design-direction", "make-interfaces-feel-better",
    "ui-to-vue",
    "react-native-patterns", "frontend-patterns", "react-performance", "frontend-a11y", "nextjs-turbopack",
    "orch-pipeline", "orch-add-feature", "orch-build-mvp", "orch-change-feature", "orch-fix-defect", "orch-refine-code",
    "plan-orchestrate", "team-agent-orchestration",
    "architecture-decision-records", "agent-architecture-audit", "hexagonal-architecture",
    "parallel-execution-optimizer", "autonomous-loops", "continuous-agent-loop", "production-audit",
    "cost-aware-llm-pipeline", "cost-tracking", "documentation-lookup",
    "api-design", "backend-patterns", "strategic-compact", "continuous-learning-v2"
)

New-Item -ItemType Directory -Force -Path $DestAgents, $DestRules, $DestSkills | Out-Null

if ($FromGitHub) {
    $tmp = Join-Path $env:TEMP ("ecc-sync-" + [guid]::NewGuid().ToString("n"))
    Write-Host "Cloning affaan-m/ECC (sparse) -> $tmp"
    git clone --depth 1 --filter=blob:none --sparse https://github.com/affaan-m/ECC.git $tmp
    Push-Location $tmp
    $sparse = @("agents", "rules/react", "rules/react-native", "rules/web", "rules/common", "rules/typescript", "rules/java") + ($SkillNames | ForEach-Object { "skills/$_" })
    git sparse-checkout set @sparse
    Pop-Location
    $EccRoot = $tmp
}

$EccAgents = Join-Path $EccRoot "agents"
$EccRules = Join-Path $EccRoot "rules"
$EccSkills = Join-Path $EccRoot "skills"

# Agents from ~/.cursor use ecc-*.md naming; from GitHub clone use plain names
$copiedAgents = 0
if (Test-Path $EccAgents) {
    foreach ($name in $AgentNames) {
        $candidates = @(
            (Join-Path $EccAgents ("ecc-" + $name + ".md")),
            (Join-Path $EccAgents ($name + ".md"))
        )
        $src = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
        if (-not $src) {
            Write-Warning "skip agent: $name"
            continue
        }
        Copy-Item -Force $src (Join-Path $DestAgents ($name + ".md"))
        $copiedAgents++
    }
}

$copiedRules = 0
if (Test-Path $EccRules) {
    # Flat .mdc already in bundle (from ~/.cursor) OR nested ECC dirs
    Get-ChildItem $EccRules -Filter "*.mdc" -ErrorAction SilentlyContinue | ForEach-Object {
        $base = $_.Name
        $match = $false
        foreach ($prefix in $RulePrefixes) {
            if ($base.StartsWith($prefix)) { $match = $true; break }
        }
        if ($match) {
            Copy-Item -Force $_.FullName (Join-Path $DestRules $base)
            $copiedRules++
        }
    }
    Write-Host "Note: nested ECC rules/react-native & rules/web need Convert via sync-ecc-github-rules.ps1 if refreshing from GitHub tree."
}

$copiedSkills = 0
if (Test-Path $EccSkills) {
    foreach ($name in $SkillNames) {
        $src = Join-Path $EccSkills $name
        if (-not (Test-Path $src)) {
            Write-Warning "skip skill: $name"
            continue
        }
        $dest = Join-Path $DestSkills $name
        if (Test-Path $dest) {
            Remove-Item -Recurse -Force $dest
        }
        Copy-Item -Recurse -Force $src $dest
        $copiedSkills++
    }
}

Write-Host "Done: $copiedAgents agents, $copiedRules flat rules, $copiedSkills skills -> $BundleRoot"

if ($FromGitHub -and (Test-Path $tmp)) {
    Write-Host "Temp clone left at $tmp (delete manually if desired)"
}
