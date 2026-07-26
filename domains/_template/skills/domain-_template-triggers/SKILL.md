---
name: domain-_template-triggers
description: >-
  {DOMAIN_NAME} 域触发表（模板）。复制域包后改 name/description，并登记本域口令 → Skill。
---

# {DOMAIN_NAME} · 域触发路由

> 通用触发表仍以根 `workflow-triggers` 为准。  
> 本 Skill **只**补充本域口令与路径；命中后先读本域 Skill，再回退通用流程。

## 口令 → Skill

| 触发信号 | Skill | 优先级 |
|----------|-------|--------|
| {DOMAIN_TRIGGER_1} | `{DOMAIN_SKILL_1}` | P0 |
| {DOMAIN_TRIGGER_2} | `{DOMAIN_SKILL_2}` | P1 |

## 路径 → Skill / Agent

| 路径 | 动作 |
|------|------|
| `{PATH_GLOBS}` | 应用 `domain-<id>-*.mdc`；大改走本域 Agent（若有） |

## 与通用工作流

- 需求 / 设计 / 开发 / 交付仍走根 `workflows/*`
- 本域仅叠加域不变量与域专属实现步骤
