# {DOMAIN_ID} · 业务域配置包

| 字段 | 值 |
|------|-----|
| id | `{DOMAIN_ID}` |
| 显示名 | `{DOMAIN_NAME}` |
| 适用项目 | `{PROJECT_HINT}` |
| 路径 globs | `{PATH_GLOBS}`（例：`apps/notes/**`、`services/notes-api/**`） |

## 何时启用

- Bootstrap / apply 时传入 `-Domain {DOMAIN_ID}`
- 仅当目标业务项目属于本域，或 monorepo 中本域路径会参与开发

## 包内清单

| 目录 | 说明 |
|------|------|
| `rules/` | 域专属 Rule（须 `globs` 对齐上表路径） |
| `skills/` | 域专属 Skill（名称建议 `domain-{DOMAIN_ID}-*`） |
| `agents/` | 域专属子代理（名称建议带域前缀） |
| `workflows/` | 可选：域专属剧本 |
| `evals/` | 可选：域专属 eval |
| `constraints.overlay.md` | 可选：追加到目标 `.cursor/constraints.md` |

## 维护

1. 改本包后，对已接入项目执行 `scripts/apply-domain-pack.ps1 -Domain {DOMAIN_ID}`
2. 若新增 Skill，在**本域**触发表 Skill（若有）或根 `workflow-triggers` 中登记触发信号
3. 不要把跨域通用内容放进本包 — 放到仓库根运行时
