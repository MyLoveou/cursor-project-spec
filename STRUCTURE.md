# 目录结构（规范库 vs 业务项目）

> 多平台规范库：**Cursor / OpenCode / Hermes** 各自独立目录，`shared/` 为跨平台共享层。

---

## 规范库（本仓库）

```
项目规范/
├── cursor/            # Cursor 平台 — 自包含
│   ├── rules/         .mdc 规则（globs + alwaysApply）
│   ├── agents/        Agent .md 定义
│   └── hooks/         hooks.json
├── opencode/          # OpenCode 平台 — 自包含
│   ├── opencode.json  主配置（agents + commands + instructions + skills.paths）
│   ├── INSTRUCTIONS.md   合并规则（无 globs，始终加载）
│   ├── agents/        Agent prompt .txt
│   └── commands/      斜杠命令模板
├── hermes/            # Hermes 平台 — 自包含
│   ├── rules/         纯 Markdown 规则（按栈分目录）
│   └── AGENTS.md      Agent 指令
├── shared/            # 三平台共享
│   ├── skills/        58 个 SKILL.md
│   ├── workflows/     6 个剧本
│   └── evals/         EDD eval 示例
├── domains/           # 业务域配置包（按需合并到目标平台）
├── scripts/           # Bootstrap / 域包安装 / ECC 同步
├── templates/         # Bootstrap 占位符
└── STRUCTURE.md · README.md · AGENTS.md · BOOTSTRAP.md
```

### 各平台差异

| 特性 | Cursor | OpenCode | Hermes |
|------|--------|----------|--------|
| 规则格式 | `.mdc` + `globs:`/`alwaysApply:` | 单文件 `INSTRUCTIONS.md` | `rules/**/*.md`（纯 Markdown） |
| 条件加载 | `globs:` 按文件类型触发 | 不支持（全部 alwaysOn） | 不支持 |
| Skill 加载 | 自动扫描 `.cursor/skills/` | `skills.paths` 发现 + `skill` 工具调用 | 复制到 `~/.hermes/skills/` |
| Agent 定义 | `.md` 内嵌 YAML frontmatter | `opencode.json` JSON + `.txt` prompt | `AGENTS.md` 单文件 |
| 斜杠命令 | Skill 名即路由 | `/command` 启动子 Agent | 不支持 |
| Hook | `hooks.json`（3 阶段） | TypeScript 插件（20+ 事件） | 不支持 |
| 配置入口 | `.cursor/` 自动扫描 | `opencode.json` 显式配置 | `config.yaml`（ECC 不修改） |

---

## 业务项目（复制后布局）

### Cursor

| 规范库 | 业务项目 |
|--------|----------|
| `cursor/rules/` | `.cursor/rules/*.mdc` |
| `cursor/agents/` | `.cursor/agents/*.md` |
| `cursor/hooks/` | `.cursor/hooks/hooks.json` |
| `shared/skills/` | `.cursor/skills/*/SKILL.md` |
| `shared/workflows/` | `.cursor/workflows/` |
| `shared/evals/` | `.cursor/evals/` |
| `domains/<id>/` | 合并进 `.cursor/`（`-Domain`） |

### OpenCode

| 规范库 | 业务项目 |
|--------|----------|
| `opencode/opencode.json` | 合并进项目 `opencode.json` 的 `instructions`/`agent`/`command` |
| `opencode/INSTRUCTIONS.md` | `instructions` 数组引用 |
| `opencode/agents/` | `{file:opencode/agents/...}` 引用 |
| `opencode/commands/` | `{file:opencode/commands/...}` 引用 |
| `shared/skills/` | `skills.paths: ["shared/skills"]` |

### Hermes

| 规范库 | 业务项目 |
|--------|----------|
| `hermes/rules/` | `~/.hermes/rules/ecc/**/*.md` |
| `hermes/AGENTS.md` | `~/.hermes/AGENTS.md` |
| `shared/skills/` | `~/.hermes/skills/ecc-imports/*/SKILL.md` |
| `shared/workflows/` | `~/.hermes/skills/ecc-imports/` |

---

## 复制方式

| 平台 | 脚本 |
|------|------|
| Cursor | `scripts/bootstrap-project.ps1 -Target cursor` |
| Cursor + 域包 | `scripts/bootstrap-project.ps1 -Target cursor -Domain <id>` |
| OpenCode | `scripts/bootstrap-project.ps1 -Target opencode` |
| Hermes | `scripts/bootstrap-project.ps1 -Target hermes` |

或**手动**：将对应平台目录 + `shared/` 内容复制到业务项目对应路径。
