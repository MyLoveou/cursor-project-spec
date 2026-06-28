# Bootstrap

> 业务项目**只复制** `.cursor/` + 从 `templates/` 生成 `AGENTS.md`、`constraints.md`。

```powershell
powershell -File "<规范库>/scripts/bootstrap-project.ps1" `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp"
```

## 生成内容

| 路径 | 说明 |
|------|------|
| `YourApp/.cursor/` | 从规范库复制（rules/skills/agents/hooks/workflows） |
| `YourApp/.cursor/constraints.md` | 从 `constraints.md.template` |
| `YourApp/AGENTS.md` | 从 `templates/AGENTS.md.template` |
| `YourApp/docs/requirements/` 等 | 项目文档骨架（需求/设计/产品） |

## 不要复制

- 规范库根 `templates/`、`scripts/`、`README.md`（留在规范库）

## 校验

- [ ] Cursor Settings → Rules 可见 Project Rules
- [ ] `constraints.md`、`AGENTS.md` 占位符已替换
- [ ] 业务项目根**仅新增** `.cursor/`（无额外规范目录）

维护 ECC：`scripts/sync-ecc-bundle.ps1`
