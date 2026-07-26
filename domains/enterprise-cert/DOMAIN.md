# enterprise-cert · 业务域配置包

| 字段 | 值 |
|------|-----|
| id | `enterprise-cert` |
| 显示名 | 企业认证 |
| 适用项目 | 企业认证相关业务仓（复盘曾提 setting-center；以实际仓库为准） |
| 路径 globs | **占位**，接入后按真实目录修改（当前可能与现状不符） |

## 自包含打包

本域可**单独**拷到业务仓（须含 `bundle/`）：

```powershell
# 规范库内刷新依赖副本
powershell -File scripts/sync-domain-bundle.ps1 -SpecRoot "E:\项目\项目规范" -Domain enterprise-cert

# 业务仓只装本包
powershell -File scripts/install-domain-pack.ps1 `
  -PackRoot "<path-to>\enterprise-cert" `
  -ProjectRoot "E:\项目\YourApp" `
  -CreateCursorIfMissing
```

依赖清单：`bundle.manifest.json`（含 `requirements-refinement`、`plan-workflow`、`implement-feature` 等）。  
**勿手改 `bundle/`**。

## 内容来源原则

| 可写入「已确认」 | 不可当作现状 |
|------------------|--------------|
| 你提供的复盘/CR/产品裁定、或 knowledge-capture 决断入库 | AI 按「通用企业认证」推断的状态机、字段、审计、权限联动等 |

包内 **SDD / 知识捕获流程** 来自你的实践反思（流程层）；**业务事实**须另行摸底与决断。

## 何时启用

- `-Domain enterprise-cert` / `install-domain-pack`
- SDD：`domain-enterprise-cert-sdd`
- **能力四件套**：

| Skill | 用途 |
|--------|------|
| `domain-enterprise-cert-knowledge-capture` | 业务规则 / 术语 / UI（域原生） |
| `codebase-inventory`（+ `domain-enterprise-cert-codebase-map`） | 功能与 API 现状 |
| `codebase-conventions` | 代码工程惯例提炼 |
| `continuous-learning-v2` | 会话 instinct 学习（bundle 内；启用方式见该 Skill） |

后三者在 `bundle/`；knowledge-capture 在域 `skills/`。

## 知识体系

```text
业务：开放发现 → pending-decisions → 人决断 → glossary / taboos / business-rules / ui-interactions
工程：codebase-conventions → conventions-pending → coding-conventions
现状：codebase-inventory → *-codebase-map.md（须人工核实）
会话：continuous-learning-v2 → instincts（可选）
```

## 包内清单

| 路径 | 说明 |
|------|------|
| `bundle.manifest.json` + `bundle/` | 根依赖（含 inventory / conventions / continuous-learning-v2 等） |
| 域 `skills/` | SDD、knowledge-capture、codebase-map、tech-design、triggers |
| 域 `rules/` / `templates/` | 门禁与域模板 |
| 知识表 | glossary / taboos / business-rules / ui-interactions / pending |

`rules/*-core.mdc` 仅含已溯源短列表，详见该文件「明确未写入」。

## 维护

1. 改依赖清单后：`sync-domain-bundle.ps1 -Domain enterprise-cert`
2. `apply-domain-pack` 或 `install-domain-pack` 装入业务仓
3. 业务结论只经决断入库；发现 AI 臆造 → 删或改「待确认」
