# 项目规范 · 硬约束

> 本文件为规范库自身的运行时约束。业务项目从 `constraints.md.template` 复制并填写。

## 仓库

| 目录 | 职责 |
|------|------|
| `.cursor/` | Rules、Skills、Agents、Hooks、Workflows |
| `templates/` | Bootstrap 占位符 |
| `scripts/` | bootstrap、sync-ecc-bundle |

## 维护

- 新增 Skill → `.cursor/skills/workflow-triggers/SKILL.md`
- Rule 使用 `globs` / `alwaysApply` frontmatter
- 人类规范不放在仓库根；约定写在 `.cursor/rules/` 与 Skills 内

## DoD（改本库）

- [ ] `.mdc` frontmatter 符合 Cursor 规范
- [ ] README / BOOTSTRAP 与目录一致
