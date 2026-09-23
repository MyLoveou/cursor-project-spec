# 项目规范 · Cursor 运行时库

> 面向 **Cursor** 的规则 / Agent / Skill 库。OpenCode / Hermes 适配已延后。
> 规则维护在 `rules/`，通过 `generate.ps1` 生成 `.cursor/rules/*.mdc`。

## 快速开始

**Windows**（PowerShell 5+）：
```powershell
powershell -File scripts/bootstrap-project.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp"
```

**macOS**（需安装 [PowerShell Core](https://learn.microsoft.com/powershell/scripting/installing-powershell-on-macos)）：
```bash
pwsh -File scripts/bootstrap-project.ps1 \
  -SpecRoot "/Users/me/projects/spec-repo" \
  -ProjectRoot "/Users/me/projects/my-app"
```

可选：`-Domain "enterprise-cert"` 叠加业务域包。

## 目录结构

```
├── rules/             # 统一规则源
│   ├── common/
│   ├── java/
│   ├── typescript/
│   ├── vue/
│   └── react/
├── agents/            # Cursor Agent 定义
├── shared/            # skills / workflows / evals
├── mcp/               # CodeGraph / git / ssh MCP
├── platforms/cursor/  # hooks
├── domains/           # 业务域配置包
├── templates/
└── scripts/
    ├── generate.ps1
    ├── bootstrap-project.ps1
    ├── install-global-skills.ps1
    ├── sync-domain-bundle.ps1
    └── apply-domain-pack.ps1
```

本仓库自己的 `.cursor/` 是生成结果，不提交。在仓库根执行：

```powershell
powershell -File scripts/generate.ps1 -SpecRoot . -OutputDir . -Target cursor
```

## 核心工作流

```
rules/ + agents/
    │
    ▼
generate.ps1 -Target cursor
    │
    └── .cursor/rules/*.mdc + .cursor/agents/*.md
```

新能力默认走 `project-spec` Skill：L1 需求 →（复杂）**L2 设计确认**（组合式含切片契约）→ L3 → apply → archive。

## 维护

- 新增/修改规则 → `rules/{category}/{id}.md`
- 新增 Skill → `shared/skills/`
- 新增 MCP → `mcp/`（`mcp.json` + 说明）
- 全局安装 Skill → `scripts/install-global-skills.ps1`（只装 Skill；规则随 bootstrap 进业务仓）
- 业务域包 → `domains/_template` 复制为 `domains/<id>/`
