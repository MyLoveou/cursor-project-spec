# Bootstrap

> 从规范库复制指定平台的运行时配置到业务项目。
> 三平台各自独立：`cursor/`、`opencode/`、`hermes/`；共享层从 `shared/` 复制。

## 基本用法

```powershell
# Cursor
powershell -File "<规范库>/scripts/bootstrap-project.ps1" `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Target cursor

# Cursor + 业务域包
powershell -File "<规范库>/scripts/bootstrap-project.ps1" `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Target cursor `
  -Domain notes,billing

# OpenCode
powershell -File "<规范库>/scripts/bootstrap-project.ps1" `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Target opencode

# Hermes
powershell -File "<规范库>/scripts/bootstrap-project.ps1" `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Target hermes
```

已有配置时只叠加域包：

```powershell
powershell -File "<规范库>/scripts/apply-domain-pack.ps1" `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Target cursor `
  -Domain "notes"
```

---

## 规范库 → 业务项目

### Cursor（`-Target cursor`）

| 规范库 | 业务项目 |
|--------|----------|
| `cursor/rules/` | `YourApp/.cursor/rules/` |
| `cursor/agents/` | `YourApp/.cursor/agents/` |
| `cursor/hooks/` | `YourApp/.cursor/hooks/` |
| `shared/skills/` | `YourApp/.cursor/skills/` |
| `shared/workflows/` | `YourApp/.cursor/workflows/` |
| `shared/evals/` | `YourApp/.cursor/evals/` |
| `domains/<id>/` | 合并进 `.cursor/`（需 `-Domain`） |
| `constraints.md.template` | `YourApp/.cursor/constraints.md` |
| `templates/AGENTS.md.template` | `YourApp/AGENTS.md` |

### OpenCode（`-Target opencode`）

| 规范库 | 业务项目 |
|--------|----------|
| `opencode/opencode.json` | 合并进项目 `opencode.json` |
| `opencode/INSTRUCTIONS.md` | `YourApp/opencode/INSTRUCTIONS.md` |
| `opencode/agents/` | `YourApp/opencode/agents/` |
| `opencode/commands/` | `YourApp/opencode/commands/` |
| `shared/skills/` | `YourApp/shared/skills/`（或 `skills.paths` 指向） |
| `shared/workflows/` | `YourApp/shared/workflows/` |

### Hermes（`-Target hermes`）

| 规范库 | 业务项目 |
|--------|----------|
| `hermes/rules/` | `~/.hermes/rules/ecc/` |
| `hermes/AGENTS.md` | `~/.hermes/AGENTS.md` |
| `shared/skills/` | `~/.hermes/skills/ecc-imports/` |

---

## 不要复制的目录

- 规范库根 `templates/`、`scripts/`、`domains/`（整夹）、`README.md`、`STRUCTURE.md`
- `domains/_template/` 与任意 `_` 前缀脚手架
- `.git/`

---

## 校验

- [ ] Cursor: Settings → Rules 可见 Project Rules；`@agent-name` 可调用
- [ ] OpenCode: `opencode.json` 中 `instructions`/`agent`/`command` 可正常解析
- [ ] Hermes: 规则和技能在 `~/.hermes/` 下可见
- [ ] `skills.paths` / 技能目录指向有效路径

维护脚本：`scripts/sync-ecc-bundle.ps1`  
域包约定：[domains/README.md](./domains/README.md)
