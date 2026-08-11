1|# Bootstrap
2|
3|> 从规范库部署运行时配置到业务项目。
4|> **自动检测**项目所使用的编辑器平台，一键完成。
5|
6|## 基本用法
7|
8|```powershell
9|# 自动检测（推荐）
10|powershell -File scripts/bootstrap-project.ps1 `
11|  -SpecRoot "E:\项目\项目规范" `
12|  -ProjectRoot "E:\项目\YourApp"
13|
14|# 部署全部平台
15|powershell -File scripts/bootstrap-project.ps1 `
16|  -SpecRoot "E:\项目\项目规范" `
17|  -ProjectRoot "E:\项目\YourApp" `
18|  -Target all
19|
20|# 指定平台
21|powershell -File scripts/bootstrap-project.ps1 `
22|  -SpecRoot "E:\项目\项目规范" `
23|  -ProjectRoot "E:\项目\YourApp" `
24|  -Target cursor
25|
26|# 带业务域包
27|powershell -File scripts/bootstrap-project.ps1 `
28|  -SpecRoot "E:\项目\项目规范" `
29|  -ProjectRoot "E:\项目\YourApp" `
30|  -Domain enterprise-cert
31|```
32|
33|已有配置时只叠加域包：
34|
35|```powershell
36|powershell -File scripts/apply-domain-pack.ps1 `
37|  -SpecRoot "E:\项目\项目规范" `
38|  -ProjectRoot "E:\项目\YourApp" `
39|  -Target cursor `
40|  -Domain "enterprise-cert"
41|```
42|
43|---
44|
45|## 部署流程
46|
47|```
48|bootstrap-project.ps1
49|    │
50|    ├─ 1. 自动检测平台（或 -Target 指定）
51|    │     检测 .cursor/、opencode.json、~/.hermes/config.yaml
52|    │
53|    ├─ 2. generate.ps1
54|    │     rules/*.md → 平台格式规则文件
55|    │
56|    ├─ 3. 复制共享资源
57|    │     shared/skills/、shared/workflows/、shared/evals/
58|    │
59|    ├─ 4. 复制平台特有文件
60|    │     platforms/{cursor|opencode|hermes}/
61|    │
62|    └─ 5. 应用域包（可选）
63|          domains/<id>/ → 合并到目标平台目录
64|```
65|
66|---
67|
68|## 自动检测规则
69|
70|| 检测信号 | 平台 |
71||----------|------|
72|| `项目/.cursor/` 目录存在 | Cursor |
73|| `项目/opencode.json` 文件存在 | OpenCode |
74|| `项目/.hermes/` 或 `~/.hermes/config.yaml` 存在 | Hermes |
75|
76|未检测到任何平台时，默认使用 Cursor。
77|
78|---
79|
80|## 规范库 → 业务项目
81|
82|### Cursor（`-Target cursor`）
83|
84|| 规范库 | 业务项目 |
85||--------|----------|
86|| `rules/` → 生成 | `YourApp/.cursor/rules/` |
87|| `agents/` | `YourApp/.cursor/agents/` |
88|| `platforms/cursor/hooks/` | `YourApp/.cursor/hooks/` |
89|| `shared/skills/` | `YourApp/.cursor/skills/` |
90|| `shared/workflows/` | `YourApp/.cursor/workflows/` |
91|| `shared/evals/` | `YourApp/.cursor/evals/` |
92|| `domains/<id>/` | 合并进 `.cursor/`（需 `-Domain`） |
93|| `constraints.md.template` | `YourApp/.cursor/constraints.md` |
94|| `templates/AGENTS.md.template` | `YourApp/AGENTS.md` |
95|
96|### OpenCode（`-Target opencode`）
97|
98|| 规范库 | 业务项目 |
99||--------|----------|
100|| `rules/` → 生成 | `YourApp/opencode/rules/` |
101|| `agents/` → 生成 | `YourApp/opencode/agents/` |
102|| `platforms/opencode/opencode.json` | 合并进项目 `opencode.json` |
103|| `platforms/opencode/agents/build.txt` | `YourApp/opencode/agents/build.txt` |
104|| `platforms/opencode/commands/` | `YourApp/opencode/commands/` |
105|| `shared/skills/` | `YourApp/shared/skills/` |
106|| `shared/workflows/` | `YourApp/shared/workflows/` |
107|
108|### Hermes（`-Target hermes`）
109|
110|| 规范库 | 业务项目 |
111||--------|----------|
112|| `rules/` → 生成 | `~/.hermes/rules/ecc/` |
113|| `agents/` → 生成 | `~/.hermes/AGENTS.md` |
114|| `shared/skills/` | `~/.hermes/skills/ecc-imports/` |
115|
116|---
117|
118|## 校验
119|
120|- [ ] Cursor: Settings → Rules 可见 Project Rules；`@agent-name` 可调用
121|- [ ] OpenCode: `opencode.json` 中 `instructions`/`agent`/`command` 可正常解析
122|- [ ] Hermes: 规则和技能在 `~/.hermes/` 下可见
123|- [ ] `skills.paths` / 技能目录指向有效路径
124|