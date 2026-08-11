1|# 项目规范 · 多平台运行时库
2|
3|> **Cursor / OpenCode / Hermes** 三平台规范库。
4|> 规则统一维护在 `rules/`，通过 `generate.ps1` 按需生成各平台格式。
5|
6|## 快速开始
7|
8|```powershell
9|# 自动检测项目所用平台，一键部署
10|powershell -File scripts/bootstrap-project.ps1 `
11|  -SpecRoot "E:\项目\项目规范" `
12|  -ProjectRoot "E:\项目\YourApp"
13|
14|# 显式指定平台
15|powershell -File scripts/bootstrap-project.ps1 `
16|  -SpecRoot "E:\项目\项目规范" `
17|  -ProjectRoot "E:\项目\YourApp" `
18|  -Target all
19|
20|# 带业务域配置包
21|powershell -File scripts/bootstrap-project.ps1 `
22|  -SpecRoot "E:\项目\项目规范" `
23|  -ProjectRoot "E:\项目\YourApp" `
24|  -Domain "enterprise-cert"
25|```
26|
27|## 目录结构
28|
29|```
30|项目规范/
31|├── rules/             # ★ 统一规则源（唯一真源，按 category 分目录）
32|│   ├── common/        # 通用规则（project-core, coding-style, security...）
33|│   ├── java/          # Java/Spring 规则
34|│   ├── typescript/    # TypeScript 规则
35|│   ├── vue/           # Vue 规则
36|│   ├── react/         # React 规则
37|│   ├── react-native/  # React Native 规则
38|│   └── web/           # Web 通用规则
39|├── agents/            # Agent 定义（三平台共享）
40|├── shared/            # 三平台共享（Skills / Workflows / Evals）
41|├── platforms/         # 平台特有文件（hooks, opencode.json, 斜杠命令等）
42|├── domains/           # 业务域配置包
43|├── templates/         # Bootstrap 占位符
44|├── scripts/           # 生成/部署/同步脚本
45|│   ├── generate.ps1     # 从 rules/ 生成平台文件
46|│   ├── bootstrap-project.ps1  # 自动检测 + 一键部署
47|│   └── ...
48|└── STRUCTURE.md · README.md · AGENTS.md · BOOTSTRAP.md
49|```
50|
51|## 核心工作流
52|
53|```
54|rules/（统一源）
55|    │
56|    ▼
57|generate.ps1 -Target cursor|opencode|hermes|all
58|    │
59|    ├── .cursor/rules/*.mdc
60|    ├── opencode/INSTRUCTIONS.md
61|    └── rules/ecc/**/*.md
62|```
63|
64|**规则只写一次**，按平台格式生成。改规则只需编辑 `rules/{category}/{id}.md`，然后重新生成。
65|
66|## 平台差异
67|
68|| 特性 | Cursor | OpenCode | Hermes |
69||------|--------|----------|--------|
70|| 规则格式 | `.mdc` + YAML frontmatter | `INSTRUCTIONS.md`（合并） | `rules/ecc/**/*.md` |
71|| 条件加载 | `globs:` / `alwaysApply:` | 不支持 | 不支持 |
72|| 生成方式 | 保留 frontmatter + body | 合并为单一文件 + `##` 章节 | body 直出 |
73|
74|## 维护
75|
76|- 新增/修改规则 → 编辑 `rules/{category}/{id}.md`
77|- 新增 Skill → `shared/skills/`
78|- 新增 Agent → `agents/`（.md 格式，各平台按需引用）
79|- 新增平台特有配置 → `platforms/{cursor|opencode|hermes}/`
80|- 新增业务域包 → `domains/_template` 复制为 `domains/<id>/`
81|