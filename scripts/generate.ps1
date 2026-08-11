# generate.ps1
# Generate platform-specific rule + agent files from unified sources.
# Supports: cursor | opencode | hermes | all
param(
    [Parameter(Mandatory=$true)][string]$SpecRoot,
    [Parameter(Mandatory=$true)][string]$OutputDir,
    [Parameter(Mandatory=$false)][string]$Target = "cursor",
    [Parameter(Mandatory=$false)][switch]$DryRun
)
$ErrorActionPreference = "Stop"
$SpecRoot = (Resolve-Path $SpecRoot).Path
$RulesDir = Join-Path $SpecRoot "rules"
$AgentsDir = Join-Path $SpecRoot "agents"
if (-not (Test-Path $RulesDir)) { throw "Rules directory not found: $RulesDir" }

# ── Cursor filename overrides (rules without category- prefix) ──
$CursorOverrides = @{}
$CursorOverrides["common/project-core"] = "project-core.mdc"
$CursorOverrides["common/ai-execution"] = "ai-execution.mdc"
$CursorOverrides["common/workflow-triggers"] = "workflow-triggers.mdc"
$CursorOverrides["common/docs-maintenance"] = "docs-maintenance.mdc"
$CursorOverrides["java/api-contracts"] = "api-contracts.mdc"
$CursorOverrides["java/backend-spring"] = "backend-spring.mdc"
$CursorOverrides["vue/frontend-vue"] = "frontend-vue.mdc"
$CursorOverrides["react/frontend-react"] = "frontend-react.mdc"
$CursorOverrides["react-native/frontend-react-native"] = "frontend-react-native.mdc"

# ── Agent groups for Hermes AGENTS.md ──
$AgentGroups = @{
    Planning = @("planner","architect","product-manager","code-architect")
    Development = @("backend-dev","frontend-dev","frontend-rn-dev","frontend-vue-dev","code-explorer","code-simplifier")
    Review = @("code-reviewer","react-reviewer","vue-reviewer","java-reviewer","typescript-reviewer","security-reviewer","database-reviewer")
    Testing = @("tdd-guide","e2e-runner","qa-engineer","pr-test-analyzer")
    Operations = @("build-error-resolver","java-build-resolver","react-build-resolver","vue-build-resolver")
    Documentation = @("doc-sync","doc-updater")
    Other = @("refactor-cleaner","a11y-architect","marketing-agent")
}

# ── Path translation tables per platform ──
$PathTranslations = @{
    opencode = @{ ".cursor/rules/" = "opencode/rules/"; ".cursor/skills/" = "shared/skills/"; ".cursor/workflows/" = "shared/workflows/"; ".cursor/agents/" = "opencode/agents/"; ".cursor/constraints.md" = "constraints.md" }
    hermes   = @{ ".cursor/rules/" = "rules/ecc/"; ".cursor/skills/" = "skills/ecc-imports/"; ".cursor/workflows/" = "skills/ecc-imports/"; ".cursor/agents/" = ""; ".cursor/constraints.md" = "constraints.md" }
}

# ── Utility: write or simulate ──
function Write-OutputFile($Path, $Content, $Label) {
    if ($DryRun) { Write-Host "  [dry-run] $Label" -f DarkGray; return }
    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.UTF8Encoding]::new($false))
    Write-Host "  [ok] $Label"
}

# ── Parse YAML-like frontmatter ──────────────────────────
function Parse-Frontmatter($Path) {
    $raw = Get-Content -Raw -Path $Path -Encoding UTF8
    $lines = $raw -split "\n"
    $fm = @{}; $bodyStart = 0
    if ($lines.Count -gt 0 -and $lines[0].Trim() -eq "---") {
        for ($i = 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i].Trim() -eq "---") { $bodyStart = $i + 1; break }
            $line = $lines[$i].Trim()
            if ($line -match '^([^:]+):\s*(.*)$') {
                $key = $matches[1].Trim()
                $val = $matches[2].Trim() -replace '^"|"$' -replace "^'|'$"
                if ($val -match '^\[(.+)\]$') { $val = $matches[1] -replace '"', '' -replace "'", '' }
                $fm[$key] = $val
            }
        }
    }
    $body = ($lines[$bodyStart..($lines.Count - 1)] | Where-Object { $_ -ne $null }) -join "`n"
    return @{ FM = $fm; Body = $body.Trim() }
}

# ── Translate .cursor/ paths in body for target platform ──
function Transform-Body($body, $target) {
    if ($target -eq "cursor") { return $body }
    $trans = $PathTranslations[$target]
    if (-not $trans) { return $body }
    $result = $body
    foreach ($from in $trans.Keys) {
        $to = $trans[$from]
        # Escape for regex: . and / are literal
        $escapedFrom = [regex]::Escape($from)
        $result = $result -replace $escapedFrom, $to
    }
    # Clean up double slashes from empty replacement
    $result = $result -replace '//+', '/'
    return $result
}

# ── Collectors ───────────────────────────────────────────
function Get-Rules {
    $all = @()
    Get-ChildItem -Path $RulesDir -Directory | ForEach-Object {
        $cat = $_.Name
        Get-ChildItem -Path $_.FullName -Filter "*.md" | ForEach-Object {
            $p = Parse-Frontmatter -Path $_.FullName
            $all += @{ Cat = $cat; Id = $_.BaseName; FM = $p.FM; Body = $p.Body }
        }
    }
    return $all
}
function Get-Agents {
    $all = @()
    if (Test-Path $AgentsDir) {
        Get-ChildItem -Path $AgentsDir -Filter "*.md" | ForEach-Object {
            $p = Parse-Frontmatter -Path $_.FullName
            $all += @{ Id = $_.BaseName; FM = $p.FM; Body = $p.Body }
        }
    }
    return $all
}

# ═══════════════════════════════════════════════════════════
#  RULE GENERATORS
# ═══════════════════════════════════════════════════════════

function Gen-CursorRules($rules, $out) {
    foreach ($r in $rules) {
        $key = "$($r.Cat)/$($r.Id)"
        $fname = if ($CursorOverrides.ContainsKey($key)) { $CursorOverrides[$key] } else { "$($r.Cat)-$($r.Id).mdc" }
        $desc = $r.FM["description"]; $globs = $r.FM["globs"]; $always = $r.FM["alwaysApply"]
        $fmBlock = "---`n"
        if ($desc) { $fmBlock += "description: `"$desc`"`n" }
        if ($globs) { if ($globs -match '^\[') { $fmBlock += "globs: $globs`n" } else { $fmBlock += "globs: `"$globs`"`n" } }
        if ($always) { $fmBlock += "alwaysApply: $always`n" }
        $fmBlock += "---`n`n"
        $content = "$fmBlock$($r.Body)`n"
        Write-OutputFile (Join-Path $out ".cursor\rules\$fname") $content "cursor rules/$fname"
    }
}

function Gen-OpenCodeRules($rules, $out, $target="opencode") {
    $cats = @{}
    foreach ($r in $rules) { if (-not $cats.ContainsKey($r.Cat)) { $cats[$r.Cat] = @() }; $cats[$r.Cat] += $r }
    foreach ($cat in $cats.Keys | Sort-Object) {
        $parts = @("# $cat Rules`n", "> Auto-generated from unified rules. Do not edit directly.`n")
        foreach ($r in $cats[$cat]) {
            $body = Transform-Body -body $r.Body -target $target
            $parts += "`n---`n`n$body`n"
        }
        Write-OutputFile (Join-Path $out "opencode\rules\$cat.md") ($parts -join "") "opencode rules/$cat.md"
    }
}

function Gen-HermesRules($rules, $out, $target="hermes") {
    foreach ($r in $rules) {
        $body = Transform-Body -body $r.Body -target $target
        Write-OutputFile (Join-Path $out "rules\ecc\$($r.Cat)\$($r.Id).md") "$body`n" "hermes rules/$($r.Cat)/$($r.Id).md"
    }
}

# ═══════════════════════════════════════════════════════════
#  AGENT GENERATORS
# ═══════════════════════════════════════════════════════════

function Gen-CursorAgents($agents, $out) {
    foreach ($a in $agents) {
        Write-OutputFile (Join-Path $out ".cursor\agents\$($a.Id).md") "$($a.Body)`n" "cursor agents/$($a.Id).md"
    }
}

function Gen-OpenCodeAgents($agents, $out) {
    foreach ($a in $agents) {
        Write-OutputFile (Join-Path $out "opencode\agents\$($a.Id).txt") "$($a.Body)`n" "opencode agents/$($a.Id).txt"
    }
}

function Gen-HermesAgents($agents, $out) {
    $lines = @("# ECC Agent Instructions`n", "`n## Available Agents`n")
    foreach ($a in $agents | Sort-Object { $_.Id }) {
        $name = $a.FM["name"]; if (-not $name) { $name = $a.Id }
        $desc = $a.FM["description"]; if (-not $desc) { $desc = "" }
        $tools = $a.FM["tools"]; if (-not $tools) { $tools = "Read, Grep, Glob" }
        $lines += "`n### $name`n"
        $lines += "- **Purpose**: $desc`n"
        $lines += "- **Tools**: $tools`n"
    }
    $lines += "`n## Agent Groups`n"
    foreach ($grpName in $AgentGroups.Keys) {
        $lines += "`n### $grpName`n$($AgentGroups[$grpName] -join ', ')`n"
    }
    $lines += @"
`n## Agent Orchestration`n
`nUse agents proactively:`n
- Complex features -> planner`n
- Code just written -> code-reviewer`n
- Bug fix / new feature -> tdd-guide`n
- Security-sensitive code -> security-reviewer`n
- Architectural decisions -> architect`n
- Build failures -> build-error-resolver (or java-build-resolver / react-build-resolver / vue-build-resolver)`n
- Database changes -> database-reviewer`n
- E2E testing -> e2e-runner`n
- React code changed -> react-reviewer`n
- Vue code changed -> vue-reviewer`n
- Java code changed -> java-reviewer`n
- TypeScript code changed -> typescript-reviewer`n
- Documentation sync -> doc-sync`n
- Dead code cleanup -> refactor-cleaner`n
- Accessibility -> a11y-architect`n
"@
    Write-OutputFile (Join-Path $out "hermes\AGENTS.md") ($lines -join "") "hermes AGENTS.md ($($agents.Count) agents)"
}

# ═══════════════════════════════════════════════════════════
#  MAIN
# ═══════════════════════════════════════════════════════════

$allRules = Get-Rules
$allAgents = Get-Agents
Write-Host "Loaded $($allRules.Count) rules + $($allAgents.Count) agents"

$targets = if ($Target -eq "all") { @("cursor", "opencode", "hermes") } else { @($Target) }
foreach ($t in $targets) {
    Write-Host "--- $t ---"
    switch ($t) {
        "cursor"   { Gen-CursorRules $allRules $OutputDir; Gen-CursorAgents $allAgents $OutputDir }
        "opencode" { Gen-OpenCodeRules $allRules $OutputDir $t; Gen-OpenCodeAgents $allAgents $OutputDir }
        "hermes"   { Gen-HermesRules $allRules $OutputDir $t; Gen-HermesAgents $allAgents $OutputDir }
        default    { throw "Unknown target: $t (use cursor, opencode, hermes, or all)" }
    }
}
if ($DryRun) { Write-Host "`n[Dry-run complete. No files written.]" -f Yellow }
else { Write-Host "`nDone. Output: $OutputDir" }
