# Bootstrap

> 从规范库**复制通用运行时**到业务项目的 `.cursor/`，并生成 `AGENTS.md`、`constraints.md`。  
> 可选：合并 **业务域配置包**（`domains/<id>/`）。

```powershell
powershell -File "<规范库>/scripts/bootstrap-project.ps1" `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp"

# 启用一个或多个业务域包
powershell -File "<规范库>/scripts/bootstrap-project.ps1" `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Domain notes,billing
```

已有 `.cursor/` 时只叠加域包：

```powershell
powershell -File "<规范库>/scripts/apply-domain-pack.ps1" `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Domain "notes"
```

**只搬某个业务域包**（含 `bundle/` 依赖）到业务仓：

```powershell
# 先在规范库 sync bundle
powershell -File scripts/sync-domain-bundle.ps1 -SpecRoot "E:\项目\项目规范" -Domain enterprise-cert

# 拷贝整个 domains/enterprise-cert 后：
powershell -File scripts/install-domain-pack.ps1 `
  -PackRoot "E:\drop\enterprise-cert" `
  -ProjectRoot "E:\项目\YourApp" `
  -CreateCursorIfMissing
```

详见 [domains/README.md](./domains/README.md)。

## 规范库 → 业务项目

| 规范库（根目录） | 业务项目 |
|------------------|----------|
| `rules/` `skills/` `agents/` `hooks/` `workflows/` `evals/` | `YourApp/.cursor/` 下同名目录 |
| `domains/<id>/{rules,skills,agents,workflows,evals}` | **合并进** `.cursor/` 同名目录（需 `-Domain`） |
| `domains/<id>/constraints.overlay.md` | **追加**到 `.cursor/constraints.md` |
| `constraints.md.template` | `YourApp/.cursor/constraints.md` |
| `templates/AGENTS.md.template` | `YourApp/AGENTS.md` |
| — | `YourApp/docs/requirements/`、`docs/standards/` 等骨架 |

也可**手动**将规范库根目录的运行时文件夹移入目标项目的 `.cursor/`；域包须按文件合并，勿整夹复制 `domains/`。

## 不要复制到业务项目

- 规范库根 `templates/`、`scripts/`、`domains/`（整夹）、`README.md`、`STRUCTURE.md`、`ecc-manifest.md.template`
- `domains/_template/` 与任意 `_` 前缀脚手架

## 校验

- [ ] Cursor Settings → Rules 可见 Project Rules
- [ ] `.cursor/constraints.md`、`AGENTS.md` 占位符已替换
- [ ] 业务项目运行时均在 `.cursor/` 内
- [ ] 若启用域包：`.cursor/domain-packs/<id>.md` 存在；域 Rule 的 `globs` 已改为真实路径

维护 ECC：`scripts/sync-ecc-bundle.ps1`  
域包约定：[domains/README.md](./domains/README.md)
