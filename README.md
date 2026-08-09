# 项目规范 · 多平台运行时库

> **Cursor / OpenCode / Hermes** 三平台规范库。
> 各平台目录自包含（`cursor/`、`opencode/`、`hermes/`），`shared/` 提供跨平台共享的 Skill / Workflow / Eval。

```powershell
# Cursor
powershell -File scripts/bootstrap-project.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Target cursor

# OpenCode
powershell -File scripts/bootstrap-project.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Target opencode

# 带业务域配置包
powershell -File scripts/bootstrap-project.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Target cursor `
  -Domain "notes"
```

详见 [BOOTSTRAP.md](./BOOTSTRAP.md)、[STRUCTURE.md](./STRUCTURE.md)、[domains/README.md](./domains/README.md)。

---

## 目录

```
项目规范/
├── cursor/         # Cursor 平台（Rules .mdc / Agents .md / Hooks）
├── opencode/       # OpenCode 平台（opencode.json / Agents .txt / Commands）
├── hermes/         # Hermes 平台（Rules .md / AGENTS.md）
├── shared/         # 三平台共享（Skills / Workflows / Evals）
├── domains/        # 业务域配置包
├── templates/      # Bootstrap 占位符
├── scripts/        # 跨平台 bootstrap、域包安装、ECC 同步
├── STRUCTURE.md
├── BOOTSTRAP.md
└── AGENTS.md
```

## 入口

| 文档 | 说明 |
|------|------|
| [STRUCTURE.md](./STRUCTURE.md) | 三平台目录布局 vs 业务项目布局 |
| [BOOTSTRAP.md](./BOOTSTRAP.md) | 接入方式与脚本参数 |
| [domains/README.md](./domains/README.md) | 业务域配置包约定 |
| [shared/workflows/README.md](./shared/workflows/README.md) | 四条主工作流 |
| [AGENTS.md](./AGENTS.md) | 各平台 Agent 对应关系 |

## 维护

- 新增 Skill → `shared/skills/`（所有平台共享）
- 新增 Rule → 按平台分别写入 `cursor/rules/`（.mdc）/ `hermes/rules/`（.md）/ `opencode/INSTRUCTIONS.md`
- 新增 Agent → 按平台分别写入对应目录
- 新增业务域包 → `domains/_template` 复制为 `domains/<id>/`
- 同步 ECC → `scripts/sync-ecc-bundle.ps1`
- 修复 Rule frontmatter → `scripts/fix-cursor-rule-frontmatter.ps1`
