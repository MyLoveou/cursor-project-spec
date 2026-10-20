# no-console.ps1 — 调试残留扫描
# 规则源: rules/common/coding-style.md §调试残留
# 检测: console.log / console.debug / debugger / TODO 标记
# 豁免: 行内注释 "scan-ignore: reason"

param(
    [Parameter(Mandatory = $true)][string]$Root,
    [Parameter(Mandatory = $false)][string]$Severity = "ALL"
)

$ErrorActionPreference = "SilentlyContinue"
$ruleId = "no-console"
$Root = $Root.TrimEnd('\')
function Get-RelPath($full, $base) {
    if ($full.StartsWith($base + "\")) { return $full.Substring($base.Length + 1) }
    return $full
}
$extensions = @("*.ts", "*.tsx", "*.js", "*.jsx", "*.vue", "*.java", "*.kt", "*.py")
$patterns = @(
    @{ Pattern = 'console\.(log|debug|warn)'; Name = "console debug output" },
    @{ Pattern = '\bdebugger\b'; Name = "debugger breakpoint" },
    @{ Pattern = '//\s*TODO|#\s*TODO|<!--\s*TODO'; Name = "TODO residual marker" }
)

$count = 0
$files = Get-ChildItem $Root -Recurse -File -Include $extensions |
    Where-Object { $_.FullName -notmatch '\\(node_modules|dist|build|target|out|\.git|\.next|\.cursor|\.hermes|\.opencode|_references|shared\\skills)\\' }

foreach ($file in $files) {
    $lineNo = 0
    foreach ($line in Get-Content $file.FullName) {
        $lineNo++
        foreach ($p in $patterns) {
            if ($line -match $p.Pattern -and $line -notmatch 'scan-ignore') {
                $rel = Get-RelPath $file.FullName $Root
                Write-Output "HIGH|$ruleId|${rel}:$lineNo|$($p.Name)"
                $count++
            }
        }
    }
}
exit [Math]::Min($count, 255)
