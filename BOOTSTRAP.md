# Bootstrap

> 从规范库部署 **Cursor** 运行时配置到业务项目。支持 **Windows / macOS**。
> OpenCode / Hermes 适配已延后。

## 前置要求

- **Windows**: PowerShell 5.1+
- **macOS**: [PowerShell Core 7+](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-macos)

## 基本用法

**Windows**:
```powershell
powershell -File scripts/bootstrap-project.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp"
```

**macOS**:
```bash
pwsh -File scripts/bootstrap-project.ps1 \
  -SpecRoot "/Users/me/projects/spec-repo" \
  -ProjectRoot "/Users/me/projects/my-app"
```

可选：把本仓库 Skill **装到本机所有项目**（`%USERPROFILE%\.cursor\skills` 与 `%USERPROFILE%\.agents\skills`）：

```powershell
powershell -File scripts/install-global-skills.ps1 -SpecRoot "E:\项目\项目规范"
```

只覆盖同名 Skill，不删你已有的其它全局 Skill。装完请重载 Cursor 窗口。

**规则不装到用户全局。** `rules/` 随 `bootstrap-project.ps1` 生成到该业务仓的 `.cursor/rules/`。common 规则默认始终生效，放进用户目录会作用到所有项目。

已有 `.cursor/` 时只叠加域包：

```powershell
powershell -File scripts/apply-domain-pack.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Domain "enterprise-cert"
```

## 部署流程

```
bootstrap-project.ps1
    │
    ├─ 1. generate.ps1 → .cursor/rules + .cursor/agents
    ├─ 2. 复制 shared/skills、workflows、evals
    ├─ 3. 复制 platforms/cursor/hooks
    ├─ 4. 复制 mcp/ → .cursor/mcp.json + .cursor/mcp/
    └─ 5. 可选 domains/<id>/
```

## 规范库 → 业务项目

| 规范库 | 业务项目 |
|--------|----------|
| `rules/` + `agents/` → 生成 | `.cursor/rules/` + `.cursor/agents/` |
| `platforms/cursor/hooks/` | `.cursor/hooks/` |
| `mcp/` | `.cursor/mcp.json` + `.cursor/mcp/` |
| `shared/skills/` | `.cursor/skills/` |
| `shared/workflows/` | `.cursor/workflows/` |
| `shared/evals/` | `.cursor/evals/` |
| `domains/<id>/` | 合并进 `.cursor/` |
| `constraints.md.template` | `.cursor/constraints.md` |
| `templates/AGENTS.md.template` | `AGENTS.md` |
| OpenSpec 基线模板 | 无则写入 `docs/product/baseline.md`、`facts.md`、`decisions.md`；`openspec init` 后请复制浓缩基线为 `openspec/baseline.md` |

## 校验

- [ ] Cursor Settings → Rules 可见 Project Rules；`@agent-name` 可调用
- [ ] `.cursor/mcp.json` 已填 SSH 占位符（或暂时删掉 ssh 段）；CodeGraph 已 `codegraph init`
- [ ] 填写 `docs/product/facts.md`（实现 + 方向）与 `docs/product/decisions.md`
- [ ] 填写 `docs/product/baseline.md`（浓缩约束；init 后复制到 `openspec/baseline.md`）
