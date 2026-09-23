# 目录结构（规范库 vs 业务项目）

> Cursor 规范库：规则在 `rules/`，通过 `generate.ps1` 生成 `.mdc`。
> OpenCode / Hermes 适配已延后。

---

## 规范库（本仓库）

```
├── mcp/                   # Cursor MCP：CodeGraph / git / ssh
├── rules/                  # 统一规则源
│   ├── common/
│   ├── java/
│   ├── typescript/
│   ├── vue/
│   └── react/
├── agents/
├── shared/
│   ├── skills/
│   ├── workflows/
│   └── evals/
├── platforms/cursor/hooks/
├── domains/
├── templates/
└── scripts/
    ├── generate.ps1
    ├── bootstrap-project.ps1
    ├── install-global-skills.ps1
    └── apply-domain-pack.ps1
```

### 规则统一格式

每条规则一个 `.md` 文件，YAML frontmatter 携带元数据。`globs` / `alwaysApply` 仅 Cursor 使用。

### 生成

| 命令 | 输出 |
|------|------|
| `generate.ps1 -Target cursor` | `.cursor/rules/*.mdc` + `.cursor/agents/*.md` |

---

## 业务项目（部署后）

| 规范库 | 业务项目 |
|--------|----------|
| `rules/` → 生成 | `.cursor/rules/*.mdc` |
| `agents/` → 生成 | `.cursor/agents/*.md` |
| `mcp/` | `.cursor/mcp.json` + `.cursor/mcp/` |
| `platforms/cursor/hooks/` | `.cursor/hooks/hooks.json` |
| `shared/skills/` | `.cursor/skills/` |
| `shared/workflows/` | `.cursor/workflows/` |
| `shared/evals/` | `.cursor/evals/` |
| `domains/<id>/` | 合并进 `.cursor/` |

## 部署

```powershell
powershell -File scripts/bootstrap-project.ps1 -SpecRoot <规范库> -ProjectRoot <项目>
powershell -File scripts/bootstrap-project.ps1 -SpecRoot <规范库> -ProjectRoot <项目> -Domain enterprise-cert
```
