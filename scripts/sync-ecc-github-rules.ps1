# Convert ECC nested rules (react-native/, web/) into Cursor flat *.mdc
# Usage: powershell -File scripts/sync-ecc-github-rules.ps1 [-EccRoot <path>]
# Default: sparse-clone affaan-m/ECC

param(
    [string]$EccRoot = "",
    [string]$BundleRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"
$tmp = $null
if (-not $EccRoot) {
    $tmp = Join-Path $env:TEMP ("ecc-rules-" + [guid]::NewGuid().ToString("n"))
    git clone --depth 1 --filter=blob:none --sparse https://github.com/affaan-m/ECC.git $tmp
    Push-Location $tmp
    git sparse-checkout set rules/react-native rules/web
    Pop-Location
    $EccRoot = $tmp
}

$DestRules = Join-Path $BundleRoot "rules"

function Convert-EccRuleToMdc {
    param($SrcFile, $DestName, $Description, $Globs, $OutDir)
    $raw = Get-Content $SrcFile -Raw -Encoding UTF8
    $body = [regex]::Replace($raw, '(?ms)^---\r?\npaths:.*?\r?\n---\r?\n', '')
    $body = $body -replace '\]\(\.\./common/([^)]+)\.md\)', '](./common-$1.mdc)'
    $front = @"
---
description: "$Description"
globs: "$Globs"
alwaysApply: false
---
"@
    $outPath = Join-Path $OutDir $DestName
    [System.IO.File]::WriteAllText($outPath, ($front + "`n" + $body.TrimStart()), [System.Text.UTF8Encoding]::new($false))
    Write-Host "wrote $DestName"
}

$rnGlobs = "**/*.{native,ios,android}.{ts,tsx}, **/app/**/*.tsx, **/screens/**/*.tsx, **/components/**/*.native.tsx"
$rnMap = @{
    'accessibility.md' = @('react-native-accessibility.mdc', 'React Native accessibility')
    'coding-style.md' = @('react-native-coding-style.mdc', 'React Native coding style')
    'hooks.md' = @('react-native-hooks.mdc', 'React Native hooks')
    'patterns.md' = @('react-native-patterns.mdc', 'React Native / Expo patterns')
    'performance.md' = @('react-native-performance.mdc', 'React Native performance')
    'production-readiness.md' = @('react-native-production.mdc', 'React Native production readiness')
    'security.md' = @('react-native-security.mdc', 'React Native security')
    'testing.md' = @('react-native-testing.mdc', 'React Native testing')
}
foreach ($k in $rnMap.Keys) {
    $pair = $rnMap[$k]
    Convert-EccRuleToMdc (Join-Path $EccRoot "rules\react-native\$k") $pair[0] $pair[1] $rnGlobs $DestRules
}

$webGlobs = "**/*.{css,scss,sass,less,html,tsx,jsx,vue,svelte}"
$webMap = @{
    'coding-style.md' = @('web-coding-style.mdc', 'Web frontend coding style')
    'design-quality.md' = @('web-design-quality.mdc', 'Web design quality')
    'hooks.md' = @('web-hooks.mdc', 'Web frontend hooks guidance')
    'patterns.md' = @('web-patterns.mdc', 'Web frontend patterns')
    'performance.md' = @('web-performance.mdc', 'Web runtime performance')
    'security.md' = @('web-security.mdc', 'Web frontend security')
    'testing.md' = @('web-testing.mdc', 'Web frontend testing')
}
foreach ($k in $webMap.Keys) {
    $pair = $webMap[$k]
    Convert-EccRuleToMdc (Join-Path $EccRoot "rules\web\$k") $pair[0] $pair[1] $webGlobs $DestRules
}

Write-Host "Done converting ECC react-native + web rules -> $DestRules"
if ($tmp) { Write-Host "Temp: $tmp" }
