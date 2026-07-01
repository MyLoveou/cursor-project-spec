# Bootstrap

> 从规范库**复制运行时目录**到业务项目的 `.cursor/`，并生成 `AGENTS.md`、`constraints.md`。

```powershell
powershell -File "<规范库>/scripts/bootstrap-project.ps1" `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp"
```

## 规范库 → 业务项目

| 规范库（根目录） | 业务项目 |
|------------------|----------|
| `rules/` `skills/` `agents/` `hooks/` `workflows/` `evals/` | `YourApp/.cursor/` 下同名目录 |
| `constraints.md.template` | `YourApp/.cursor/constraints.md` |
| `templates/AGENTS.md.template` | `YourApp/AGENTS.md` |
| — | `YourApp/docs/requirements/` 等骨架 |

也可**手动**将规范库根目录的运行时文件夹移入目标项目的 `.cursor/`。

## 不要复制到业务项目

- 规范库根 `templates/`、`scripts/`、`README.md`、`STRUCTURE.md`、`ecc-manifest.md.template`

## 校验

- [ ] Cursor Settings → Rules 可见 Project Rules
- [ ] `.cursor/constraints.md`、`AGENTS.md` 占位符已替换
- [ ] 业务项目运行时均在 `.cursor/` 内

维护 ECC：`scripts/sync-ecc-bundle.ps1`
