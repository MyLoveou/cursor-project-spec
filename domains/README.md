# 业务域配置包（Domain Packs）

> **通用运行时**按平台分布在 `cursor/` / `opencode/` / `hermes/` + 共享层 `shared/`  
> **业务域包**在 `domains/<domain-id>/`，可**单独**拷到业务仓（须含 `bundle/` 依赖）。

## 两种用法

| 场景 | 做法 |
|------|------|
| 业务仓已用全量 Bootstrap | `apply-domain-pack.ps1 -Target cursor -Domain <id>`（从规范库合并） |
| **只带某个域包**到业务仓 | 拷贝整个 `domains/<id>/`（含 `bundle/`）→ `install-domain-pack.ps1 -PackRoot …` |

## 自包含：`bundle/`

域 Skill 常依赖根上的 `requirements-refinement`、`plan-workflow` 等。  
若只拷域专属文件，业务仓会缺 Skill。因此：

1. `bundle.manifest.json` 声明依赖列表  
2. `scripts/sync-domain-bundle.ps1` 从规范库根**复制**进 `domains/<id>/bundle/`  
3. 安装时先合并 `bundle/`，再合并域原生 `rules|skills|agents`（**域原生覆盖 bundle**）

```powershell
# 在规范库维护：改依赖后刷新 bundle
powershell -File scripts/sync-domain-bundle.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -Domain enterprise-cert

# 只把域包目录拷到业务机后安装
powershell -File scripts/install-domain-pack.ps1 `
  -PackRoot "E:\drop\enterprise-cert" `
  -ProjectRoot "E:\项目\YourApp" `
  -CreateCursorIfMissing
```

> **不要手改 `bundle/`**；改 `bundle.manifest.json` 后重新 sync。

## 目录约定

```
domains/<domain-id>/
├── DOMAIN.md
├── bundle.manifest.json      # 依赖清单
├── bundle/                   # sync 生成：根 skills/rules/agents/workflows/…
│   ├── skills/
│   ├── rules/
│   ├── agents/
│   ├── workflows/
│   ├── root-templates/
│   └── SYNC-STAMP.md
├── rules/ skills/ agents/    # 域原生（可覆盖 bundle 同名项）
├── templates/                # → 目标平台对应模板目录
├── glossary.md / taboos.md / …  # 知识表（可选）
└── constraints.overlay.md
```

- `<domain-id>`：kebab-case；`_` 前缀为脚手架，不可安装  
- Cursor 只扫描 `.cursor/rules|skills|agents`；OpenCode 读取 `opencode.json` + `instructions`；Hermes 读取 `rules/ecc/` 与 `skills/ecc-imports/`。域包须**扁平合并**到对应平台目录

## 已有域包

| id | 显示名 | 说明 |
|----|--------|------|
| `enterprise-cert` | 企业认证 | SDD + 四件套 + 工具三层（台账/CodeGraph/MCP KG）+ bundle |

## 新建域包

```powershell
Copy-Item -Recurse domains\_template domains\<domain-id>
# 编辑 DOMAIN.md、rules/skills，填写 bundle.manifest.json
powershell -File scripts/sync-domain-bundle.ps1 -SpecRoot . -Domain <domain-id>
```

## 从规范库叠加（已有全量 .cursor）

```powershell
powershell -File scripts/apply-domain-pack.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Target cursor `
  -Domain enterprise-cert
```

## 合并顺序

1. `bundle/`（vendored 根运行时）  
2. 域原生目录（覆盖同名）  
3. 知识表 / templates → 目标平台对应路径

## 不支持

- 域包内 `hooks/` 自动合并（忽略）  
- 无 `bundle/` 却声称「只拷域包即可用」（须先 sync）
