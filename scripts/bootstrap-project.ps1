# Bootstrap: copy flat runtime dirs from spec repo -> target .cursor/
# Optional: merge domain pack(s) via apply-domain-pack.ps1

param(
    [Parameter(Mandatory = $true)]
    [string]$SpecRoot,
    [Parameter(Mandatory = $true)]
    [string]$ProjectRoot,
    [Parameter(Mandatory = $false)]
    [Alias("Domains")]
    [string[]]$Domain = @(),
    [Parameter(Mandatory = $false)]
    [string]$Target = "cursor"
)

$ErrorActionPreference = "Stop"

$SpecRoot = (Resolve-Path $SpecRoot).Path
$ProjectRoot = (Resolve-Path $ProjectRoot).Path
$CursorDest = Join-Path $ProjectRoot ".cursor"

switch ($Target) {
    "cursor" {
        if (Test-Path $CursorDest) {
            throw "Target already has .cursor: $CursorDest (remove or backup first)"
        }
        New-Item -ItemType Directory -Force -Path $CursorDest | Out-Null

        $CursorMappings = @{
            "cursor/rules"     = ".cursor/rules"
            "cursor/agents"    = ".cursor/agents"
            "cursor/hooks"     = ".cursor/hooks"
            "shared/skills"    = ".cursor/skills"
            "shared/workflows" = ".cursor/workflows"
            "shared/evals"     = ".cursor/evals"
        }
        foreach ($srcRel in $CursorMappings.Keys) {
            $src = Join-Path $SpecRoot $srcRel
            if (-not (Test-Path $src)) {
                throw "Missing runtime dir in spec repo: $src"
            }
            $dst = Join-Path $ProjectRoot $CursorMappings[$srcRel]
            Copy-Item -Recurse -Force $src $dst
        }

        $template = Join-Path $SpecRoot "constraints.md.template"
        if (-not (Test-Path $template)) {
            throw "Missing constraints.md.template: $template"
        }
        Copy-Item $template (Join-Path $CursorDest "constraints.md")

        Copy-Item (Join-Path $SpecRoot "templates\AGENTS.md.template") (Join-Path $ProjectRoot "AGENTS.md")

        $docsDirs = @(
            "docs/requirements/features",
            "docs/design/features",
            "docs/design/adr",
            "docs/product",
            "docs/standards"
        )
        foreach ($d in $docsDirs) {
            New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot $d) | Out-Null
        }

        $standardsTpl = Join-Path $SpecRoot "templates\docs-standards"
        if (Test-Path $standardsTpl) {
            Get-ChildItem $standardsTpl -Filter "*.md.template" | ForEach-Object {
                $destName = $_.BaseName + ".md"
                Copy-Item $_.FullName (Join-Path $ProjectRoot "docs\standards\$destName")
            }
        }
    }
    "opencode" {
        $opencodeSrc = Join-Path $SpecRoot "opencode"
        if (-not (Test-Path $opencodeSrc)) {
            throw "Missing opencode dir in spec repo: $opencodeSrc"
        }
        Get-ChildItem -Path $opencodeSrc -Force | ForEach-Object {
            $dest = Join-Path $ProjectRoot $_.Name
            if ($_.PSIsContainer) {
                if (Test-Path $dest) {
                    Remove-Item -Recurse -Force $dest -ErrorAction SilentlyContinue
                }
                Copy-Item -Recurse -Force $_.FullName $dest
            }
            else {
                if (($_.Name -eq "opencode.json") -and (Test-Path $dest)) {
                    $srcJson = Get-Content -Raw -Path $_.FullName | ConvertFrom-Json
                    $dstJson = Get-Content -Raw -Path $dest | ConvertFrom-Json
                    foreach ($prop in $srcJson.PSObject.Properties) {
                        $srcVal = $prop.Value
                        if ($dstJson.PSObject.Properties.Name -contains $prop.Name) {
                            $dstVal = $dstJson.$($prop.Name)
                            if ($srcVal -is [array] -and $dstVal -is [array]) {
                                $dstJson.$($prop.Name) = @($dstVal) + @($srcVal) | Select-Object -Unique
                            }
                            else {
                                $dstJson.$($prop.Name) = $srcVal
                            }
                        }
                        else {
                            $dstJson | Add-Member -MemberType NoteProperty -Name $prop.Name -Value $srcVal
                        }
                    }
                    $dstJson | ConvertTo-Json -Depth 10 | Set-Content -Path $dest -Encoding utf8
                    Write-Host "[opencode] merged opencode.json"
                }
                else {
                    Copy-Item -Force $_.FullName $dest
                }
            }
        }

        $sharedSkillsSrc = Join-Path $SpecRoot "shared\skills"
        if (Test-Path $sharedSkillsSrc) {
            $sharedSkillsDest = Join-Path $ProjectRoot "shared\skills"
            if (Test-Path $sharedSkillsDest) {
                Remove-Item -Recurse -Force $sharedSkillsDest -ErrorAction SilentlyContinue
            }
            New-Item -ItemType Directory -Force -Path (Split-Path $sharedSkillsDest -Parent) | Out-Null
            Copy-Item -Recurse -Force $sharedSkillsSrc $sharedSkillsDest
        }
    }
    "hermes" {
        $hermesHome = Join-Path $env:USERPROFILE ".hermes"

        $hermesRulesSrc = Join-Path $SpecRoot "hermes\rules"
        if (-not (Test-Path $hermesRulesSrc)) {
            throw "Missing hermes/rules in spec repo: $hermesRulesSrc"
        }
        $hermesRulesDest = Join-Path $hermesHome "rules\ecc"
        if (Test-Path $hermesRulesDest) {
            Remove-Item -Recurse -Force $hermesRulesDest -ErrorAction SilentlyContinue
        }
        New-Item -ItemType Directory -Force -Path $hermesRulesDest | Out-Null
        Copy-Item -Recurse -Force "$hermesRulesSrc\*" $hermesRulesDest

        $hermesAgentsSrc = Join-Path $SpecRoot "hermes\AGENTS.md"
        if (Test-Path $hermesAgentsSrc) {
            Copy-Item -Force $hermesAgentsSrc (Join-Path $hermesHome "AGENTS.md")
        }

        $sharedSkillsSrc = Join-Path $SpecRoot "shared\skills"
        if (Test-Path $sharedSkillsSrc) {
            $hermesSkillsDest = Join-Path $hermesHome "skills\ecc-imports"
            if (Test-Path $hermesSkillsDest) {
                Remove-Item -Recurse -Force $hermesSkillsDest -ErrorAction SilentlyContinue
            }
            New-Item -ItemType Directory -Force -Path $hermesSkillsDest | Out-Null
            Copy-Item -Recurse -Force "$sharedSkillsSrc\*" $hermesSkillsDest
        }
    }
    default {
        throw "Unknown target: $Target (use cursor, opencode, or hermes)"
    }
}

$domainIds = @($Domain | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() })
if ($domainIds.Count -gt 0) {
    & (Join-Path $PSScriptRoot "apply-domain-pack.ps1") `
        -SpecRoot $SpecRoot `
        -ProjectRoot $ProjectRoot `
        -Domain $domainIds `
        -Target $Target
}

Write-Host "Done: bootstrapped project for target '$Target'"
if ($Target -eq "cursor") {
    Write-Host "  Runtime dirs -> $CursorDest"
    Write-Host "  Edit .cursor/constraints.md and AGENTS.md placeholders."
}
if ($domainIds.Count -gt 0) {
    Write-Host "  Domain pack(s): $($domainIds -join ', ')"
}
