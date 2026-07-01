# 项目规范库 · 硬约束（示例）

> 本文件为规范库自身说明；业务项目由 `constraints.md.template` 生成 `.cursor/constraints.md`。

## 仓库结构

| 目录 | 职责 |
|------|------|
| `rules/` `skills/` `agents/` `hooks/` `workflows/` `evals/` | Cursor 运行时（复制到目标 `.cursor/`） |
| `templates/` | Bootstrap 占位符 |
| `scripts/` | bootstrap、sync-ecc、fix-frontmatter |

## 维护

- 新增 Skill → `skills/workflow-triggers/SKILL.md`
- 约定写在 `rules/` 与 Skills 内，不在仓库根另建人类规范目录
