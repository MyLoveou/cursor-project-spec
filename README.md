# 项目规范 · Cursor 运行时库

> **本仓库 = 扁平运行时目录**（`rules/`、`skills/`、`agents/` 等）+ Bootstrap 脚本。  
> 复用到业务项目时，将运行时目录**整体移入** `<项目>/.cursor/`（或手动复制对应子目录）。

```powershell
powershell -File scripts/bootstrap-project.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp"

# 带业务域配置包
powershell -File scripts/bootstrap-project.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Domain "notes"
```

详见 [BOOTSTRAP.md](./BOOTSTRAP.md)、[domains/README.md](./domains/README.md)。

---

## 目录

```
项目规范/
├── rules/ skills/ agents/ hooks/ workflows/ evals/   # 通用运行时 → 目标 .cursor/
├── domains/       # 业务域配置包（按 -Domain 合并，非整夹复制）
├── constraints.md.template
├── templates/     # Bootstrap 占位符
├── scripts/       # bootstrap、apply-domain-pack、sync-ecc-bundle、…
├── STRUCTURE.md
├── BOOTSTRAP.md
└── AGENTS.md
```

## 入口

| 文档 | 说明 |
|------|------|
| [STRUCTURE.md](./STRUCTURE.md) | 规范库布局 vs 业务项目 `.cursor/` 布局 |
| [domains/README.md](./domains/README.md) | 业务域配置包约定与接入 |
| [workflows/README.md](./workflows/README.md) | 四条主工作流 |
| [skills/workflow-triggers/SKILL.md](./skills/workflow-triggers/SKILL.md) | 工作流触发表 |

## 维护

- 新增 Skill → `skills/workflow-triggers/SKILL.md`
- 新增业务域包 → `domains/_template` 复制为 `domains/<id>/`，填 `bundle.manifest.json` 后 `sync-domain-bundle.ps1`
- 只搬域包到业务仓 → `install-domain-pack.ps1 -PackRoot …`
- 同步 ECC → `scripts/sync-ecc-bundle.ps1`（可选 `-FromGitHub`）
- 同步 ECC RN/Web rules → `scripts/sync-ecc-github-rules.ps1`
- 同步第三方 Skill → `scripts/sync-vendor-skills.ps1`（如 `agent-browser`）
- 修复 Rule frontmatter → `scripts/fix-cursor-rule-frontmatter.ps1`
