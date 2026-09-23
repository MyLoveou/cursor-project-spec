# generate.ps1 — Cursor rules + agents from unified sources.
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
if ($Target -ne "cursor") {
    throw "Only Cursor is supported (got '$Target'). OpenCode/Hermes generation is postponed."
}

$CursorOverrides = @{}
$CursorOverrides["common/project-core"] = "project-core.mdc"
$CursorOverrides["common/ai-execution"] = "ai-execution.mdc"
$CursorOverrides["common/workflow-triggers"] = "workflow-triggers.mdc"
$CursorOverrides["common/docs-maintenance"] = "docs-maintenance.mdc"
$CursorOverrides["java/api-contracts"] = "api-contracts.mdc"
$CursorOverrides["java/backend-spring"] = "backend-spring.mdc"
$CursorOverrides["vue/frontend-vue"] = "frontend-vue.mdc"
$CursorOverrides["react/frontend-react"] = "frontend-react.mdc"

function Write-OutputFile($Path, $Content, $Label) {
    if ($DryRun) { Write-Host "  [dry-run] $Label" -f DarkGray; return }
    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.UTF8Encoding]::new($false))
    Write-Host "  [ok] $Label"
}

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
    return @{ FM = $fm; Body = $body.Trim(); Raw = $raw }
}

$allRules = @()
Get-ChildItem -Path $RulesDir -Directory | ForEach-Object {
    $cat = $_.Name
    Get-ChildItem -Path $_.FullName -Filter "*.md" | ForEach-Object {
        $p = Parse-Frontmatter -Path $_.FullName
        $allRules += @{ Cat = $cat; Id = $_.BaseName; FM = $p.FM; Body = $p.Body }
    }
}

Write-Host "Loaded $($allRules.Count) rules"
Write-Host "--- cursor ---"

foreach ($r in $allRules) {
    $key = "$($r.Cat)/$($r.Id)"
    $fname = if ($CursorOverrides.ContainsKey($key)) { $CursorOverrides[$key] } else { "$($r.Cat)-$($r.Id).mdc" }
    $desc = $r.FM["description"]; $globs = $r.FM["globs"]; $always = $r.FM["alwaysApply"]
    $fmBlock = "---`n"
    if ($desc) { $fmBlock += "description: `"$desc`"`n" }
    if ($globs) { if ($globs -match '^\[') { $fmBlock += "globs: $globs`n" } else { $fmBlock += "globs: `"$globs`"`n" } }
    if ($always) { $fmBlock += "alwaysApply: $always`n" }
    $fmBlock += "---`n`n"
    Write-OutputFile (Join-Path $OutputDir ".cursor\rules\$fname") "$fmBlock$($r.Body)`n" "cursor rules/$fname"
}

if (Test-Path $AgentsDir) {
    Get-ChildItem -Path $AgentsDir -Filter "*.md" | ForEach-Object {
        $raw = Get-Content -Raw -Path $_.FullName -Encoding UTF8
        Write-OutputFile (Join-Path $OutputDir ".cursor\agents\$($_.Name)") $raw "cursor agents/$($_.Name)"
    }
}

if ($DryRun) { Write-Host "`n[Dry-run complete. No files written.]" -f Yellow }
else { Write-Host "`nDone. Output: $OutputDir" }
