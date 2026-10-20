# file-size.ps1 — 文件行数扫描
# 规则源: rules/common/coding-style.md §File Organization
# 检测: 单文件超过 800 行（>400 行提示）

param(
    [Parameter(Mandatory = $true)][string]$Root,
    [Parameter(Mandatory = $false)][string]$Severity = "ALL"
)

$ErrorActionPreference = "SilentlyContinue"
$ruleId = "file-size"
$Root = $Root.TrimEnd('\')
function Get-RelPath($full, $base) {
    if ($full.StartsWith($base + "\")) { return $full.Substring($base.Length + 1) }
    return $full
}
$extensions = @("*.ts", "*.tsx", "*.js", "*.jsx", "*.vue", "*.java", "*.kt", "*.py", "*.css", "*.scss")

$count = 0
$files = Get-ChildItem $Root -Recurse -File -Include $extensions |
    Where-Object { $_.FullName -notmatch '\\(node_modules|dist|build|target|out|\.git|\.next|\.cursor|\.hermes|\.opencode|_references|shared\\skills)\\' }

foreach ($file in $files) {
    $lines = (Get-Content $file.FullName | Measure-Object -Line).Lines
    if ($lines -gt 800) {
        $rel = Get-RelPath $file.FullName $Root
        Write-Output "HIGH|$ruleId|${rel}:1|File has $lines lines, exceeds 800-line limit, should be split"
        $count++
    } elseif ($lines -gt 400) {
        $rel = Get-RelPath $file.FullName $Root
        Write-Output "LOW|$ruleId|${rel}:1|File has $lines lines, exceeds 400-line comfort zone"
        $count++
    }
}
exit [Math]::Min($count, 255)
