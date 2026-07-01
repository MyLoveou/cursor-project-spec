# 项目规范 · Cursor 运行时库

> **本仓库 = 扁平运行时目录**（`rules/`、`skills/`、`agents/` 等）+ Bootstrap 脚本。  
> 复用到业务项目时，将运行时目录**整体移入** `<项目>/.cursor/`（或手动复制对应子目录）。

```powershell
powershell -File scripts/bootstrap-project.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp"
```

详见 [BOOTSTRAP.md](./BOOTSTRAP.md)。

---

## 目录

```
项目规范/
├── rules/ skills/ agents/ hooks/ workflows/ evals/   # 运行时（复制到目标 .cursor/）
├── constraints.md.template
├── templates/     # Bootstrap 占位符
├── scripts/       # bootstrap、sync-ecc-bundle、fix-cursor-rule-frontmatter
├── STRUCTURE.md
├── BOOTSTRAP.md
└── AGENTS.md
```

## 入口

| 文档 | 说明 |
|------|------|
| [STRUCTURE.md](./STRUCTURE.md) | 规范库布局 vs 业务项目 `.cursor/` 布局 |
| [workflows/README.md](./workflows/README.md) | 四条主工作流 |
| [skills/workflow-triggers/SKILL.md](./skills/workflow-triggers/SKILL.md) | 工作流触发表 |

## 维护

- 新增 Skill → `skills/workflow-triggers/SKILL.md`
- 同步 ECC → `scripts/sync-ecc-bundle.ps1`
- 同步第三方 Skill → `scripts/sync-vendor-skills.ps1`（如 `agent-browser`）
- 修复 Rule frontmatter → `scripts/fix-cursor-rule-frontmatter.ps1`
