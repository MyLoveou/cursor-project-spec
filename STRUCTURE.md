# 目录结构（规范库 vs 业务项目）

> 规范库**无** `.cursor/` 包装层；Bootstrap 或手动复制时，将运行时目录放入目标项目的 `.cursor/`。

---

## 规范库（本仓库）

```
项目规范/
├── rules/ skills/ agents/ hooks/ workflows/ evals/
├── constraints.md.template
├── templates/
├── scripts/
└── STRUCTURE.md · README.md · AGENTS.md
```

Cursor **不会**自动扫描规范库根目录；此处仅供维护与版本管理。

---

## 业务项目（Cursor 自动加载）

复制后布局：

| 路径 | 说明 |
|------|------|
| `.cursor/rules/*.mdc` | `description` + `globs` 或 `alwaysApply` |
| `.cursor/skills/*/SKILL.md` | Skills |
| `.cursor/agents/*.md` | 子代理 |
| `.cursor/hooks/hooks.json` | Hooks |
| `AGENTS.md` | 项目根（Bootstrap 生成） |

扩展（Skill 引用，非 Settings 自动项）：

| 路径 | 用途 |
|------|------|
| `.cursor/workflows/` | 需求/设计/开发/交付剧本 |
| `.cursor/evals/` | EDD eval 示例 |
| `.cursor/constraints.md` | 硬约束（由 template 生成） |

栈 Rule 须用 `globs:`，勿用 ECC 旧字段 `paths:`。修复：`scripts/fix-cursor-rule-frontmatter.ps1`。

---

## 复制方式

1. **脚本**：`scripts/bootstrap-project.ps1`（推荐）
2. **手动**：将 `rules/`、`skills/`、`agents/`、`hooks/`、`workflows/`、`evals/` 移入 `<项目>/.cursor/`
