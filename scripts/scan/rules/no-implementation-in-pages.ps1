# no-implementation-in-pages.ps1 — 组合根扫描
# 规则源: rules/common/coding-style.md §组合根
# 检测: 页面/入口文件内出现业务函数声明
# 豁免: 纯视图逻辑（局部 state、格式化、无副作用派生、JSX 内联箭头）

param(
    [Parameter(Mandatory = $true)][string]$Root,
    [Parameter(Mandatory = $false)][string]$Severity = "ALL"
)

$ErrorActionPreference = "SilentlyContinue"
$ruleId = "no-impl-in-pages"
$Root = $Root.TrimEnd('\')
function Get-RelPath($full, $base) {
    if ($full.StartsWith($base + "\")) { return $full.Substring($base.Length + 1) }
    return $full
}

# 页面/入口文件判定路径模式（按项目调整）
$pageGlobs = @(
    '\.(tsx|vue)$'                      # 组件文件
)
$pagePathPatterns = @(
    '\\pages\\', '\\screens\\', '\\views\\', '\\components\\',
    '\\App\.(tsx|vue)$', '\\main\.(ts|tsx)$'
)

# 业务函数实现信号: function 声明 + 副作用调用（useQuery/useMutation/fetch/axios/http/DB/API）
$implPattern = '(export\s+)?(async\s+)?function\s+\w+\s*\([^)]*\)\s*\{'
$sideEffectPattern = '(useQuery|useMutation|fetch\(|axios\.|http\.(get|post|put|delete)|api\.(get|post|put|delete)|localStorage|sessionStorage)'

$count = 0
$files = Get-ChildItem $Root -Recurse -File -Include @("*.tsx", "*.vue") |
    Where-Object { $_.FullName -notmatch '\\(node_modules|dist|build|target|out|\.git|\.next|\.cursor|\.hermes|\.opencode|_references|shared\\skills)\\' }

foreach ($file in $files) {
    $rel = Get-RelPath $file.FullName $Root
    # 是页面/入口文件？
    $isPage = $false
    foreach ($pat in $pagePathPatterns) {
        if ($rel -match $pat) { $isPage = $true; break }
    }
    if (-not $isPage) { continue }

    $content = Get-Content $file.FullName -Raw
    $lines = Get-Content $file.FullName
    $inFn = $false; $fnStart = 0; $fnLine = ""; $braceDepth = 0; $fnHasSideEffect = $false; $fnLength = 0

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if (-not $inFn) {
            if ($line -match $implPattern) {
                $inFn = $true; $fnStart = $i + 1; $fnLine = $line.Trim(); $fnHasSideEffect = $false; $fnLength = 1
                $braceDepth = 0
            }
        }
        if ($inFn) {
            $braceDepth += ([regex]::Matches($line, '\{')).Count - ([regex]::Matches($line, '\}')).Count
            $fnLength++
            if ($line -match $sideEffectPattern) { $fnHasSideEffect = $true }
            if ($braceDepth -le 0 -and $line -match '\}') {
                # 函数结束：报告业务函数（有副作用或过长，且非纯视图）
                $isPureView = ($fnLength -le 3) -and (-not $fnHasSideEffect)
                if (($fnHasSideEffect -or $fnLength -gt 10) -and -not $isPureView) {
                    $fnName = if ($fnLine -match 'function\s+(\w+)') { $matches[1] } else { "(anonymous)" }
                    $fxNote = if ($fnHasSideEffect) { ", has side effect" } else { "" }
                    Write-Output "MEDIUM|$ruleId|${rel}:$fnStart|Page file implements function '$fnName' ($fnLength lines$fxNote) - move to service/hook"
                    $count++
                }
                $inFn = $false
            }
        }
    }
}
exit [Math]::Min($count, 255)
