# scan-assemble.ps1 — 规范扫描组装脚本
#
# 自动发现 scripts/scan/rules/*.ps1 中的全部扫描器并依次运行，
# 聚合输出为 Markdown 报告。新增规范扫描器 = 在 rules/ 下新增一个 .ps1，
# 本脚本无需修改。
#
# 用法:
#   powershell -File scripts/scan/scan-assemble.ps1 -Root "E:\项目\YourApp" [-Severity HIGH] [-Fix]
#
# 扫描器约定（每个 rules/*.ps1 必须遵守）:
#   1. 接受 -Root <path> 参数（扫描根目录）
#   2. 输出违规行，格式: "SEV|rule-id|file:line|message"
#   3. 通过 exit code 返回违规数（0 = 无违规）

param(
    [Parameter(Mandatory = $true)][string]$Root,
    [Parameter(Mandatory = $false)][string]$Severity = "ALL",
    [Parameter(Mandatory = $false)][switch]$Fix,
    [Parameter(Mandatory = $false)][switch]$Json
)

$ErrorActionPreference = "Continue"
$Root = (Resolve-Path $Root).Path
$RulesDir = Join-Path $PSScriptRoot "rules"
$ReportFile = Join-Path $PSScriptRoot "scan-report.md"

if (-not (Test-Path $RulesDir)) { throw "Scanner directory not found: $RulesDir" }

$scanners = Get-ChildItem $RulesDir -Filter "*.ps1" | Sort-Object Name
if ($scanners.Count -eq 0) { Write-Host "[scan] no scanners found in $RulesDir"; exit 0 }

Write-Host "[scan] assembling $($scanners.Count) scanners over $Root" -f Cyan

$allViolations = @()
foreach ($s in $scanners) {
    Write-Host "  [run] $($s.BaseName)" -f DarkGray
    $output = & $s.FullName -Root $Root -Severity $Severity 2>&1
    foreach ($line in $output) {
        $text = "$line"
        if ($text -match '^([A-Z]+)\|([^|]+)\|([^|]+)\|(.*)$') {
            $allViolations += [PSCustomObject]@{
                Severity = $matches[1]
                RuleId   = $matches[2]
                Location = $matches[3]
                Message  = $matches[4]
            }
        } elseif ($text -notmatch '^\[') {
            Write-Host "  [warn] non-standard output from $($s.BaseName): $text" -f Yellow
        }
    }
}

# 按严重级排序
$sevOrder = @{ CRITICAL = 0; HIGH = 1; MEDIUM = 2; LOW = 3; INFO = 4 }
$sorted = $allViolations | Sort-Object { $sevOrder[$_.Severity] }, RuleId, Location

$bySeverity = $sorted | Group-Object Severity
Write-Host ""
Write-Host "[scan] summary:" -f Cyan
foreach ($g in $bySeverity) {
    Write-Host ("  {0,-9} {1}" -f $g.Name, $g.Count) -f $(switch ($g.Name) { "CRITICAL" { "Red" } "HIGH" { "Red" } "MEDIUM" { "Yellow" } "LOW" { "DarkYellow" } default { "Gray" } })
}

# Markdown 报告
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# Scan Report")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("- Root: ``$Root``")
[void]$sb.AppendLine("- Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
[void]$sb.AppendLine("- Scanners: $($scanners.Count)")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## Summary")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("| Severity | Count |")
[void]$sb.AppendLine("|----------|-------|")
if ($bySeverity.Count -eq 0) {
    [void]$sb.AppendLine("| (none) | 0 |")
} else {
    foreach ($g in $bySeverity) { [void]$sb.AppendLine("| $($g.Name) | $($g.Count) |") }
}
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## Violations")
[void]$sb.AppendLine("")
if ($sorted.Count -eq 0) {
    [void]$sb.AppendLine("*No violations found.*")
} else {
    [void]$sb.AppendLine("| Severity | Rule | Location | Message |")
    [void]$sb.AppendLine("|----------|------|----------|---------|")
    foreach ($v in $sorted) {
        $loc = $v.Location -replace '\|', '\|'
        $msg = $v.Message -replace '\|', '\|'
        [void]$sb.AppendLine("| $($v.Severity) | $($v.RuleId) | $loc | $msg |")
    }
}
$content = $sb.ToString()
[System.IO.File]::WriteAllText($ReportFile, $content, [System.Text.UTF8Encoding]::new($false))
Write-Host ""
Write-Host "[scan] report written: $ReportFile" -f Cyan

if ($Json) {
    $sorted | ConvertTo-Json -Depth 3 | Write-Output
}

$total = $sorted.Count
exit [Math]::Min($total, 255)
