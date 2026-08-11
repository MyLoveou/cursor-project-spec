1|# bootstrap-project.ps1 — Bootstrap project with unified rules
2|#
3|# Auto-detects platform(s) or accepts explicit -Target.
4|# Calls generate.ps1 for rule generation, then copies shared + platform files.
5|#
6|# Usage:
7|#   bootstrap-project.ps1 -SpecRoot <spec> -ProjectRoot <project>
8|#   bootstrap-project.ps1 -SpecRoot <spec> -ProjectRoot <project> -Target all
9|#   bootstrap-project.ps1 -SpecRoot <spec> -ProjectRoot <project> -Domain enterprise-cert
10|
11|param(
12|    [Parameter(Mandatory = $true)]
13|    [string]$SpecRoot,
14|    [Parameter(Mandatory = $true)]
15|    [string]$ProjectRoot,
16|    [Parameter(Mandatory = $false)]
17|    [Alias("Domains")]
18|    [string[]]$Domain = @(),
19|    [Parameter(Mandatory = $false)]
20|    [string]$Target = "auto"
21|)
22|
23|$ErrorActionPreference = "Stop"
24|$SpecRoot = (Resolve-Path $SpecRoot).Path
25|$ProjectRoot = (Resolve-Path $ProjectRoot).Path
26|
27|# ── Auto-detect platforms ──────────────────────────────────
28|function Detect-Platforms($projectRoot) {
29|    $detected = @()
30|    if (Test-Path (Join-Path $projectRoot ".cursor")) {
31|        $detected += "cursor"
32|        Write-Host "[detect] .cursor/ found"
33|    }
34|    if (Test-Path (Join-Path $projectRoot "opencode.json")) {
35|        $detected += "opencode"
36|        Write-Host "[detect] opencode.json found"
37|    }
38|    if (Test-Path (Join-Path $projectRoot ".hermes")) {
39|        $detected += "hermes"
40|        Write-Host "[detect] .hermes/ found"
41|    }
42|    # Also check global Hermes config
43|    $hermesGlobal = Join-Path $env:USERPROFILE ".hermes\config.yaml"
44|    if ((Test-Path $hermesGlobal) -and ($detected -notcontains "hermes")) {
45|        $detected += "hermes"
46|        Write-Host "[detect] ~/.hermes/config.yaml found"
47|    }
48|    return $detected
49|}
50|
51|function Deploy-Platform($target, $specRoot, $projectRoot) {
52|    Write-Host "`n=== Deploying: $target ==="
53|    $generatorScript = Join-Path $specRoot "scripts\generate.ps1"
54|    if (-not (Test-Path $generatorScript)) {
55|        throw "generate.ps1 not found: $generatorScript"
56|    }
57|
58|    # 1. Generate platform-specific rules
59|    Write-Host "[$target] generating rules..."
60|    & $generatorScript -SpecRoot $specRoot -OutputDir $projectRoot -Target $target
61|
62|    # 2. Copy shared resources (skills, workflows, evals)
63|    Write-Host "[$target] copying shared resources..."
64|    switch ($target) {
65|        "cursor" {
66|            $cursorDest = Join-Path $projectRoot ".cursor"
67|            # Skills
68|            $skillsSrc = Join-Path $specRoot "shared\skills"
69|            if (Test-Path $skillsSrc) {
70|                $skillsDest = Join-Path $cursorDest "skills"
71|                if (Test-Path $skillsDest) { Remove-Item -Recurse -Force $skillsDest -ErrorAction SilentlyContinue }
72|                Copy-Item -Recurse -Force $skillsSrc $skillsDest
73|            }
74|            # Workflows
75|            $wfSrc = Join-Path $specRoot "shared\workflows"
76|            if (Test-Path $wfSrc) {
77|                $wfDest = Join-Path $cursorDest "workflows"
78|                if (Test-Path $wfDest) { Remove-Item -Recurse -Force $wfDest -ErrorAction SilentlyContinue }
79|                Copy-Item -Recurse -Force $wfSrc $wfDest
80|            }
81|            # Evals
82|            $evalsSrc = Join-Path $specRoot "shared\evals"
83|            if (Test-Path $evalsSrc) {
84|                $evalsDest = Join-Path $cursorDest "evals"
85|                if (Test-Path $evalsDest) { Remove-Item -Recurse -Force $evalsDest -ErrorAction SilentlyContinue }
86|                Copy-Item -Recurse -Force $evalsSrc $evalsDest
87|            }
88|            # Hooks
89|            $hooksSrc = Join-Path $specRoot "platforms\cursor\hooks"
90|            if (Test-Path $hooksSrc) {
91|                $hooksDest = Join-Path $cursorDest "hooks"
92|                if (Test-Path $hooksDest) { Remove-Item -Recurse -Force $hooksDest -ErrorAction SilentlyContinue }
93|                Copy-Item -Recurse -Force $hooksSrc $hooksDest
94|            }
95|            # Constraints template
96|            $constraintsTpl = Join-Path $specRoot "constraints.md.template"
97|            if (Test-Path $constraintsTpl) {
98|                Copy-Item $constraintsTpl (Join-Path $cursorDest "constraints.md")
99|            }
100|            # AGENTS.md template
101|            $agentsTpl = Join-Path $specRoot "templates\AGENTS.md.template"
102|            if (Test-Path $agentsTpl) {
103|                Copy-Item $agentsTpl (Join-Path $projectRoot "AGENTS.md")
104|            }
105|            # Docs directories
106|            $docsDirs = @("docs/requirements/features", "docs/design/features", "docs/design/adr", "docs/product", "docs/standards")
107|            foreach ($d in $docsDirs) {
108|                New-Item -ItemType Directory -Force -Path (Join-Path $projectRoot $d) | Out-Null
109|            }
110|            # Standards templates
111|            $stdTpl = Join-Path $specRoot "templates\docs-standards"
112|            if (Test-Path $stdTpl) {
113|                Get-ChildItem $stdTpl -Filter "*.md.template" | ForEach-Object {
114|                    $destName = $_.BaseName + ".md"
115|                    Copy-Item $_.FullName (Join-Path $projectRoot "docs\standards\$destName")
116|                }
117|            }
118|        }
119|        "opencode" {
120|            # opencode.json
121|            $jsonSrc = Join-Path $specRoot "platforms\opencode\opencode.json"
122|            $jsonDest = Join-Path $projectRoot "opencode.json"
123|            if (Test-Path $jsonSrc) {
124|                if (Test-Path $jsonDest) {
125|                    Write-Host "[opencode] opencode.json exists — merge manually if needed"
126|                } else {
127|                    Copy-Item $jsonSrc $jsonDest
128|                }
129|            }
130|            # Platform-only agents (e.g., build.txt — primary agent)
131|            $agentsSrc = Join-Path $specRoot "platforms\opencode\agents"
132|            if (Test-Path $agentsSrc) {
133|                $agentsDest = Join-Path $projectRoot "opencode\agents"
134|                if (Test-Path $agentsDest) { Remove-Item -Recurse -Force $agentsDest -ErrorAction SilentlyContinue }
135|                New-Item -ItemType Directory -Force -Path (Split-Path $agentsDest -Parent) | Out-Null
136|                Copy-Item -Recurse -Force $agentsSrc $agentsDest
137|            }
138|            # Commands
139|            $cmdsSrc = Join-Path $specRoot "platforms\opencode\commands"
140|            if (Test-Path $cmdsSrc) {
141|                $cmdsDest = Join-Path $projectRoot "opencode\commands"
142|                if (Test-Path $cmdsDest) { Remove-Item -Recurse -Force $cmdsDest -ErrorAction SilentlyContinue }
143|                Copy-Item -Recurse -Force $cmdsSrc $cmdsDest
144|            }
145|            # Shared skills
146|            $skillsSrc = Join-Path $specRoot "shared\skills"
147|            if (Test-Path $skillsSrc) {
148|                $skillsDest = Join-Path $projectRoot "shared\skills"
149|                if (Test-Path $skillsDest) { Remove-Item -Recurse -Force $skillsDest -ErrorAction SilentlyContinue }
150|                New-Item -ItemType Directory -Force -Path (Split-Path $skillsDest -Parent) | Out-Null
151|                Copy-Item -Recurse -Force $skillsSrc $skillsDest
152|            }
153|            # Shared workflows
154|            $wfSrc = Join-Path $specRoot "shared\workflows"
155|            if (Test-Path $wfSrc) {
156|                $wfDest = Join-Path $projectRoot "shared\workflows"
157|                if (Test-Path $wfDest) { Remove-Item -Recurse -Force $wfDest -ErrorAction SilentlyContinue }
158|                Copy-Item -Recurse -Force $wfSrc $wfDest
159|            }
160|        }
161|        "hermes" {
162|            $hermesHome = Join-Path $env:USERPROFILE ".hermes"
163|            # Skills (into ecc-imports)
164|            $skillsSrc = Join-Path $specRoot "shared\skills"
165|            if (Test-Path $skillsSrc) {
166|                $skillsDest = Join-Path $hermesHome "skills\ecc-imports"
167|                if (Test-Path $skillsDest) { Remove-Item -Recurse -Force $skillsDest -ErrorAction SilentlyContinue }
168|                New-Item -ItemType Directory -Force -Path $skillsDest | Out-Null
169|                Copy-Item -Recurse -Force (Join-Path $skillsSrc "*") $skillsDest
170|            }
171|            # AGENTS.md (generated by generate.ps1)
172|            $genAgents = Join-Path $projectRoot "hermes\AGENTS.md"
173|            if (Test-Path $genAgents) {
174|                Copy-Item -Force $genAgents (Join-Path $hermesHome "AGENTS.md")
175|                Remove-Item -Force $genAgents
176|                Remove-Item -Force (Join-Path $projectRoot "hermes") -ErrorAction SilentlyContinue
177|            }
178|            # Rules (generated by generate.ps1 to $projectRoot/rules/ecc/)
179|            # Copy them to ~/.hermes/rules/ecc/
180|            $genRules = Join-Path $projectRoot "rules\ecc"
181|            if (Test-Path $genRules) {
182|                $hermesRulesDest = Join-Path $hermesHome "rules\ecc"
183|                if (Test-Path $hermesRulesDest) { Remove-Item -Recurse -Force $hermesRulesDest -ErrorAction SilentlyContinue }
184|                New-Item -ItemType Directory -Force -Path $hermesRulesDest | Out-Null
185|                Copy-Item -Recurse -Force (Join-Path $genRules "*") $hermesRulesDest
186|                # Clean up temporary generated rules in project
187|                Remove-Item -Recurse -Force (Join-Path $projectRoot "rules") -ErrorAction SilentlyContinue
188|            }
189|        }
190|    }
191|    Write-Host "[$target] done."
192|}
193|
194|# ── Main ───────────────────────────────────────────────────
195|Write-Host "Spec root:   $SpecRoot"
196|Write-Host "Project root: $ProjectRoot"
197|Write-Host "Target:      $Target`n"
198|
199|# Resolve target(s)
200|$targets = @()
201|if ($Target -eq "auto") {
202|    $targets = Detect-Platforms -projectRoot $ProjectRoot
203|    if ($targets.Count -eq 0) {
204|        Write-Host "[warn] No platform detected. Defaulting to 'cursor'."
205|        $targets = @("cursor")
206|    }
207|    Write-Host "[auto] deploying to: $($targets -join ', ')"
208|} elseif ($Target -eq "all") {
209|    $targets = @("cursor", "opencode", "hermes")
210|} else {
211|    $valid = @("cursor", "opencode", "hermes")
212|    if ($valid -notcontains $Target) {
213|        throw "Unknown target: $Target (use cursor, opencode, hermes, all, or auto)"
214|    }
215|    $targets = @($Target)
216|}
217|
218|foreach ($t in $targets) {
219|    Deploy-Platform -target $t -specRoot $SpecRoot -projectRoot $ProjectRoot
220|}
221|
222|# Apply domain packs
223|$domainIds = @($Domain | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() })
224|if ($domainIds.Count -gt 0) {
225|    $applyScript = Join-Path $SpecRoot "scripts\apply-domain-pack.ps1"
226|    if (-not (Test-Path $applyScript)) {
227|        Write-Host "[warn] apply-domain-pack.ps1 not found, skipping domain packs"
228|    } else {
229|        foreach ($d in $domainIds) {
230|            Write-Host "`n--- Applying domain pack: $d ---"
231|            & $applyScript -SpecRoot $SpecRoot -ProjectRoot $ProjectRoot -Domain $d -Target $targets[0]
232|        }
233|    }
234|}
235|
236|Write-Host "`nDone! Bootstrapped $($targets.Count) platform(s): $($targets -join ', ')"
237|if ($targets -contains "cursor") {
238|    Write-Host "  Edit .cursor/constraints.md and AGENTS.md placeholders."
239|}
240|