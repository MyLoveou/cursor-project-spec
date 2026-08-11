1|# 目录结构（规范库 vs 业务项目）
2|
3|> 多平台规范库：规则统一在 `rules/`，通过 `generate.ps1` 生成各平台格式。
4|> 三平台共享：`agents/`、`shared/`。平台特有：`platforms/`。
5|
6|---
7|
8|## 规范库（本仓库）
9|
10|```
11|项目规范/
12|├── rules/                  # ★ 统一规则源（唯一真源）
13|│   ├── common/             project-core, coding-style, security, testing...
14|│   ├── java/               api-contracts, backend-spring, coding-style...
15|│   ├── typescript/         coding-style, hooks, patterns...
16|│   ├── vue/                coding-style, composables, frontend-vue...
17|│   ├── react/              coding-style, hooks, frontend-react...
18|│   ├── react-native/       accessibility, coding-style, hooks...
19|│   └── web/                coding-style, design-quality, performance...
20|├── agents/                 Agent 定义 · .md 格式（所有平台共享）
21|├── shared/                 # 三平台共享
22|│   ├── skills/             58 个 SKILL.md
23|│   ├── workflows/          6 个工作流剧本
24|│   └── evals/              EDD eval 示例
25|├── platforms/              # 平台特有配置
26|│   ├── cursor/hooks/       hooks.json
27|│   ├── opencode/           opencode.json, agents/*.txt, commands/
28|│   └── hermes/             AGENTS.md
29|├── domains/                # 业务域配置包
30|├── templates/              # Bootstrap 占位符
31|├── scripts/                # 生成/部署/同步
32|│   ├── generate.ps1        # 统一规则 → 平台格式
33|│   ├── bootstrap-project.ps1     # 自动检测 + 一键部署
34|│   └── apply-domain-pack.ps1     # 叠加域包
35|└── README.md · AGENTS.md · BOOTSTRAP.md · STRUCTURE.md
36|```
37|
38|### 规则统一格式
39|
40|每条规则一个 `.md` 文件，YAML frontmatter 携带元数据：
41|
42|```markdown
43|---
44|id: coding-style
45|category: vue
46|description: "Vue Coding Style"
47|globs: "**/*.vue, **/components/**/*.vue"
48|alwaysApply: false
49|---
50|# Vue Coding Style
51|
52|...规则正文...
53|```
54|
55|| 字段 | 用途 | 适用平台 |
56||------|------|----------|
57|| `id` | 规则标识（文件名） | 所有 |
58|| `category` | 分类目录 | 所有 |
59|| `description` | 规则描述 | 所有 |
60|| `globs` | 文件路径触发 | 仅 Cursor |
61|| `alwaysApply` | 始终生效 | 仅 Cursor |
62|
63|### 生成规则
64|
65|| 平台 | 命令 | 输出 |
66||------|------|------|
67|| Cursor | `generate.ps1 -Target cursor` | `.cursor/rules/*.mdc` + `.cursor/agents/*.md` |
68|| OpenCode | `generate.ps1 -Target opencode` | `opencode/rules/{category}.md` + `opencode/agents/*.txt` |
69|| Hermes | `generate.ps1 -Target hermes` | `rules/ecc/**/*.md` + `AGENTS.md` |
70|| 全部 | `generate.ps1 -Target all` | 以上全部 |
71|
72|### Agent 统一格式
73|
74|Agent 统一源为 `agents/{name}.md`（Cursor 格式，YAML frontmatter + Markdown body）。
75|
76|| 平台 | 产出方式 |
77||------|----------|
78|| Cursor | 原样复制 `.md` 文件 |
79|| OpenCode | 去 frontmatter，输出 `.txt` |
80|| Hermes | 提取 frontmatter 生成 `AGENTS.md` 索引 |
81|
82|---
83|
84|## 业务项目（部署后布局）
85|
86|### Cursor
87|
88|| 规范库 | 业务项目 |
89||--------|----------|
90|| `rules/` → 生成 | `.cursor/rules/*.mdc` |
91|| `agents/` → 生成 | `.cursor/agents/*.md` |
92|| `platforms/cursor/hooks/` | `.cursor/hooks/hooks.json` |
93|| `shared/skills/` | `.cursor/skills/` |
94|| `shared/workflows/` | `.cursor/workflows/` |
95|| `shared/evals/` | `.cursor/evals/` |
96|| `domains/<id>/` | 合并进 `.cursor/` |
97|
98|### OpenCode
99|
100|| 规范库 | 业务项目 |
101||--------|----------|
102|| `rules/` → 生成 | `opencode/rules/{category}.md` |
103|| `agents/` → 生成 | `opencode/agents/*.txt` |
104|| `platforms/opencode/opencode.json` | `opencode.json`（合并） |
105|| `platforms/opencode/agents/build.txt` | `opencode/agents/build.txt`（primary agent） |
106|| `platforms/opencode/commands/` | `opencode/commands/` |
107|| `shared/skills/` | `shared/skills/` |
108|
109|### Hermes
110|
111|| 规范库 | 业务项目 |
112||--------|----------|
113|| `rules/` → 生成 | `~/.hermes/rules/ecc/` |
114|| `agents/` → 生成 | `~/.hermes/AGENTS.md` |
115|| `shared/skills/` | `~/.hermes/skills/ecc-imports/` |
116|
117|---
118|
119|## 部署方式
120|
121|```powershell
122|# 自动检测平台
123|powershell -File scripts/bootstrap-project.ps1 -SpecRoot <规范库> -ProjectRoot <项目>
124|
125|# 全部平台
126|powershell -File scripts/bootstrap-project.ps1 -SpecRoot <规范库> -ProjectRoot <项目> -Target all
127|
128|# 指定平台
129|powershell -File scripts/bootstrap-project.ps1 -SpecRoot <规范库> -ProjectRoot <项目> -Target cursor
130|
131|# 叠加域包
132|powershell -File scripts/bootstrap-project.ps1 -SpecRoot <规范库> -ProjectRoot <项目> -Domain enterprise-cert
133|```
134|