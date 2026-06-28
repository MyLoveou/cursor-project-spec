# 项目规范 · Cursor 运行时库

> **本仓库 = `.cursor/` 整包** + Bootstrap 脚本。复制到业务项目时**只复制 `.cursor/`**。

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
├── .cursor/       # Rules、Skills、Agents、Hooks、Workflows（全部运行时）
├── templates/     # Bootstrap 占位符（AGENTS.md、constraints 等）
├── scripts/       # bootstrap、sync-ecc-bundle、fix-cursor-rule-frontmatter
├── BOOTSTRAP.md
└── AGENTS.md
```

## `.cursor/` 入口

| 文档 | 说明 |
|------|------|
| [.cursor/STRUCTURE.md](./.cursor/STRUCTURE.md) | Cursor 官方目录 vs 扩展 |
| [.cursor/README.md](./.cursor/README.md) | Skills、维护 |
| [.cursor/workflows/README.md](./.cursor/workflows/README.md) | 四条主工作流 |

## 维护

- 新增 Skill → `.cursor/skills/workflow-triggers/SKILL.md`
- 同步 ECC → `scripts/sync-ecc-bundle.ps1`
- 修复 Rule frontmatter → `scripts/fix-cursor-rule-frontmatter.ps1`
