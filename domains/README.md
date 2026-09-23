# 业务域配置包（Domain Packs）

> 通用运行时部署到业务仓 `.cursor/`。域包在 `domains/<domain-id>/`，可单独拷贝（须含 `bundle/`）。

## 两种用法

| 场景 | 做法 |
|------|------|
| 业务仓已用全量 Bootstrap | `apply-domain-pack.ps1 -Domain <id>` |
| 只带某个域包到业务仓 | 拷贝 `domains/<id>/`（含 `bundle/`）→ `install-domain-pack.ps1` |

## 自包含：`bundle/`

1. `bundle.manifest.json` 声明依赖  
2. `scripts/sync-domain-bundle.ps1` 复制进 `domains/<id>/bundle/`  
3. 安装时先合并 `bundle/`，再合并域原生（域原生覆盖）

```powershell
powershell -File scripts/sync-domain-bundle.ps1 -SpecRoot "E:\项目\项目规范" -Domain enterprise-cert
powershell -File scripts/install-domain-pack.ps1 -PackRoot "E:\drop\enterprise-cert" -ProjectRoot "E:\项目\YourApp" -CreateCursorIfMissing
```

> **不要手改 `bundle/`**；改 manifest 后重新 sync。

## 目录约定

```
domains/<domain-id>/
├── DOMAIN.md
├── bundle.manifest.json
├── bundle/
├── rules/ skills/ agents/
├── templates/
└── constraints.overlay.md
```

- `<domain-id>`：kebab-case；`_` 前缀脚手架不可安装  
- 扁平合并进 `.cursor/rules|skills|agents`

## 已有域包

| id | 显示名 | 说明 |
|----|--------|------|
| `enterprise-cert` | 企业认证 | SDD + 知识捕获 + 摸底模板 + bundle |

## 新建

```powershell
Copy-Item -Recurse domains\_template domains\<domain-id>
# 编辑 DOMAIN.md、rules/skills，填写 bundle.manifest.json
powershell -File scripts/sync-domain-bundle.ps1 -SpecRoot . -Domain <domain-id>
```
