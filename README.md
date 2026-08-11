# 项目规范 · 多平台运行时库

> **Cursor / OpenCode / Hermes** 三平台规范库。支持 **Windows / macOS**。
> 规则统一维护在 `rules/`，通过 `generate.ps1` 按需生成各平台格式。

## 快速开始

**Windows**（PowerShell 5+）：
```powershell
powershell -File scripts/bootstrap-project.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp"
```

**macOS**（需安装 [PowerShell Core](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-macos)）：
```bash
pwsh -File scripts/bootstrap-project.ps1 \
  -SpecRoot "/Users/me/projects/spec-repo" \
  -ProjectRoot "/Users/me/projects/my-app"
```

可选参数：
```powershell
-Target all                          # 部署全部平台（默认 auto 自动检测）
-Target cursor|opencode|hermes       # 指定单一平台
-Domain "enterprise-cert"            # 叠加业务域包
-DryRun                              # 预览模式（仅 generate.ps1）
```

## 目录结构

```
项目规范/
├── rules/             # ★ 统一规则源（唯一真源，按 category 分目录）
│   ├── common/        # 通用规则（project-core, coding-style, security...）
│   ├── java/          # Java/Spring 规则
│   ├── typescript/    # TypeScript 规则
│   ├── vue/           # Vue 规则
│   ├── react/         # React 规则
│   ├── react-native/  # React Native 规则
│   └── web/           # Web 通用规则
├── agents/            # Agent 定义（三平台共享）
├── shared/            # 三平台共享（Skills / Workflows / Evals）
├── platforms/         # 平台特有文件（hooks, opencode.json, 斜杠命令等）
├── domains/           # 业务域配置包
├── templates/         # Bootstrap 占位符
├── scripts/           # 生成/部署/同步脚本
│   ├── generate.ps1            # 从 rules/ + agents/ 生成平台文件
│   ├── bootstrap-project.ps1   # 自动检测 + 一键部署
│   └── ...
└── STRUCTURE.md · README.md · AGENTS.md · BOOTSTRAP.md
```

## 核心工作流

```
rules/ + agents/（统一源）
    │
    ▼
generate.ps1 -Target cursor|opencode|hermes|all
    │
    ├── .cursor/rules/*.mdc + .cursor/agents/*.md
    ├── opencode/rules/*.md + opencode/agents/*.txt
    └── rules/ecc/**/*.md + AGENTS.md
```

**规则只写一次**，按平台格式生成。改规则只需编辑 `rules/{category}/{id}.md`，然后重新生成。

## 跨平台兼容

| 项 | 说明 |
|------|------|
| 脚本引擎 | Windows: `powershell` · macOS: `pwsh` (PowerShell Core 7+) |
| 路径分隔 | 全部使用 `Join-Path`，不硬编码 `\` 或 `/` |
| 用户目录 | `$env:USERPROFILE`（Win: `C:\Users\...` · Mac: `/Users/...`） |
| 换行符 | 统一 LF，Git 自动处理 CRLF |

## 维护

- 新增/修改规则 → 编辑 `rules/{category}/{id}.md`
- 新增 Skill → `shared/skills/`
- 新增 Agent → `agents/`（.md 格式，各平台按需引用）
- 新增平台特有配置 → `platforms/{cursor|opencode|hermes}/`
- 新增业务域包 → `domains/_template` 复制为 `domains/<id>/`
