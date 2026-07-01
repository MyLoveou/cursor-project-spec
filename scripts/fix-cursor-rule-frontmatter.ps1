# Fix ECC stack rules: paths -> globs (Cursor .mdc frontmatter)
$rulesDir = Join-Path (Split-Path $PSScriptRoot -Parent) "rules"
Get-ChildItem $rulesDir -Filter "*.mdc" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw -Encoding UTF8
    if ($content -notmatch '(?ms)^---\r?\npaths:\r?\n((?:  - .+\r?\n)+)---') {
        return
    }
    $pathsBlock = $Matches[1]
    $paths = [regex]::Matches($pathsBlock, '- "(.+)"') | ForEach-Object { $_.Groups[1].Value }
    $globs = ($paths -join ', ')
    $title = if ($content -match '(?m)^# (.+)') { $Matches[1].Trim() } else { $_.BaseName }
    $body = ($content -replace '(?ms)^---\r?\n.*?\r?\n---\r?\n', '')
    $newFront = "---`ndescription: `"$title`"`nglobs: `"$globs`"`nalwaysApply: false`n---`n"
    Set-Content -Path $_.FullName -Value ($newFront + $body) -Encoding UTF8 -NoNewline
    Write-Host "fixed: $($_.Name)"
}
