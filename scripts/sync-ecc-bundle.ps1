# Sync ECC agents/rules/skills from ~/.cursor into spec repo root (flat layout)
# Usage: powershell -File scripts/sync-ecc-bundle.ps1

param(
    [string]$EccRoot = (Join-Path $env:USERPROFILE ".cursor"),
    [string]$BundleRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"

$EccAgents = Join-Path $EccRoot "agents"
$EccRules = Join-Path $EccRoot "rules"
$EccSkills = Join-Path $EccRoot "skills"
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

$RulePrefixes = @("common-", "java-", "react-", "typescript-", "vue-")

$SkillNames = @(
    "market-research", "deep-research", "research-ops",
    "product-capability", "blueprint",
    "frontend-design-direction", "make-interfaces-feel-better",
    "ui-to-vue"
)

if (-not (Test-Path $EccAgents)) {
    throw "ECC agents dir missing: $EccAgents"
}

New-Item -ItemType Directory -Force -Path $DestAgents, $DestRules, $DestSkills | Out-Null

$copiedAgents = 0
foreach ($name in $AgentNames) {
    $srcName = "ecc-" + $name + ".md"
    $src = Join-Path $EccAgents $srcName
    if (-not (Test-Path $src)) {
        Write-Warning "skip agent: $srcName"
        continue
    }
    $destName = $name + ".md"
    Copy-Item -Force $src (Join-Path $DestAgents $destName)
    $copiedAgents++
}

$copiedRules = 0
if (Test-Path $EccRules) {
    Get-ChildItem $EccRules -Filter "*.mdc" | ForEach-Object {
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

Write-Host "Done: $copiedAgents agents, $copiedRules rules, $copiedSkills skills -> $BundleRoot"
